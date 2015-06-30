From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Tue, 30 Jun 2015 10:42:47 -0600
Message-ID: <20150630164247.GB30149@obsidianresearch.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int>
 <20150629213618.4188.50574.stgit@build.ogc.int>
 <55925B70.1070409@mellanox.com>
 <001e01d0b341$1eefe9f0$5ccfbdd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <001e01d0b341$1eefe9f0$5ccfbdd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> NFSRDMA currently checks the transport type to decide how to set the
> access flags for memory registration.  With the new services
> exported in this series, we can change/simplify NFSRDMA to not have
> to know the transport type.

It would be excellent if this series actually went through and got rid
of all the now deprecated users. This would confirm we have the right
API here and prune off the old stuff. This is fairly trivial to do, I
think?

The goal is to make things simpler, maintaining two kernel APIs is not
simpler :)

Regarding Sagi's comments .. We don't have to do everything at once,
a series that focuses only on the access flags seems sane to
me.

Sagi's idea makes a lot of sense, but maybe it should be explored
along the direction Christoph has been talking about?

I suggested the wrapper because it makes it very easy to force the old
API out (just remove the old function call), but maybe we could move
the old style access flags into a private header or something ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
