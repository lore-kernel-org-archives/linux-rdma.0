From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: infiniband BKL leftovers
Date: Sun, 11 Oct 2009 10:42:19 -0700
Message-ID: <adad44tj090.fsf@cisco.com>
References: <alpine.LFD.2.00.0910102015400.9428@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.0910102015400.9428-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
	(Thomas Gleixner's message of "Sat, 10 Oct 2009 20:37:20 +0200
	(CEST)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ralph Campbell <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[Adding a few CCs]

 > I'm looking into removing cycle_kernel_lock() from
 > drivers/infiniband/hw/ipath/ipath_file_ops.c .
 > 
 > cycle_kernel_lock() was pushed down into open functions to "emulate"
 > the previous BKL protected semantics by "serializing" the open
 > function against driver init in progress. Nobody knows how effective
 > this "serialization" was in reality. :)
 > 
 > This protection is not necessary when everything what might be needed
 > by write/aio_write/poll/mmap should be in place before
 > ipath_user_add() creates the device node.
 > 
 > But looking at the callsite ipath_init_one() I'm not so sure about that.
 > 
 > At the end of ipath_init_one() I see:
 > 
 >         ipath_device_create_group(&pdev->dev, dd);
 >         ipathfs_add_device(dd);
 >         ipath_user_add(dd);
 >         ipath_diag_add(dd);
 >         ipath_register_ib_device(dd);
 > 
 > ipath_user_add() is called before ipath_register_ib_device() which
 > registers the device with the infiniband core. That makes me wonder
 > whether the device node is really ready to use right after it is
 > created.
 > 
 > Aside of that I noticed that all the functions above have elaborate
 > error pathes, but non of the return values of these functions is ever
 > checked. Intersting approach :)

I guess you guys are getting serious about BKL removal.  I think I made
about as much progress on the ipath driver when the BKL pushdown first
happened: I looked at the code with an eye to getting rid of the BKL and
got too confused and scared to proceed.

I'm not sure what the best way to handle this is; as far as I know the
ipath code is abandoned by Qlogic (they have a new driver that also
supports newer hw that they have not tried to get upstream yet) and BKL
issues aside the code looks racy, eg

	if (atomic_inc_return(&user_count) == 1) {
		ret = user_init();

makes sure that only one thread does user_init() but it doesn't make
sure that user_init() finishes before another thread proceeds.

So I guess if the BKL stuff is blocking you in any way, we can just drop
it from ipath and leave it as yet another race condition in a rotting
old driver.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
