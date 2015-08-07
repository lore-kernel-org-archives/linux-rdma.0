From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH for-4.3 11/15] iw_cxgb4: Support ib_alloc_mr verb
Date: Fri, 7 Aug 2015 11:29:12 -0500
Message-ID: <003c01d0d12e$31a879d0$94f96d70$@opengridcomputing.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com> <1438241568-3685-12-git-send-email-sagig@mellanox.com> <003301d0d122$a1e46ee0$e5ad4ca0$@opengridcomputing.com> <20150807151318.GA13777@infradead.org> <003a01d0d12c$e84b4e80$b8e1eb80$@opengridcomputing.com> <20150807162615.GA16851@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150807162615.GA16851-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of 'Christoph Hellwig'
> Sent: Friday, August 07, 2015 11:26 AM
> To: Steve Wise
> Cc: 'Christoph Hellwig'; 'Sagi Grimberg'; 'Doug Ledford'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; target-
> devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH for-4.3 11/15] iw_cxgb4: Support ib_alloc_mr verb
> 
> On Fri, Aug 07, 2015 at 11:19:59AM -0500, Steve Wise wrote:
> > I guess I'll post two patches, the NFS fix that preceeds af78181/ b7e06cd, and a reworked patch to replace e20684a.
> >
> > Is that the way to go in your opinion?
> 
> To me this sounds good.  We have a couple patches from Jason's series
> that already need to be replaced, so the tree will need a rebase anyway,
> so I don't see a problem with replacing ones in Sagi's series either.
> If Sagi needs to do a repost for some reason he can just include your
> NFS patch in front of the series.

I misspoke.  I had the order reversed. The order is such that we can add my new NFS patch after:

e20684a xprtrdma, svcrdma: Convert to ib_alloc_mr

and before these:

af78181 cxgb3: Support ib_alloc_mr verb
b7e06cd iw_cxgb4: Support ib_alloc_mr verb

Steve


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
