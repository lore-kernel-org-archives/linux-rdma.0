From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/1] mthca: Modify to support embedded PowerPC platforms
Date: Sun, 09 Jan 2011 21:53:27 -0800
Message-ID: <ada4o9h9ueg.fsf@cisco.com>
References: <ig5usq$tgi$1@dough.gmane.org> <adalj2xb6h0.fsf@cisco.com>
	<ada4o9lb42k.fsf@cisco.com> <ig6m82$k8i$1@dough.gmane.org>
	<adazkrcabt7.fsf@cisco.com> <4D293FFE.7000901@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D293FFE.7000901-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org> (J. L. Burr's message of "Sat, 08
	Jan 2011 23:56:30 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > > One thing to try would be to load the ib_mthca module with fw_cmd_doorbell=1
 > > That won't fix anything, but if it fails in a different way that might
 > > give a clue as to what's wrong.
 > 
 > I tried this and it *does* fail in a different way:
 > 
 > NOP command failed to generate interrupt (IRQ 18), aborting.

OK, that's very interesting information.  The effect of that flag is to
have the driver write firmware commands into the doorbell region (BAR 2)
instead of the command region (BAR 0).  And it seems writes to the
doorbell region are getting lost on your system (that might also explain
why there were no packets received without the fw_cmd_doorbell flag;
receives are posted to the HCA by doorbell writes too).  I suspect if we
could get fw_cmd_doorbell=1 working on your system then that would fix
everything else too.

It might help to dump all the addresses in mthca_setup_cmd_doorbells()
-- ie what the driver is using for base and also the final address that
gets ioremap'ed.  But I do notice that BAR 2 of the HCA is at E00000000
which is at a very aligned border -- is it possible that something in
your system's PCI windows is not set up quite right so that BAR is a problem?

 > When I compared some of these fields in my GDB dump of module areas, I
 > see that the doorbell offsets on my system are all 0x000C.  That is,
 > all 8 elements of the dev->cmd.dbell_offsets array are 0x000C.

I think that's OK... don't have a good system to check what I get though.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
