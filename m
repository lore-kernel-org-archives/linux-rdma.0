From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/4] rdma-core infrastructure
Date: Mon, 17 Oct 2016 12:26:25 -0400
Message-ID: <20161017162625.GJ14983@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161015092619.GJ9282@leon.nu>
 <20161017155159.GG14983@redhat.com>
 <20161017161154.GB5679@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161017161154.GB5679-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 17, 2016 at 10:11:54AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 17, 2016 at 11:51:59AM -0400, Jarod Wilson wrote:
> 
> > > 3. Does it make sense to rename glue/ to be packages/ and move debian there?
> > 
> > That, or as Jason has suggested, just have a top-level redhat directory,
> > same as the debian one. Don't really care much what it's called, just as
> > long as we can get (at least most of) this stuff into the tree, rather
> > than having it lingering in our own special package.
> 
> The debian/ directory has to be top level for debian tools, so I'm
> inclined to just follow the pattern and go with redhat/.

Okay, good, my vague recollection of that was correct.

> I think it is no problem to take what you have right away, but lets
> try to move as much as is trivial/sensible into common places.

I'm shuffling things around locally to redhat/ and have pulled in your
Docs install change. Want me to finish cleaning up, double-check that it
all builds, and ship a v2 set?

> Maybe we can tackle the larger questions (eg systemd) later..

Some of these issues might be better addressed once more distros have had
a chance to digest the new package and see what they still need. Entirely
possible others have a similar pile of glue for their distro, including
generic parts, and their generic parts are more polished than ours.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
