From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 12:21:44 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org> <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928171724.GF12415-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 28 Sep 2015, Jason Gunthorpe wrote:

> Should we combine the user side of the kapi 'core' stack (libverbs,
> all open source providers, libumad, libcm) into one source
> package? Many projects have been working in that model lately with
> some success, IMHO.

Yes please.

> Right now we even have the situation where some providers won't build
> with some verbs's, so it isn't even really the case they are actually
> independent.

Right. Its really nasty when you are trying to add features that require
libibverbs and libmlx? changes. Plus it may depend on kernel changes.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
