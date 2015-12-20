From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: RoCE passive side failures on 4.4-rc5
Date: Sun, 20 Dec 2015 09:29:40 +0200
Message-ID: <567658E4.6040508@mellanox.com>
References: <5672BF85.6080005@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5672BF85.6080005-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/17/2015 3:58 PM, Or Gerlitz wrote:
> Using 4.4-rc5+ [1] and **not** applying any of the patches I sent today,
> I noted that RoCE passive side isn't working (rdma-cm, ibv_rc_pingpong 
> works).
>
> I have two nodes in ConnectX3 VPI config (port1 IB and port2 Eth), the 
> one with the 4.4-rc5 kernel can act as both (rping) client/server for 
> IB links but only (rping) client for RoCE.
>
> I tried both inter-node and loopback runs, in all cases, the client 
> side getsCM
> reject with reason 28, see [2], tried both iser and rping. Eth (ICMP, 
> TCP) works OK.

OK, small progress, when the force Eth link type on my IB port (using 
mlx4 sysfs), things work.

You should be able to reproduce it on your non-VPI systems the other way 
around, by
forcing IB link type on one of the Eth ports and see the failure.

I Saw the same behavior with both 4.4-rc2 and 4.4-rc5

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
