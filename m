From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 0/5] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 12 May 2016 15:27:09 -0600
Message-ID: <20160512212709.GB6545@obsidianresearch.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
 <20160512173445.GA13553@obsidianresearch.com>
 <20160512190738.GA15146@phlsvsds.ph.intel.com>
 <20160512192508.GA17319@obsidianresearch.com>
 <20160512195304.GA10419@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160512195304.GA10419@phlsvsds.ph.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 03:53:04PM -0400, Dennis Dalessandro wrote:
> >>Is it really that big of a deal to export a version number?
> >
> >If it isn't needed, don't add it..
> 
> For the reason I gave, I think it is needed so unless you are vehemently
> opposed to it I would prefer to leave it.

It represents the opposite of what we want to see in good uapi
design. Linux generally doesn't use versioning, it uses active in-band
discovery (eg via ENOSYS or something)

If you do something that needs versioning then add it, otherwise
assume a design using in-band discovery.

> >Drivers can be removed in other ways, eg pci hot unplug. Do not assume
> >module_exit is the only way and rely on module ref counting for
> >correctness.
> 
> Point taken. I'll look into this. So are you perhaps suggesting we do
> something like is done for uverbs_dev in ib_verbs_add_one() where there is a
> kobj for uverbs_dev and the parent of uverbs_dev->cdeb is set to that? In
> our case it would probably be something like hfi1_devdata.

Unconditionally the cdev parent kref must point to the kref that holds
the liftime of the memory containing the struct cdev.

See

commit 35d4a0b63dc0c6d1177d4f532a9deae958f0662c
Author: Yishai Hadas <yishaih@mellanox.com>
Date:   Thu Aug 13 18:32:03 2015 +0300

    IB/uverbs: Fix race between ib_uverbs_open and remove_one

But I thought there might be more issues with release racing with
remove as some of the release functions were quite complex, and I
didn't see much locking (I did not study it closely). It needs a
careful analysis to show that is OK.  Remember unregistering the cdev
is not a fence and open fd's can remain and be released at any time.

Jason
