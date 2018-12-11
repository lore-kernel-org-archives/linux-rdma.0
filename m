From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v2 6/8] socket: Add SO_TIMESTAMP[NS]_NEW
Date: Tue, 11 Dec 2018 12:25:18 -0800
Message-ID: <20181211202520.16799-7-deepa.kernel@gmail.com>
References: <20181211202520.16799-1-deepa.kernel@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181211202520.16799-1-deepa.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org, jejb@parisc-linux.org, ralf@linux-mips.org, rth@twiddle.net, linux-alpha@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linux-rdma@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Add SO_TIMESTAMP_NEW and SO_TIMESTAMPNS_NEW variants of
socket timestamp options.
These are the y2038 safe versions of the SO_TIMESTAMP_OLD
and SO_TIMESTAMPNS_OLD for all architectures.

Note that the format of scm_timestamping.ts[0] is not changed
in this patch.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: jejb@parisc-linux.org
Cc: ralf@linux-mips.org
Cc: rth@twiddle.net
Cc: linux-alpha@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-parisc@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: sparclinux@vger.kernel.org
---
 arch/alpha/include/uapi/asm/socket.h  | 15 ++++++-
 arch/mips/include/uapi/asm/socket.h   | 14 ++++++-
 arch/parisc/include/uapi/asm/socket.h | 14 ++++++-
 arch/sparc/include/uapi/asm/socket.h  | 14 ++++++-
 include/linux/skbuff.h                | 18 +++++++++
 include/net/sock.h                    |  1 +
 include/uapi/asm-generic/socket.h     | 15 ++++++-
 net/core/sock.c                       | 51 ++++++++++++++++++------
 net/ipv4/tcp.c                        | 57 +++++++++++++++++++--------
 net/rds/af_rds.c                      |  8 +++-
 net/rds/recv.c                        | 16 +++++++-
 net/socket.c                          | 47 ++++++++++++++++------
 12 files changed, 216 insertions(+), 54 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 00e45c80e574..352e3dc0b3d9 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -3,6 +3,7 @@
 #define _UAPI_ASM_SOCKET_H
 
 #include <asm/sockios.h>
+#include <asm/bitsperlong.h>
 
 /* For setsockopt(2) */
 /*
@@ -110,12 +111,22 @@
 
 #define SO_TIMESTAMP_OLD         29
 #define SO_TIMESTAMPNS_OLD       35
+
 #define SO_TIMESTAMPING_OLD      37
 
+#define SO_TIMESTAMP_NEW         62
+#define SO_TIMESTAMPNS_NEW       63
+
 #if !defined(__KERNEL__)
 
-#define SO_TIMESTAMP           SO_TIMESTAMP_OLD
-#define SO_TIMESTAMPNS         SO_TIMESTAMPNS_OLD
+#if __BITS_PER_LONG == 64
+#define SO_TIMESTAMP		SO_TIMESTAMP_OLD
+#define SO_TIMESTAMPNS		SO_TIMESTAMPNS_OLD
+#else
+#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
+#define SO_TIMESTAMPNS (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMPNS_OLD : SO_TIMESTAMPNS_NEW)
+#endif
+
 #define SO_TIMESTAMPING        SO_TIMESTAMPING_OLD
 
 #define SCM_TIMESTAMP          SO_TIMESTAMP
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index b9553f770346..d1752e3f1248 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -11,6 +11,7 @@
 #define _UAPI_ASM_SOCKET_H
 
 #include <asm/sockios.h>
+#include <asm/bitsperlong.h>
 
 /*
  * For setsockopt(2)
@@ -123,10 +124,19 @@
 #define SO_TIMESTAMPNS_OLD       35
 #define SO_TIMESTAMPING_OLD      37
 
+#define SO_TIMESTAMP_NEW         62
+#define SO_TIMESTAMPNS_NEW       63
+
 #if !defined(__KERNEL__)
 
-#define SO_TIMESTAMP           SO_TIMESTAMP_OLD
-#define SO_TIMESTAMPNS         SO_TIMESTAMPNS_OLD
+#if __BITS_PER_LONG == 64
+#define SO_TIMESTAMP		SO_TIMESTAMP_OLD
+#define SO_TIMESTAMPNS		SO_TIMESTAMPNS_OLD
+#else
+#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
+#define SO_TIMESTAMPNS (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMPNS_OLD : SO_TIMESTAMPNS_NEW)
+#endif
+
 #define SO_TIMESTAMPING        SO_TIMESTAMPING_OLD
 
 #define SCM_TIMESTAMP          SO_TIMESTAMP
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 37cdfe64bb27..0a45b668abd1 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -3,6 +3,7 @@
 #define _UAPI_ASM_SOCKET_H
 
 #include <asm/sockios.h>
+#include <asm/bitsperlong.h>
 
 /* For setsockopt(2) */
 #define SOL_SOCKET	0xffff
