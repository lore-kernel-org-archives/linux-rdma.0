From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user access
Date: Sat, 16 Apr 2016 11:29:35 -0400
Message-ID: <20160416152934.GA27403@phlsvsds.ph.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com> <20160414164550.GC6247@obsidianresearch.com> <20160414174830.GA11641@rhel.sc.intel.com> <20160415040126.GB10689@leon.nu> <20160415161754.GA21549@rhel> <20160415173035.GC10689@leon.nu> <20160415173401.GA10868@infradead.org> <20160415212328.GF10689@leon.nu> <20160415232800.GA32513@rhel> <20160416060940.GB6349@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160416060940.GB6349-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 16, 2016 at 09:09:40AM +0300, Leon Romanovsky wrote:
>On Fri, Apr 15, 2016 at 07:28:01PM -0400, Ira Weiny wrote:
>> On Sat, Apr 16, 2016 at 12:23:28AM +0300, Leon Romanovsky wrote:
>> Do you have a technical reason that this patch series does not fix the
>> write/writev issue brought up by Al?
>
>Sure, I truly believe that we can do common API in a months time-frame
>and I want to be focused on one transition path only (write/read -> new
>API) and not on two parallel paths (ioctl -> new API and write/read ->
>new API) plus support of all these intermediate steps.

That doesn't say anything about how this patch doesn't address Al and 
Linus's complaint, or raise a technical issue with the patch set.

These are two separate issues. I do not see a reason to try and make them 
one, and use this to drive the "one-device to rule them all" idea.  This 
series converts the write() to ioctl() and fixes the problem we set to, as 
promised. You don't like the API, that's fine.  We'll discuss that on 
linux-rdma, but no reason to hold this patch set while that happens. 

>The original request came after this driver was moved from staging to
>RDMA stack, since the driver is still in staging, there is no need to
>hurry up now.

There is no need to keep the driver in staging. This is not a driver that 
has style problems or is not well tested.  It is a driver that has been 
heavily tested, performs well and has completed its staging TODO list. We 
went ahead and added this write()/writev() fix before making the move 
because Al and Linus wanted that issue addressed. For the record:

 $ cat drivers/staging/rdma/hfi1/TODO
 July, 2015

 - Remove unneeded file entries in sysfs
 - Remove software processing of IB protocol and place in library for use
   by qib, ipath (if still present), hfi1, and eventually soft-roce

Both of those items are complete. The API issue was raised back when the 
driver was submitted (almost a year ago), as you can see it did not make the 
cut as a staging requirement. Whether you agree with the maintainer's 
decision or not. I don't see how it's fair to try and add it again now.

As I mentioned let's discuss the uAPI stuff on linux-rdma. Have the web 
meetings that you were mentioning and do whatever we need to in order to 
improve the sub-system, but stop trying to tie our driver and moving out of 
staging to this much larger issue.

Thanks

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
