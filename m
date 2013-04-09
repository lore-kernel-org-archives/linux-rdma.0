From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups
Date: Wed, 10 Apr 2013 00:43:13 +0300
Message-ID: <CAJZOPZKBns8kPH+ayzd1k--6K0NXFx=1Pez_bfSg9rQz-fvmHg@mail.gmail.com>
References: <1364129012-12198-1-git-send-email-ogerlitz@mellanox.com>
	<1364129012-12198-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364129012-12198-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This patch introduces the concept of RSS and TSS QP groups which
> allows for implementing them by low level drivers and using it
> by IPoIB and later also by user space ULPs.
>
> A QP group is a set of QPs consists of a parent QP and two disjoint sets
> of RSS and TSS QPs. The creation of a QP group is a two stage process:
>
> In the the 1st stage, the parent QP is created.
>
> In the 2nd stage the children QPs of the parent are created.
>
> Each child QP indicates if its a RSS or TSS QP. Both the TSS
> and RSS sets of QPs should have contiguous QP numbers.
>
> It is forbidden to modify parent QP state before all RSS/TSS children
> were created. In the same manner it is disallowed to destroy the parent
> QP unless all RSS/TSS children were destroyed.
>
> A few new elements/concepts are introduced to support this:
>
> Three new device capabilities that can be set by the low level driver:
>
> - IB_DEVICE_QPG which is set to indicate QP groups are supported.
>
> - IB_DEVICE_UD_RSS which is set to indicate that the device supports
> RSS, that is applying hash function on incoming TCP/UDP/IP packets and
> dispatching them to multiple "rings" (child QPs).
>
> - IB_DEVICE_UD_TSS which is set to indicate that the device supports
> "HW TSS" which means that the HW is capable of over-riding the source
> UD QPN present in sent IB datagram header (DTH) with the parent's QPN.
>
> Low level drivers not supporting HW TSS, could still support QP groups, such
> as combination is referred as "SW TSS". Where in this case, the low level drive
> fills in the qpg_tss_mask_sz field of struct ib_qp_cap returned from
> ib_create_qp. Such that this mask can be used to retrieve the parent QPN from
> incoming packets carrying a child QPN (as of the contiguous QP numbers requirement).
>
> - max rss table size device attribute, which is the maximal size of the RSS
> indirection table  supported by the device
>
> - qp group type attribute for qp creation saying whether this is a parent QP
> or rx/tx (rss/tss) child QP or none of the above for non rss/tss QPs.
>
> - per qp group type, another attribute is added, for parent QPs, the number
> of rx/tx child QPs and for child QPs pointer to the parent.
>
> - IB_QP_GROUP_RSS attribute mask, which should be used when modifying
> the parent QP state from reset to init


On Tue, Apr 9, 2013 at 8:06 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> I have no issue with RSS/TSS.  But the 'qp group' interface to using this seems kludgy.

lets try to be more specific

> On a node, this is multiple send/receive queues grouped together to form a larger
> construct.  On the wire, this is a single QP - maybe?  I'm still not clear on that.  From
> what's written, all the send queues appear as a single QPN.  The receive queues
> appear as different QPNs.

Starting with RSS QP groups: its a group made of one parent QP and N
RSS child QPs.

On the wire everything is sent to the RSS parent QP, however, when the
HW receives a packet for which this QP/QPN is the destination, it
applies a hash function on the packet header and subject to the hash
result dispatches the packet to one of the N child QPs.

The design applies for IB UD QPs and Raw Ethernet Packet QP types,
under IB the QPN of the parent is on the wire, under Eth, there are no
QPNs on the wire, but that HW has some "steering rule" which makes
certain packets to be steered to that RSS parent, and the RSS parent
in turn further does dispatching decision (hashing) to determine which
of the child RSS QPs will actually receive that packet.

With IPoIB, the remote side is provided with the RSS parent QPN as
part of the IPoIB HW address provided in the ARP reply payload, so
packets are sent to that QPN. With RAW Packet Eth QPs, the remote side
isn't aware to QPNs at all, all goes through a steering rule who is
directing to the RSS parent.

