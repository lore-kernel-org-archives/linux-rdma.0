From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH for-next v2 03/10] IB/core: Add netdev to path record
Date: Sun, 18 Oct 2015 21:33:01 +0530
Message-ID: <CANjDDBjOunBTB3jdR4FX16JCykFAOZ8TebEC8hqX0_QYXwuVJQ@mail.gmail.com>
References: <1444923534-10882-1-git-send-email-matanb@mellanox.com> <1444923534-10882-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444923534-10882-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Looks Good
Reviewed-By: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

On Thu, Oct 15, 2015 at 9:08 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> In order to find the sgid_index, one could just query the IB cache
> with the correct GID and netdevice. Therefore, instead of storing
> the L2 attributes directly in the path, we only store the
> ifindex and net and use them later to get the sgid_index.
> The vlan_id and smac L2 attributes are removed in a later patch.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/sa_query.c        | 13 +++++++++++--
>  drivers/infiniband/core/uverbs_marshall.c |  2 ++
>  include/rdma/ib_sa.h                      | 10 ++++++++++
>  3 files changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
> index 9a4e789..c9d9d7a 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -1007,18 +1007,25 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
>         force_grh = rdma_cap_eth_ah(device, port_num);
>
>         if (rec->hop_limit > 1 || force_grh) {
> +               struct net_device *ndev = ib_get_ndev_from_path(rec);
> +
>                 ah_attr->ah_flags = IB_AH_GRH;
>                 ah_attr->grh.dgid = rec->dgid;
>
> -               ret = ib_find_cached_gid(device, &rec->sgid, NULL, &port_num,
> +               ret = ib_find_cached_gid(device, &rec->sgid, ndev, &port_num,
>                                          &gid_index);
> -               if (ret)
> +               if (ret) {
> +                       if (ndev)
> +                               dev_put(ndev);
>                         return ret;
> +               }
>
>                 ah_attr->grh.sgid_index    = gid_index;
>                 ah_attr->grh.flow_label    = be32_to_cpu(rec->flow_label);
>                 ah_attr->grh.hop_limit     = rec->hop_limit;
>                 ah_attr->grh.traffic_class = rec->traffic_class;
> +               if (ndev)
> +                       dev_put(ndev);
>         }
>         if (force_grh) {
>                 memcpy(ah_attr->dmac, rec->dmac, ETH_ALEN);
> @@ -1151,6 +1158,8 @@ static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
>                 ib_unpack(path_rec_table, ARRAY_SIZE(path_rec_table),
>                           mad->data, &rec);
>                 rec.vlan_id = 0xffff;
> +               rec.net = NULL;
> +               rec.ifindex = 0;
>                 memset(rec.dmac, 0, ETH_ALEN);
>                 memset(rec.smac, 0, ETH_ALEN);
>                 query->callback(status, &rec, query->context);
> diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
> index abd9724..484698c 100644
> --- a/drivers/infiniband/core/uverbs_marshall.c
> +++ b/drivers/infiniband/core/uverbs_marshall.c
> @@ -144,5 +144,7 @@ void ib_copy_path_rec_from_user(struct ib_sa_path_rec *dst,
>         memset(dst->smac, 0, sizeof(dst->smac));
>         memset(dst->dmac, 0, sizeof(dst->dmac));
>         dst->vlan_id = 0xffff;
> +       dst->net = NULL;
> +       dst->ifindex = 0;
>  }
>  EXPORT_SYMBOL(ib_copy_path_rec_from_user);
> diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
> index 7e071a6..406ecf1 100644
> --- a/include/rdma/ib_sa.h
> +++ b/include/rdma/ib_sa.h
> @@ -39,6 +39,7 @@
>  #include <linux/compiler.h>
>
>  #include <linux/atomic.h>
> +#include <linux/netdevice.h>
>
>  #include <rdma/ib_verbs.h>
>  #include <rdma/ib_mad.h>
> @@ -157,8 +158,17 @@ struct ib_sa_path_rec {
>         u8           smac[ETH_ALEN];
>         u8           dmac[ETH_ALEN];
>         u16          vlan_id;
> +       /* ignored in IB */
> +       int          ifindex;
> +       /* ignored in IB */
> +       struct net  *net;
>  };
>
> +static inline struct net_device *ib_get_ndev_from_path(struct ib_sa_path_rec *rec)
> +{
> +       return rec->net ? dev_get_by_index(rec->net, rec->ifindex) : NULL;
> +}
> +
>  #define IB_SA_MCMEMBER_REC_MGID                                IB_SA_COMP_MASK( 0)
>  #define IB_SA_MCMEMBER_REC_PORT_GID                    IB_SA_COMP_MASK( 1)
>  #define IB_SA_MCMEMBER_REC_QKEY                                IB_SA_COMP_MASK( 2)
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
