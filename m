From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: IB/srp: merge fixes from MLNX_OFED
Date: Tue, 18 Feb 2014 17:47:15 +0100
Message-ID: <53038E93.7050706@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

is that "/mswg/git/mlnx_ofed/mlnx-ofed-2.x-kernel.git" tree from the
MLNX_OFED public by any chance?

There are fixes included relevant for the mainline. Would be strange if
I would send the patches as somebody at Mellanox discovered and fixed
the issues.

I've hit a kernel panic today during testing caused by the loop around
ib_fmr_pool_unmap(). The loop has been fixed in MLNX_OFED. So there
should be a patch sent for it to the linux-rdma mailing list.

I've also noticed the added target locking around target->free_tx
handling in srp_rport_reconnect(). There are cases e.g. in
srp_queuecommand() where holding the rport mutex isn't enough to protect
it. So for me this looks right.

Then, in srp_create_target() I've noticed the check of the return value
of ib_query_gid(). Makes completely sense to check it.

Please send patches for so obvious fixes to the mailing list! There is a
very good chance that they get accepted.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
