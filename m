From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Mon, 18 Apr 2016 23:45:49 -0400
Message-ID: <20160419034548.GG27515@rhel.amr.corp.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160418130909.GD11508@infradead.org>
 <20160418174047.GB13865@obsidianresearch.com>
 <20160418182411.GA4904@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160418182411.GA4904@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
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
> 
> The stuff the intel driver are doing isn't pretty, but unfortunately
> not unusual either - lots of SCSI or network driver have ioctls
> like that.  Now we could argue if the ioctls should be one the
> main node (uverbs) or the a driver private chardev, or not exist
> at all and people will have to patch the driver with some vendor
> version if they really need it.  Examples for either of these
> choices exist in the tree.

I'm a bit confused by what you are suggesting that "people will have to patch
the driver with some vendor version if they really need it."?

Could you elaborate?

PSM is the primary performant path for this device.  Without it this device is
severely limited in its intended functionality.

We are strongly motivated to have all of our functionality included in the
mainstream kernel.  So for eprom/snoop we would really like to find a way to
include all this functionality.

Ira

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
