From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: IB/hfi1: add driver files
Date: Mon, 27 Jun 2016 16:19:29 +0300
Message-ID: <20160627131928.GA28678@mwanda>
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

	drivers/infiniband/hw/hfi1/user_sdma.c:1438 set_txreq_header_ahg()
	warn: mask and shift to zero

drivers/infiniband/hw/hfi1/user_sdma.c
  1436                  /* Clear KDETH.SH on last packet */
  1437                  if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT)) {
  1438                          val |= cpu_to_le16(KDETH_GET(hdr->kdeth.ver_tid_offset,
  1439                                                                  INTR) >> 16);

The >> 16 should probably be deleted.  My guess is that it's left over
from an open coded byte swap?

  1440                          val &= cpu_to_le16(~(1U << 13));
  1441                          AHG_HEADER_SET(req->ahg, diff, 7, 16, 14, val);
  1442                  } else {
  1443                          AHG_HEADER_SET(req->ahg, diff, 7, 16, 12, val);
  1444                  }

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
