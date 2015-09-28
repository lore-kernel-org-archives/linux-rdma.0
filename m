From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 15:15:46 -0600
Message-ID: <20150928211546.GA10311@obsidianresearch.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com>
 <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org>
 <20150928174215.GB1623@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D25098A@ORSMSX110.amr.corp.intel.com>
 <20150928190024.GB8358@obsidianresearch.com>
 <5609A19A.806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5609A19A.806-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2015 at 04:22:50PM -0400, Doug Ledford wrote:

> >> just a bug fix. Further, that new stuff might even require new
> >> kernel code, so it could not just be replaced as a new user-space
> >> package by a distro w/o updating the kernel.
> > 
> > We are not going to make a change like that, that violates the spirit
> > of how the uabi side is supposed to work.

> None of that violates the spirit of the libibverbs development, but
> it still doesn't necessarily match up with distro needs.

I was commenting specifically on the idea that we'd ever release a
libverbs that forced a kernel upgrade. I hope we all agree that is not
acceptable.

> Anyway, I had intended, and I've started on, making a change in how
> libibverbs is done anyway.  The idea that a new release is just a script
> that throws a version on and we go is naive.  I *will* be doing
> pre-release rc tarballs and there will be testing and there will be a
> release process that helps to make sure we don't see things like what we
> saw with librdmacm (sorry to pick on you Sean): 1.0.17/1.0.17.1,
> 1.0.18/1.0.18.1, and 1.0.19/1.0.19.1.

I don't know about other people, but I've built the mess enough times
to know I don't want to do it. Especially if it starts to be "git HEAD
on all the bits doesn't work together"

Making rcs is fine, but think of the audience? Who will build them,
who will test them, and is it *as easy as possible* to do
that?

Make it hard and people will ignore git, ignore rc release, ignore
release tar balls and just wait for OFED to put something out.

IMHO - we should be talking about getting to the point where we can
deliver the kernel rc and uapi rc together to someplace like UNH and
vendor internal labs and expect them to test that pair. Regularly,
ideally on the kernel release time line.

To that end, in my view, exactly two source releases is the ideal.

Regarding bug fixes: I've seen other communities emulate the kernel
scheme of tagging patches in git for backport, and distros use that
guidance to make sure bug fixes filter back into their releases. Just
like the kernel. Much easier to do that in one place than many.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
