From: "Shankar, Hari" <Hari.Shankar-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: udaddy test failure; RDMA_CM_EVENT_UNREACHABLE, error: 2
Date: Sun, 22 Mar 2015 22:20:15 +0000
Message-ID: <D1348EAF.EFB3%hari.shankar@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <AB0CC2D1678FAC40AEC2325D668834BD-c5HhxtLuC0z3oGB3hsPCZA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Trying to test UDP with AF_IB family using udaddy binary. However client
is failing with RDMA_CM_EVENT_UNREACHABLE error. Here is the output

Using ConnectX-3 for IB support,

On Server,

./udaddy -b fe80::a0:9800:30:76f4  -f gid -P udp

rdma_bind_addr:848
udaddy: starting server
ucma_getaddrinfo: ret=0
rdma_bind_addr:848
rdma_listen:1543
rdma_get_cm_event:2089

On Client,
 ./udaddy -s fe80::a0:9800:30:76f4  -f gid -P udp

rdma_bind_addr:848
udaddy: starting client
ucma_getaddrinfo: ret=0
udaddy: connecting
rdma_resolve_addr:929
rdma_get_cm_event:2089
rdma_resolve_route:991
rdma_get_cm_event:2089
rdma_create_qp:1415
rdma_create_qp_ex:1351
rdma_connect:1495
rdma_get_cm_event:2089
udaddy: event: RDMA_CM_EVENT_UNREACHABLE, error: 2
test complete
rdma_destroy_qp:1426
return status 2



Running ucmatose with the following works fine,

On Server
./ucmatose -b fe80::a0:9800:30:76f4  -f gid -P ib

On Client
./ucmatose -s fe80::a0:9800:30:76f4  -f gid -P ib

Any suggestions on what I am missing/doing wrong,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
