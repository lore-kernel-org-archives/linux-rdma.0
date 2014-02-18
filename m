From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: IB/srp: merge fixes from MLNX_OFED
Date: Tue, 18 Feb 2014 19:25:13 +0200
Message-ID: <53039779.3080507@dev.mellanox.co.il>
References: <53038E93.7050706@profitbricks.com> <530392D9.1010900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530392D9.1010900-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/18/2014 7:05 PM, Bart Van Assche wrote:
> On 02/18/14 17:47, Sebastian Riemer wrote:
>> I've also noticed the added target locking around target->free_tx
>> handling in srp_rport_reconnect(). There are cases e.g. in
>> srp_queuecommand() where holding the rport mutex isn't enough to protect
>> it. So for me this looks right.
>>
>> Then, in srp_create_target() I've noticed the check of the return value
>> of ib_query_gid(). Makes completely sense to check it.
>>
>> Please send patches for so obvious fixes to the mailing list! There is a
>> very good chance that they get accepted.
> Hello Sebastian,
>
> If I hadn't been busy testing scsi-mq patches recently, the SRP
> initiator patches you referred to would already have been posted for
> review on the linux-rdma mailing list. I hope to find some time one of
> the next days to post a few SRP initiator patches on the linux-rdma
> mailing list - not only the ones referred to above but also a few other
> patches.

Hey Sebastian & Bart,

Yes, I did plan to submit a few patches for SRP soon (I'm currently busy 
playing with scsi-mq and cleaning-up iSER DIF patches).
Thanks for the reminder, you are absolutely right!

Regarding the FMR unmap crash, I experienced it when running our 
distro-backported MLNX_OFED
and hadn't got a chance to see if it reproduces in upstream yet. Thanks 
for confirming this reproduces here as well.
Bart, Are you familiar with this issue? it should reproduce over mlx5 
driver or SRIOV (where FMRs are not supported).

Regarding the rest,
Let's let Bart propose his fixes and I'll make sure to see if I have 
anything to add there.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
