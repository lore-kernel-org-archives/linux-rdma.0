From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v3-v6] Add OPA extended LID support
Date: Tue, 15 Aug 2017 13:40:22 -0700
Message-ID: <8d3d0a5a-df5e-b023-ec7c-f83e47a22f00@intel.com>
References: <1502734663-44224-1-git-send-email-don.hiatt@intel.com>
 <50ff7793-413a-09a6-1805-ca0bce0452a2@intel.com>
 <cd6cd877-659d-8218-abf8-a23905af4f42@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cd6cd877-659d-8218-abf8-a23905af4f42-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 8/14/2017 1:12 PM, Don Hiatt wrote:
> On 8/14/2017 11:36 AM, Don Hiatt wrote:
>>
>>
>> On 8/14/2017 11:17 AM, Don Hiatt wrote:
>>> This patch series primarily increases sizes of variables that hold
>>> lid values from 16 to 32 bits. Additionally, it adds a check in
>>> the IB mad stack to verify a properly formatted MAD when OPA
>>> extended LIDs are used.
>>>
>>> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> ---
>>>
>>> This is an incremental patch to move from v3 of the 'Add OPA
>>> extended LID support' to v6 of the series.
>>> Changes from v5:
>>> ---------------
>>> * Fixed typo in WARN_ON_ONCE usage in helper functions.
>>> * Actually return be16 in ib_lid_be16() helper function.
>>
>> Sorry, this was meant to go to my email as a test, not to the list. 
>> My tests are still running so please
>> hold off on this until I confirm.
>>
> All test completed fine. I think we're good to go.
>
> Leon, if I missed anything else please let me know.
>
> Thanks,
>
> don
>
I did not get this email respond but saw it on the mailing list so 
pasted it in to respond)

 >Yeah, you should fix the function below too.
 >The whole extended LID series did enormous mess with all these 
