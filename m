From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/1] mthca: Modify to support embedded PowerPC platforms
Date: Thu, 06 Jan 2011 21:58:19 -0800
Message-ID: <adalj2xb6h0.fsf@cisco.com>
References: <ig5usq$tgi$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ig5usq$tgi$1@dough.gmane.org> (J. L. Burr's message of "Thu, 6
	Jan 2011 21:47:07 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Using the mthca driver from 2.6.26, I initially got various mapping errors.
 > The patch in the next note fixed these.  The problem is that the 440SPe uses
 > a 36-bit physical address on an otherwise 32-bit CPU.  This means it is
 > important to use the Linux "phys_addr_t" type, rather than "unsigned long"
 > (which is still 32-bits on this CPU).  "phys_addr_t" is 64-bits on this
 > platform and should work for all platforms, as far as I know.  I therefore
 > believe this patch has general value (correct me if I'm wrong!).

Yes, this fix is correct, and analogous fixes are required for cxgb4,
mlx4 and I think amso1100 at least.

 > But when I connect my 440SPe system to the Intel RH4.6 system, I only get
 > the green LED to light on each card (no yellow LED).  The Intel RH4.6
 > /var/log/osm.log shows:
 > 
 > -> umad_receiver: ERR 5409: send completed with error (method=0x1 attr=0x11
 > trans_id=0x3600001239) -- dropping
 > -> umad_receiver: ERR 5411: DR SMP Hop Ptr: 0x0
 > -> Received SMP on a 1 hop path:
 > Initial path = 0,0
 > Return path  = 0,0
 > -> __osm_sm_mad_ctrl_send_err_cb: ERR 3113: MAD completed in error
 > (IB_TIMEOUT)

It appears either the MADs sent from the SM on your x86 system are not
being received properly on the powerpc side, or the replies are being
corrupted or not sent properly back from the powerpc side.

It might be instructive to watch /proc/interrupts on the ppc system and
see if it goes up when the x86 subnet manager does a sweep.

I'm not sure where to start debugging this really -- I can say that at
some point in the distant past (2 or 3 years ago at least) I did have
mthca working on a PowerPC 440SPe eval board.  And people continue to
use mthca on other IBM POWER platforms.  So at least endianness is
unlikely to be the problem; I could believe that we have a bug with
handling non-cache-coherent DMA that has snuck in since I last tried
things (around 2.6.19 or so I think).

Unfortunately it's very difficult to debug problems with the denx
variant of an 18-month-old kernel.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
