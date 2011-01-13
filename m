From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: mlx4 fix for 36-bit bus addresses on 32-bit arch
Date: Thu, 13 Jan 2011 15:14:54 -0700
Message-ID: <20110113221454.GB9681@obsidianresearch.com>
References: <ig5vl1$j0$1@dough.gmane.org>
 <adafwt06puj.fsf@cisco.com>
 <4D2D5FAD.6030508@cadence.com>
 <adahbde57r7.fsf_-_@cisco.com>
 <4D2F310B.2010906@cadence.com>
 <20110113184432.GA9681@obsidianresearch.com>
 <ada62ts316q.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada62ts316q.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 13, 2011 at 02:10:05PM -0800, Roland Dreier wrote:
>  > Although, while looking into this I wonder J.L., how does your PCI
>  > device even work? Look at, eg pci_read_bridge_mmio_ref, it seems to me
>  > it will bail if a bridge is seen with a 64 bit setting but the system
>  > isn't 64 bit? IMHO, this is a bug, it should be testing for
>  > sizeof(resource_size_t)
> 
> I don't see that function... where are you looking?

Sorry, I typo'd it

static void __devinit pci_read_bridge_mmio_pref(struct pci_bus *child)

drivers/pci/probe.c

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
