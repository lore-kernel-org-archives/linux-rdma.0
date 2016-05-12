From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] IB/hfi1: Remove write() and use ioctl() for user access
Date: Thu, 12 May 2016 15:53:04 -0400
Message-ID: <20160512195304.GA10419@phlsvsds.ph.intel.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com> <20160512173445.GA13553@obsidianresearch.com> <20160512190738.GA15146@phlsvsds.ph.intel.com> <20160512192508.GA17319@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160512192508.GA17319-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 01:25:08PM -0600, Jason Gunthorpe wrote:
>On Thu, May 12, 2016 at 03:07:38PM -0400, Dennis Dalessandro wrote:
>> >>There is also a driver software version being exported via a sysfs
>> >>file. This is needed so that user space applications (psm) can
>> >>determine if it needs to do ioctl() or write().
>> >
>> >Why? Don't do this, just call ioctl() and if it fails then use write().
>> 
>> Is it really that big of a deal to export a version number?
>
>If it isn't needed, don't add it..

For the reason I gave, I think it is needed so unless you are vehemently 
opposed to it I would prefer to leave it.

>> >another reference counted structure. You need to consider how all this
>> >works when the driver is removed while the cdev is still open (or
>> >driver remove is racing with the cdev release).
>> 
>> The driver can't be removed while the cdev is still open. I tested with a
>> test code that opens /dev/hfi1_0 and spins. The use count as reported by
>> lsmod ticks up and the driver can not be unloaded until I ctrl+c the test
>> program.
>
>Drivers can be removed in other ways, eg pci hot unplug. Do not assume
>module_exit is the only way and rely on module ref counting for
>correctness.

Point taken. I'll look into this. So are you perhaps suggesting we do 
something like is done for uverbs_dev in ib_verbs_add_one() where there is a 
kobj for uverbs_dev and the parent of uverbs_dev->cdeb is set to that? In 
our case it would probably be something like hfi1_devdata.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
