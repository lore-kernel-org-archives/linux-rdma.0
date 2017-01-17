From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 6/7] IB/core: Declare all common IB types
Date: Tue, 17 Jan 2017 12:15:14 -0700
Message-ID: <20170117191514.GE27528@obsidianresearch.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-7-git-send-email-matanb@mellanox.com>
 <20170112001955.GF31682@obsidianresearch.com>
 <CAAKD3BBKnJRNF+iqRSkjmGVcff=Hd68wVvXW7y+=pnnc4=yDfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BBKnJRNF+iqRSkjmGVcff=Hd68wVvXW7y+=pnnc4=yDfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 17, 2017 at 07:37:30PM +0200, Matan Barak wrote:
> >> +DECLARE_UVERBS_TYPE(uverbs_type_comp_channel,
> >> +                 &UVERBS_TYPE_ALLOC_FD(0, sizeof(struct ib_uobject) + sizeof(struct ib_uverbs_event_file),
> >> +                                       uverbs_free_event_file,
> >> +                                       &uverbs_event_fops,
> >> +                                       "[infinibandevent]",
> >> O_RDONLY));
> >
> > Really hate these macros.
> >
> > const struct ib_uobject_type uverbs_type_comp_channel = {
> >        .size = sizeof(struct ib_uverbs_event_file,
> >        .destroy = uverbs_destroy_event_file, // destroy = release device resources!!
> >        .fd = {
> >           .fops = &uverbs_event_fops,
> >           .name = "[infinibandevent]"
> >        },
> > };
> >
> > If you can't do it without macros something else is wrong.
> >
> 
> We could initialize directly of course, but the code will be more
> complex than what you proposed (there are some structure
> nestings and pointers there).

Why would it be more complex? That does what the macro does. Don't
make it more complex ;)

> Anyway, what's wrong with this macro? It's pretty straight forward,
> it's a common schema in this code and it even checks
> that the object_size makes sense.

There are too many parameters, it is too hard to casually follow, and
it doesn't fit the typical kernel model for this kind of thing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
