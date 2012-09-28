From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 2/7] libibverbs: libibverbs: Introduce XRC domains
Date: Fri, 28 Sep 2012 17:16:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A98074@FMSMSX151.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A97DD6@FMSMSX151.amr.corp.intel.com>
 <20120928003427.GA21759@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120928003427.GA21759-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +enum verbs_xrcd_mask {
> > +	VERBS_XRCD_HANDLE	= 1 << 0,
> > +	VERBS_XRCD_RESERVED	= 1 << 1
> > +};
> 
> I think it would be a good idea to make both of these constants
> (1<<0), the '0' serves as an ABI rev, not an individual field. That
> will give a bit more life to this system, and it makes much more sense
> to require them be present as a group.

I'd rather not, as it makes checking for a specific field more difficult.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
