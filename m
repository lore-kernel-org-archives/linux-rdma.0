From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH for-next v2 09/10] IB/core: Remove smac and vlan id from
 qp_attr and ah_attr
Date: Sun, 18 Oct 2015 22:54:51 +0530
Message-ID: <CANjDDBjAHz4wLAK-HE25V2fLr7n2pLuP8OrnxcUXuXKh+U1rgA@mail.gmail.com>
References: <1444923534-10882-1-git-send-email-matanb@mellanox.com> <1444923534-10882-10-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444923534-10882-10-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks Good
Reviewed-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

On Thu, Oct 15, 2015 at 9:08 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Smac and vlan id could be resolved from the GID attribute, and thus
> these attributes aren't needed anymore. Removing them.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/sa_query.c   |  4 ----
>  drivers/infiniband/core/ucma.c       |  1 -
>  drivers/infiniband/core/uverbs_cmd.c |  1 -
>  include/rdma/ib_verbs.h              | 13 ++++---------
>  4 files changed, 4 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
> index c9d9d7a..77f5afc 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -1029,11 +1029,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
>         }
>         if (force_grh) {
>                 memcpy(ah_attr->dmac, rec->dmac, ETH_ALEN);
> -               ah_attr->vlan_id = rec->vlan_id;
> -       } else {
> -               ah_attr->vlan_id = 0xffff;
>         }
> -
>         return 0;
>  }
>  EXPORT_SYMBOL(ib_init_ah_from_path);
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index a53fc9b..ac55a9e 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -1211,7 +1211,6 @@ static int ucma_set_ib_path(struct ucma_context *ctx,
>                 return -EINVAL;
>
>         memset(&sa_path, 0, sizeof(sa_path));
> -       sa_path.vlan_id = 0xffff;
>
>         ib_sa_unpack_path(path_data->path_rec, &sa_path);
>         ret = rdma_set_ib_paths(ctx->cm_id, &sa_path, 1);
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index b242480..ae5f912 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2698,7 +2698,6 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
>         attr.grh.sgid_index    = cmd.attr.grh.sgid_index;
>         attr.grh.hop_limit     = cmd.attr.grh.hop_limit;
>         attr.grh.traffic_class = cmd.attr.grh.traffic_class;
> -       attr.vlan_id           = 0;
>         memset(&attr.dmac, 0, sizeof(attr.dmac));
>         memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 9868cab..0b20658 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -697,7 +697,6 @@ struct ib_ah_attr {
>         u8                      ah_flags;
>         u8                      port_num;
>         u8                      dmac[ETH_ALEN];
> -       u16                     vlan_id;
>  };
>
>  enum ib_wc_status {
> @@ -957,10 +956,10 @@ enum ib_qp_attr_mask {
>         IB_QP_PATH_MIG_STATE            = (1<<18),
>         IB_QP_CAP                       = (1<<19),
>         IB_QP_DEST_QPN                  = (1<<20),
> -       IB_QP_SMAC                      = (1<<21),
> -       IB_QP_ALT_SMAC                  = (1<<22),
> -       IB_QP_VID                       = (1<<23),
> -       IB_QP_ALT_VID                   = (1<<24),
> +       IB_QP_RESERVED1                 = (1<<21),
> +       IB_QP_RESERVED2                 = (1<<22),
> +       IB_QP_RESERVED3                 = (1<<23),
> +       IB_QP_RESERVED4                 = (1<<24),
>  };
>
>  enum ib_qp_state {
> @@ -1010,10 +1009,6 @@ struct ib_qp_attr {
>         u8                      rnr_retry;
>         u8                      alt_port_num;
>         u8                      alt_timeout;
> -       u8                      smac[ETH_ALEN];
> -       u8                      alt_smac[ETH_ALEN];
> -       u16                     vlan_id;
> -       u16                     alt_vlan_id;
>  };
>
>  enum ib_wr_opcode {
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
