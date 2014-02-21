From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/srp: Fail SCSI commands silently
Date: Fri, 21 Feb 2014 10:23:58 +0100
Message-ID: <53071B2E.2050302@acm.org>
References: <5305DE01.7030004@acm.org> <5305DE67.9070805@acm.org> <1392954937.26557.3.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392954937.26557.3.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/21/14 04:55, David Dillow wrote:
> On Thu, 2014-02-20 at 11:52 +0100, Bart Van Assche wrote:
>> Do not log SCSI command failures that are the result of a transport
>> layer failure, a SCSI abort or SCSI reset. This patch is a slightly
>> modified version of a patch posted by Sebastian Riemer in March 2013
>> (see also http://thread.gmane.org/gmane.linux.drivers.rdma/15020/).
>>
>> This patch avoids that a system becomes unresponsive during failover
>> of a large number of LUNs when kernel messages are logged to a serial
>> console.
> 
> While I can see the utility for slow consoles, this should probably be
> done in the SCSI lib, with a separate flag for indicating it is a
> failure due to transport issues. That would allow the functionality to
> be used by multiple drivers and verbosity configured in one place,
> rather than patched in driver-by-driver.

Hello Dave,

If it would be possible to move the code for setting the REQ_QUIET flag
into the SCSI lib that would be great. However, as far as I know only
the LLD knows which requests are in progress. A call to
blk_start_request() makes blk_dequeue_request() remove a request from
the queuelist in struct request_queue. I am not aware of any list in the
block layer nor in the SCSI mid-layer that keeps track of requests that
are in progress ?

Thanks,

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
