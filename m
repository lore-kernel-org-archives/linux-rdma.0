From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/hfi1: add driver files
Date: Wed, 16 Sep 2015 10:13:07 +0300
Message-ID: <20150916071307.GA29995@mwanda>
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

	drivers/staging/rdma/hfi1/user_sdma.c:1349 set_txreq_header_ahg()
	warn: mask and shift to zero

drivers/staging/rdma/hfi1/user_sdma.c
  1347                  /* Clear KDETH.SH on last packet */
  1348                  if (unlikely(tx->flags & USER_SDMA_TXREQ_FLAGS_LAST_PKT)) {
  1349                          val |= cpu_to_le16(KDETH_GET(hdr->kdeth.ver_tid_offset,
  1350                                                                  INTR) >> 16);


KDETH_GET(hdr->kdeth.ver_tid_offset, INTR) is zero or one.  1 >> 16 is
zero.  This line is a no-op.

  1351                          val &= cpu_to_le16(~(1U << 13));
  1352                          AHG_HEADER_SET(req->ahg, diff, 7, 16, 14, val);
  1353                  } else
  1354                          AHG_HEADER_SET(req->ahg, diff, 7, 16, 12, val);

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
