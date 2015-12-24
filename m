From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 for-next 5/7] IB/mlx4: Add IB counters table
Date: Thu, 24 Dec 2015 12:30:26 +0200
Message-ID: <567BC942.6010603@dev.mellanox.co.il>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
 <1444909482-17113-6-git-send-email-eranbe@mellanox.com>
 <567BC52B.4030801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567BC52B.4030801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

I'm also can't load mlx5 drivers in your tree [1] but
I don't know where it's from, it can come from pretty much everything...

Now I'm left with no useable HW to test with :(


[1]:
mlx5_core 0000:06:00.0: firmware version: 12.14.74
mlx5_core 0000:06:00.1: firmware version: 12.14.74
mlx5_ib: Mellanox Connect-IB Infiniband driver v2.2-1 (Feb 2014)
command failed, status bad parameter(0x3), syndrome 0x7424da
command failed, status bad parameter(0x3), syndrome 0x7424da
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
