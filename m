From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] iw_cxgb4: Wake up waiters after flushing the qp
Date: Fri, 21 Nov 2014 09:42:10 -0600
Message-ID: <001e01d005a1$b6517690$22f463b0$@opengridcomputing.com>
References: <20141020153755.31500.44966.stgit@build.ogc.int> <546F597B.4020404@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546F597B.4020404-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I've pushed these to:

git://git.openfabrics.org/~swise/linux.git for_roland

Steve

Hariprasad Shenai (2):
      iw_cxgb4: Fixes locking issue in process_mpa_request
      iw_cxgb4: limit MRs to < 8GB for T4/T5 devices

Pramod Kumar (2):
      cxgb4/rdma:Increase epd buff size for debug interface
      cxgb4/rdma: configure 0B MRs to match HW implementation

Steve Wise (1):
      iw_cxgb4: Wake up waiters after flushing the qp


> -----Original Message-----
> From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
> Sent: Friday, November 21, 2014 9:26 AM
> To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] iw_cxgb4: Wake up waiters after flushing the qp
> 
> Hey Roland,
> 
> Hope you can get this bug fix into 3.18.  Plus these others that have
> been submitted a while ago.  Here is the entire list:
> 
> https://patchwork.kernel.org/patch/5106541/
> https://patchwork.kernel.org/patch/5249511/
> https://patchwork.kernel.org/patch/5249501/
> https://patchwork.kernel.org/patch/5089511/
> https://patchwork.kernel.org/patch/5089501/
> 
> 
> Thanks,
> 
> Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
