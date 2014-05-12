From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 3/3] Add ibv_query_port_ex support
Date: Mon, 12 May 2014 10:43:23 -0600
Message-ID: <20140512164323.GA20666@obsidianresearch.com>
References: <1399531883-30599-1-git-send-email-ogerlitz@mellanox.com>
 <1399531883-30599-4-git-send-email-ogerlitz@mellanox.com>
 <20140508190951.GB25849@obsidianresearch.com>
 <5370BCF2.7050107@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5370BCF2.7050107-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 12, 2014 at 03:22:10PM +0300, Matan Barak wrote:

> >Anonymous struct/union is a C11 feature and GNU extension. I don't
> >think is appropriate for a user library to rely on. We cannot assume
> >the user is has a compiler in C11 mode.
> >
> >The cannonical layout should be:
> >
> >struct ibv_port_attr_ex {
> >    uint64_t comp_mask;
> >    struct ibv_port_attr	port_attr;
> >    // New stuff goes here
> >}
> >
> 
> It's not mandatory, but I think it could prevent future breakages
> and inconsistencies. Anyway, anonymous unions are supported in icc
> 9.2+, clang 3.1+ and of course gcc. However, I'll remove this in the
> next version of this series.

Many compilers support C11, but if the user chooses to compile with,
say, -std=c99 then the feature goes away. System level headers should
never require the user to use a specific -std.

You can also inline the legacy port_attr into the struct, which might
be the best option here.

> >It is fine to use comp_mask to indicate all the fields, no need for
> >the weird mask1, lets not over complicate things for users.
> 
> I don't think that's the right thing to do. According to my
> understanding, the prefix of the extension verb is fully compatible
> with the old structure.

This is not necessary in this case, it is convient that the old
structure exist within the extended structure so that it is easy for
the wrapper to call an old function without having to munge the
function pointers, but that copy can be in any place.

> Afterwards, comp_mask has a bit for every new field. mask1 is a new
> field that indicates which of the "old" values the user is
> interested in. If we want to be strict with the extension verbs
> definition, lets keep it all the way.

comp_mask has bits for fields, that is all it does, the distinction
between 'new' and 'old' is meaningless at this point. Just inline the
bits in comp_mask.

Generally, it would be smart to limit the number of comp_mask bits
used so we don't run out in the future, so in general, a new extension
can omit bits for fields that exist when the extension is introduced.

However, in this case there is a functional purpose to having the
fields have bits, so you should just go ahead and include them
directly.

Adding more masks is just going to be confusing to users. Remember,
there is no static type checking, so the user has to know that
IBV_QUERY_PORT_EX_LINK_LAYER is associated with mask1, while
IBV_QUERY_PORT_EX_ATTR_MASK1 is somehow associated with comp_mask -
and they sure do look similar, and it is counter-intuitive compared to
other cases in the library.

BTW, before I forget, the patch that introduces the API must also
include a man page for it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
