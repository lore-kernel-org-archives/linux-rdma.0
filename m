From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: IB/hfi1: add driver files
Date: Wed, 13 Jul 2016 16:27:49 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2D052967@fmsmsx120.amr.corp.intel.com>
References: <20160627131928.GA28678@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160627131928.GA28678@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The patch 7724105686e7: "IB/hfi1: add driver files" from Jul 30, 2015, leads to
> the following static checker warning:
> 
> 	drivers/infiniband/hw/hfi1/user_sdma.c:1438
> set_txreq_header_ahg()
> 	warn: mask and shift to zero
> 
> drivers/infiniband/hw/hfi1/user_sdma.c
>   1436                  /* Clear KDETH.SH on last packet */
>   1437                  if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT)) {
>   1438                          val |= cpu_to_le16(KDETH_GET(hdr-
> >kdeth.ver_tid_offset,
>   1439                                                                  INTR) >> 16);
> 
> The >> 16 should probably be deleted.  My guess is that it's left over from an
> open coded byte swap?
> 
>   1440                          val &= cpu_to_le16(~(1U << 13));
>   1441                          AHG_HEADER_SET(req->ahg, diff, 7, 16, 14, val);
>   1442                  } else {
>   1443                          AHG_HEADER_SET(req->ahg, diff, 7, 16, 12, val);
>   1444                  }
> 

Dan, what static checker shows this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
