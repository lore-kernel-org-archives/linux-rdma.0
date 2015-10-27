From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/7] Add support for extended version of ibv_query_device
Date: Tue, 27 Oct 2015 19:05:05 +0200
Message-ID: <CAAKD3BAj87azavOkp_tOPfznEwMcjAb8sUrX0KH3wAB2vECXeA@mail.gmail.com>
References: <1445964755-13371-1-git-send-email-matanb@mellanox.com>
	<1445964755-13371-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445964755-13371-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2015 at 6:52 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> The new mlx4_query_device_ex implementation uses the
> extended version of libibverbs/uverbs query_device command.
> In addition, it reads the hca_core_clock offset in the bar
> from the vendor specific part of ibv_query_device_ex command.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/mlx4-abi.h | 13 +++++++++++++
>  src/mlx4.c     |  1 +
>  src/mlx4.h     |  8 ++++++++
>  src/verbs.c    | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 73 insertions(+), 3 deletions(-)
>
> diff --git a/src/mlx4-abi.h b/src/mlx4-abi.h
> index b48f6fc..b348ce3 100644
> --- a/src/mlx4-abi.h
> +++ b/src/mlx4-abi.h
> @@ -111,4 +111,17 @@ struct mlx4_create_qp {
>         __u8                            reserved[5];
>  };
>
> +enum query_device_resp_mask {
> +       QUERY_DEVICE_RESP_MASK_TIMESTAMP = 1UL << 0,
> +};
> +
> +struct query_device_ex_resp {
> +       struct ibv_query_device_resp_ex core;
> +       struct {
> +               uint32_t comp_mask;
> +               uint32_t response_length;
> +               uint64_t hca_core_clock_offset;
> +       };
> +};
> +
>  #endif /* MLX4_ABI_H */
> diff --git a/src/mlx4.c b/src/mlx4.c
> index c30f4bf..d41dff0 100644
> --- a/src/mlx4.c
> +++ b/src/mlx4.c
> @@ -207,6 +207,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
>         verbs_set_ctx_op(verbs_ctx, open_qp, mlx4_open_qp);
>         verbs_set_ctx_op(verbs_ctx, ibv_create_flow, ibv_cmd_create_flow);
>         verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
> +       verbs_set_ctx_op(verbs_ctx, query_device_ex, mlx4_query_device_ex);
>
>         return 0;
>
> diff --git a/src/mlx4.h b/src/mlx4.h
> index 519d8f4..0f643bc 100644
> --- a/src/mlx4.h
> +++ b/src/mlx4.h
> @@ -198,6 +198,7 @@ struct mlx4_context {
>                 uint8_t                 link_layer;
>                 enum ibv_port_cap_flags caps;
>         } port_query_cache[MLX4_PORTS_NUM];
> +       uint64_t                        core_clock_offset;
>  };
>
>  struct mlx4_buf {
> @@ -378,6 +379,13 @@ void mlx4_free_db(struct mlx4_context *context, enum mlx4_db_type type, uint32_t
>
>  int mlx4_query_device(struct ibv_context *context,
>                        struct ibv_device_attr *attr);
> +int _mlx4_query_device_ex(struct ibv_context *context,
> +                         const struct ibv_query_device_ex_input *input,
> +                         struct ibv_device_attr_ex *attr, size_t attr_size,
> +                         uint32_t *comp_mask);
> +int mlx4_query_device_ex(struct ibv_context *context,
> +                        const struct ibv_query_device_ex_input *input,
> +                        struct ibv_device_attr_ex *attr, size_t attr_size);
>  int mlx4_query_port(struct ibv_context *context, uint8_t port,
>                      struct ibv_port_attr *attr);
>
> diff --git a/src/verbs.c b/src/verbs.c
> index 2cb1f8a..e93114b 100644
> --- a/src/verbs.c
> +++ b/src/verbs.c
> @@ -45,6 +45,14 @@
>  #include "mlx4-abi.h"
>  #include "wqe.h"
>
> +static void parse_raw_fw_ver(uint64_t raw_fw_ver, unsigned *major,
> +                            unsigned *minor, unsigned *sub_minor)
> +{
> +       *major     = (raw_fw_ver >> 32) & 0xffff;
> +       *minor     = (raw_fw_ver >> 16) & 0xffff;
> +       *sub_minor = raw_fw_ver & 0xffff;
> +}
> +
>  int mlx4_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
>  {
>         struct ibv_query_device cmd;
> @@ -56,9 +64,7 @@ int mlx4_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
>         if (ret)
>                 return ret;
>
> -       major     = (raw_fw_ver >> 32) & 0xffff;
> -       minor     = (raw_fw_ver >> 16) & 0xffff;
> -       sub_minor = raw_fw_ver & 0xffff;
> +       parse_raw_fw_ver(raw_fw_ver, &major, &minor, &sub_minor);
>
>         snprintf(attr->fw_ver, sizeof attr->fw_ver,
>                  "%d.%d.%03d", major, minor, sub_minor);
> @@ -66,6 +72,48 @@ int mlx4_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
>         return 0;
>  }
>
> +int _mlx4_query_device_ex(struct ibv_context *context,
> +                         const struct ibv_query_device_ex_input *input,
> +                         struct ibv_device_attr_ex *attr, size_t attr_size,
> +                         uint32_t *comp_mask)
> +{
> +       struct ibv_query_device_ex cmd;
> +       struct query_device_ex_resp resp;
> +       uint64_t raw_fw_ver;
> +       unsigned major, minor, sub_minor;
> +       int ret;
> +
> +       memset(&resp, 0, sizeof(resp));
> +
> +       ret = ibv_cmd_query_device_ex(context, input, attr, attr_size,
> +                                     &raw_fw_ver, &cmd, sizeof(cmd),
> +                                     sizeof(cmd), &resp.core,
> +                                     sizeof(resp.core), sizeof(resp));
> +       if (ret)
> +               return ret;
> +
> +       parse_raw_fw_ver(raw_fw_ver, &major, &minor, &sub_minor);
> +
> +       snprintf(attr->orig_attr.fw_ver, sizeof(attr->orig_attr.fw_ver),
> +                "%d.%d.%03d", major, minor, sub_minor);
> +
> +       if (resp.comp_mask & QUERY_DEVICE_RESP_MASK_TIMESTAMP)
> +               to_mctx(context)->core_clock_offset =
> +                       resp.hca_core_clock_offset;
> +
> +       if (comp_mask)
> +               *comp_mask = resp.comp_mask;
> +
> +       return 0;
> +}
> +
> +int mlx4_query_device_ex(struct ibv_context *context,
> +                        const struct ibv_query_device_ex_input *input,
> +                        struct ibv_device_attr_ex *attr, size_t attr_size)
> +{
> +       return _mlx4_query_device_ex(context, input, attr, attr_size, NULL);
> +}
> +
>  int mlx4_query_port(struct ibv_context *context, uint8_t port,
>                      struct ibv_port_attr *attr)
>  {
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This should have libmlx4 prefix.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
