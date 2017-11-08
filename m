From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/bnxt_re: report vlan_id and sl in qp1 recv completion
Date: Wed, 8 Nov 2017 13:13:25 +0530
Message-ID: <CANjDDBg0Sywthx1GaFFgNc-KUFoxaOme3aZGZaONQ5HK2Y61ew@mail.gmail.com>
References: <1510119893-24676-1-git-send-email-devesh.sharma@broadcom.com> <VI1PR0502MB3008145309EC3989B23415CED1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008145309EC3989B23415CED1560-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 8, 2017 at 11:57 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>
>> -----Original Message-----
>> From: Devesh Sharma [mailto:devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org]
>> Sent: Tuesday, November 07, 2017 11:45 PM
>> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>;
>> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Subject: [PATCH] RDMA/bnxt_re: report vlan_id and sl in qp1 recv completion
>>
>> In a real RoCE v2 network it is possible to have two Sections of network have
>> same IP hence same gid. However those may have different vlans. During
>> connection resolution it is important to report the actual vlan on which the MAD
>> packet was received instead of relying on other means to resolve vlan-id.
>> ib_find_gid_index should not be used to resolve the vlan-id using sgid of the
>> local system where the packet was received.
>>
>> Our device has the capability to report the actual VLAN-ID in the GSI qp
>> completions. Since we have the capability our driver should move away from
>> resolving the vlan-id with the help of SGID at the destination port.
>>
>> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>> Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 33
>> ++++++++++++++++++++++++++++++++
>> drivers/infiniband/hw/bnxt_re/qplib_fp.c |  1 +
>>  2 files changed, 34 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> index ebcdfb4..558d786 100644
>> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> @@ -2771,6 +2771,32 @@ static void bnxt_re_process_res_rawqp1_wc(struct
>> ib_wc *wc,
>>       wc->wc_flags |= IB_WC_GRH;
>>  }
>>
>> +static bool bnxt_re_is_vlan_pkt(struct bnxt_qplib_cqe *orig_cqe,
>> +                             u16 *vid, u8 *sl)
>> +{
>> +     u32 metadata;
>> +     u16 tpid;
>> +     bool ret = false;
>> +
> Large number of places reverse Christmas tree reverse order is not followed, but let's try to follow for newly added code  like below.
>         bool ret = false;
>         u32 metadata;
>         u16 tpid;
>

Okay sending a rev.

>> +     metadata = orig_cqe->raweth_qp1_metadata;
>> +     if (orig_cqe->raweth_qp1_flags2 &
>> +
>>       CQ_RES_RAWETH_QP1_RAWETH_QP1_FLAGS2_META_FORMAT_VLAN)
>> {
>> +             tpid = ((metadata &
>> +
>> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_TPID_MASK) >>
>> +
>> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_TPID_SFT);
>> +             if (tpid == ETH_P_8021Q) {
>> +                     *vid = metadata &
>> +
>> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_VID_MASK;
>> +                     *sl = (metadata &
>> +
>> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_PRI_MASK) >>
>> +
>> CQ_RES_RAWETH_QP1_RAWETH_QP1_METADATA_PRI_SFT;
>> +                     ret = true;
>> +             }
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>>  static void bnxt_re_process_res_rc_wc(struct ib_wc *wc,
>>                                     struct bnxt_qplib_cqe *cqe)
>>  {
>> @@ -2796,6 +2822,8 @@ static void
>> bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
>>       struct bnxt_qplib_cqe *orig_cqe = NULL;
>>       struct bnxt_re_sqp_entries *sqp_entry = NULL;
>>       int nw_type;
>> +     u16 vlan_id;
>> +     u8 sl;
>>
>>       tbl_idx = cqe->wr_id;
>>
>> @@ -2810,6 +2838,11 @@ static void
>> bnxt_re_process_res_shadow_qp_wc(struct bnxt_re_qp *qp,
>>       wc->ex.imm_data = orig_cqe->immdata;
>>       wc->src_qp = orig_cqe->src_qp;
>>       memcpy(wc->smac, orig_cqe->smac, ETH_ALEN);
>> +     if (bnxt_re_is_vlan_pkt(orig_cqe, &vlan_id, &sl)) {
>> +             wc->vlan_id = vlan_id;
>> +             wc->sl = sl;
>> +             wc->wc_flags |= IB_WC_WITH_VLAN;
>> +     }
>>       wc->port_num = 1;
>>       wc->vendor_err = orig_cqe->status;
>>
>> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
>> b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
>> index a82044d..8962621 100644
>> --- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
>> +++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
>> @@ -2236,6 +2236,7 @@ static int
>> bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
>>
>>       cqe->raweth_qp1_flags = le16_to_cpu(hwcqe->raweth_qp1_flags);
>>       cqe->raweth_qp1_flags2 = le32_to_cpu(hwcqe->raweth_qp1_flags2);
>> +     cqe->raweth_qp1_metadata = le32_to_cpu(hwcqe-
>> >raweth_qp1_metadata);
>>
>>       rq = &qp->rq;
>>       if (wr_id_idx > rq->hwq.max_elements) {
>> --
>> 1.8.3.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
