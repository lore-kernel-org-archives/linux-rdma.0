From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 10:23:07 -0700
Message-ID: <20150928172307.GA24141@infradead.org>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com>
 <20150928171724.GF12415@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150928171724.GF12415-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2015 at 11:17:24AM -0600, Jason Gunthorpe wrote:
> Should we combine the user side of the kapi 'core' stack (libverbs,
> all open source providers, libumad, libcm) into one source
> package? Many projects have been working in that model lately with
> some success, IMHO.
> 
> Many of these components are one or two C files, and the overhead of
> maintaining N copies of all the auto-crap is more than the package
> itself :|
> 
> Right now we even have the situation where some providers won't build
> with some verbs's, so it isn't even really the case they are actually
> independent.

I'm just a bystander in terms of userspace support, but the current
model always seemed a complete trainwreck to me.  Especially as it
implied a public ABI between the core libibvers and the providers, which
caused all kinds of problems.  Especially if you userspace guys want
to keep up with the improvements we're doing on the kernel side you
better get up to speed an create a coherent environment :)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
