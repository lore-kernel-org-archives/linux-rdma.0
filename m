From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [bug report] IB/hfi1: Add 16B RC/UC support
Date: Fri, 25 Aug 2017 23:18:41 +0300
Message-ID: <20170825201841.am6qeziyfz26fr5q@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Don Hiatt,

The patch 5b6cabb0db77: "IB/hfi1: Add 16B RC/UC support" from Aug 4,
2017, leads to the following static checker warning:

	drivers/infiniband/hw/hfi1/rc.c:856 hfi1_make_rc_ack_16B()
	error: uninitialized symbol 'bth1'.

drivers/infiniband/hw/hfi1/rc.c
   815          struct hfi1_16b_header *hdr = &opa_hdr->opah;
   816          struct ib_other_headers *ohdr;
   817          u32 bth0, bth1;
                          ^^^^
Declared.

   818          u16 len, pkey;
   819          u8 becn = !!is_fecn;
   820          u8 l4 = OPA_16B_L4_IB_LOCAL;
   821          u8 extra_bytes;
   822  
   823          opa_hdr->hdr_type = HFI1_PKT_TYPE_16B;
   824          ohdr = &hdr->u.oth;
   825          /* header size in 32-bit words 16B LRH+BTH+AETH = (16+12+4)/4 */
   826          *hwords = 8;
   827          extra_bytes = hfi1_get_16b_padding(*hwords << 2, 0);
   828          *nwords = SIZE_OF_CRC + ((extra_bytes + SIZE_OF_LT) >> 2);
   829  
   830          if (unlikely(rdma_ah_get_ah_flags(&qp->remote_ah_attr) & IB_AH_GRH) &&
   831              hfi1_check_mcast(rdma_ah_get_dlid(&qp->remote_ah_attr))) {
   832                  *hwords += hfi1_make_grh(ibp, &hdr->u.l.grh,
   833                                           rdma_ah_read_grh(&qp->remote_ah_attr),
   834                                           *hwords - 4, *nwords);
   835                  ohdr = &hdr->u.l.oth;
   836                  l4 = OPA_16B_L4_IB_GLOBAL;
   837          }
   838          *pbc_flags |= PBC_PACKET_BYPASS | PBC_INSERT_BYPASS_ICRC;
   839  
   840          /* read pkey_index w/o lock (its atomic) */
   841          pkey = hfi1_get_pkey(ibp, qp->s_pkey_index);
   842  
   843          /* Convert dwords to flits */
   844          len = (*hwords + *nwords) >> 1;
   845  
   846          hfi1_make_16b_hdr(hdr,
   847                            ppd->lid | rdma_ah_get_path_bits(&qp->remote_ah_attr),
   848                            opa_get_lid(rdma_ah_get_dlid(&qp->remote_ah_attr),
   849                                        16B),
   850                            len, pkey, becn, 0, l4, sc5);
   851  
   852          bth0 = pkey | (OP(ACKNOWLEDGE) << 24);
   853          bth0 |= extra_bytes << 20;
   854          if (qp->s_mig_state == IB_MIG_MIGRATED)
   855                  bth1 = OPA_BTH_MIG_REQ;
                        ^^^^^^^^^^^^^^^^^^^^^^^
Not initialized on the != IB_MIG_MIGRATED case.

   856          hfi1_make_bth_aeth(qp, ohdr, bth0, bth1);
                                                   ^^^^
I'm not immediately sure what bth1 should be initialized to by default.
Perhaps zero?

   857  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
