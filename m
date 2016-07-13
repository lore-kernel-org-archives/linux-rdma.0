From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V1 4/8] RDMA/core: Add support for custom types
Date: Wed, 13 Jul 2016 10:39:24 -0600
Message-ID: <20160713163924.GA19657@obsidianresearch.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-5-git-send-email-matanb@mellanox.com>
 <20160712192345.GC8206@obsidianresearch.com>
 <081a02c0-0650-d0c2-494c-19a64b83cbc1@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <081a02c0-0650-d0c2-494c-19a64b83cbc1-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 13, 2016 at 05:44:46PM +0300, Matan Barak wrote:

> We can, but then every driver should declare the common objects
> order by itself.  Maybe we could provide a macro that does this for
> you (if you don't have any custom types interleaved).

Hum, that seems so very fragile and complex..

There are other ways to deal with destruction ordering. refcounts
only for use during descruction might be easier. Repeatedly iterate
over the uobject list deleting 0 refcount objects until the list is
empty.

So, eg when you create a MR on a PD then PD's destruct refcount gets
++'d, and when the MR is deleted it gets --'d. This naturally forces
the needed ordering.

> >What use is tracking the ubojects in a per-type list? Do we ever
> >iterate that way other than on global destruct?
> >
> 
> The only purpose of these lists are either ucontext destruction or device
> removal (which ultimately deletes all ucontexts).
> ucontext destruction requires list per ucontext x type.

I wouldn't waste memory on optimizing destruction like that, just run
over the idr repeatedly, matching against the object type.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