@@ -104,10 +105,19 @@
 #define SO_TIMESTAMPNS_OLD       0x4013
 #define SO_TIMESTAMPING_OLD      0x4020
 
+#define SO_TIMESTAMP_NEW         0x4037
+#define SO_TIMESTAMPNS_NEW       0x4038
+
 #if !defined(__KERNEL__)
 
-#define SO_TIMESTAMP           SO_TIMESTAMP_OLD
-#define SO_TIMESTAMPNS         SO_TIMESTAMPNS_OLD
+#if __BITS_PER_LONG == 64
+#define SO_TIMESTAMP		SO_TIMESTAMP_OLD
+#define SO_TIMESTAMPNS		SO_TIMESTAMPNS_OLD
+#else
+#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
+#define SO_TIMESTAMPNS (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMPNS_OLD : SO_TIMESTAMPNS_NEW)
+#endif
+
 #define SO_TIMESTAMPING        SO_TIMESTAMPING_OLD
 
 #define SCM_TIMESTAMP          SO_TIMESTAMP
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index ca573641fc6c..dc8527cae5a7 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -3,6 +3,7 @@
 #define _ASM_SOCKET_H
 
 #include <asm/sockios.h>
+#include <asm/bitsperlong.h>
 
 /* For setsockopt(2) */
 #define SOL_SOCKET	0xffff
@@ -105,10 +106,19 @@
 #define SO_TIMESTAMPNS_OLD       0x0021
 #define SO_TIMESTAMPING_OLD      0x0023
 
+#define SO_TIMESTAMP_NEW         0x0040
+#define SO_TIMESTAMPNS_NEW       0x0041
+
 #if !defined(__KERNEL__)
 
-#define SO_TIMESTAMP           SO_TIMESTAMP_OLD
-#define SO_TIMESTAMPNS         SO_TIMESTAMPNS_OLD
+#if __BITS_PER_LONG == 64
+#define SO_TIMESTAMP		SO_TIMESTAMP_OLD
+#define SO_TIMESTAMPNS		SO_TIMESTAMPNS_OLD
+#else
+#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
+#define SO_TIMESTAMPNS (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMPNS_OLD : SO_TIMESTAMPNS_NEW)
+#endif
+
 #define SO_TIMESTAMPING        SO_TIMESTAMPING_OLD
 
 #define SCM_TIMESTAMP          SO_TIMESTAMP
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e2dc01330cb1..1d583c3e7f89 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3465,12 +3465,30 @@ static inline void skb_get_timestamp(const struct sk_buff *skb,
 	*stamp = ns_to_kernel_old_timeval(skb->tstamp);
 }
 
+static inline void skb_get_new_timestamp(const struct sk_buff *skb,
+					 struct __kernel_sock_timeval *stamp)
+{
+	struct timespec64 ts = ktime_to_timespec64(skb->tstamp);
+
+	stamp->tv_sec = ts.tv_sec;
+	stamp->tv_usec = ts.tv_nsec / 1000;
+}
+
 static inline void skb_get_timestampns(const struct sk_buff *skb,
 				       struct timespec *stamp)
 {
 	*stamp = ktime_to_timespec(skb->tstamp);
 }
 
