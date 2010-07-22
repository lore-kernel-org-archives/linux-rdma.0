From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: Issue with RDMA_CM on systems with multiple IB HCA's.
Date: Thu, 22 Jul 2010 10:15:07 +0300
Message-ID: <4C47EFFB.1040808@Voltaire.com>
References: <Pine.GSO.4.40.1007212046022.17-100000@kappa.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.GSO.4.40.1007212046022.17-100000-ItQMRKI8FOvVp4Hyp30HIZ9NZdITTVap@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hari Subramoni wrote:
> [subramon@amd6 perftest]$ ./ib_rdma_bw -c 172.16.1.5
> 11928: | port=18515 | ib_port=1 | size=65536 | tx_depth=100 | iters=1000 | duplex=0 | cma=1 |
> 11928: Local address:  LID 0000, QPN 000000, PSN 0x5bfbba RKey 0x90042602 VAddr 0x002b27feabe000
> 11928: Remote address: LID 0000, QPN 000000, PSN 0x392fe6, RKey 0xf8042605 VAddr 0x002b9d5c93b000


you can see the lid and qp numbers are zero, something is broken... when you use the rdma-cm, 
the address to be provided to the utility should be on an IPoIB subnet, is that what you're doing?

Basically, I would suggest that you first use rping(1) provided by librdmacm-utils to make 
sure things are working well in your configuration and then move to the perftest utils.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
