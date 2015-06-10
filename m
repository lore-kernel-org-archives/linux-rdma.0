From: Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Subject: rdmacm issue
Date: Tue, 9 Jun 2015 18:52:43 -0700
Message-ID: <5577986B.7070702@nasa.gov>
Reply-To: <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have an issue where lustre servers and clients cannot talk to each other.
There are about 11,000 clients all trying to connect to a server that just been rebooted
(nbp6-oss3 in this example)

pfe21 is a lustre client thats trying to remount the filesystem from nbp6-oss3.

running rping server on pfe21 hangs and waits until the client tried to connect, then it prints out
debug information up to cq_thread started. and hangs there, for a minute or so until issuing the two UNREACHABLE errors:

pfe21 ~ # rping -v -s -d -P -p2 -a 10.151.27.19
port 2
created cm_id 0x60e350
rdma_bind_addr successful
rdma_listen
cma_event type RDMA_CM_EVENT_CONNECT_REQUEST cma_id 0x60b620 (child)
child cma 0x60b620
created pd 0x60bd80
created channel 0x60bda0
created cq 0x60bdc0
created qp 0x60bf00
rping_setup_buffers called on cb 0x60b8c0
allocated & registered buffers...
accepting client connection request
cq_thread started.
cma_event type RDMA_CM_EVENT_UNREACHABLE cma_id 0x60b620 (child)
cma event RDMA_CM_EVENT_UNREACHABLE, error -110


The rping client is started below. As soon as it starts, it runs up to the point
of cq_thread started. Hangs there and eventually times out as well, issuing 4 error
messages:

nbp6-oss3 ~ # rping -c -vp-d -S 30 -p 2 -a 10.151.27.19
size 30
port 2
created cm_id 0x60f640
cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x60f640 (parent)
cma_event type RDMA_CM_EVENT_ROUTE_RESOLVED cma_id 0x60f640 (parent)
rdma_resolve_addr - rdma_resolve_route successful
created pd 0x60ab10
created channel 0x60ab30
created cq 0x60ab50
created qp 0x60ac60
rping_setup_buffers called on cb 0x6072e0
allocated & registered buffers...
cq_thread started.
cma_event type RDMA_CM_EVENT_UNREACHABLE cma_id 0x60f640 (parent)
cma event RDMA_CM_EVENT_UNREACHABLE, error -110
wait for CONNECTED state 4
connect error -1


Any ideas? The neighbor entries on both side were in a reachable state before the test. And the two systems did manage to find one another. Keep in mind that when this
is going on, 11,000+ clients are trying to connect to nbp6-oss3

Normally lustre mounts fine and rping have no issues. We have noticed some neighbor resolution issues and are considering ucast_solicit, mcast_solicit, and unres_qlen changes
because we also occationally experience issues with icmp ping. Its typically been the experience that changing these configs have little effect.  Yes its probably the case that
unicast arp refresh has long failed and 11,000+ clients may be multicasting for
for arp.

Any help or insight greatly appreciated.

thx, bob



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
