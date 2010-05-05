From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] ib_core: implement XRC RCV qp's
Date: Wed, 05 May 2010 15:56:46 -0700
Message-ID: <adaaasearf5.fsf@roland-alpha.cisco.com>
References: <201002281102.21207.jackm@dev.mellanox.co.il>
	<adavdbaxcs1.fsf@roland-alpha.cisco.com>
	<201005050945.05729.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201005050945.05729.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Jack Morgenstein's
	message of "Wed, 5 May 2010 09:45:05 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, diego-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > The uverbs layer DOES handle the counting/listing (see, for example,
 > list_add_tail at the end of ib_uverbs_create_xrc_rcv_qp.

But that is the per-process list of rcv QPs... not the reference
counting for each rcv QP.  Look at how trivial
ib_uverbs_destroy_xrc_rcv_qp is -- there is no reference counting of the
real object there.

 > However, I had an additional problem -- to distribute async events received
 > for the xrc_rcv QP to all registered processes (so that each could unregister
 > and allow the QP to be destroyed -- the ref count going to zero).

 > In my original implementation, the low-level driver was responsible for generating
 > the events for all the processes.  To move this mechanism to the core would require
 > a fairly extensive re-write.  I would need to introduce ib_core methods for create,
 > reg, unreg, and destroy, since the uverbs layer operates per user process and does
 > not track across multiple processes.  I was concerned that modifications of this
 > magnitude would introduce instability in XRC, and would require a significant QA cycle

It seems to me that it should, if anything, be easier to track all these
lists at the uverbs layer.  We already have a global xrcd structure for
each xrcd that we could easily stick a list of rcv QPs in (and keep the
list of rcv QP registrations per rcv QP). 

I do see your point that the changes might be fairly large (although the
total XRC code is not so big), but we shouldn't stick ourselves with a
wrong implementation just because that implementation was already tested.

 > Finally, I do not believe that it is such a bad thing to have low-level driver
 > procedures for reg/unreg here.  If a given low-level driver has implementation
 > details that it wishes to record, it should have the opportunity to do so.

Hmm.  I'm having a hard time imagining what those details are -- I
really do feel that this tracking of per-process reference counting etc
is something that we should do once in the core, rather than hiding it
in low-level drivers.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
