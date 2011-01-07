From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/1] mthca: Modify to support embedded PowerPC platforms
Date: Fri, 07 Jan 2011 09:00:36 -0800
Message-ID: <adazkrcabt7.fsf@cisco.com>
References: <ig5usq$tgi$1@dough.gmane.org> <adalj2xb6h0.fsf@cisco.com>
	<ada4o9lb42k.fsf@cisco.com> <ig6m82$k8i$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ig6m82$k8i$1@dough.gmane.org> (J. L. Burr's message of "Fri, 7
	Jan 2011 04:24:34 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > I think it was the merger of the 64-bit PowerPC with the 32-bit ppc that led
 > to things like the phys_addr_t type, etc.  There must be some other aspect
 > new to the powerpc tree which requires adjustment by the driver.

I'm pretty sure that when I had things working, it was with the powerpc
(not ppc) tree, with the embedded device tree, etc.  I think one
difference might be that my platform had less memory or perhaps
different firmware, so that the kernel addresses for PCI resources were
below 4GB.  I seem to remember maybe there was some automagic in
ioremap() that expanded the IO addresses to the right place.

It does seem that the driver is loading properly and then simply not
getting receive completions for the packets sent by the subnet manager.
Since other events are occurring, I would guess that something is going
wrong with posting the receives, though I don't know exactly what it
might be.

One thing to try would be to load the ib_mthca module with fw_cmd_doorbell=1
That won't fix anything, but if it fails in a different way that might
give a clue as to what's wrong.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
