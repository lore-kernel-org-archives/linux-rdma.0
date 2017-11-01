From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: How far back does rdma-core X supports the kernel Y?
Date: Wed, 1 Nov 2017 12:53:19 -0600
Message-ID: <20171101185319.GK1030@ziepe.ca>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171101163915.GB1030@ziepe.ca>
 <287a10c2-15a7-0748-c59e-3f084e7538f4@dev.mellanox.co.il>
 <20171101180001.GH1030@ziepe.ca>
 <3424c3a1-22cb-7330-81d6-0e1bf45ab755@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3424c3a1-22cb-7330-81d6-0e1bf45ab755-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 01, 2017 at 08:22:37PM +0200, Yishai Hadas wrote:
> On 11/1/2017 8:00 PM, Jason Gunthorpe wrote:
> >>>          if (attr_mask & ~((1ULL << (IBV_QP_DEST_QPN + 1)) - 1))
> >>
> >>The above rdma-core code is correct, look at verbs.h:
> >>IBV_QP_DEST_QPN = 1 << 20,
> >
> >Okay, then it should be
> >
> >  if (attr_mask & ~(IB_QP_RATE_LIMIT - 1))
> >
> 
> Why the library should support values that were never exposed in verbs.h ?

I think Ram is explaining that the kernel rdma_cm provides the
attr_mask to use with modify_qp, and that the 4.3 kernel sets the
three now reserved bits. The expectation is that user space will flow
those bits and values from the kernel rdma_cm interface back to
uverbs.

Userspace never looks at the attr_mask, and it does not matter that
the values were never in verbs.h.

rdma-core is expected to work on 4.3, so if 4.3 is using this kind of
path, we cannot block it in userspace.

At least, I think that is what Ram is saying.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
