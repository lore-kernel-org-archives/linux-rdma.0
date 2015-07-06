From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V3 0/5] Transport-independent MRs
Date: Mon, 6 Jul 2015 09:24:54 -0500
Message-ID: <000e01d0b7f7$86f6f100$94e4d300$@opengridcomputing.com>
References: <20150705231831.12029.80307.stgit@build2.ogc.int> <20150706052542.GB1109@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150706052542.GB1109-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org]
> Sent: Monday, July 06, 2015 12:26 AM
> To: Steve Wise
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
> Subject: Re: [PATCH V3 0/5] Transport-independent MRs
> 
> On Sun, Jul 05, 2015 at 06:21:53PM -0500, Steve Wise wrote:
> > This series introduces transport-independent RDMA core services for
> > allocating DMA MRs and computing fast register access flags.  Included are
> > changes to the iSER and NFSRDMA ULPs to make use of the new services.
> 
> Can you convert all of them and remove the old APIs?

I can.  These are the only "transport independent" ULPs at this point.  But if we want to remove ib_get_dma_mr(), then I can do
this.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
