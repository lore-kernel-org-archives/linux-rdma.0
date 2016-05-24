From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/10] IB/hfi1: Do not free hfi1 cdev parent structure early
Date: Tue, 24 May 2016 10:17:57 -0400
Message-ID: <20160524141756.GA17438@phlsvsds.ph.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com> <20160519122642.22041.66203.stgit@scvm10.sc.intel.com> <20160519183100.GC26130@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160519183100.GC26130-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2016 at 12:31:00PM -0600, Jason Gunthorpe wrote:
>If dd->kobj is passed as the parent to hfi1_cdev_init then cdev core
>will do this for you, just confusing to duplicate it here??
>
>> @@ -1007,6 +1009,15 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
>>  	rvt_dealloc_device(&dd->verbs_dev.rdi);
>
>Hurm. How are you synchronizing pci device removal with ioctls on the
>cdev?

We have a system in place to tear down the various resources, unregister 
from the core, disable interrupts, disable send/rcv contexts, etc. 

Due to the nature of our hardware user space has direct access to the 
device. This means there is always going to be a race between the card going 
away and user space trying to access something that isn't there.

We could add a flag that says to start failing ioctls, we could forcibly 
close the file descriptor on the user, and I'm sure there are other things 
we could do. However there is always the race condition when the user has 
direct access.

The situations which we have to worry about are someone physically removing 
the card, or using admin priv to unbind it from pci, things of that nature.  
All of which are not normal use cases.

This patch handles a specific issue. The parent data structure of the cdev 
going away. So if something is hanging onto the cdev we won't panic when it 
tries to close. For instance a user application sending the get_version 
ioctl after the device has gone away but before closing its FD. 

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
