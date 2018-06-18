From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] infiniband: i40iw, nes: don't use wall time for TCP sequence numbers
Date: Mon, 18 Jun 2018 16:44:17 +0200
Message-ID: <20180618144443.137068-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, netdev@vger.kernel.org, Henry Orosco <henry.orosco@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Jia-Ju Bai <baijiaju1990@gmail.com>, Yuval Shaia <yuval.shaia@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The nes infiniband driver uses current_kernel_time() to get a nanosecond
granunarity timestamp to initialize its tcp sequence counters. This is
one of only a few remaining users of that deprecated function, so we
should try to get rid of it.

Aside from using a deprecated API, there are several problems I see here:

- Using a CLOCK_REALTIME based time source makes it predictable in
  case the time base is synchronized.
- Using a coarse timestamp means it only gets updated once per jiffie,
  making it even more predictable in order to avoid having to access
  the hardware clock source
- The upper 2 bits are always zero because the nanoseconds are at most
  999999999.

For the Linux TCP implementation, we use secure_tcp_seq(), which appears
to be appropriate here as well, and solves all the above problems.

I'm doing the same change in both versions of the nes driver, with
i40iw being a later copy of the same code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
The above change is just a guess at what it should look like,
please review carefully and Ack/Nak as appropriate.
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 8 +++++---
 drivers/infiniband/hw/nes/nes_cm.c     | 8 +++++---
 net/core/secure_seq.c                  | 1 +
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 7b2655128b9f..da221d07f2dd 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -57,6 +57,7 @@
 #include <net/addrconf.h>
 #include <net/ip6_route.h>
 #include <net/ip_fib.h>
+#include <net/secure_seq.h>
 #include <net/tcp.h>
 #include <asm/checksum.h>
 
@@ -2164,7 +2165,6 @@ static struct i40iw_cm_node *i40iw_make_cm_node(
 				   struct i40iw_cm_listener *listener)
 {
 	struct i40iw_cm_node *cm_node;
-	struct timespec ts;
 	int oldarpindex;
 	int arpindex;
 	struct net_device *netdev = iwdev->netdev;
@@ -2214,8 +2214,10 @@ static struct i40iw_cm_node *i40iw_make_cm_node(
 	cm_node->tcp_cntxt.rcv_wscale = I40IW_CM_DEFAULT_RCV_WND_SCALE;
 	cm_node->tcp_cntxt.rcv_wnd =
 			I40IW_CM_DEFAULT_RCV_WND_SCALED >> I40IW_CM_DEFAULT_RCV_WND_SCALE;
-	ts = current_kernel_time();
-	cm_node->tcp_cntxt.loc_seq_num = ts.tv_nsec;
+	cm_node->tcp_cntxt.loc_seq_num = secure_tcp_seq(htonl(cm_node->loc_addr[0]),
+							htonl(cm_node->rem_addr[0]),
+							htons(cm_node->loc_port),
+							htons(cm_node->rem_port));
 	cm_node->tcp_cntxt.mss = (cm_node->ipv4) ? (iwdev->vsi.mtu - I40IW_MTU_TO_MSS_IPV4) :
 				 (iwdev->vsi.mtu - I40IW_MTU_TO_MSS_IPV6);
 
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 6cdfbf8c5674..2b67ace5b614 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -58,6 +58,7 @@
 #include <net/neighbour.h>
 #include <net/route.h>
 #include <net/ip_fib.h>
+#include <net/secure_seq.h>
 #include <net/tcp.h>
 #include <linux/fcntl.h>
 
@@ -1445,7 +1446,6 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 					struct nes_cm_listener *listener)
 {
 	struct nes_cm_node *cm_node;
-	struct timespec ts;
 	int oldarpindex = 0;
 	int arpindex = 0;
 	struct nes_device *nesdev;
@@ -1496,8 +1496,10 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	cm_node->tcp_cntxt.rcv_wscale = NES_CM_DEFAULT_RCV_WND_SCALE;
 	cm_node->tcp_cntxt.rcv_wnd = NES_CM_DEFAULT_RCV_WND_SCALED >>
 				     NES_CM_DEFAULT_RCV_WND_SCALE;
-	ts = current_kernel_time();
-	cm_node->tcp_cntxt.loc_seq_num = htonl(ts.tv_nsec);
+	cm_node->tcp_cntxt.loc_seq_num = secure_tcp_seq(htonl(cm_node->loc_addr),
+							htonl(cm_node->rem_addr),
+							htons(cm_node->loc_port),
+							htons(cm_node->rem_port));
 	cm_node->tcp_cntxt.mss = nesvnic->max_frame_size - sizeof(struct iphdr) -
 				 sizeof(struct tcphdr) - ETH_HLEN - VLAN_HLEN;
 	cm_node->tcp_cntxt.rcv_nxt = 0;
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 7232274de334..af6ad467ed61 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -140,6 +140,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 			    &net_secret);
 	return seq_scale(hash);
 }
+EXPORT_SYMBOL_GPL(secure_tcp_seq);
 
 u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
-- 
2.9.0
