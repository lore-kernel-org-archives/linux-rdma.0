From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 for-next 5/7] IB/mlx4: Add IB counters table
Date: Thu, 24 Dec 2015 12:34:39 +0200
Message-ID: <567BCA3F.7050502@mellanox.com>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
 <1444909482-17113-6-git-send-email-eranbe@mellanox.com>
 <567BC52B.4030801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567BC52B.4030801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/24/2015 12:12 PM, Sagi Grimberg wrote:
> This patch seems to generate a list corruption [1] when I test
> with Doug's for-4.5 tree. Eran, care to take a look at this? 

This patch is part from a series that was introduced in 4.3-rc1 [1], did 
4.4-rc5/6 worked for you before you uploaded there further patches?

Or.

[1]
fbfb662 IB/mlx4: Add support for blocking multicast loopback QP creation 
user flag
7b59f0f IB/mlx4: Add counter based implementation for QP multicast 
loopback block
3ba8e31 IB/mlx4: Add IB counters table
74194fb net/mlx4_en: Implement mcast loopback prevention for ETH qps
9a89283 net/mlx4_core: Add support for filtering multicast loopback
ddf9529 IB/core: Allow setting create flags in QP init attribute
6d8a749 IB/core: Extend ib_uverbs_create_qp


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