+static inline void skb_get_new_timestampns(const struct sk_buff *skb,
+					   struct __kernel_timespec *stamp)
+{
+	struct timespec64 ts = ktime_to_timespec64(skb->tstamp);
+
+	stamp->tv_sec = ts.tv_sec;
+	stamp->tv_nsec = ts.tv_nsec;
+}
+
 static inline void __net_timestamp(struct sk_buff *skb)
 {
 	skb->tstamp = ktime_get_real();
diff --git a/include/net/sock.h b/include/net/sock.h
index f665d74ae509..3c666a12cf6c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -801,6 +801,7 @@ enum sock_flags {
 	SOCK_RCU_FREE, /* wait rcu grace period in sk_destruct() */
 	SOCK_TXTIME,
 	SOCK_XDP, /* XDP is attached */
+	SOCK_TSTAMP_NEW, /* Indicates 64 bit timestamps always */
 };
 
 #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index dc704e41203d..0b0fae6b57a9 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -3,6 +3,7 @@
 #define __ASM_GENERIC_SOCKET_H
 
 #include <asm/sockios.h>
+#include <asm/bitsperlong.h>
 
 /* For setsockopt(2) */
 #define SOL_SOCKET	1
@@ -107,10 +108,20 @@
 #define SO_TIMESTAMPNS_OLD       35
 #define SO_TIMESTAMPING_OLD      37
 
+#define SO_TIMESTAMP_NEW         62
+#define SO_TIMESTAMPNS_NEW       63
+
 #if !defined(__KERNEL__)
 
-#define SO_TIMESTAMP           SO_TIMESTAMP_OLD
-#define SO_TIMESTAMPNS         SO_TIMESTAMPNS_OLD
+#if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
+/* on 64-bit and x32, avoid the ?: operator */
+#define SO_TIMESTAMP		SO_TIMESTAMP_OLD
+#define SO_TIMESTAMPNS		SO_TIMESTAMPNS_OLD
+#else
+#define SO_TIMESTAMP (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMP_OLD : SO_TIMESTAMP_NEW)
+#define SO_TIMESTAMPNS (sizeof(time_t) == sizeof(__kernel_long_t) ? SO_TIMESTAMPNS_OLD : SO_TIMESTAMPNS_NEW)
+#endif
+
 #define SO_TIMESTAMPING        SO_TIMESTAMPING_OLD
 
 #define SCM_TIMESTAMP          SO_TIMESTAMP
diff --git a/net/core/sock.c b/net/core/sock.c
index cf990db9b2a0..1f4db404782c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -647,6 +647,35 @@ bool sk_mc_loop(struct sock *sk)
 }
 EXPORT_SYMBOL(sk_mc_loop);
 
+static void setsockopt_timestamp(struct sock *sk, int type, int val)
+{
+	if (!val) {
+		sock_reset_flag(sk, SOCK_RCVTSTAMP);
+		sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
+		sock_reset_flag(sk, SOCK_TSTAMP_NEW);
+		return;
+	}
+
+	if (type == SO_TIMESTAMP_NEW || type == SO_TIMESTAMPNS_NEW)
+		sock_set_flag(sk, SOCK_TSTAMP_NEW);
+	else
+		sock_reset_flag(sk, SOCK_TSTAMP_NEW);
+
+	switch (type) {
+	case SO_TIMESTAMP_OLD:
+	case SO_TIMESTAMP_NEW:
+		sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
+		break;
+	case SO_TIMESTAMPNS_OLD:
+	case SO_TIMESTAMPNS_NEW:
+		sock_set_flag(sk, SOCK_RCVTSTAMPNS);
+		break;
+	}
+
+	sock_set_flag(sk, SOCK_RCVTSTAMP);
+	sock_enable_timestamp(sk, SOCK_TIMESTAMP);
+}
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
@@ -815,18 +844,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_TIMESTAMP_OLD:
+	case SO_TIMESTAMP_NEW:
 	case SO_TIMESTAMPNS_OLD:
-		if (valbool)  {
-			if (optname == SO_TIMESTAMP_OLD)
-				sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-			else
-				sock_set_flag(sk, SOCK_RCVTSTAMPNS);
-			sock_set_flag(sk, SOCK_RCVTSTAMP);
-			sock_enable_timestamp(sk, SOCK_TIMESTAMP);
-		} else {
-			sock_reset_flag(sk, SOCK_RCVTSTAMP);
-			sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-		}
+	case SO_TIMESTAMPNS_NEW:
+		setsockopt_timestamp(sk, optname, valbool);
 		break;
 
 	case SO_TIMESTAMPING_OLD:
