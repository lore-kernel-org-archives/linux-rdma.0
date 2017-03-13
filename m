From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: v4.11-rc2: DMAR: Allocating domain for mlx4_0 failed
Date: Mon, 13 Mar 2017 14:21:13 -0400
Message-ID: <1BCFE3F4-A455-4EFC-845E-1FAAF3902D55@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi-

When I boot v4.11-rc1 or -rc2 on my systems, the CX-3 Pro cards
are no longer plumbed. Booting with v4.10 works as expected.

The below system log messages are typical of the failure.

[    2.449385] mlx4_core 0000:03:00.0: FW version 2.40.5000 (cmd intf rev 3), max commands 16
[    2.449389] mlx4_core 0000:03:00.0: Catastrophic error buffer at 0x1f020, size 0x10, BAR 0
[    2.449392] mlx4_core 0000:03:00.0: Communication vector bar:2 offset:0x800
[    2.449393] mlx4_core 0000:03:00.0: FW size 385 KB
[    2.449396] mlx4_core 0000:03:00.0: Internal clock bar:0 offset:0x78f50
[    2.449397] mlx4_core 0000:03:00.0: Clear int @ f0058, BAR 0
[    2.451629] mlx4_core 0000:03:00.0: Mapped 26 chunks/6168 KB for FW

 ....

[    7.838089] mlx4_core 0000:03:00.0: mlx4_allocate_default_counters: default counter index 0 for port 1
[    7.849428] mlx4_en: Mellanox ConnectX HCA Ethernet driver v2.2-1 (Feb 2014)
[    7.874963] <mlx4_ib> mlx4_ib_add: mlx4_ib: Mellanox ConnectX InfiniBand driver v2.2-1 (Feb 2014)
[    7.875916] <mlx4_ib> mlx4_ib_add: counter index 0 for port 1 allocated 0
[    7.924595] mlx4_core 0000:03:00.0: Mapped 1 chunks/256 KB at 100040000 for ICM
[    7.926363] DMAR: Allocating domain for mlx4_0 failed
[    7.927698] infiniband mlx4_0: Couldn't post receive WRs
[    7.929011] infiniband mlx4_0: Couldn't start port
[    7.951265] infiniband mlx4_0: Couldn't open port 1
[    7.953435] infiniband mlx4_0: ib_register_mad_agent: Invalid port 1
[    7.955576] infiniband mlx4_0: ib_register_mad_agent: Invalid port 1
[    7.957701] infiniband mlx4_0: Port 1 not found
[    7.959813] infiniband mlx4_0: Couldn't close port 1 for agents
[    7.961944] infiniband mlx4_0: Port 1 not found
[    7.963899] infiniband mlx4_0: Couldn't close port 1


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
