From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 4/7] IB/core: Change idr objects to use the
 new schema
Date: Wed, 15 Feb 2017 11:11:06 -0700
Message-ID: <20170215181106.GD19162@obsidianresearch.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-5-git-send-email-matanb@mellanox.com>
 <20170210203048.GD4335@obsidianresearch.com>
 <CAAKD3BAUZpf5pr4G3Uv=ikD3WGgOgmbcz2WnrPm3FCJiSFCVJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BAUZpf5pr4G3Uv=ikD3WGgOgmbcz2WnrPm3FCJiSFCVJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 15, 2017 at 03:45:00PM +0200, Matan Barak wrote:

> > And here I think you should move the pd->device_dealloc_pd into
> > destroy_commit by having it call what you called hot_plug, and turn
> > this simply into:
> >
> >         return uobj_remove_or_put(uobj, RDMA_REMOVE_DESTROY);
> >
> > static inline int uobj_remove_or_put(struct ib_uobject *uobj, enum rdma_remove_reason why)
> > {
> >     int rc = uobj->type->ops->remove(uobj, why);
> >     if (!rc)
> >         uverbs_uobject_put(uobj);
> >
> >     /* If we are using a forced destruction mode then the driver is
> >         not permitted to fail. */
> >     WARN_ON(!rc && why != RDMA_REMOVE_DESTROY);
> >     return rc;
> > }
> >
> > And generally use this pattern for all the destroy verbs.
> >
> 
> I prefer to keep this separation. In handlers code, the handler is
> responsible to destroy the actual object and to just call
> remove_commit or lookup_put (via the accessor functions of course).
> There's a clear separation here between the uobjects management and
> the objects themselves.  It's also more symmetrical - the user
> created this pd and [s]he shall destroy it.

unless the context is closed, or hot unplug is done, this argument
makes no sense.

The above is very clear and forces the needed sanity on the whole
broken destory system

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
