From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH v2 0/5] IB/hfi1: Remove write() and use ioctl() for user access
Date: Thu, 12 May 2016 15:07:38 -0400
Message-ID: <20160512190738.GA15146@phlsvsds.ph.intel.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com> <20160512173445.GA13553@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160512173445.GA13553@obsidianresearch.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 11:34:45AM -0600, Jason Gunthorpe wrote:
>On Thu, May 12, 2016 at 10:18:27AM -0700, Dennis Dalessandro wrote:
>
>> There is also a driver software version being exported via a sysfs
>> file. This is needed so that user space applications (psm) can
>> determine if it needs to do ioctl() or write().
>
>Why? Don't do this, just call ioctl() and if it fails then use write().

Is it really that big of a deal to export a version number?

There are cases where psm could be built with a different kernel (depends on  
a header file) than the currently running one.  This allows psm to check the 
current running version with what it was built against. This could be useful 
for other scenarios in the future as well. Not just the write vs ioctl.

>> This does not add anything for compat_ioctl() as it is my understanding that
>> 32 bit applications that attempt to call the ioctl() will just fail. Which is
>> the intended behavior.
>
>qib works fine with a 64 bit kernel and 32 bit user space, don't
>break it.

We will handle this issue when we get to the qib patches. I want to hammer 
out what the solution for hfi1 looks like first.

>> There is also a question of if we need to set kobj.parent [1], I'm
>
>It is needed, you need to audit this stuff, there might be more wrong
>than that.

>> not sure this is the case since the cdev in question lives
>> in /dev, not /dev/infiniband.
>
>Irrelevant. kobj.parent is needed because the cdev is embedded within
>another reference counted structure. You need to consider how all this
>works when the driver is removed while the cdev is still open (or
>driver remove is racing with the cdev release).

The driver can't be removed while the cdev is still open. I tested with a
test code that opens /dev/hfi1_0 and spins. The use count as reported by 
lsmod ticks up and the driver can not be unloaded until I ctrl+c the test 
program.

Are you saying the driver's cdev release function could race with the 
drivers moudle_exit()? I don't think this happens. I put a sleep in the 
release function and ctrl+c my test program and it hangs until the sleep 
expires.  I tried to rmmod the driver (during the window)  and it fails as 
in use.

-Denny