lid/slid/dlid.
 >
 > 88 static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
 > 89 {
 > 90         if ((be32_to_cpu(dlid) >=
 > 91              be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
 > 92             (be32_to_cpu(slid) >=
 > 93              be16_to_cpu(IB_MULTICAST_LID_BASE)))
 > 94                 return true;
 > 95         else
 > 96                 return false;
 > 97 }
 >
 >It will help a lot, if you break this patch to small steps:
 >1. Fix existing annotation errors.
 >2. Change (rename) the ib_lid/ib_slid functions.
 >3. Add WARN_ON.
 >
 >Right now, we have potential breakage of compatibility between
 >big-endian vs. little-endian systems.
 >
 >Please run smatch and sparse checkers before LID patches and after to
 >know what else you should fix.
 >
 > Thanks

This patch series sat on the mailing list for over two months since the 
your last
request. It then got merged in and an incremental patch was asked for.

I've been trying to address your concerns but since this patch is going 
in as an
incremental  patch I do not see how breaking it up as requested is 
required.

If Doug would like to pull the entire series then I'll break the patches up.

As of now, with this patch the endian-ness issues have been resolved, or 
are you
saying they are not?


>>> Changes from v4:
>>> ---------------
>>> * Add comment for function usage and a warning to catch bad flows.
>>> * Rename ib_slid_{be,cpu}16 to ib_lid_{be,cpu}16.
>>>
>>> Changes from v3:
>>> ---------------
>>> * Add 'IB/core: Add functions to convert 32 bit lids to 16 bits' and
>>>    use them in place of casts.
>>>
>>>   drivers/infiniband/core/cm.c            |  4 ++--
>>>   drivers/infiniband/core/user_mad.c      |  2 +-
>>>   drivers/infiniband/core/uverbs_cmd.c    | 11 ++++++-----
>>>   drivers/infiniband/hw/hfi1/mad.c        |  2 +-
>>>   drivers/infiniband/hw/mlx4/alias_GUID.c |  2 +-
>>>   drivers/infiniband/hw/mlx4/mad.c        |  8 ++++----
>>>   drivers/infiniband/hw/mlx5/mad.c        |  2 +-
>>>   drivers/infiniband/hw/mthca/mthca_cmd.c |  4 ++--
>>>   drivers/infiniband/hw/mthca/mthca_mad.c |  4 ++--
>>>   drivers/infiniband/sw/rdmavt/cq.c       |  2 +-
>>>   include/rdma/ib_verbs.h                 | 26 
>>> ++++++++++++++++++++------
>>>   11 files changed, 41 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/core/cm.c 
>>> b/drivers/infiniband/core/cm.c
>>> index d5ca101..8bb7aea 100644
>>> --- a/drivers/infiniband/core/cm.c
>>> +++ b/drivers/infiniband/core/cm.c
>>> @@ -1770,7 +1770,7 @@ static void cm_process_routed_req(struct 
>>> cm_req_msg *req_msg, struct ib_wc *wc)
>>>   {
>>>       if (!cm_req_get_primary_subnet_local(req_msg)) {
>>>           if (req_msg->primary_local_lid == IB_LID_PERMISSIVE) {
>>> -            req_msg->primary_local_lid = ib_slid_be16(wc->slid);
>>> +            req_msg->primary_local_lid = ib_lid_be16(wc->slid);
>>>               cm_req_set_primary_sl(req_msg, wc->sl);
>>>           }
>>>   @@ -1780,7 +1780,7 @@ static void cm_process_routed_req(struct 
>>> cm_req_msg *req_msg, struct ib_wc *wc)
>>>         if (!cm_req_get_alt_subnet_local(req_msg)) {
>>>           if (req_msg->alt_local_lid == IB_LID_PERMISSIVE) {
>>> -            req_msg->alt_local_lid = ib_slid_be16(wc->slid);
>>> +            req_msg->alt_local_lid = ib_lid_be16(wc->slid);
>>>               cm_req_set_alt_sl(req_msg, wc->sl);
>>>           }
>>>   diff --git a/drivers/infiniband/core/user_mad.c 
>>> b/drivers/infiniband/core/user_mad.c
>>> index ff3c67a..c1696e6 100644
>>> --- a/drivers/infiniband/core/user_mad.c
>>> +++ b/drivers/infiniband/core/user_mad.c
>>> @@ -229,7 +229,7 @@ static void recv_handler(struct ib_mad_agent 
>>> *agent,
>>>       packet->mad.hdr.status       = 0;
>>>       packet->mad.hdr.length       = hdr_size(file) + 
>>> mad_recv_wc->mad_len;
>>>       packet->mad.hdr.qpn       = cpu_to_be32(mad_recv_wc->wc->src_qp);
>>> -    packet->mad.hdr.lid       = ib_slid_be16(mad_recv_wc->wc->slid);
>>> +    packet->mad.hdr.lid       = ib_lid_be16(mad_recv_wc->wc->slid);
>>>       packet->mad.hdr.sl       = mad_recv_wc->wc->sl;
>>>       packet->mad.hdr.path_bits  = mad_recv_wc->wc->dlid_path_bits;
>>>       packet->mad.hdr.pkey_index = mad_recv_wc->wc->pkey_index;
>>> diff --git a/drivers/infiniband/core/uverbs_cmd.c 
>>> b/drivers/infiniband/core/uverbs_cmd.c
>>> index eb0da37..0eed250 100644
>>> --- a/drivers/infiniband/core/uverbs_cmd.c
>>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>>> @@ -275,12 +275,13 @@ ssize_t ib_uverbs_query_port(struct 
>>> ib_uverbs_file *file,
>>>       resp.bad_pkey_cntr   = attr.bad_pkey_cntr;
>>>       resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
>>>       resp.pkey_tbl_len    = attr.pkey_tbl_len;
>>> +
>>>       if (rdma_cap_opa_ah(ib_dev, cmd.port_num)) {
>>> -        resp.lid  = OPA_TO_IB_UCAST_LID(attr.lid);
>>> +        resp.lid     = OPA_TO_IB_UCAST_LID(attr.lid);
>>>           resp.sm_lid  = OPA_TO_IB_UCAST_LID(attr.sm_lid);
>>>       } else {
>>> -        resp.lid     = (u16)attr.lid;
>>> -        resp.sm_lid  = (u16)attr.sm_lid;
>>> +        resp.lid     = ib_lid_cpu16(attr.lid);
>>> +        resp.sm_lid  = ib_lid_cpu16(attr.sm_lid);
>>>       }
>>>       resp.lmc          = attr.lmc;
>>>       resp.max_vl_num      = attr.max_vl_num;
>>> @@ -1206,9 +1207,9 @@ static int copy_wc_to_user(struct ib_device 
>>> *ib_dev, void __user *dest,
>>>       tmp.wc_flags        = wc->wc_flags;
>>>       tmp.pkey_index        = wc->pkey_index;
>>>       if (rdma_cap_opa_ah(ib_dev, wc->port_num))
>>> -        tmp.slid  = OPA_TO_IB_UCAST_LID(wc->slid);
>>> +        tmp.slid    = OPA_TO_IB_UCAST_LID(wc->slid);
>>>       else
>>> -        tmp.slid  = ib_slid_cpu16(wc->slid);
>>> +        tmp.slid    = ib_lid_cpu16(wc->slid);
>>>       tmp.sl            = wc->sl;
>>>       tmp.dlid_path_bits    = wc->dlid_path_bits;
>>>       tmp.port_num        = wc->port_num;
>>> diff --git a/drivers/infiniband/hw/hfi1/mad.c 
>>> b/drivers/infiniband/hw/hfi1/mad.c
>>> index 00ebc26..8d1aa34 100644
>>> --- a/drivers/infiniband/hw/hfi1/mad.c
>>> +++ b/drivers/infiniband/hw/hfi1/mad.c
>>> @@ -3958,7 +3958,7 @@ static int opa_local_smp_check(struct 
>>> hfi1_ibport *ibp,
>>>                      const struct ib_wc *in_wc)
>>>   {
>>>       struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
>>> -    u16 slid = ib_slid_cpu16(in_wc->slid);
>>> +    u16 slid = ib_lid_cpu16(in_wc->slid);
>>>       u16 pkey;
>>>         if (in_wc->pkey_index >= ARRAY_SIZE(ppd->pkeys))
>>> diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c 
>>> b/drivers/infiniband/hw/mlx4/alias_GUID.c
>>> index 5a897b0..0e4f60c 100644
>>> --- a/drivers/infiniband/hw/mlx4/alias_GUID.c
>>> +++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
>>> @@ -528,7 +528,7 @@ static int set_guid_rec(struct ib_device *ibdev,
>>>         memset(&guid_info_rec, 0, sizeof (struct ib_sa_guidinfo_rec));
>>>   -    guid_info_rec.lid = cpu_to_be16((u16)attr.lid);
>>> +    guid_info_rec.lid = ib_lid_be16(attr.lid);
>>>       guid_info_rec.block_num = index;
>>>         memcpy(guid_info_rec.guid_info_list, rec_det->all_recs,
>>> diff --git a/drivers/infiniband/hw/mlx4/mad.c 
>>> b/drivers/infiniband/hw/mlx4/mad.c
>>> index 04fb44e..0793a21 100644
>>> --- a/drivers/infiniband/hw/mlx4/mad.c
>>> +++ b/drivers/infiniband/hw/mlx4/mad.c
>>> @@ -169,7 +169,7 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int 
>>> mad_ifc_flags,
>>>             op_modifier |= 0x4;
>>>   -        in_modifier |= ib_slid_cpu16(in_wc->slid) << 16;
>>> +        in_modifier |= ib_lid_cpu16(in_wc->slid) << 16;
>>>       }
>>>         err = mlx4_cmd_box(dev->dev, inmailbox->dma, 
>>> outmailbox->dma, in_modifier,
>>> @@ -625,7 +625,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev 
>>> *dev, int slave, u8 port,
>>>           memcpy((char *)&tun_mad->hdr.slid_mac_47_32, 
>>> &(wc->smac[4]), 2);
>>>       } else {
>>>           tun_mad->hdr.sl_vid = cpu_to_be16(((u16)(wc->sl)) << 12);
>>> -        tun_mad->hdr.slid_mac_47_32 = ib_slid_be16(wc->slid);
>>> +        tun_mad->hdr.slid_mac_47_32 = ib_lid_be16(wc->slid);
>>>       }
>>>         ib_dma_sync_single_for_device(&dev->ib_dev,
>>> @@ -826,7 +826,7 @@ static int ib_process_mad(struct ib_device 
>>> *ibdev, int mad_flags, u8 port_num,
>>>           }
>>>       }
>>>   -    slid = in_wc ? ib_slid_cpu16(in_wc->slid) : 
>>> be16_to_cpu(IB_LID_PERMISSIVE);
>>> +    slid = in_wc ? ib_lid_cpu16(in_wc->slid) : 
>>> be16_to_cpu(IB_LID_PERMISSIVE);
>>>         if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 
>>> 0) {
>>>           forward_trap(to_mdev(ibdev), port_num, in_mad);
>>> @@ -860,7 +860,7 @@ static int ib_process_mad(struct ib_device 
>>> *ibdev, int mad_flags, u8 port_num,
>>>           in_mad->mad_hdr.method == IB_MGMT_METHOD_SET &&
>>>           in_mad->mad_hdr.attr_id == IB_SMP_ATTR_PORT_INFO &&
>>>           !ib_query_port(ibdev, port_num, &pattr))
>>> -        prev_lid = (u16)pattr.lid;
>>> +        prev_lid = ib_lid_cpu16(pattr.lid);
>>>         err = mlx4_MAD_IFC(to_mdev(ibdev),
>>>                  (mad_flags & IB_MAD_IGNORE_MKEY ? 
>>> MLX4_MAD_IFC_IGNORE_MKEY : 0) |
>>> diff --git a/drivers/infiniband/hw/mlx5/mad.c 
>>> b/drivers/infiniband/hw/mlx5/mad.c
>>> index cd2264a..18cfe5b 100644
>>> --- a/drivers/infiniband/hw/mlx5/mad.c
>>> +++ b/drivers/infiniband/hw/mlx5/mad.c
>>> @@ -78,7 +78,7 @@ static int process_mad(struct ib_device *ibdev, 
>>> int mad_flags, u8 port_num,
>>>       u16 slid;
>>>       int err;
>>>   -    slid = in_wc ? ib_slid_cpu16(in_wc->slid) : 
>>> be16_to_cpu(IB_LID_PERMISSIVE);
>>> +    slid = in_wc ? ib_lid_cpu16(in_wc->slid) : 
>>> be16_to_cpu(IB_LID_PERMISSIVE);
>>>         if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 0)
>>>           return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
>>> diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c 
>>> b/drivers/infiniband/hw/mthca/mthca_cmd.c
>>> index e19ae0b..d0f062f 100644
>>> --- a/drivers/infiniband/hw/mthca/mthca_cmd.c
>>> +++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
>>> @@ -1921,7 +1921,7 @@ int mthca_MAD_IFC(struct mthca_dev *dev, int 
>>> ignore_mkey, int ignore_bkey,
>>>               (in_wc->wc_flags & IB_WC_GRH ? 0x80 : 0);
>>>           MTHCA_PUT(inbox, val, MAD_IFC_G_PATH_OFFSET);
>>>   -        MTHCA_PUT(inbox, ib_slid_cpu16(in_wc->slid), 
>>> MAD_IFC_RLID_OFFSET);
>>> +        MTHCA_PUT(inbox, ib_lid_cpu16(in_wc->slid), 
>>> MAD_IFC_RLID_OFFSET);
>>>           MTHCA_PUT(inbox, in_wc->pkey_index, MAD_IFC_PKEY_OFFSET);
>>>             if (in_grh)
>>> @@ -1929,7 +1929,7 @@ int mthca_MAD_IFC(struct mthca_dev *dev, int 
>>> ignore_mkey, int ignore_bkey,
>>>             op_modifier |= 0x4;
>>>   -        in_modifier |= ib_slid_cpu16(in_wc->slid) << 16;
>>> +        in_modifier |= ib_lid_cpu16(in_wc->slid) << 16;
>>>       }
>>>         err = mthca_cmd_box(dev, inmailbox->dma, outmailbox->dma,
>>> diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c 
>>> b/drivers/infiniband/hw/mthca/mthca_mad.c
>>> index a9caada..093f775 100644
>>> --- a/drivers/infiniband/hw/mthca/mthca_mad.c
>>> +++ b/drivers/infiniband/hw/mthca/mthca_mad.c
>>> @@ -205,7 +205,7 @@ int mthca_process_mad(struct ib_device *ibdev,
>>>                 u16 *out_mad_pkey_index)
>>>   {
>>>       int err;
>>> -    u16 slid = in_wc ? ib_slid_cpu16(in_wc->slid) : 
>>> be16_to_cpu(IB_LID_PERMISSIVE);
>>> +    u16 slid = in_wc ? ib_lid_cpu16(in_wc->slid) : 
>>> be16_to_cpu(IB_LID_PERMISSIVE);
>>>       u16 prev_lid = 0;
>>>       struct ib_port_attr pattr;
>>>       const struct ib_mad *in_mad = (const struct ib_mad *)in;
>>> @@ -256,7 +256,7 @@ int mthca_process_mad(struct ib_device *ibdev,
>>>           in_mad->mad_hdr.method == IB_MGMT_METHOD_SET &&
>>>           in_mad->mad_hdr.attr_id == IB_SMP_ATTR_PORT_INFO &&
>>>           !ib_query_port(ibdev, port_num, &pattr))
>>> -        prev_lid = (u16)pattr.lid;
>>> +        prev_lid = ib_lid_cpu16(pattr.lid);
>>>         err = mthca_MAD_IFC(to_mdev(ibdev),
>>>                   mad_flags & IB_MAD_IGNORE_MKEY,
>>> diff --git a/drivers/infiniband/sw/rdmavt/cq.c 
>>> b/drivers/infiniband/sw/rdmavt/cq.c
>>> index 0335a3d..97d71e4 100644
>>> --- a/drivers/infiniband/sw/rdmavt/cq.c
>>> +++ b/drivers/infiniband/sw/rdmavt/cq.c
>>> @@ -107,7 +107,7 @@ void rvt_cq_enter(struct rvt_cq *cq, struct 
>>> ib_wc *entry, bool solicited)
>>>           wc->uqueue[head].src_qp = entry->src_qp;
>>>           wc->uqueue[head].wc_flags = entry->wc_flags;
>>>           wc->uqueue[head].pkey_index = entry->pkey_index;
>>> -        wc->uqueue[head].slid = ib_slid_cpu16(entry->slid);
>>> +        wc->uqueue[head].slid = ib_lid_cpu16(entry->slid);
>>>           wc->uqueue[head].sl = entry->sl;
>>>           wc->uqueue[head].dlid_path_bits = entry->dlid_path_bits;
>>>           wc->uqueue[head].port_num = entry->port_num;
>>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>>> index 7eaf7d2..a766b8d 100644
>>> --- a/include/rdma/ib_verbs.h
>>> +++ b/include/rdma/ib_verbs.h
>>> @@ -3707,15 +3707,29 @@ static inline enum rdma_ah_attr_type 
>>> rdma_ah_find_type(struct ib_device *dev,
>>>           return RDMA_AH_ATTR_TYPE_IB;
>>>   }
>>>   -/* Return slid in 16bit CPU encoding */
>>> -static inline u16 ib_slid_cpu16(u32 slid)
>>> +/**
>>> + * ib_lid_cpu16 - Return lid in 16bit CPU encoding.
>>> + *     In the current implementation the only way to get
>>> + *     get the 32bit lid is from other sources for OPA.
>>> + *     For IB, lids will always be 16bits so cast the
>>> + *     value accordingly.
>>> + *
>>> + * @lid: A 32bit LID
>>> + */
>>> +static inline u16 ib_lid_cpu16(u32 lid)
>>>   {
>>> -    return (u16)slid;
>>> +    WARN_ON_ONCE(lid & 0xFFFF0000);
>>> +    return (u16)lid;
>>>   }
>>>   -/* Return slid in 16bit BE encoding */
>>> -static inline u16 ib_slid_be16(u32 slid)
>>> +/**
>>> + * ib_lid_be16 - Return lid in 16bit BE encoding.
>>> + *
>>> + * @lid: A 32bit LID
>>> + */
>>> +static inline __be16 ib_lid_be16(u32 lid)
>>>   {
>>> -    return cpu_to_be16((u16)slid);
>>> +    WARN_ON_ONCE(lid & 0xFFFF0000);
>>> +    return cpu_to_be16((u16)lid);
>>>   }
>>>   #endif /* IB_VERBS_H */
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
