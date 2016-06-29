From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 20:34:24 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0669F5@ORSMSX109.amr.corp.intel.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com>
 <20160628170549.GE3584@leon.nu> <20160628211858.GB5786@obsidianresearch.com>
 <20160629120920.GA24151@infradead.org>
 <20160629183414.GD17031@obsidianresearch.com>
 <017301d1d236$8496b030$8dc41090$@opengridcomputing.com>
 <20160629185757.GA17839@obsidianresearch.com>
 <017801d1d23a$a3836b10$ea8a4130$@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A82373AB06699A@ORSMSX109.amr.corp.intel.com>
 <017f01d1d23b$f27c4970$d774dc50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <017f01d1d23b$f27c4970$d774dc50$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > But, even if you didn't have this, this would just follow the same
> release
> procedure
> > that is used by the kernel.
> 
> What do you mean?

You don't have individual releases for the kernel drivers.  They all just get grouped into the next kernel release.

FWIW, libfabric uses a single repo, and actually builds the providers directly into the library.  That model has been working fine, and the benefits far away the negatives.  I think the concern here is being overstated.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
