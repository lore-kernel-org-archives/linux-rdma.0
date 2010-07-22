From: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Issue with RDMA_CM on systems with multiple IB HCA's.
Date: Wed, 21 Jul 2010 20:54:04 -0400 (EDT)
Message-ID: <Pine.GSO.4.40.1007212046022.17-100000@kappa.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

I'm trying to run 'ib_rdma_bw' test (part of the perftest suite) on a
cluster with two IB ConnectX DDR HCA's. The OFED version I'm using is
1.5.1. OpenSM is running on the network and the ports are up and active.
I see that whenever I use RDMA_CM to establish connections, the program
quits with the error given below (the test runs fine if we don't use
RDMA_CM).

I recall seeing a post mentioning some issues with RDMA_CM on systems
with multiple HCA's. I was wondering whether this has been resolved with
the latest OFED.

Any input on this issue would be greatly appreciated. Also, it would be
great if anyone could point me to any open bugs on this issue so that I
can track it's status.

[subramon@amd6 perftest]$ ./ib_rdma_bw -c 172.16.1.5
11928: | port=18515 | ib_port=1 | size=65536 | tx_depth=100 | iters=1000 |
duplex=0 | cma=1 |
11928: Local address:  LID 0000, QPN 000000, PSN 0x5bfbba RKey 0x90042602
VAddr 0x002b27feabe000
11928: Remote address: LID 0000, QPN 000000, PSN 0x392fe6, RKey 0xf8042605
VAddr 0x002b9d5c93b000

11928:pp_send_start: bad wc status 12
11928:main: Completion with error at client:
11928:main: Failed status 5: wr_id 3
11928:main: scnt=100, ccnt=0

Thanks in advance,
Hari.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
