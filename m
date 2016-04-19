From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Tue, 19 Apr 2016 11:38:17 -0600
Message-ID: <20160419173817.GF20844@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160418130909.GD11508@infradead.org>
 <20160418174047.GB13865@obsidianresearch.com>
 <20160418182411.GA4904@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418182411.GA4904-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 18, 2016 at 11:24:11AM -0700, Christoph Hellwig wrote:
> On Mon, Apr 18, 2016 at 11:40:47AM -0600, Jason Gunthorpe wrote:
> > I wasn't arguing this should integrate into verbs in some way, only
> > that the way to access the driver-specific uAPI of a RDMA device should
> > be through the RDMA common uAPI and not through a random char dev.
> 
> Well, it's stuff not related to our RDMA userspace API (which _is_
> Verbs, not counting for the complete crackpot abuse in usnic), but
> very device specific. 

It is weakly related, it uses the same device discovery and security
model.

> The stuff the intel driver are doing isn't pretty, but unfortunately
> not unusual either - lots of SCSI or network driver have ioctls
> like that.  Now we could argue if the ioctls should be one the
> main node (uverbs) or the a driver private chardev, or not exist
> at all and people will have to patch the driver with some vendor
> version if they really need it.  Examples for either of these
> choices exist in the tree.

Right - and the RDMA uAPI has always had an integrated driver-bypass
channel as part of the verb uAPI calls, extending that to allow for
new-driver-specific calls seems very natural.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
