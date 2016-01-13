From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Reduce mlx5_ib_wq cacheline bouncing
Date: Wed, 13 Jan 2016 10:55:27 +0200
Message-ID: <569610FF.4080200@mellanox.com>
References: <1452594732-9573-1-git-send-email-sagig@mellanox.com>
 <5694EEAA.3050600@mellanox.com> <56951130.60802@dev.mellanox.co.il>
 <56951375.1050704@mellanox.com> <569514A5.1050705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569514A5.1050705-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/12/2016 4:58 PM, Sagi Grimberg wrote:
> I tested iser perf and it seems to sustain. 

That's good. I also think we should move fwd with the patch once the 
review is passed OKay, even if we don't have the means to evaluate  the 
gain, future will tell.

> I didn't see any major difference but I really don't think block 
> storage iops/latency is not the correct way to evaluate this change. 

yes... pktgen doesn't work for IPoIB (if it was, we could use 64B UDP 
packets w.o csum to see the impact) maybe RDS (rds-stress tool) has more 
ops/sec then conventional block rdma driver?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
