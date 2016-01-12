From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Reduce mlx5_ib_wq cacheline bouncing
Date: Tue, 12 Jan 2016 16:58:45 +0200
Message-ID: <569514A5.1050705@dev.mellanox.co.il>
References: <1452594732-9573-1-git-send-email-sagig@mellanox.com>
 <5694EEAA.3050600@mellanox.com> <56951130.60802@dev.mellanox.co.il>
 <56951375.1050704@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56951375.1050704-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> I didn't took the time to measure cache hit/miss. I just noticed it
>> a while ago and it's been bugging me for some time so I figured I'd
>> send it out...
>
> The thing is that for data-path changes on high performance network
> drivers, we @ least need to know that the perf is as good as it was
> before the change. So you could run your iser perf IOPS test
> before/after the change and post 1-2 lines with results as part of the
> change-log.

I tested iser perf and it seems to sustain. I didn't see any major
difference but I really don't think block storage iops/latency is not
the correct way to evaluate this change.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
