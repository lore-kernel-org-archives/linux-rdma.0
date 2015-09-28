From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 14:16:13 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1509281409220.31889@east.gentwo.org>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org> <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com> <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org> <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org> <20150928174215.GB1623@obsidianresearch.com> <9C6B67F36DCAFC479B1CF6A967258A8C7D25098A@ORSMSX110.amr.corp.intel.com> <20150928190024.GB8358@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928190024.GB8358-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 28 Sep 2015, Jason Gunthorpe wrote:

> I would guess all-together is actually less work for the distro side
> because the whole candidate patch stream for backporting is right
> there, easy to see, not sprinkled across all manner of git trees.

This is true not only for the distro but also for those needing to make
changes because f.e. some things are broken. Its much easier to send out a
single patch vs the "big library" instead of 3 separate ones against libibverbs,
libmlx5, libmlx4. Keeping track of that is a nightmare.

Ideally there should be a lib directory in the kernel where the stuff
lives so that a single patch can make the necessary changes.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
