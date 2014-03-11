From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/srp: Fix crash when unmapping data loop
Date: Tue, 11 Mar 2014 15:38:00 +0200
Message-ID: <531F11B8.5030202@dev.mellanox.co.il>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-2-git-send-email-sagig@mellanox.com> <530B6444.1000805@acm.org> <530F225E.5070500@dev.mellanox.co.il> <53183B71.4090609@acm.org> <53189526.2010704@mellanox.com> <53189DDE.7090003@dev.mellanox.co.il> <53197FC5.4090102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53197FC5.4090102-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/7/2014 10:13 AM, Bart Van Assche wrote:
> On 03/06/14 17:10, Sagi Grimberg wrote:
>> So I took Roland latest 3.14-rc1 and tried to reproduce this issue using
>> HCA with no FMRs support and was *NOT* able to reproduce this issue. This
>> issue reproduced for me on RH6 backported srp and I can't tell where is
>> the delta at the moment. Perhaps Sebastian can share his scenario that
>> reproduces this issue and was solved by the patch I proposed.
>>
>> I suggest to try and reproduce it with your ib_srp-backport code over
>> RH6, worth a look right?
> Hello Sagi,

Hey Bart,

A bit late but I hope not too late...

> It would help if you could explain why you are concerned about holding a
> spin lock during the srp_post_send() call. According to
> Documentation/infiniband/core_locking.txt ib_post_send() is not allowed
> to sleep.

Correct, taking the spinlock around ib_post_send is allowed and I don't 
think any HCA drivers
will ever sleep there.

>   And before the SCSI host lock push-down the SCSI host lock was
> held around the srp_queuecommand() invocation. In other words, holding a
> spin lock around the srp_post_send() call in srp_queuecommand() is
> neither new nor disallowed by the RDMA API documentation.

I just noted that I think it should be avoided due to performance reasons.
We are going towards scsi-mq and I suspect fast-path spinlocks will 
become much
more expensive in this era, and we should try to avoid them rather than 
take them.

>   And if there
> would be any (legacy?) RDMA HCA drivers that are not upstream and for
> which it is not safe to invoke ib_post_send() with a spin lock held, how
> about invoking srp_post_send() in distro's that support these drivers
> without holding target->lock ?

I don't think we need to worry about that.

>   The patch I posted fixes a race between
> srp_finish_req() and the error path in srp_queuecommand by setting
> req->scmnd after the srp_post_send() call instead of before.

Yes, I agree this would help.

>   Holding
> target->lock around the srp_post_send() call and the req->scmnd
> assignment is only needed to avoid the (theoretical) race where
> processing of an SRP reply would already have been started before
> req->scmnd has been assigned by srp_queuecommand().

I see... will assigning scmnd = NULL only if srp_post_send will fail, 
and restore the assignment as before help?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
