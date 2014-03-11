From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/srp: Fix crash when unmapping data loop
Date: Tue, 11 Mar 2014 14:51:12 +0100
Message-ID: <531F14D0.7010608@acm.org>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-2-git-send-email-sagig@mellanox.com> <530B6444.1000805@acm.org> <530F225E.5070500@dev.mellanox.co.il> <53183B71.4090609@acm.org> <53189526.2010704@mellanox.com> <53189DDE.7090003@dev.mellanox.co.il> <53197FC5.4090102@acm.org> <531F11B8.5030202@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531F11B8.5030202-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/11/14 14:38, Sagi Grimberg wrote:
>> And before the SCSI host lock push-down the SCSI host lock was
>> held around the srp_queuecommand() invocation. In other words, holding a
>> spin lock around the srp_post_send() call in srp_queuecommand() is
>> neither new nor disallowed by the RDMA API documentation.
> 
> I just noted that I think it should be avoided due to performance reasons.
> We are going towards scsi-mq and I suspect fast-path spinlocks will
> become much
> more expensive in this era, and we should try to avoid them rather than
> take them.

Once the SRP initiator driver will support multiple queues the lock
around srp_post_send() will be per queue instead of per target so if the
number of queues is large enough that lock won't be a contention point.
I have experimental code ready that follows this approach.

>> Holding
>> target->lock around the srp_post_send() call and the req->scmnd
>> assignment is only needed to avoid the (theoretical) race where
>> processing of an SRP reply would already have been started before
>> req->scmnd has been assigned by srp_queuecommand().
> 
> I see... will assigning scmnd = NULL only if srp_post_send will fail,
> and restore the assignment as before help?

Sorry but I'm not enthusiast about that approach because it could result
in resources being freed while srp_post_send() is in progress. I prefer
to avoid this kind of race conditions.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
