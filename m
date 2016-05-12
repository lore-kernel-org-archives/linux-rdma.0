From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2 0/5] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 12 May 2016 13:25:08 -0600
Message-ID: <20160512192508.GA17319@obsidianresearch.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
 <20160512173445.GA13553@obsidianresearch.com>
 <20160512190738.GA15146@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160512190738.GA15146@phlsvsds.ph.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 03:07:38PM -0400, Dennis Dalessandro wrote:
> >>There is also a driver software version being exported via a sysfs
> >>file. This is needed so that user space applications (psm) can
> >>determine if it needs to do ioctl() or write().
> >
> >Why? Don't do this, just call ioctl() and if it fails then use write().
> 
> Is it really that big of a deal to export a version number?

If it isn't needed, don't add it..

> >another reference counted structure. You need to consider how all this
> >works when the driver is removed while the cdev is still open (or
> >driver remove is racing with the cdev release).
> 
> The driver can't be removed while the cdev is still open. I tested with a
> test code that opens /dev/hfi1_0 and spins. The use count as reported by
> lsmod ticks up and the driver can not be unloaded until I ctrl+c the test
> program.

Drivers can be removed in other ways, eg pci hot unplug. Do not assume
module_exit is the only way and rely on module ref counting for
correctness.

Jason
