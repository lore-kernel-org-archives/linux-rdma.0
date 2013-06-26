From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH for-next 0/8] Add Mellanox mlx5 driver for Connect-IB
 devices
Date: Tue, 25 Jun 2013 17:14:21 -0700 (PDT)
Message-ID: <20130625.171421.1810028558109575694.davem@davemloft.net>
References: <1371384149-24558-1-git-send-email-eli@dev.mellanox.co.il>
	<51C31561.3040507@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C31561.3040507-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 20 Jun 2013 17:44:49 +0300

> So we skipped netdev in V0, in an attempt to reduce cross
> postings... anyway, the mlx5_core driver is similar story as of
> mlx4_core. So, if looking forward, for the initial merge to be
> simpler, are you OK for both the core and IB driver to go through
> Roland's tree?

I'd like to see it posted to netdev for review before making any
kind of decision like that.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
