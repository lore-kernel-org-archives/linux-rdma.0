From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/hfi1: add driver files
Date: Wed, 16 Sep 2015 10:14:42 +0300
Message-ID: <20150916071442.GA30250@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Mike Marciniszyn,

The patch 7724105686e7: "IB/hfi1: add driver files" from Jul 30,
2015, leads to the following static checker warning:

	drivers/staging/rdma/hfi1/rc.c:2399 hfi1_rc_hdrerr()
	warn: right shift assign to zero

drivers/staging/rdma/hfi1/rc.c
  2376  void hfi1_rc_hdrerr(
  2377          struct hfi1_ctxtdata *rcd,
  2378          struct hfi1_ib_header *hdr,
  2379          u32 rcv_flags,
  2380          struct hfi1_qp *qp)
  2381  {
  2382          int has_grh = rcv_flags & HFI1_HAS_GRH;
  2383          struct hfi1_other_headers *ohdr;
  2384          struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
  2385          int diff;
  2386          u8 opcode;
  2387          u32 psn;
  2388  
  2389          /* Check for GRH */
  2390          ohdr = &hdr->u.oth;
  2391          if (has_grh)
  2392                  ohdr = &hdr->u.l.oth;
  2393  
  2394          opcode = be32_to_cpu(ohdr->bth[0]);
  2395          if (hfi1_ruc_check_hdr(ibp, hdr, has_grh, qp, opcode))
  2396                  return;
  2397  
  2398          psn = be32_to_cpu(ohdr->bth[2]);
  2399          opcode >>= 24;
  2400  

opcode should probably be a u32 instead of a u8.

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
