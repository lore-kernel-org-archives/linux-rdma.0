From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v1 1/3] IB/srp: Fix crash when unmapping data loop
Date: Tue, 11 Mar 2014 15:29:17 +0100
Message-ID: <531F1DBD.9070505@acm.org>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-2-git-send-email-sagig@mellanox.com> <530B6444.1000805@acm.org> <530F225E.5070500@dev.mellanox.co.il> <53183B71.4090609@acm.org> <53189526.2010704@mellanox.com> <53189DDE.7090003@dev.mellanox.co.il> <53197FC5.4090102@acm.org> <531F11B8.5030202@dev.mellanox.co.il> <531F14D0.7010608@acm.org> <531F18A7.1000907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531F18A7.1000907-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, sagi grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/11/14 15:07, Sagi Grimberg wrote:
> On 3/11/2014 3:51 PM, Bart Van Assche wrote:
>> On 03/11/14 14:38, Sagi Grimberg wrote:
>>> I see... will assigning scmnd = NULL only if srp_post_send will fail,
>>> and restore the assignment as before help?
>> Sorry but I'm not enthusiast about that approach because it could result
>> in resources being freed while srp_post_send() is in progress. I prefer
>> to avoid this kind of race conditions.
> 
> Are you referring to srp_create_target_ib racing with srp_post_send? if
> not, what resources are you referring to?

I was referring to a potential race between srp_terminate_io() and
srp_post_send(). The function srp_claim_req() can grab a SCSI command as
soon as req->scmnd has been set so srp_terminate_io() can also get
invoked as soon as req->scmnd has been set. I'd like to avoid that
srp_post_send() reads information from a struct srp_iu that has already
been freed and that maybe has already been reused for another request.
Hence my preference to set req->scmnd after srp_post_send() since that
avoids triggering a race condition between srp_post_send() and
srp_terminate_io().

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
