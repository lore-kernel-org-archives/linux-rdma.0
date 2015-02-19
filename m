From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/core: Add support for extended query device caps
Date: Thu, 19 Feb 2015 14:30:29 +0200
Message-ID: <CAAKD3BAPL82RC5u5uxJg9QPgiM+05TcnURzO14Y5OKYxhYrmqw@mail.gmail.com>
References: <1424244364-6242-1-git-send-email-haggaie@mellanox.com>
	<1424244364-6242-2-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424244364-6242-2-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 18, 2015 at 9:26 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add extensible query device capabilities verb to allow adding new features.
> ib_uverbs_ex_query_device is added and copy_query_dev_fields is used to copy
> capability fields to be used by both ib_uverbs_query_device and
> ib_uverbs_ex_query_device.
>
> Following the discussion about this patch [1], the code now validates the
> command's comp_mask is zero, returning -EINVAL for unknown values, in order to
> allow extending the verb in the future.
>
> The verb also checks the user-space provided response buffer size and only
> fills in capabilities that will fit in the buffer. In attempt to follow the
> spirit of presentation [2] by Tzahi Oved that was presented during OpenFabrics
> Alliance International Developer Workshop 2013, the comp_mask bits will only
> describe which fields are valid. Furthermore, fields that can simply be
> cleared when they are not supported, do not require a comp_mask bit at all.
> The verb returns a response_length field containing the actual number of bytes
> written by the kernel, so that a newer version running on an older kernel can
> tell which fields were actually returned.
>
> [1] [PATCH v1 0/5] IB/core: extended query device caps cleanup for v3.19
>     http://thread.gmane.org/gmane.linux.kernel.api/7889/
>
> [2] https://www.openfabrics.org/images/docs/2013_Dev_Workshop/Tues_0423/2013_Workshop_Tues_0830_Tzahi_Oved-verbs_extensions_ofa_2013-tzahio.pdf
>
> Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs.h      |   1 +
>  drivers/infiniband/core/uverbs_cmd.c  | 135 +++++++++++++++++++++++-----------
>  drivers/infiniband/core/uverbs_main.c |   1 +
>  include/uapi/rdma/ib_user_verbs.h     |  12 +++
>  4 files changed, 108 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> index 643c08a025a5..b716b0815644 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -258,5 +258,6 @@ IB_UVERBS_DECLARE_CMD(close_xrcd);
>
>  IB_UVERBS_DECLARE_EX_CMD(create_flow);
>  IB_UVERBS_DECLARE_EX_CMD(destroy_flow);
> +IB_UVERBS_DECLARE_EX_CMD(query_device);
>
>  #endif /* UVERBS_H */
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index b7943ff16ed3..75ab6fef6de5 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -400,6 +400,52 @@ err:
>         return ret;
>  }
>
> +static void copy_query_dev_fields(struct ib_uverbs_file *file,
> +                                 struct ib_uverbs_query_device_resp *resp,
> +                                 struct ib_device_attr *attr)
> +{
> +       resp->fw_ver            = attr->fw_ver;
> +       resp->node_guid         = file->device->ib_dev->node_guid;
> +       resp->sys_image_guid    = attr->sys_image_guid;
> +       resp->max_mr_size       = attr->max_mr_size;
> +       resp->page_size_cap     = attr->page_size_cap;
> +       resp->vendor_id         = attr->vendor_id;
> +       resp->vendor_part_id    = attr->vendor_part_id;
> +       resp->hw_ver            = attr->hw_ver;
> +       resp->max_qp            = attr->max_qp;
> +       resp->max_qp_wr         = attr->max_qp_wr;
> +       resp->device_cap_flags  = attr->device_cap_flags;
> +       resp->max_sge           = attr->max_sge;
> +       resp->max_sge_rd        = attr->max_sge_rd;
> +       resp->max_cq            = attr->max_cq;
> +       resp->max_cqe           = attr->max_cqe;
> +       resp->max_mr            = attr->max_mr;
> +       resp->max_pd            = attr->max_pd;
> +       resp->max_qp_rd_atom    = attr->max_qp_rd_atom;
> +       resp->max_ee_rd_atom    = attr->max_ee_rd_atom;
> +       resp->max_res_rd_atom   = attr->max_res_rd_atom;
> +       resp->max_qp_init_rd_atom       = attr->max_qp_init_rd_atom;
> +       resp->max_ee_init_rd_atom       = attr->max_ee_init_rd_atom;
> +       resp->atomic_cap                = attr->atomic_cap;
> +       resp->max_ee                    = attr->max_ee;
> +       resp->max_rdd                   = attr->max_rdd;
> +       resp->max_mw                    = attr->max_mw;
> +       resp->max_raw_ipv6_qp           = attr->max_raw_ipv6_qp;
> +       resp->max_raw_ethy_qp           = attr->max_raw_ethy_qp;
> +       resp->max_mcast_grp             = attr->max_mcast_grp;
> +       resp->max_mcast_qp_attach       = attr->max_mcast_qp_attach;
> +       resp->max_total_mcast_qp_attach = attr->max_total_mcast_qp_attach;
> +       resp->max_ah                    = attr->max_ah;
> +       resp->max_fmr                   = attr->max_fmr;
> +       resp->max_map_per_fmr           = attr->max_map_per_fmr;
> +       resp->max_srq                   = attr->max_srq;
> +       resp->max_srq_wr                = attr->max_srq_wr;
> +       resp->max_srq_sge               = attr->max_srq_sge;
> +       resp->max_pkeys                 = attr->max_pkeys;
> +       resp->local_ca_ack_delay        = attr->local_ca_ack_delay;
> +       resp->phys_port_cnt             = file->device->ib_dev->phys_port_cnt;
> +}
> +
>  ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
>                                const char __user *buf,
>                                int in_len, int out_len)
> @@ -420,47 +466,7 @@ ssize_t ib_uverbs_query_device(struct ib_uverbs_file *file,
>                 return ret;
>
>         memset(&resp, 0, sizeof resp);
> -
> -       resp.fw_ver                    = attr.fw_ver;
> -       resp.node_guid                 = file->device->ib_dev->node_guid;
> -       resp.sys_image_guid            = attr.sys_image_guid;
> -       resp.max_mr_size               = attr.max_mr_size;
> -       resp.page_size_cap             = attr.page_size_cap;
> -       resp.vendor_id                 = attr.vendor_id;
> -       resp.vendor_part_id            = attr.vendor_part_id;
> -       resp.hw_ver                    = attr.hw_ver;
> -       resp.max_qp                    = attr.max_qp;
> -       resp.max_qp_wr                 = attr.max_qp_wr;
> -       resp.device_cap_flags          = attr.device_cap_flags;
> -       resp.max_sge                   = attr.max_sge;
> -       resp.max_sge_rd                = attr.max_sge_rd;
> -       resp.max_cq                    = attr.max_cq;
> -       resp.max_cqe                   = attr.max_cqe;
> -       resp.max_mr                    = attr.max_mr;
> -       resp.max_pd                    = attr.max_pd;
> -       resp.max_qp_rd_atom            = attr.max_qp_rd_atom;
> -       resp.max_ee_rd_atom            = attr.max_ee_rd_atom;
> -       resp.max_res_rd_atom           = attr.max_res_rd_atom;
> -       resp.max_qp_init_rd_atom       = attr.max_qp_init_rd_atom;
> -       resp.max_ee_init_rd_atom       = attr.max_ee_init_rd_atom;
> -       resp.atomic_cap                = attr.atomic_cap;
> -       resp.max_ee                    = attr.max_ee;
> -       resp.max_rdd                   = attr.max_rdd;
> -       resp.max_mw                    = attr.max_mw;
> -       resp.max_raw_ipv6_qp           = attr.max_raw_ipv6_qp;
> -       resp.max_raw_ethy_qp           = attr.max_raw_ethy_qp;
> -       resp.max_mcast_grp             = attr.max_mcast_grp;
> -       resp.max_mcast_qp_attach       = attr.max_mcast_qp_attach;
> -       resp.max_total_mcast_qp_attach = attr.max_total_mcast_qp_attach;
> -       resp.max_ah                    = attr.max_ah;
> -       resp.max_fmr                   = attr.max_fmr;
> -       resp.max_map_per_fmr           = attr.max_map_per_fmr;
> -       resp.max_srq                   = attr.max_srq;
> -       resp.max_srq_wr                = attr.max_srq_wr;
> -       resp.max_srq_sge               = attr.max_srq_sge;
> -       resp.max_pkeys                 = attr.max_pkeys;
> -       resp.local_ca_ack_delay        = attr.local_ca_ack_delay;
> -       resp.phys_port_cnt             = file->device->ib_dev->phys_port_cnt;
> +       copy_query_dev_fields(file, &resp, &attr);
>
>         if (copy_to_user((void __user *) (unsigned long) cmd.response,
>                          &resp, sizeof resp))
> @@ -3287,3 +3293,50 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
>
>         return ret ? ret : in_len;
>  }
> +
> +int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
> +                             struct ib_udata *ucore,
> +                             struct ib_udata *uhw)
> +{
> +       struct ib_uverbs_ex_query_device_resp resp;
> +       struct ib_uverbs_ex_query_device  cmd;
> +       struct ib_device_attr attr;
> +       struct ib_device *device;
> +       int err;
> +
> +       device = file->device->ib_dev;
> +       if (ucore->inlen < sizeof(cmd))
> +               return -EINVAL;
> +
> +       err = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
> +       if (err)
> +               return err;
> +
> +       if (cmd.comp_mask)
> +               return -EINVAL;

I think we should all agree about the extension verbs mechanism before
taking it further.
IMHO, using comp_mask only for fields that their valid value != 0 is confusing.
For example, an old kernel should support a command if:
(a) it knows all its valid bits
(b) all fields after the size it knows is 0

In the old schema, the kernel only needs to look at the comp_mask bits
and execute the
command or reject it.

Furthermore, ibv_create_flow and ibv_destroy_flow were already
accepted using the old schema.

Regards,
Matan

> +
> +       if (cmd.reserved)
> +               return -EINVAL;
> +
> +       /* Check that the size of the response buffer provided by the user is
> +        * large enough for the response's legacy fields and header.
> +        * Since this is the first version of this verb, this includes the
> +        * entire response struct. When adding extra fields to the response
> +        * struct, change this line as needed. */
> +       resp.response_length = sizeof(resp);
> +       if (ucore->outlen < resp.response_length)
> +               return -ENOSPC;
> +
> +       err = device->query_device(device, &attr);
> +       if (err)
> +               return err;
> +
> +       copy_query_dev_fields(file, &resp.base, &attr);
> +       resp.comp_mask = 0;
> +
> +       err = ib_copy_to_udata(ucore, &resp, resp.response_length);
> +       if (err)
> +               return err;
> +
> +       return 0;
> +}
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index 5db1a8cc388d..259dcc7779f5 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -123,6 +123,7 @@ static int (*uverbs_ex_cmd_table[])(struct ib_uverbs_file *file,
>                                     struct ib_udata *uhw) = {
>         [IB_USER_VERBS_EX_CMD_CREATE_FLOW]      = ib_uverbs_ex_create_flow,
>         [IB_USER_VERBS_EX_CMD_DESTROY_FLOW]     = ib_uverbs_ex_destroy_flow,
> +       [IB_USER_VERBS_EX_CMD_QUERY_DEVICE]     = ib_uverbs_ex_query_device,
>  };
>
>  static void ib_uverbs_add_one(struct ib_device *device);
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
> index 867cc5084afb..f0f799afd856 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -90,6 +90,7 @@ enum {
>  };
>
>  enum {
> +       IB_USER_VERBS_EX_CMD_QUERY_DEVICE = IB_USER_VERBS_CMD_QUERY_DEVICE,
>         IB_USER_VERBS_EX_CMD_CREATE_FLOW = IB_USER_VERBS_CMD_THRESHOLD,
>         IB_USER_VERBS_EX_CMD_DESTROY_FLOW,
>  };
> @@ -201,6 +202,17 @@ struct ib_uverbs_query_device_resp {
>         __u8  reserved[4];
>  };
>
> +struct ib_uverbs_ex_query_device {
> +       __u32 comp_mask;
> +       __u32 reserved;
> +};
> +
> +struct ib_uverbs_ex_query_device_resp {
> +       struct ib_uverbs_query_device_resp base;
> +       __u32 comp_mask;
> +       __u32 response_length;
> +};
> +
>  struct ib_uverbs_query_port {
>         __u64 response;
>         __u8  port_num;
> --
> 1.7.11.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
