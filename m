From: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: kernel memory registration (was: RDMA/core:
 Transport-independent access flags)
Date: Sat, 11 Jul 2015 03:31:53 -0700
Message-ID: <20150711103153.GC14741@infradead.org>
References: <20150707161751.GA623@obsidianresearch.com>
 <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <559D983D.6000804@talpey.com>
 <20150708233604.GA20765@obsidianresearch.com>
 <559E54AB.2010905@dev.mellanox.co.il>
 <20150709170142.GA21921@obsidianresearch.com>
 <559F8881.7070308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <559F8881.7070308-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 10, 2015 at 11:55:29AM +0300, Sagi Grimberg wrote:
> If there is one thing worse than a complicated API, it is a restrictive
> one. I'd much rather ULPs just having a simple API for registering
> memory.

Quite to the contrary.  The complex API almost asks for weird abuses
and twists.  The too restrictive one means people that want to extend
it need to start a discussion on how we extent the API, which improves
the chances to come up with something sensible dramatically.

> >I expect all these calls would be function pointers, and each driver
> >would provide a function pointer that is optimal for it's use. Eg mlx4
> >would provide a pointer that used the S/G list, then falls back to
> >FRMR if the S/G list is exhausted. The core code would provide a
> >toolbox of common functions the drivers can use here.
> 
> Maybe it's just me, but I can't help but wander if this is facilitating
> an atmosphere where drivers will keep finding new ways to abuse even
> the most simple operations.

I'm not too excited about moving the code in the drivers.  The RDMA
subsystem actually has a lot more hardware drivers than ULDs, so moving
logic into them seems like a major step backwards.  From my journeys
into the drivers it rather seems like they are doing too much work
already.

Having a few schemes availabe in the core code that the driver can chose
from seems like a much more sensible option.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
