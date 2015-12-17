From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RoCE passive side failures on 4.4-rc5
Date: Thu, 17 Dec 2015 15:58:29 +0200
Message-ID: <5672BF85.6080005@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Guys,

Using 4.4-rc5+ [1] and **not** applying any of the patches I sent today,
I noted that RoCE passive side isn't working (rdma-cm, ibv_rc_pingpong 
works).

I have two nodes in ConnectX3 VPI config (port1 IB and port2 Eth), the 
one with the 4.4-rc5 kernel can act as both (rping) client/server for IB 
links but only (rping) client for RoCE.

I tried both inter-node and loopback runs, in all cases, the client side 
getsCM
reject with reason 28, see [2], tried both iser and rping. Eth (ICMP, 
TCP) works OK.

Or.

[1] Linus tree up to commit a5e90b1 "Merge branch 'fixes' of 
git://ftp.arm.linux.org.uk/~rmk/linux-arm"

[2] $ rping -d -v -c -a 192.168.31.17 -C 1
verbose
client
count 1
created cm_id 0x60cd90
cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x60cd90 (parent)
cma_event type RDMA_CM_EVENT_ROUTE_RESOLVED cma_id 0x60cd90 (parent)
rdma_resolve_addr - rdma_resolve_route successful
created pd 0x60cfe0
created channel 0x608510
created cq 0x607f50
created qp 0x60d000
rping_setup_buffers called on cb 0x606010
allocated & registered buffers...
cq_thread started.
wait for CONNECTED state 10
cma_event type RDMA_CM_EVENT_REJECTED cma_id 0x60cd90 (parent)
connect error -1
rping_free_buffers called on cb 0x606010
cma event RDMA_CM_EVENT_REJECTED, error 28

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