@@ -1191,6 +1212,14 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sock_flag(sk, SOCK_RCVTSTAMPNS);
 		break;
 
+	case SO_TIMESTAMP_NEW:
+		v.val = sock_flag(sk, SOCK_RCVTSTAMP) && sock_flag(sk, SOCK_TSTAMP_NEW);
+		break;
+
+	case SO_TIMESTAMPNS_NEW:
+		v.val = sock_flag(sk, SOCK_RCVTSTAMPNS) && sock_flag(sk, SOCK_TSTAMP_NEW);
+		break;
+
 	case SO_TIMESTAMPING_OLD:
 		v.val = sk->sk_tsflags;
 		break;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5a86ce0bdf32..73e1628a3946 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1860,32 +1860,57 @@ static void tcp_update_recv_tstamps(struct sk_buff *skb,
 		tss->ts[2] = (struct timespec) {0};
 }
 
-/* Similar to __sock_recv_timestamp, but does not require an skb */
-static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
-			       struct scm_timestamping *tss)
+static void tcp_recv_sw_timestamp(struct msghdr *msg, const struct sock *sk, struct timespec64 *ts)
 {
-	struct __kernel_old_timeval tv;
-	bool has_timestamping = false;
+	int new_tstamp = sock_flag(sk, SOCK_TSTAMP_NEW);
+
+	if (ts->tv_sec || ts->tv_nsec) {
+		if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
+			if (new_tstamp) {
+				struct __kernel_timespec kts = {ts->tv_sec, ts->tv_nsec};
+
+				put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
+					 sizeof(kts), &kts);
+			} else {
+				struct timespec ts_old = timespec64_to_timespec(*ts);
 
-	if (tss->ts[0].tv_sec || tss->ts[0].tv_nsec) {
-		if (sock_flag(sk, SOCK_RCVTSTAMP)) {
-			if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
 				put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
-					 sizeof(tss->ts[0]), &tss->ts[0]);
+					 sizeof(ts), &ts_old);
+			}
+		} else if (sock_flag(sk, SOCK_RCVTSTAMP)) {
+			if (new_tstamp) {
+				struct __kernel_sock_timeval stv;
+
+				stv.tv_sec = ts->tv_sec;
+				stv.tv_usec = ts->tv_nsec / 1000;
+
+				put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_NEW,
+					 sizeof(stv), &stv);
 			} else {
-				tv.tv_sec = tss->ts[0].tv_sec;
-				tv.tv_usec = tss->ts[0].tv_nsec / 1000;
+				struct __kernel_old_timeval tv;
 
+				tv.tv_sec = ts->tv_sec;
+				tv.tv_usec = ts->tv_nsec / 1000;
 				put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
 					 sizeof(tv), &tv);
 			}
 		}
-
-		if (sk->sk_tsflags & SOF_TIMESTAMPING_SOFTWARE)
-			has_timestamping = true;
-		else
-			tss->ts[0] = (struct timespec) {0};
 	}
