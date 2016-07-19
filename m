From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V1 7/8] RDMA/core: Change locking of ib_uobject
Date: Tue, 19 Jul 2016 14:44:56 -0600
Message-ID: <20160719204456.GF16042@obsidianresearch.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-8-git-send-email-matanb@mellanox.com>
 <20160713171657.GB19657@obsidianresearch.com>
 <6ae1a553-408c-723a-93a2-3d46d952ce35@mellanox.com>
 <20160714170051.GB2046@obsidianresearch.com>
 <b47386f4-fdb5-d24b-dbc6-9b5e18be6bf9@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b47386f4-fdb5-d24b-dbc6-9b5e18be6bf9-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2016 at 06:16:11PM +0300, Matan Barak wrote:
> On 14/07/2016 20:00, Jason Gunthorpe wrote:
> >That seems like it should be simple enough? Can we use the lock in the
> >kobj or something? Why is it like that today anyhow?
> 
> Yeah, I think it'll be safer to use lower level locking (like in kobj).

That is something that could productively be a dedicated patch
series..

> Well, another option (not saying it's a better one) is to develop the new
> ABI in a separate branch and try real world applications using it (with a
> modified libibverbs of course). This shall give use a feel if things are
> mature enough. The last step could be adding a write->ioctl interface.
> That's qualified to "flag day" conversion in the main branch.

My advice is to not do that.

I've observed a low success rate with such huge flag day projects.

Transitional is more work, but it is the historical 'kernel way'

> >So I don't know what your plan is to 'ditch the locks' with the new
> >infrastucture while maintaining the uverbs api..

> Using a conversion layer of the old ABI to the new ABI. Move the current
> write locks to lower kobj level as you suggested.

Hm, that is a long way to go :)

> If you want to break device != fd, you might want to destroy a device and
> start using the same fd with another device.

But that would return EBUSY like all our other destory calls if the
subordinate objects have not been deleted?

> >>> uobj = uobj_alloc(file->ucontext, 0, sizeof(*uobj));
> >>> [.. full setup ..]
> >>> uobj_activate(uobj); // live = 1, list_add_tail, idr_add
> >>>
> >>> resp.handle = uobj->id;
> >>> copy_to_user(..);
> >>>
> >>> put_uobj(uobj);
> >>> return ret;
> >>>
> >>>err1:
> >>> uobj_deactivate(uobj);
> >>>err2:
> >>> put_obj(uobj);
> >>>
> >>
> >>I agree with the general schema, but I think idr_add should be done in
> >>uobj_alloc as it can fail.
> >
> >In my version uobj_activate can fail, and we already have to have the
> >goto-unwind infrastructure to cope with that (copy_to_user could
> >fail), so I'm not sure why avoiding it would be helpful?
> >
> 
> I think it should be the other way around - copy_to_user is done by the
> handler and uobj_activate is done by the infrastructure. Therefore, the
> general doesn't know how to roll back the command and I want to guarantee
> anything it does after calling the handler succeed.

That just shuffles the requirement around. copy_to_user can always
fail, and it always has to happen after the idr_add - so there must
always be an unwind for it. Which means we can allow uobj_activate to
fail too and use the same basic unwind.

> IMHO, uverbs_cmd should become write_format->ioctl_format convertor.
> We don't want to have two paths doing almost the same thing in two different
> ways.

Right, but that is a long way off...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
