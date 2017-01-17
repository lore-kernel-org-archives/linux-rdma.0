From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/core: Add support for fd objects
Date: Tue, 17 Jan 2017 12:11:16 -0700
Message-ID: <20170117191116.GC27528@obsidianresearch.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-4-git-send-email-matanb@mellanox.com>
 <20170111235801.GC31682@obsidianresearch.com>
 <CAAKD3BBQLxnh-keng+LjZEyWBYKbXN_Sszk1BcGnyVeZU_45nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BBQLxnh-keng+LjZEyWBYKbXN_Sszk1BcGnyVeZU_45nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 17, 2017 at 07:24:59PM +0200, Matan Barak wrote:
> >> +void uverbs_cleanup_fd(void *private_data)
> >> +{
> >> +     struct ib_uobject *uobject = uverbs_priv_fd_to_uobject(private_data);
> >> +
> >> +     kfree(uobject);
> >> +}
> >
> > Woah, this is not OK at this point in the series. There is really too
> > much stuff bundled into patch 7 to make proper sense of this.
> >
> 
> This is a standard structure of a series - you first build up the
> infrastructure and then use it to change everything.

Well, again, no, this is not normal. At this point in the series the
lifetime model for uboject is totally screwed up between the new/old
code. That is not OK

Do not get confused with how you write *new code* vs how you
*transform* old code. This is the latter and I expect each patch in
the series to globally follow or change the overal invarients. Do not
introduce two incompatible schemes.

> worried that embedding the actual changes with the infrastructural
> changes will require massive amounts of testing to verify it's
> bisect-able.

If each patch makes internal self consisent sense and compiles I'm
happy enough... Not asking that every patch be exhaustively tested.

As it stands this series is pretty useless for bisection because
everything hinges on the final patch, so having at least the ideas
properly broken up is a win from that standpoint.

> > Do not drop the kref out of ib_uobject, that should be the master
> > kref, drop the kref out of ib_uverbs_event_file instead.
> 
> I didn't really follow, could you please clarify?

In patch 7 you delete the kref from ib_uobject, but keep a kref in
ib_uverbs_event_file.

Instead you should keep the kref in ib_uobject, make it work properly,
and discard the kref in ib_uverbs_event_file when you add in
ib_uobject as a member.

The uobject kref semantics around the IDR should be pretty simple: The
IDR holds a kref on all the members of the IDR. get on add, put on
remove.

The per-uobject rwlock prevents removing the object from the IDR so
anything operating within the read side of the rwlock does not need to
kref get. Only when the uobject is transfered outside that rwlock is a
get required (eg for fops private_data)

Not mangling the kref model of uobject should make the two APIs more
compatible.

> It can't be moved to finalize, as fdallocate could fail and we assume nothing
> in the finalize stage could fail. However, I'll zero this value.

Okay, sure, -1 or something.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
