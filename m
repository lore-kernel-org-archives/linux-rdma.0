Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792612720;
	b=z5pkggmYRm72RaUJvKhVCggnQkbHZIoIjh+LoYvg/srSqYx108kgIemFonWx38tSL5pe
	 GlaQvslfoyyWJXy4D0TajFsiLgKM0QNmNVCQJJrIxEHvt6pG1kKVEksdKJWin9DYydek8
	 WyZT1tG+RPeLYp4KBCop7q+Qq1S5HKVVt03iBuZrxLt69f8lijqSM5CtZnS6RQqDhTVa8
	 ycWPYgDT+yyjPHkMhD76OMSNeE4r2mrqIhqXWiC4zPnVcK3kMr0PW1/me8mVin/VCQ2zd
	 VpHzkPPT7I082VqsGfx7J7eoRG19XOUvAWqYBXbPdvhGoIX9evjP+lQW+iS8yn3vH1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792612720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2ANWlFn7243wEgpPqvaRA7/S+H16E1sFVY0CGMQuxWE=;
	b=az2X8k2OL4V3p6O8a3AotkfiWGy13LF4ibyTl3iN1/rvXsMqEkKsTpBdpLnpZV5jDTq0
	 eTClC24Z9rKqihPOAQCXN1zHS0JzdvNoF0oOdx1YJevuPpjv2YJJoeYaK3l+SuZng6ity
	 9bi4669ZFwfodlPJqRK16eOKZ9GurISPFoQ/ZX5nAJIqQFHC4BKWiIpnS1n1oIpjUkhW2
	 JZejXdQCVTTI24BIGy+AO+0dVK+jgeeC686sjyLC8ioQqWjesEiVFWJI0x256BTSBiAyx
	 1uUVzLaKHd5ICPiX1hqXrmqeZYQrfjSp73dcmEF8vooBqjlyJhnvyu4CAuqXycR1xVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YnFwDbrb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659E2606A31F;
	Wed, 21 Oct 2026 19:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YnFwDbrb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EB31F000C3;
	Wed, 21 Oct 2026 19:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612720;
	bh=2ANWlFn7243wEgpPqvaRA7/S+H16E1sFVY0CGMQuxWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnFwDbrb+plvxM0xx02TEsmWtJdKb86WcGUrsHUIhbfXZ/h60OD5nHkgQFlh4u/G2
	 pZji1KM9029oGXkGI5Mc5ARVPMYhgAGqwuInoNv8QKooWyGdpAuQ1LroSHWU85Ctjp
	 a1hAvLij+fZqWphhgUm/U03rd7CP72VRVrPvNj8yqG7lSzM131K7jMUlT1izLkdzuw
	 UZeIYhKfLwgg/RWhhCN1bYp8sizDxw4t4IflmnMBL2fyu6PptPXdGbpMviw38xdoXY
	 d27tZ7nrVjD2uwpZ7N/DFO13mPxWHDpNBdur73Iud8+4Abun2CR1omCMOVbS2fZ1JR
	 hJINmO0LvOx/g==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	oleg@redhat.com,
	joel.granados@kernel.org
Subject: [PATCH net 2/2] net/rds: do not initialize transports after rds_init() failed
Date: Wed, 21 Oct 2026 12:58:37 -0700
Message-ID: <20261021195837.142802-3-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261021195837.142802-1-achender@kernel.org>
References: <20261021195837.142802-1-achender@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds, rds_rdma and rds_tcp each have their own module_init().  When they
are built in, those run in link order, so rds_init() goes first, but
do_initcalls() does not stop when it fails.  The transports then
initialize against a core that has already been torn down: rds_wq has
been destroyed, yet rds_ib_dev_put(), rds_ib_unregister_client() and
rds_tcp_accept_work() still queue onto or flush it, and
rds_trans_register() hands the transports to a core whose socket
family may never have been registered.

This was seen with CONFIG_SYSCTL=n, where rds_sysctl_init() failed and
rds_ib_init()'s error path then flushed the freed rds_wq [1], but any
rds_init() failure after rds_threads_init() has the same effect.

Record whether rds_init() succeeded and have rds_rdma_init() and
rds_tcp_init() bail out with -ENODEV otherwise.  Modular builds are
unaffected: the transports need symbols exported by rds.ko, so they
cannot be loaded unless rds_init() succeeded.

[1] https://lore.kernel.org/oe-lkp/202610190310.9737b2e3-lkp@intel.com
Fixes: 55b7ed0b582f ("RDS: Common RDMA transport code")
Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Assisted-by: LLM
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/af_rds.c         | 14 ++++++++++++++
 net/rds/rdma_transport.c |  3 +++
 net/rds/rds.h            |  1 +
 net/rds/tcp.c            |  3 +++
 4 files changed, 21 insertions(+)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index d5defe9172e3..840587c05178 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -922,8 +922,11 @@ static void rds6_sock_info(struct socket *sock, unsigned int len,
 }
 #endif
 
+static bool rds_initialized;
+
 static void rds_exit(void)
 {
+	rds_initialized = false;
 	sock_unregister(rds_family_ops.family);
 	proto_unregister(&rds_proto);
 	rds_conn_exit();
@@ -944,6 +947,16 @@ module_exit(rds_exit);
 
 u32 rds_gen_num;
 
+/* When RDS is built in, a failed rds_init() does not stop the rds_rdma
+ * and rds_tcp initcalls from running against a core that has already
+ * been torn down (rds_wq in particular).  Let them bail out early.
+ */
+bool rds_is_initialized(void)
+{
+	return rds_initialized;
+}
+EXPORT_SYMBOL_GPL(rds_is_initialized);
+
 static int __init rds_init(void)
 {
 	int ret;
@@ -980,6 +993,7 @@ static int __init rds_init(void)
 	rds_info_register_func(RDS6_INFO_SOCKETS, rds6_sock_info);
 	rds_info_register_func(RDS6_INFO_RECV_MESSAGES, rds6_sock_inc_info);
 #endif
+	rds_initialized = true;
 
 	goto out;
 
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 7be38be1228e..cc6a7d29791a 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -325,6 +325,9 @@ static int __init rds_rdma_init(void)
 {
 	int ret;
 
+	if (!rds_is_initialized())
+		return -ENODEV;
+
 	ret = rds_ib_init();
 	if (ret)
 		goto out;
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 2db49573dacd..b7ef7c8b1e03 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -1040,6 +1040,7 @@ extern unsigned int  rds_sysctl_trace_level;
 int rds_threads_init(void);
 void rds_threads_exit(void);
 extern struct workqueue_struct *rds_wq;
+bool rds_is_initialized(void);
 void rds_queue_reconnect(struct rds_conn_path *cp);
 void rds_connect_worker(struct work_struct *);
 void rds_shutdown_worker(struct work_struct *);
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 34815b4f658b..c1ad37505417 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -815,6 +815,9 @@ static int __init rds_tcp_init(void)
 {
 	int ret;
 
+	if (!rds_is_initialized())
+		return -ENODEV;
+
 	rds_tcp_conn_slab = KMEM_CACHE(rds_tcp_connection, 0);
 	if (!rds_tcp_conn_slab) {
 		ret = -ENOMEM;
-- 
2.50.1

