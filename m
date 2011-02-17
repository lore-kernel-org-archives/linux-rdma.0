From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IPoIB: fix faulty list maintenance in path and neigh
 list
Date: Thu, 17 Feb 2011 15:34:07 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A4888838446B0D@AVEXMB1.qlogic.org>
References: <20110201161247.12671.10028.stgit@kop-dev-sles11-04.qlogic.org>
 <AANLkTin1pudSXZCGY31p2GnY6noWi2DS3y2+Gprj0+ug@mail.gmail.com>
 <4D5C70F6.3050604@linux.vnet.ibm.com>
 <AANLkTim-BnQ9tM68eGsCoOVYDRonmEOO6JN+EFT2zdff@mail.gmail.com>
 <4D5D7C95.5010408@linux.vnet.ibm.com>
 <AANLkTinyUjhZE_-n8zPJyGLVobaoFVnQ=iC1QMusQH+y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinyUjhZE_-n8zPJyGLVobaoFVnQ=iC1QMusQH+y-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gary Leshner <gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Tom Elken <tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We too have had installability, perhaps associated with these lists, but it has been difficult to diagnose.

We duplicate it by forcing dropped packets and seeing the QP's come/go at the rate of 1000s a second because of the 0 rnr_retry and retry counts.  This analysis is in line behind other bug investigations.

The list patch was a result of code inspection.

Ralph's patch predates me.   His appears to move some list inserts to before a post, I'm assuming since an intervening completion could occur, but I haven't studied it in detail to see if any locking prevents it.

I would be interested in Pradeep's test (OS, Hardware, scripts...)

Mike

-----Original Message-----
From: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] On Behalf Of Roland Dreier
Sent: Thursday, February 17, 2011 6:24 PM
To: Pradeep Satyanarayana
Cc: Mike Marciniszyn; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Gary Leshner; Tom Elken
Subject: Re: [PATCH] IPoIB: fix faulty list maintenance in path and neigh list

> Yes, that is the crux of the issue. I had missed that ipoib_mcast_free() is
> only called on remove_list.

So do we have any idea of what this patch is fixing?  Any thoughts from
the qlogic people involved in this patch?

> While we are discussing IPoIB issues, how about the two other issues that
> I illustrated previously. One was Ralph Campbell's patch for fixes to
> ipoib_cm_start_rx_drain() and my questions wrt ipoib_neigh_cleanup()?

I do need to take a good look at Ralph's patches to try and understand them
and I hope apply them.  Not sure I still have any link to your questions though.

 - R.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
