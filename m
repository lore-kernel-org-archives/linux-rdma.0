From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 fix for 36-bit bus addresses on 32-bit arch
Date: Thu, 13 Jan 2011 14:10:05 -0800
Message-ID: <ada62ts316q.fsf@cisco.com>
References: <ig5vl1$j0$1@dough.gmane.org> <adafwt06puj.fsf@cisco.com>
	<4D2D5FAD.6030508@cadence.com> <adahbde57r7.fsf_-_@cisco.com>
	<4D2F310B.2010906@cadence.com>
	<20110113184432.GA9681@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110113184432.GA9681-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Thu, 13 Jan 2011 11:44:32 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Although, while looking into this I wonder J.L., how does your PCI
 > device even work? Look at, eg pci_read_bridge_mmio_ref, it seems to me
 > it will bail if a bridge is seen with a 64 bit setting but the system
 > isn't 64 bit? IMHO, this is a bug, it should be testing for
 > sizeof(resource_size_t)

I don't see that function... where are you looking?

$ git grep pci_read_bridge_mmio_ref
$ git describe
v2.6.37-6858-g581548d

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
