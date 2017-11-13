From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1] RDMA/bnxt_re: report vlan_id and sl in qp1 recv completion
Date: Mon, 13 Nov 2017 14:30:50 +0530
Message-ID: <CANjDDBi6TXx0fiXGEwP22TVe9meuc+BSOLD4ynkSaQJ4YkEjiQ@mail.gmail.com>
References: <1510127325-26879-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510127325-26879-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

I have already sent v1 as Parav asked, if there are no other comments
on this patch, could you please pull this in.

-Regards
Devesh

On Wed, Nov 8, 2017 at 1:18 PM, Devesh Sharma
<devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
> In a real RoCE v2 network it is possible to have two
> Sections of network have same IP hence same gid. However
> those may have different vlans. During connection resolution
> it is important to report the actual vlan on which the
> MAD packet was received instead of relying on other means
> to resolve vlan-id. ib_find_gid_index should not be used
> to resolve the vlan-id using sgid of the local system
> where the packet was received.
>
> Our device has the capability to report the actual VLAN-ID
> in the GSI qp completions. Since we have the capability our
> driver should move away from resolving the vlan-id with the
> help of SGID at the destination port.
>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 35 +++++++++++++++++++++++++++++++-
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c |  1 +
>  2 files changed, 35 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index ebcdfb4..bdb6435 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -2771,6 +2771,32 @@ static void bnxt_re_process_res_rawqp1_wc(struct ib_wc *wc,
>         wc->wc_flags |= IB_WC_GRH;
>  }
>
> +static bool bnxt_re_is_vlan_pkt(struct bnxt_qplib_cqe *orig_cqe,
> +                               u16 *vid, u8 *sl)
> +{
> +       bool ret = false;
> +       u32 metadata;
> +       u16 tpid;
> +
> +       metadata = orig_cqe->raweth_qp1_metadata;
> +       if (orig_cqe->raweth_qp1_flags2 &
> +               CQ_RES_RAWETH_QP1_RAWETH_QP1_FLAGS2_META_FORMAT_VLAN) {
> +               tpid = ((metadata &
> +                        CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_TPID_MASK) >>
> +                        CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_TPID_SFT);
> +               if (tpid == ETH_P_8021Q) {
> +                       *vid = metadata &
> +                              CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_VID_MASK;
> +                       *sl = (metadata &
> +                              CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_PRI_MASK) >>
> +                              CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_PRI_SFT;
> +                       ret = true;
> +               }
> +       }
> +
> +       return ret;
> +}
> +
>  static void bnxt_re_process_res_rc_wc(struct ib_wc *wc,
>                                       struct bnxt_qplib_cqe *cqe)
>  {
> @@ -2790,12 +2816,14 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
>                                              struct ib_wc *wc,
>                                              struct bnxt_qplib_cqe *cqe)
>  {
> -       u32 tbl_idx;
>         struct bnxt_re_dev *rdev = qp->rdev;
>         struct bnxt_re_qp *qp1_qp = NULL;
>         struct bnxt_qplib_cqe *orig_cqe = NULL;
>         struct bnxt_re_sqp_entries *sqp_entry = NULL;
>         int nw_type;
> +       u32 tbl_idx;
> +       u16 vlan_id;
> +       u8 sl;
>
>         tbl_idx = cqe->wr_id;
>
> @@ -2810,6 +2838,11 @@ static void bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
>         wc->ex.imm_data = orig_cqe->immdata;
>         wc->src_qp = orig_cqe->src_qp;
>         memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
> +       if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
> +               wc->vlan_id = vlan_id;
> +               wc->sl = sl;
> +               wc->wc_flags |= IB_WC_WITH_VLAN;
> +       }
>         wc->port_num = 1;
>         wc->vendor_err = orig_cqe->status;
>
> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> index a82044d..8962621 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> @@ -2236,6 +2236,7 @@ static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
>
>         cqe->raweth_qp1_flags = le16_to_cpu(hwcqe->raweth_qp1_flags);
>         cqe->raweth_qp1_flags2 = le32_to_cpu(hwcqe->raweth_qp1_flags2);
> +       cqe->raweth_qp1_metadata = le32_to_cpu(hwcqe->raweth_qp1_metadata);
>
>         rq = &qp->rq;
>         if (wr_id_idx > rq->hwq.max_elements) {
> --
> 1.8.3.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