+}
+
+/* Similar to __sock_recv_timestamp, but does not require an skb */
+static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
+			       struct scm_timestamping *tss)
+{
+	bool has_timestamping = false;
+	struct timespec64 ts = timespec_to_timespec64(tss->ts[0]);
+
+	tcp_recv_sw_timestamp(msg, sk, &ts);
+
+	if (sk->sk_tsflags & SOF_TIMESTAMPING_SOFTWARE)
+		has_timestamping = true;
+	else
+		tss->ts[0] = (struct timespec) {0};
 
 	if (tss->ts[2].tv_sec || tss->ts[2].tv_nsec) {
 		if (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE)
diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index eeb4639adbe5..65571a6273c3 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -348,7 +348,7 @@ static int rds_set_transport(struct rds_sock *rs, char __user *optval,
 }
 
 static int rds_enable_recvtstamp(struct sock *sk, char __user *optval,
-				 int optlen)
+				 int optlen, int optname)
 {
 	int val, valbool;
 
@@ -360,6 +360,9 @@ static int rds_enable_recvtstamp(struct sock *sk, char __user *optval,
 
 	valbool = val ? 1 : 0;
 
+	if (optname == SO_TIMESTAMP_NEW)
+		sock_set_flag(sk, SOCK_TSTAMP_NEW);
+
 	if (valbool)
 		sock_set_flag(sk, SOCK_RCVTSTAMP);
 	else
@@ -431,8 +434,9 @@ static int rds_setsockopt(struct socket *sock, int level, int optname,
 		release_sock(sock->sk);
 		break;
 	case SO_TIMESTAMP_OLD:
+	case SO_TIMESTAMP_NEW:
 		lock_sock(sock->sk);
-		ret = rds_enable_recvtstamp(sock->sk, optval, optlen);
+		ret = rds_enable_recvtstamp(sock->sk, optval, optlen, optname);
 		release_sock(sock->sk);
 		break;
 	case SO_RDS_MSG_RXPATH_LATENCY:
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 435bf2320cd3..6bb6b16ca270 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -550,8 +550,20 @@ static int rds_cmsg_recv(struct rds_incoming *inc, struct msghdr *msg,
 	if ((inc->i_rx_tstamp != 0) &&
 	    sock_flag(rds_rs_to_sk(rs), SOCK_RCVTSTAMP)) {
 		struct __kernel_old_timeval tv = ns_to_kernel_old_timeval(inc->i_rx_tstamp);
-		ret = put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
-			       sizeof(tv), &tv);
+
+		if (!sock_flag(rds_rs_to_sk(rs), SOCK_TSTAMP_NEW)) {
+			ret = put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
+				       sizeof(tv), &tv);
+		} else {
+			struct __kernel_sock_timeval sk_tv;
+
+			sk_tv.tv_sec = tv.tv_sec;
+			sk_tv.tv_usec = tv.tv_usec;
+
+			ret = put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_NEW,
+				       sizeof(sk_tv), &sk_tv);
+		}
+
 		if (ret)
 			goto out;
 	}
diff --git a/net/socket.c b/net/socket.c
index c92f0e97ae58..96fe831b79ad 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -699,6 +699,38 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
 		 sizeof(ts_pktinfo), &ts_pktinfo);
 }
 
+static void sock_recv_sw_timestamp(struct msghdr *msg, struct sock *sk,
+				   struct sk_buff *skb)
+{
+	if (sock_flag(sk, SOCK_TSTAMP_NEW)) {
+		if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
+			struct __kernel_sock_timeval tv;
+
+			skb_get_new_timestamp(skb, &tv);
+			put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_NEW,
+				 sizeof(tv), &tv);
+		} else {
+			struct __kernel_timespec ts;
+
+			skb_get_new_timestampns(skb, &ts);
+			put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
+				 sizeof(ts), &ts);
+		}
+	}
+	if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
+		struct __kernel_old_timeval tv;
+
+		skb_get_timestamp(skb, &tv);
+		put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
+			 sizeof(tv), &tv);
+	} else {
+		struct timespec ts;
+
+		skb_get_timestampns(skb, &ts);
+		put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
+			 sizeof(ts), &ts);
+	}
+}
 /*
  * called from sock_recv_timestamp() if sock_flag(sk, SOCK_RCVTSTAMP)
  */
@@ -718,19 +750,8 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 		false_tstamp = 1;
 	}
 
-	if (need_software_tstamp) {
-		if (!sock_flag(sk, SOCK_RCVTSTAMPNS)) {
-			struct __kernel_old_timeval tv;
-			skb_get_timestamp(skb, &tv);
-			put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
-				 sizeof(tv), &tv);
-		} else {
-			struct timespec ts;
-			skb_get_timestampns(skb, &ts);
-			put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
-				 sizeof(ts), &ts);
-		}
-	}
+	if (need_software_tstamp)
+		sock_recv_sw_timestamp(msg, sk, skb);
 
 	memset(&tss, 0, sizeof(tss));
 	if ((sk->sk_tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
-- 
2.17.1
