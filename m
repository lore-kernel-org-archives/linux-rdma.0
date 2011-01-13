From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: mlx4 fix for 36-bit bus addresses on 32-bit arch
Date: Thu, 13 Jan 2011 11:44:32 -0700
Message-ID: <20110113184432.GA9681@obsidianresearch.com>
References: <ig5vl1$j0$1@dough.gmane.org>
 <adafwt06puj.fsf@cisco.com>
 <4D2D5FAD.6030508@cadence.com>
 <adahbde57r7.fsf_-_@cisco.com>
 <4D2F310B.2010906@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D2F310B.2010906-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 13, 2011 at 12:06:19PM -0500, J.L. Burr wrote:

> However, I had a new concern about both the mthca and mlx4 changes so far:  
> Are we sure using the phys_addr_t type is the correct thing to do?

I'd say this is right. It looks to me like the choice has been made to
just drop BAR's that have 64 bit addresses if the system is 32
bit. 

Although, while looking into this I wonder J.L., how does your PCI
device even work? Look at, eg pci_read_bridge_mmio_ref, it seems to me
it will bail if a bridge is seen with a 64 bit setting but the system
isn't 64 bit? IMHO, this is a bug, it should be testing for
sizeof(resource_size_t)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
