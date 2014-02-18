From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: IB/srp: merge fixes from MLNX_OFED
Date: Tue, 18 Feb 2014 18:05:29 +0100
Message-ID: <530392D9.1010900@acm.org>
References: <53038E93.7050706@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53038E93.7050706-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/18/14 17:47, Sebastian Riemer wrote:
> I've also noticed the added target locking around target->free_tx
> handling in srp_rport_reconnect(). There are cases e.g. in
> srp_queuecommand() where holding the rport mutex isn't enough to protect
> it. So for me this looks right.
> 
> Then, in srp_create_target() I've noticed the check of the return value
> of ib_query_gid(). Makes completely sense to check it.
> 
> Please send patches for so obvious fixes to the mailing list! There is a
> very good chance that they get accepted.

Hello Sebastian,

If I hadn't been busy testing scsi-mq patches recently, the SRP
initiator patches you referred to would already have been posted for
review on the linux-rdma mailing list. I hope to find some time one of
the next days to post a few SRP initiator patches on the linux-rdma
mailing list - not only the ones referred to above but also a few other
patches.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