You can send packets over RSS packet QP but not receive packets.

So for RSS, the remote side isn't aware to that QP group @ all.

Makes sense?

As for TSS QP groups, basically && generally speaking, the only case
that really matters are applications/drivers that care for the source
QPN of a packet.

but lets get there after hopefully agreeing what is RSS QP group.

Or.

>
> Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c         |    1 +
>  drivers/infiniband/core/verbs.c              |  118 ++++++++++++++++++++++++++
>  drivers/infiniband/hw/amso1100/c2_provider.c |    3 +
>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +
>  drivers/infiniband/hw/cxgb4/qp.c             |    3 +
>  drivers/infiniband/hw/ehca/ehca_qp.c         |    3 +
>  drivers/infiniband/hw/ipath/ipath_qp.c       |    3 +
>  drivers/infiniband/hw/mlx4/qp.c              |    3 +
>  drivers/infiniband/hw/mthca/mthca_provider.c |    3 +
>  drivers/infiniband/hw/nes/nes_verbs.c        |    3 +
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    5 +
>  drivers/infiniband/hw/qib/qib_qp.c           |    5 +
>  include/rdma/ib_verbs.h                      |   40 ++++++++-
>  13 files changed, 190 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index a7d00f6..b8f2dff 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -1581,6 +1581,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
>         attr.sq_sig_type   = cmd.sq_sig_all ? IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
>         attr.qp_type       = cmd.qp_type;
>         attr.create_flags  = 0;
> +       attr.qpg_type      = IB_QPG_NONE;
>
>         attr.cap.max_send_wr     = cmd.max_send_wr;
>         attr.cap.max_recv_wr     = cmd.max_recv_wr;
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index a8fdd33..f40f194 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -406,12 +406,98 @@ struct ib_qp *ib_open_qp(struct ib_xrcd *xrcd,
>  }
>  EXPORT_SYMBOL(ib_open_qp);
>
> +static int ib_qpg_verify(struct ib_qp_init_attr *qp_init_attr)
> +{
> +       /* RSS/TSS QP group basic validation */
> +       struct ib_qp *parent;
> +       struct ib_qpg_init_attrib *attr;
> +       struct ib_qpg_attr *pattr;
> +
> +       switch (qp_init_attr->qpg_type) {
> +       case IB_QPG_PARENT:
> +               attr = &qp_init_attr->parent_attrib;
> +               if (attr->tss_child_count == 1)
> +                       return -EINVAL; /* doesn't make sense */
> +               if (attr->rss_child_count == 1)
> +                       return -EINVAL; /* doesn't make sense */
> +               if ((attr->tss_child_count == 0) &&
> +                   (attr->rss_child_count == 0))
> +                       /* should be called with IP_QPG_NONE */
> +                       return -EINVAL;
> +               break;
> +       case IB_QPG_CHILD_RX:
> +               parent = qp_init_attr->qpg_parent;
> +               if (!parent || parent->qpg_type != IB_QPG_PARENT)
> +                       return -EINVAL;
> +               pattr = &parent->qpg_attr.parent_attr;
> +               if (!pattr->rss_child_count)
> +                       return -EINVAL;
> +               if (atomic_read(&pattr->rsscnt) >= pattr->rss_child_count)
> +                       return -EINVAL;
> +               break;
> +       case IB_QPG_CHILD_TX:
> +               parent = qp_init_attr->qpg_parent;
> +               if (!parent || parent->qpg_type != IB_QPG_PARENT)
> +                       return -EINVAL;
> +               pattr = &parent->qpg_attr.parent_attr;
> +               if (!pattr->tss_child_count)
> +                       return -EINVAL;
> +               if (atomic_read(&pattr->tsscnt) >= pattr->tss_child_count)
> +                       return -EINVAL;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
> +static void ib_init_qpg(struct ib_qp_init_attr *qp_init_attr, struct ib_qp *qp)
> +{
> +       struct ib_qp *parent;
> +       struct ib_qpg_init_attrib *attr;
> +       struct ib_qpg_attr *pattr;
> +
> +       qp->qpg_type = qp_init_attr->qpg_type;
> +
> +       /* qp was created without an error parmaters are O.K. */
> +       switch (qp_init_attr->qpg_type) {
> +       case IB_QPG_PARENT:
> +               attr = &qp_init_attr->parent_attrib;
> +               pattr = &qp->qpg_attr.parent_attr;
> +               pattr->rss_child_count = attr->rss_child_count;
> +               pattr->tss_child_count = attr->tss_child_count;
> +               atomic_set(&pattr->rsscnt, 0);
> +               atomic_set(&pattr->tsscnt, 0);
> +               break;
> +       case IB_QPG_CHILD_RX:
> +               parent = qp_init_attr->qpg_parent;
> +               qp->qpg_attr.parent = parent;
> +               /* update parent's counter */
> +               pattr = &parent->qpg_attr.parent_attr;
> +               atomic_inc(&pattr->rsscnt);
> +               break;
> +       case IB_QPG_CHILD_TX:
> +               parent = qp_init_attr->qpg_parent;
> +               qp->qpg_attr.parent = parent;
> +               /* update parent's counter */
> +               pattr = &parent->qpg_attr.parent_attr;
> +               atomic_inc(&pattr->tsscnt);
> +               break;
> +       default:
> +               break;
> +       }
> +}
> +
>  struct ib_qp *ib_create_qp(struct ib_pd *pd,
>                            struct ib_qp_init_attr *qp_init_attr)
>  {
>         struct ib_qp *qp, *real_qp;
>         struct ib_device *device;
>
> +       if (ib_qpg_verify(qp_init_attr))
> +               return ERR_PTR(-EINVAL);
> +
>         device = pd ? pd->device : qp_init_attr->xrcd->device;
>         qp = device->create_qp(pd, qp_init_attr, NULL);
>
> @@ -460,6 +546,8 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
>                         atomic_inc(&pd->usecnt);
>                         atomic_inc(&qp_init_attr->send_cq->usecnt);
>                 }
> +
> +               ib_init_qpg(qp_init_attr, qp);
>         }
>
>         return qp;
> @@ -496,6 +584,9 @@ static const struct {
>                                                 IB_QP_QKEY),
>                                 [IB_QPT_GSI] = (IB_QP_PKEY_INDEX                |
>                                                 IB_QP_QKEY),
> +                       },
> +                       .opt_param = {
> +                               [IB_QPT_UD]  = IB_QP_GROUP_RSS
>                         }
>                 },
>         },
> @@ -805,6 +896,13 @@ int ib_modify_qp(struct ib_qp *qp,
>                  struct ib_qp_attr *qp_attr,
>                  int qp_attr_mask)
>  {
> +       if (qp->qpg_type == IB_QPG_PARENT) {
> +               struct ib_qpg_attr *pattr = &qp->qpg_attr.parent_attr;
> +               if (atomic_read(&pattr->rsscnt) < pattr->rss_child_count)
> +                       return -EINVAL;
> +               if (atomic_read(&pattr->tsscnt) < pattr->tss_child_count)
> +                       return -EINVAL;
> +       }
>         return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
>  }
>  EXPORT_SYMBOL(ib_modify_qp);
> @@ -878,6 +976,15 @@ int ib_destroy_qp(struct ib_qp *qp)
>         if (atomic_read(&qp->usecnt))
>                 return -EBUSY;
>
> +       if (qp->qpg_type == IB_QPG_PARENT) {
> +               /* All childeren should have been deleted by now */
> +               struct ib_qpg_attr *pattr = &qp->qpg_attr.parent_attr;
> +               if (atomic_read(&pattr->rsscnt))
> +                       return -EINVAL;
> +               if (atomic_read(&pattr->tsscnt))
> +                       return -EINVAL;
> +       }
> +
>         if (qp->real_qp != qp)
>                 return __ib_destroy_shared_qp(qp);
>
> @@ -896,6 +1003,17 @@ int ib_destroy_qp(struct ib_qp *qp)
>                         atomic_dec(&rcq->usecnt);
>                 if (srq)
>                         atomic_dec(&srq->usecnt);
> +
> +               if (qp->qpg_type == IB_QPG_CHILD_RX ||
> +                   qp->qpg_type == IB_QPG_CHILD_TX) {
> +                       /* decrement parent's counters */
> +                       struct ib_qp *pqp = qp->qpg_attr.parent;
> +                       struct ib_qpg_attr *pattr = &pqp->qpg_attr.parent_attr;
> +                       if (qp->qpg_type == IB_QPG_CHILD_RX)
> +                               atomic_dec(&pattr->rsscnt);
> +                       else
> +                               atomic_dec(&pattr->tsscnt);
> +               }
>         }
>
>         return ret;
> diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
> index 07eb3a8..546760b 100644
> --- a/drivers/infiniband/hw/amso1100/c2_provider.c
> +++ b/drivers/infiniband/hw/amso1100/c2_provider.c
> @@ -241,6 +241,9 @@ static struct ib_qp *c2_create_qp(struct ib_pd *pd,
>         if (init_attr->create_flags)
>                 return ERR_PTR(-EINVAL);
>
> +       if (init_attr->qpg_type != IB_QPG_NONE)
> +               return ERR_PTR(-ENOSYS);
> +
>         switch (init_attr->qp_type) {
>         case IB_QPT_RC:
>                 qp = kzalloc(sizeof(*qp), GFP_KERNEL);
> diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> index 9c12da0..f3d9e0c 100644
> --- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -905,6 +905,8 @@ static struct ib_qp *iwch_create_qp(struct ib_pd *pd,
>         PDBG("%s ib_pd %p\n", __func__, pd);
>         if (attrs->qp_type != IB_QPT_RC)
>                 return ERR_PTR(-EINVAL);
> +       if (attrs->qpg_type != IB_QPG_NONE)
> +               return ERR_PTR(-ENOSYS);
>         php = to_iwch_pd(pd);
>         rhp = php->rhp;
>         schp = get_chp(rhp, ((struct iwch_cq *) attrs->send_cq)->cq.cqid);
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
> index 70b1808..e21b89b 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -1491,6 +1491,9 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
>         if (attrs->qp_type != IB_QPT_RC)
>                 return ERR_PTR(-EINVAL);
>
> +       if (attrs->qpg_type != IB_QPG_NONE)
> +               return ERR_PTR(-ENOSYS);
> +
>         php = to_c4iw_pd(pd);
>         rhp = php->rhp;
>         schp = get_chp(rhp, ((struct c4iw_cq *)attrs->send_cq)->cq.cqid);
> diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
> index 00d6861..627c32c 100644
> --- a/drivers/infiniband/hw/ehca/ehca_qp.c
> +++ b/drivers/infiniband/hw/ehca/ehca_qp.c
> @@ -464,6 +464,9 @@ static struct ehca_qp *internal_create_qp(
>         int is_llqp = 0, has_srq = 0, is_user = 0;
>         int qp_type, max_send_sge, max_recv_sge, ret;
>
> +       if (init_attr->qpg_type != IB_QPG_NONE)
> +               return ERR_PTR(-ENOSYS);
> +
>         /* h_call's out parameters */
>         struct ehca_alloc_qp_parms parms;
>         u32 swqe_size = 0, rwqe_size = 0, ib_qp_num;
> diff --git a/drivers/infiniband/hw/ipath/ipath_qp.c b/drivers/infiniband/hw/ipath/ipath_qp.c
> index 0857a9c..117b775 100644
> --- a/drivers/infiniband/hw/ipath/ipath_qp.c
> +++ b/drivers/infiniband/hw/ipath/ipath_qp.c
> @@ -755,6 +755,9 @@ struct ib_qp *ipath_create_qp(struct ib_pd *ibpd,
>                 goto bail;
>         }
>
> +       if (init_attr->qpg_type != IB_QPG_NONE)
> +               return ERR_PTR(-ENOSYS);
> +
>         if (init_attr->cap.max_send_sge > ib_ipath_max_sges ||
>             init_attr->cap.max_send_wr > ib_ipath_max_qp_wrs) {
>                 ret = ERR_PTR(-EINVAL);
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index 35cced2..c58dbdc 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -998,6 +998,9 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
>               init_attr->qp_type > IB_QPT_GSI)))
>                 return ERR_PTR(-EINVAL);
>
> +       if (init_attr->qpg_type != IB_QPG_NONE)
> +               return ERR_PTR(-ENOSYS);
> +
>         switch (init_attr->qp_type) {
>         case IB_QPT_XRC_TGT:
>                 pd = to_mxrcd(init_attr->xrcd)->pd;
> diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
> index 5b71d43..120aa1e 100644
> --- a/drivers/infiniband/hw/mthca/mthca_provider.c
> +++ b/drivers/infiniband/hw/mthca/mthca_provider.c
> @@ -518,6 +518,9 @@ static struct ib_qp *mthca_create_qp(struct ib_pd *pd,
>         if (init_attr->create_flags)
>                 return ERR_PTR(-EINVAL);
>
> +       if (init_attr->qpg_type != IB_QPG_NONE)
> +               return ERR_PTR(-ENOSYS);
> +
>         switch (init_attr->qp_type) {
>         case IB_QPT_RC:
>         case IB_QPT_UC:
> diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
> index 8f67fe2..dfae39a 100644
> --- a/drivers/infiniband/hw/nes/nes_verbs.c
> +++ b/drivers/infiniband/hw/nes/nes_verbs.c
> @@ -1134,6 +1134,9 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
>         if (init_attr->create_flags)
>                 return ERR_PTR(-EINVAL);
>
> +       if (init_attr->qpg_type != IB_QPG_NONE)
> +               return ERR_PTR(-ENOSYS);
> +
>         atomic_inc(&qps_created);
>         switch (init_attr->qp_type) {
>                 case IB_QPT_RC:
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index b29a424..7c3e0ce 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -841,6 +841,11 @@ static int ocrdma_check_qp_params(struct ib_pd *ibpd, struct ocrdma_dev *dev,
>                            __func__, dev->id, attrs->qp_type);
>                 return -EINVAL;
>         }
> +       if (attrs->qpg_type != IB_QPG_NONE) {
> +               ocrdma_err("%s(%d) unsupported qpg type=0x%x requested\n",
> +                          __func__, dev->id, attrs->qpg_type);
> +                          return -ENOSYS;
> +       }
>         if (attrs->cap.max_send_wr > dev->attr.max_wqe) {
>                 ocrdma_err("%s(%d) unsupported send_wr=0x%x requested\n",
>                            __func__, dev->id, attrs->cap.max_send_wr);
> diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
> index a6a2cc2..eda3f93 100644
> --- a/drivers/infiniband/hw/qib/qib_qp.c
> +++ b/drivers/infiniband/hw/qib/qib_qp.c
> @@ -986,6 +986,11 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
>                 goto bail;
>         }
>
> +       if (init_attr->qpg_type != IB_QPG_NONE) {
> +               ret = ERR_PTR(-ENOSYS);
> +               goto bail;
> +       }
> +
>         /* Check receive queue parameters if no SRQ is specified. */
>         if (!init_attr->srq) {
>                 if (init_attr->cap.max_recv_sge > ib_qib_max_sges ||
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 98cc4b2..9317e76 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -116,7 +116,10 @@ enum ib_device_cap_flags {
>         IB_DEVICE_MEM_MGT_EXTENSIONS    = (1<<21),
>         IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
>         IB_DEVICE_MEM_WINDOW_TYPE_2A    = (1<<23),
> -       IB_DEVICE_MEM_WINDOW_TYPE_2B    = (1<<24)
> +       IB_DEVICE_MEM_WINDOW_TYPE_2B    = (1<<24),
> +       IB_DEVICE_QPG                   = (1<<25),
> +       IB_DEVICE_UD_RSS                = (1<<26),
> +       IB_DEVICE_UD_TSS                = (1<<27)
>  };
>
>  enum ib_atomic_cap {
> @@ -164,6 +167,7 @@ struct ib_device_attr {
>         int                     max_srq_wr;
>         int                     max_srq_sge;
>         unsigned int            max_fast_reg_page_list_len;
> +       int                     max_rss_tbl_sz;
>         u16                     max_pkeys;
>         u8                      local_ca_ack_delay;
>  };
> @@ -586,6 +590,7 @@ struct ib_qp_cap {
>         u32     max_send_sge;
>         u32     max_recv_sge;
>         u32     max_inline_data;
> +       u32     qpg_tss_mask_sz;
>  };
>
>  enum ib_sig_type {
> @@ -621,6 +626,18 @@ enum ib_qp_create_flags {
>         IB_QP_CREATE_RESERVED_END               = 1 << 31,
>  };
>
> +enum ib_qpg_type {
> +       IB_QPG_NONE     = 0,
> +       IB_QPG_PARENT   = (1<<0),
> +       IB_QPG_CHILD_RX = (1<<1),
> +       IB_QPG_CHILD_TX = (1<<2)
> +};
> +
> +struct ib_qpg_init_attrib {
> +       u32 tss_child_count;
> +       u32 rss_child_count;
> +};
> +
>  struct ib_qp_init_attr {
>         void                  (*event_handler)(struct ib_event *, void *);
>         void                   *qp_context;
> @@ -629,9 +646,14 @@ struct ib_qp_init_attr {
>         struct ib_srq          *srq;
>         struct ib_xrcd         *xrcd;     /* XRC TGT QPs only */
>         struct ib_qp_cap        cap;
> +       union {
> +               struct ib_qp *qpg_parent; /* see qpg_type */
> +               struct ib_qpg_init_attrib parent_attrib;
> +       };
>         enum ib_sig_type        sq_sig_type;
>         enum ib_qp_type         qp_type;
>         enum ib_qp_create_flags create_flags;
> +       enum ib_qpg_type        qpg_type;
>         u8                      port_num; /* special QP types only */
>  };
>
> @@ -698,7 +720,8 @@ enum ib_qp_attr_mask {
>         IB_QP_MAX_DEST_RD_ATOMIC        = (1<<17),
>         IB_QP_PATH_MIG_STATE            = (1<<18),
>         IB_QP_CAP                       = (1<<19),
> -       IB_QP_DEST_QPN                  = (1<<20)
> +       IB_QP_DEST_QPN                  = (1<<20),
> +       IB_QP_GROUP_RSS                 = (1<<21)
>  };
>
>  enum ib_qp_state {
> @@ -994,6 +1017,14 @@ struct ib_srq {
>         } ext;
>  };
>
> +struct ib_qpg_attr {
> +       atomic_t rsscnt; /* count open rss children */
> +       atomic_t tsscnt; /* count open rss children */
> +       u32      rss_child_count;
> +       u32      tss_child_count;
> +};
> +
> +
>  struct ib_qp {
>         struct ib_device       *device;
>         struct ib_pd           *pd;
> @@ -1010,6 +1041,11 @@ struct ib_qp {
>         void                   *qp_context;
>         u32                     qp_num;
>         enum ib_qp_type         qp_type;
> +       enum ib_qpg_type        qpg_type;
> +       union {
> +               struct ib_qp   *parent; /* rss/tss parent */
> +               struct ib_qpg_attr parent_attr;
> +       } qpg_attr;
>  };
>
>  struct ib_mr {
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
