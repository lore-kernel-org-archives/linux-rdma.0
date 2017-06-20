From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: iSER Connection via LIO not working
Date: Tue, 20 Jun 2017 10:23:03 +0300
Message-ID: <193ee311-f8a7-cf78-9dbc-190c89769adf@grimberg.me>
References: <2E68B5D1-49CF-4F2C-B7F3-DA20E05503B8@creamfinance.com>
 <CAANLjFraKgxAC09VH8u72SbQZs8WhXnnk87VQB0ywoVavC2hSg@mail.gmail.com>
 <2E0A092F-9530-44FB-8A6F-D76D8E94ABE0@creamfinance.com>
 <CAANLjFqg1ked1Ls0W=BRRw5o5vheHKnUw5C_5OVciFQd0H8djg@mail.gmail.com>
 <827EC8DD-86E7-4011-8F68-B29396B2034D@creamfinance.com>
 <CAANLjFqt_RqU6UFPCcZJ5Mec-ku__YErFb-VLrV4Qx9G7ArAZA@mail.gmail.com>
 <1790271E-1A6B-492D-B4B6-701873B23A01@creamfinance.com>
 <32E1700B9017364D9B60AED9960492BC3431F8F1@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC3431F8F1-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Rosenstein <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Good job tracking this down.   Thanks!
> 
> static void
> iser_calc_scsi_params(struct iser_conn *iser_conn,
>                        unsigned int max_sectors)
> {
>          struct iser_device *device = iser_conn->ib_conn.device;
>          unsigned short sg_tablesize, sup_sg_tablesize;
> 
>          sg_tablesize = DIV_ROUND_UP(max_sectors * 512, SIZE_4K);
>          sup_sg_tablesize = min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
>                                   device->ib_device->attrs.max_fast_reg_page_list_len);
> 
>          iser_conn->scsi_sg_tablesize = min(sg_tablesize, sup_sg_tablesize);
> }
> 
> The bug is that device->ib_device->attrs.max_fast_reg_page_list_len should only be considered valid IFF IB_DEVICE_MEM_MGT_EXTENSIONS is set in
> device->ib_device->device_cap_flags.  The assignment you suggest should be an else on an if test of the device_cap_flags bit.

Hi Guys,

Good job tracking it down!

I think you are the first one to test iSER on top of qib.

Mike, What other variable do we need to look at to determine the
maximum registered size per fmr? I was under the impression that
max_fast_reg_page_list_len is not directly related to
IB_DEVICE_MEM_MGT_EXTENSIONS as fmrs also accepts page lists.

Anyway,
Can we please please please add proper support for wr based memory
registrations in qib? I have a patch piped for removing FMRs from iser
altogether, now that this came up I obviously can't send it...

Looking at the code, looks like qib inherits rdmavt memory registration
with the new api, the only missing piece afaict is the remote invalidate
and qib can turn on IB_DEVICE_MEM_MGT_EXTENSIONS.

Can something like the (untested) below work:
--
diff --git a/drivers/infiniband/hw/qib/qib_rc.c 
b/drivers/infiniband/hw/qib/qib_rc.c
index 4ddbcac5eabe..2bdfad6ecc11 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1861,6 +1861,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct 
ib_header *hdr,

         case OP(SEND_ONLY):
         case OP(SEND_ONLY_WITH_IMMEDIATE):
+       case OP(SEND_ONLY_WITH_INVALIDATE):
                 ret = qib_get_rwqe(qp, 0);
                 if (ret < 0)
                         goto nack_op_err;
@@ -1871,6 +1872,13 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct 
ib_header *hdr,
                         goto no_immediate_data;
                 /* FALLTHROUGH for SEND_ONLY_WITH_IMMEDIATE */
         case OP(SEND_LAST_WITH_IMMEDIATE):
+       case OP(SEND_LAST_WITH_INVALIDATE):
+               if (opcode == OP(SEND_LAST_WITH_INVALIDATE)) {
+                       wc.ex.invalidate_rkey = 
be32_to_cpu(ohdr->u.imm_data);
+                       rvt_invalidate_rkey(qp, wc.ex.invalidate_rkey);
+                       wc.wc_flags = IB_WC_WITH_INVALIDATE;
+                       goto send_last;
+               }
  send_last_imm:
                 wc.ex.imm_data = ohdr->u.imm_data;
                 hdrsize += 4;
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
