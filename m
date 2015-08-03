From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 17/50] IB/hfi1: add PSM driver control/data path
Date: Mon, 3 Aug 2015 08:27:20 -0700
Message-ID: <20150803152720.GA4171@infradead.org>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191859.25256.28987.stgit@phlsvslse11.ph.intel.com>
 <20150730194041.GA28754@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC25777DA0@fmsmsx120.amr.corp.intel.com>
 <55BA9A38.2030401@redhat.com>
 <20150731073158.GA2485@infradead.org>
 <55BD2997.6000203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55BD2997.6000203-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 01, 2015 at 04:18:31PM -0400, Doug Ledford wrote:
> If you have a legitimate technical reason to NACK this feature, make
> your case.  I've publicly stated, in response to Al no less, that I
> don't see justification for making a team re-engineer a working, private
> interface because a disinterested third party finds it "weird".  If you
> provide no valid technical justification for your NACK, I'm going to
> disregard it.

It's breaking the semantics that write("foo", len) is the same as writev
of a single vector using writev.  We had to add a workaround for the
few broken places doing this which we'd like to remove in the long term.

Note that private driver interface really doesn't matter here.
Everything using file operations does go through the VFS so it does have
major implication on the semantics for all the kernel.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
