From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Old SDR IB HBA
Date: Wed, 16 May 2012 16:43:51 +0300
Message-ID: <4FB3AF17.2060902@mellanox.com>
References: <d004e56b0a274ba55134840a93060de4@omrb.pnpi.spb.ru> <CAJZOPZL0MuNnjP8=CyQqL+GC7RDyMGTt_ng+iYbFDOpdrv3ZWA@mail.gmail.com> <a5e77072fa7ebef170d9558adaac4ca8@omrb.pnpi.spb.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a5e77072fa7ebef170d9558adaac4ca8-heEE5zn7HfaV8fSEjHp0FA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Shvetsov <alexxy-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/15/2012 10:31 PM, Alexey Shvetsov wrote:
> Affected kernel version 3.3
>

yep, there's a bug in the IB core sysfs code which is fixed in 3.4 that 
can cause that 8.5Gbs to be displayed...
The bug was introduced in 3.2 or 3.3 and fixed in 3.4, see commit 
e9319b0cb00d4d68792fdae37e81e316cb632cb9 "IB/core: Fix SDR rates in 
sysfs" and some later commits to that file

Or.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
