From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 00/32] Soft-RoCE driver
Date: Sat, 26 Dec 2015 00:03:01 -0800
Message-ID: <1451116981.10148.7.camel@hasee>
References: <1450948698-13383-1-git-send-email-kamalh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450948698-13383-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2015-12-24 at 11:17 +0200, Kamal Heib wrote:
> Doug and list Hi,
> 
> This patchset introduces Soft RoCE driver.

Thanks to submit this driver.
I have been looking for this kind of driver a while to setup a RDMA
environment with 2 virtual machines.

I did a quick test with 2 VMs.

root@vm1:~# rxe_cfg start
tee: /sys/kernel/config/rdma_cm/rxe0/default_roce_mode: Permission denied
IBOE V2
  Name  Link  Driver  Speed  NMTU  IPv4_addr      RDEV  RMTU          
  eth0  yes   8139cp         1500  192.168.122.3  rxe0  1024  (3)

ibv_rc_pingpong works!

root@vm1:~# ibv_rc_pingpong -d rxe0 -g 0
  local address:  LID 0x0000, QPN 0x000011, PSN 0xfb6f08, GID fe80::5054:ff:fe12:3456
  remote address: LID 0x0000, QPN 0x000011, PSN 0xcb2acb, GID fe80::5054:ff:fe5f:8a49
8192000 bytes in 0.66 seconds = 99.94 Mbit/sec
1000 iters in 0.66 seconds = 655.76 usec/iter

root@vm2:~# ibv_rc_pingpong -d rxe0 -g 0 192.168.122.89
  local address:  LID 0x0000, QPN 0x000011, PSN 0xcb2acb, GID fe80::5054:ff:fe5f:8a49
  remote address: LID 0x0000, QPN 0x000011, PSN 0xfb6f08, GID fe80::5054:ff:fe12:3456
8192000 bytes in 0.66 seconds = 99.70 Mbit/sec
1000 iters in 0.66 seconds = 657.32 usec/iter

rping seems works too!

root@vm1:~# rping -s -d
created cm_id 0x1683d20
rdma_bind_addr successful
rdma_listen
cma_event type RDMA_CM_EVENT_CONNECT_REQUEST cma_id 0x1684200 (child)
child cma 0x1684200
created pd 0x16844a0
created channel 0x16844c0
created cq 0x16844e0
created qp 0x1684590
rping_setup_buffers called on cb 0x1683010
allocated & registered buffers...
accepting client connection request
cq_thread started.
cma_event type RDMA_CM_EVENT_ESTABLISHED cma_id 0x1684200 (child)
ESTABLISHED
recv completion
Received rkey 118b addr 22899e0 len 64 from peer
server received sink adv
server posted rdma read req 
rdma read completion
server received read complete
server posted go ahead
send completion
recv completion
Received rkey 1045 addr 2289950 len 64 from peer
server received sink adv
rdma write from lkey d11 laddr 16846d0 len 64
rdma write completion
server rdma write complete 
server posted go ahead
send completion
cma_event type RDMA_CM_EVENT_DISCONNECTED cma_id 0x1684200 (child)
server DISCONNECT EVENT...
wait for RDMA_READ_ADV state 9
rping_free_buffers called on cb 0x1683010
destroy cm_id 0x1683d20

root@vm2:~# rping -c -d -a 192.168.122.89 -C 1
count 1
created cm_id 0x2289200
cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x2289200 (parent)
cma_event type RDMA_CM_EVENT_ROUTE_RESOLVED cma_id 0x2289200 (parent)
rdma_resolve_addr - rdma_resolve_route successful
created pd 0x22896e0
created channel 0x2289700
created cq 0x2289720
created qp 0x22897d0
rping_setup_buffers called on cb 0x2288010
allocated & registered buffers...
cq_thread started.
cma_event type RDMA_CM_EVENT_ESTABLISHED cma_id 0x2289200 (parent)
ESTABLISHED
rmda_connect successful
RDMA addr 22899e0 rkey 118b len 64
send completion
recv completion
RDMA addr 2289950 rkey 1045 len 64
send completion
recv completion
rping_free_buffers called on cb 0x2288010
destroy cm_id 0x2289200



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
