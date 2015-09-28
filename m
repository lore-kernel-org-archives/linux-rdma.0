From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 18:18:52 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C7D25098A@ORSMSX110.amr.corp.intel.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org>
 <20150928174215.GB1623@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928174215.GB1623-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2015 at 10:42:08AM -0700, Jason Gunthorpe wrote:
>We are well past the point of doing experimental breaking stuff in the core uapi libraries. If it is in the master git it should be shippable by a distro, and it is so easy >to slap a version number on the HEAD if a distro/ofed/etc wants one.

This may be true, but since it is the master, there could be all kinds of new stuff in it and not just the simple bug fix a H/W vendor might want to 
put into his/her user-space H/W specific library. Consider the situation when some H/W vendor just wants to provide a simple fix to their library.
In the current model, they simply fix it and release a new H/W specific library that a customer or distro can pick up and ship.

In the merged library case, the fix has to go into master, which may have other new stuff already in it. If you simply build a new package and
roll the version number, it now has to be retested and revalidated by the distro and perhaps other ISVs that have coded and validated
with the previous package, since it has new stuff and not just a bug fix. Further, that new stuff might even require new kernel code, so it could not just
be replaced as a new user-space package by a distro w/o updating the kernel. 

There are definitely pros and cons to each model. Since I am not a maintainer of any of the code, I really don't have a strong opinion 
either way. I think it is really up to all the various H/W vendors and maintainers of the other libraries, umad, rdmacm, ibcm, etc. and the Linux distros 
which way they would prefer it be done.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
