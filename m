From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED libraries
Date: Fri, 14 Oct 2011 17:15:01 -0400 (EDT)
Message-ID: <afc840ac-de34-4102-a276-a54fdf030451@zmail05.collab.prod.int.phx2.redhat.com>
References: <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

----- Original Message -----
> On Tue, Oct 11, 2011 at 7:39 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Tue, Oct 11, 2011 at 09:02:41AM -0500, Christoph Lameter wrote:
> >> Has XRC support not been merged? How can I build the OFED
> >> libraries
> >> against Linux 3.1? I'd really like to get rid of the OFED kernel
> >> tree
> >> nightmare.
> >
> > You have to use upstream libraries with upstream kernels. Be warned
> > that the OFED libraries of the same SONAME are not ABI compatible
> > with
> > upstream libraries.
> 
> Why is the OFED libibverbs library binary incompatible with the
> non-OFED libibverbs library ?

Well, as an example:

Upstream (Roland's) libibverbs (and this may not be entirely clean,
I do have the original RoCE support in here, and plan to switch over
to IBoE when it's available): /usr/include/infiniband/verbs.h

struct ibv_srq {
        struct ibv_context     *context;
        void                   *srq_context;
        struct ibv_pd          *pd;
        uint32_t                handle;

        pthread_mutex_t         mutex;
        pthread_cond_t          cond;
        uint32_t                events_completed;
};

>From OFED's libibverbs: /usr/include/infiniband/verbs.h

struct ibv_srq {
        struct ibv_context     *context;
        void                   *srq_context;
        struct ibv_pd          *pd;
        uint32_t                handle;

        uint32_t                events_completed;

        uint32_t                xrc_srq_num;
        struct ibv_xrc_domain  *xrc_domain;
        struct ibv_cq          *xrc_cq;

        pthread_mutex_t         mutex;
        pthread_cond_t          cond;
};

So, while they added a few new things, they also reordered existing
items.  This is a public structure passed back to the app and which
the app might read any of the items if they are interested.  So, with
a struct change like this you would normally require an update to
the library symbol map and have a compat wrapper so that binaries
compiled with either the old or new struct definition can link
against the library.  However, here is the library symbol maps for
ibv_create_srq in each library source:

Roland's: ibv_create_srq{IBVERBS_1.0}
OFED's: ibv_create_srq{IBVERBS_1.0}

This is despite the fact that whenever an ibverbs interface has
needed an update, Roland has done the right thing and updated
the symbol version to the IBVERBS_1.1 space in the map and
created a back compat wrapper in the 1.0 space.  So it's not even
like the OFED folks didn't have examples of how to do this
properly staring them in the face, they just didn't care to do it
properly.

> Why hasn't XRC support been implemented
> in the OFED libibverbs library such that applications built against
> the upstream libibverbs headers also work with the latest OFED
> version
> of that library ?

Because OFED exists.  That's the *real* reason they don't bother to
write this stuff right in the first place.  OFED is released as one
single unit, and there is no guarantee of API or ABI compatibility
from one release to the next.  And there is no guarantee of API/ABI
compatibility between any given OFED released library and any other
upstream library (aka, no guarantee that the OFED libibverbs will
work with the upstream librdmacm).  If something doesn't work,
then their answer is "Upgrade to the latest OFED on all machines,
and recompile your apps as needed".  If you had your own tree and
didn't have to answer to any upstream review, especially on
controversial new features or difficult designs, would you bother?

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
