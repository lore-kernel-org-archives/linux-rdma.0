From: Dan Coombs <dcoombs-LmJBtNfl/RVO0n7uQEQMm4CZgX+1HZI1@public.gmane.org>
Subject: IWARP Valgrind Issue
Date: Mon, 26 Jun 2017 16:57:02 +0000
Message-ID: <CY4PR19MB12215AF6E7225113294CF8DB8BDF0@CY4PR19MB1221.namprd19.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

I'm getting a valgrind error when using the cxgb4/iw_cxgb4 drivers for a Ch=
elsio IWARP card.

System info:
Distribution:=A0Ubuntu 16.04.2 LTS
Kernel:=A04.4.0-79-generic
Hardware: Chelsio T420-BT
Drivers:
Chelsio T4/T5/T6 Offload Network Driver - version 3.2.0.0=20
Chelsio T420-BT rev 2=20
iw_cxgb4:Chelsio T4/T5/T6 RDMA Driver - version 3.2.0.0 =20


Bug:

Running with=A0sudo valgrind --leak-check=3Dfull --undef-value-errors=3Dno

12,720 bytes in 1 blocks are definitely lost in loss record 146 of 150


Call stack:

ibv_create_cq (verbs.c:328)
c4iw_create_cq (verbs.c:245)
calloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)

Code simply opens the device, creates a completion channel and a completion=
 queue with ibv_create_*, then destroys the completion queue and completion=
 channel with ibv_destroy_*.


Thanks,
Dan =
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
