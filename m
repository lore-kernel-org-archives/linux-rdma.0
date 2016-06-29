From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 14:25:08 -0500
Message-ID: <017f01d1d23b$f27c4970$d774dc50$@opengridcomputing.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com> <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il> <20160627181758.GD23540@obsidianresearch.com> <20160628050246.GB3584@leon.nu> <20160628162028.GA27518@obsidianresearch.com> <20160628170549.GE3584@leon.nu> <20160628211858.GB5786@obsidianresearch.com> <20160629120920.GA24151@infradead.org> <20160629183414.GD17031@obsidianresearch.com> <017301d1d236$8496b030$8dc41090$@opengridcomputing.com> <20160629185757.GA17839@obsidianresearch.com> <017801d1d23a$a3836b10$ea8a4130$@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A82373AB06699A@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB06699A-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Yes, and I'm asking that we figure this out before we cram all these
> > libraries
> > into one git repo.  And again, currently I think distros pull release
> > tarballs
> > and not from any git trees for the rdma provider libraries...
> 
> A git repo can still generate multiple packages/libraries.
>

Agreed.  I'm just asking that we agree on the procedure for how we release
things as part of doing this centralized provider library git repo (assuming we
have consensus that this is the way to move forward).
 
> But, even if you didn't have this, this would just follow the same release
procedure
> that is used by the kernel.

What do you mean?  

Steve. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
