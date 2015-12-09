From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 10:39:43 -0700
Message-ID: <20151209173943.GA31636@obsidianresearch.com>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
 <20151208212133.GC14378@obsidianresearch.com>
 <566823E2.5090504@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <566823E2.5090504-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 07:51:46AM -0500, Hal Rosenstock wrote:
> > ipoib always uses the 0 pkey index to create the default ipoib
> > interface. (see eg, update_parent_pkey)
> 
> This is beyond IBA spec and is currently a linux convention for IPoIB.
> IMO it should be changed to search for this pkey rather than assume
> it's

I don't think you are following. It uses pkey[0] as the pkey for
ipoib, not necessarily for SA communication.

Since there is no way to know what the desired pkey is for ipoib there
is no possibility to search. Using pkey index is 0 a good solution
since it allows the SM to configure ipoib defaults centrally.

> > When operating securely the SA should place the pkey for default ipoib
> > operation in pkey index 0, and place 0x7FFF in another index. I run
> > alot of networks exactly like this and it works very well.
> 
> Yes, it can run that way but more secure is without the full default
> pkey. When full default pkey is in every port, the rest of the
> partitioning doesn't really matter...

That isn't what I said, I said the pkey for the default ipoib
interface is in pkey[0], eg, the network runs with [0x8001,0x7FFF] as
the pkey table. There is no 0xFFFF pkey except on SA nodes.

Linux automatically creates ib0 on 0x8001 and the rest of the
in-kernel stack (should?) correctly find and use 0x7FFF as the pkey to
use to talk to the SA.

acm should follow ipoib convention for creating it's multicast groups
and setup it's default multicast group using pkey[0]

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
