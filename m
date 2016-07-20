From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V1 7/8] RDMA/core: Change locking of ib_uobject
Date: Wed, 20 Jul 2016 11:56:33 -0600
Message-ID: <20160720175633.GM21460@obsidianresearch.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-8-git-send-email-matanb@mellanox.com>
 <20160713171657.GB19657@obsidianresearch.com>
 <6ae1a553-408c-723a-93a2-3d46d952ce35@mellanox.com>
 <20160714170051.GB2046@obsidianresearch.com>
 <b47386f4-fdb5-d24b-dbc6-9b5e18be6bf9@mellanox.com>
 <20160719204456.GF16042@obsidianresearch.com>
 <5c6e6a5d-9fde-a31f-1038-dce9e09662c4@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5c6e6a5d-9fde-a31f-1038-dce9e09662c4-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 20, 2016 at 10:54:55AM +0300, Matan Barak (External) wrote:
> Not sure -EBUSY, but an error of course. I think this should be done in a
> lower layer. I would like to avoid managing dependencies between object in
> the general infrastructure. It's the same as you can't destroy a PD when
> there's a bounded CQ (you should get some error for that).

Yes, that is my thinking..
> >>I think it should be the other way around - copy_to_user is done by the
> >>handler and uobj_activate is done by the infrastructure. Therefore, the
> >>general doesn't know how to roll back the command and I want to guarantee
> >>anything it does after calling the handler succeed.
> >
> >That just shuffles the requirement around. copy_to_user can always
> >fail, and it always has to happen after the idr_add - so there must
> >always be an unwind for it. Which means we can allow uobj_activate to
> >fail too and use the same basic unwind.
> >
> 
> [Infra]
> validate params
> allocate uobjects and IDRs
> 		[handler]
> 			copy_from_user
> 			execute
> 			if (success) {
> 				copy_to_user
> 				return success
> 			} else {
> 				return failure
> 			}
> 
> [infra contiune]
> if success
> 	enable_new_uobjs
> 	unlock_uobjs
> 	destroy_what_has_to_be_destroyed
> else
> 	delete_new_uobjs
> 	unlock_uobjs
> 
> 
> In that way, the infrastructure doesn't need to roll back commands. Only to
> roll back whatever it executed.

I'd really prefer to avoid this kind of flow where the idr is
installed at the top. The current code does that and uses 'live' to
fix it, but that is not how idrs are typically used in the kernel, and
getting rid of live is a noble goal, IMHO.

I suggest you use the same basic flow but 'handler' returns a
functional uobj that is *not* inside the idr, and the destroy of a
functional uboj is simply handled by calling the types' destroy
method, like any other case.

To make this work better I suggest having a standard place in the
ioctl response for the allocated uobj # and let the core code fill
that in, that way we don't need to copy_to_user in the handler for the
uobj #.

If idr insertion fails, then call the type's destroy function, just
like on a fd close or otherwise. No trouble for the core code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
