From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 03/13] IB/core: Add new ioctl interface
Date: Thu, 15 Jun 2017 10:57:51 -0600
Message-ID: <20170615165751.GB23773@obsidianresearch.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
 <1496838172-39671-4-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB143340@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BArF5U49WQ2PcYjpSbPpQmyubJQ6vKKUer_L05QBQpT0w@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1436F6@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BA+Bpwbx+pZivK_+jRLc9kCrvhQkPy4tKcaTqUZhfRiOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BA+Bpwbx+pZivK_+jRLc9kCrvhQkPy4tKcaTqUZhfRiOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 15, 2017 at 02:50:17PM +0300, Matan Barak wrote:

> Following object oriented approach, I can think of the following
> trivial changes:
> type->class
> action->method (actually, these are static methods, but nm)

I don't think they are static methods.. anything that takes an object
id or a fd num is a normal method acting on that object, anything that
returns an object id/fd num is a constructor, anything that destroys
an object id is a destructor.

> The "groups" concept is a bit harder to grasp in OO. In our case, an
> entity is actually divided into a few "groups" and its actual
> content

This is similar to standard OO concept of mixins/multiple inheritance,
but you are applying the idea to function parameter lists, not classes.

> In contrast of the OO multiple inheritance case, we have a specific
> meaning to the order of these groups - the handler actually uses
> them.

That distinction seems conceptually unnecessary.. The access of the
arguments should not depend on where the argument is defined, only on
the argument ID, which is back to what I said before, why do we need
to even have a word for namepace?

static inline void *uverbs_get_attr(const uvbers_attr_bundle *args, uint32_t attr_id)
{
    if (((attr_id & UVERBS_ID_NS_MASK) >> UVERBS_ID_NS_SHIFT) == 0)
        return args.common_attrs[attr_id & XX];
    if (((attr_id & UVERBS_ID_NS_MASK) >> UVERBS_ID_NS_SHIFT) == 1)
        return args.driver_attrs[attr_id & YY];
    return NULL;
}

void some_method(const uvbers_attr_bundle *args)
{
    uverbs_get_attr(args, ATTR_ID_COMMON_A);
    uverbs_get_attr(args, ATTR_ID_MLX5_B);
}

> struct uverbs_attr_spec {
>     enum uverbs_attr_type        type;
>     <...>
> };
> 
> struct uverbs_attr_spec_ns {
>     struct uverbs_attr_spec        *attrs;
>     <...>
> };

I don't think we need _ns versions of any of these at all. Stop
treating ns as special, there is only attribute IDs, and the only time
the specialness of the ID layout comes into play is when you hash the
ID for quick lookup, or 'hash' the ID for attribute storage (eg
uverbs_get_attr)

*NOTHING* else should care if an ID is within the driver, common or
other reserved space.

> >> I used the term "group" to emphasize that these aren't just a random
> >> collection of params in a lit.
> >> Grouping this entities together has a specific meaning.
> >
> > But *what* is that meaning?  That's what I'd like the name to
> > convey.  I thought the grouping was because the attributes were a
> > set of parameters being passed into a single
> > function/operation/action/method.
> 
> Entities were grouped together because they belong to the same
> namespace. If we take the attributes for an example, once we execute
> the method's handler, we get one group of attributes for the common
> namespace and another one for the driver namespace. By using
> namespaces, we could introduce new arguments for either common and
> driver specific without stepping on other attributes in different
> namespaces.  When reaching the handler, each argument has a unique
> meaning. Please see the uverbs_attr_array example above.

Again, don't see why we should care. All of this micro-optimizing
should be hidden from the method author.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
