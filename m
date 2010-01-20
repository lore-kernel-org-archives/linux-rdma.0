From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: mode connected infiniband
Date: Wed, 20 Jan 2010 11:21:34 -0800
Message-ID: <adaiqaw8tvl.fsf@roland-alpha.cisco.com>
References: <8fd3bb681001140011k5ec9492eg19b59b110e45a2b5@mail.gmail.com>
	<adabpgwmwiw.fsf@roland-alpha.cisco.com>
	<4B52C456.5030501@mellanox.co.il>
	<20100118025626.GG9059@obsidianresearch.com>
	<adar5pl37ky.fsf@roland-alpha.cisco.com>
	<ab66a8181001200002n120af0e7m3733b42a945dc06b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ab66a8181001200002n120af0e7m3733b42a945dc06b-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Gennadiy Nerubayev's message of "Wed, 20 Jan 2010 03:02:02 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gennadiy Nerubayev <parakie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > I'll contribute my 2c here, as I have experienced some page allocation
 > errors in the past when using drbd and cm. I think drbd in particular
 > might trigger it since it's pushes a lot of data through the link, but
 > regardless the circumstances are somewhat difficult to replicate. I'm not
 > completely certain they are relevant, but here are some of the traces that
 > I've noticed then; these were observed on some version of OFED 1.4 if I
 > recall. Setting /proc/sys/vm/min_free_kbytes to some ridiculous number does
 > work around this.
 > 
 > http://www.mail-archive.com/drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org/msg00441.html
 > http://lists.linbit.com/pipermail/drbd-user/2009-April/011880.html

Thanks.  I notice that neither of these tracebacks actually have any
IPoIB functions (or indeed anything RDMA-related).  So it seems the
problem is probably somewhere more generic, triggered by the large MTU
allowed by IPoIB CM.

One traceback starts with

    drbd0_worker: page allocation failure. order:5, mode:0x10

so someone is trying to do an order 5 allocation on the send path.  And
the other one starts with

    drbd0_receiver: page allocation failure. order:4, mode:0x20

So similarly, the receive path is trying an order 4 allocation.

Are both of these tracebacks using IPoIB CM with a ~64K MTU?

 - R.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
