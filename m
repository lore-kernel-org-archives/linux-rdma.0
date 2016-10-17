From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/4] rdma-core infrastructure
Date: Mon, 17 Oct 2016 11:51:59 -0400
Message-ID: <20161017155159.GG14983@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161015092619.GJ9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161015092619.GJ9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 15, 2016 at 12:26:19PM +0300, Leon Romanovsky wrote:
> On Fri, Oct 14, 2016 at 03:21:32PM -0400, Jarod Wilson wrote:
> > This is a set of patches to make some minor changes to the stock spec file,
> > add a bunch of userspace glue that Red Hat has been shipping on it's own in
> > Red Hat Enterprise Linux and Fedora for a while now, and a revised split
> > package spec file that we're likely to use in at least RHEL, to preserve the
> > current packaging split.
> 
> Jarod,
> 
> I'm far a way from packaging, so I have very general questions.
> 1. You mentioned FC, but used glue/redhat/. Is it applicable for Centos?

Red Hat is the driving force behind Red Hat Enterprise Linux, CentOS (or
any other clone) and Fedora, so it would generally be applicable for all
of them, similar to how the 'debian' stuff is generally applicable to
derivatives like ubuntu as well.

> 2. Do  FC and Centos need similar files in structure?

For the most part, they should be identical.

> 3. Does it make sense to rename glue/ to be packages/ and move debian there?

That, or as Jason has suggested, just have a top-level redhat directory,
same as the debian one. Don't really care much what it's called, just as
long as we can get (at least most of) this stuff into the tree, rather
than having it lingering in our own special package.

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
