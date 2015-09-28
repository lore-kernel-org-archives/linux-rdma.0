From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 11:42:15 -0600
Message-ID: <20150928174215.GB1623@obsidianresearch.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com>
 <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150928173208.GA8083-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2015 at 10:32:08AM -0700, Christoph Hellwig wrote:
> 
> Hi Robert,
> 
> getting a package out should not be an issue.  master should always be
> in releasable state, and cutting a release should be a simple shell
> script doing all the tagging and uploading.

+1

We are well past the point of doing experimental breaking stuff in the
core uapi libraries. If it is in the master git it should be shippable
by a distro, and it is so easy to slap a version number on the HEAD if
a distro/ofed/etc wants one.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
