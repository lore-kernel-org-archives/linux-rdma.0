From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/sa: Restrict SA Netlink to admin users
Date: Tue, 11 Aug 2015 11:27:17 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB18540085@CRSMSX102.amr.corp.intel.com>
References: <1438895310-6087-1-git-send-email-ira.weiny@intel.com>
 <55C8407C.6060103@mellanox.com>
 <20150810215829.GA12260@phlsvsds.ph.intel.com>
 <20150811053810.GA13314@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150811053810.GA13314-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Tuesday, August 11, 2015 1:38 AM
> To: Weiny, Ira
> Cc: Haggai Eran; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] IB/sa: Restrict SA Netlink to admin users
> 
> On Mon, Aug 10, 2015 at 05:58:30PM -0400, ira.weiny wrote:
> 
> > Furthermore, the check in netlink_bind also uses the socket namespace
> > to restrict the use of multicast.  This plus my checks should allow an
> > admin to place the SA proxy (ibacm in our test cases) in an alternate
> > network namespace if they so desire.  But this is independent to the
> > namespace which may be used for data applications.
> 
> I think Haggai is on to something, there is certainly a problem here, that
> netlink_bind will let a namespace subscribe is a certainly a problem for what
> Haggai is working on.
> 
> For now, I think, only root (or CAP_ whatever) in the init namespace should
> have access to this feature. Not sure how to check that.

netlink_capable(skb, CAP_NET_ADMIN) will do the trick.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
