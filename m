Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283D13B0581;
	Fri, 21 Aug 2026 07:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787298022; cv=none; b=W6CuOcK8Vdy3An0LtAViL8/9awziiTM6EGdVI58XBblu2rOhgFoqohyo1+cJHmji83/qaQ4XDMKKOtDrkHXazsjj3ksoD6pzxnS4cuvmvX4kgCks2NHqkwPk0Cs9qReIqpJfXAcvSwAdKUSrjFlMUqLPsWH+uNcoz0MoIwDL54w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787298022; c=relaxed/simple;
	bh=BIK6FeWGas+vOHc8L+lchqILJVeY4cgbq0l6axetMb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n1Z23CrRFoRIeowq68+YDnCTtWUb8nyrU4NmqUzC75qcdUHiwz6k3Ux4MIjCKnmavFgbtl0XQfKCXzZP0bF1i0H2SxtFeaLQTdlAAjGbsU9nxrGd4DVocFS4ko9aNndYl9Pbt27Ydnj0tnjPWB0VwyMkMlgx+jo72yRfW8kecKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Uws0H671; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Uws0H671"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787298005; h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
	bh=pO5YMZPN5pZKeHNfvKxyxBg1SvNVSdVz7HEdqpp7/L4=;
	b=Uws0H671cJ/pBPsW8bKS0KraUe7NlohgPxxtk6odby/vb1hBLpmO6NbWptLMnPTcyiCHPqPUwMuAuYOaiob4+cOrf3TYHED/vZiNkXkUrjJ0RyjTVk40ec1HYoKF10MOgXP1y5k2S11RfBo11buIHVifRxt3NQ4d595lz3qcfR8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=chuyf26@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X9Lf98I_1787298004;
Received: from x31j07255.sqa.na131(mailfrom:Chuyf26@linux.alibaba.com fp:SMTPD_---0X9Lf98I_1787298004 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Aug 2026 15:40:05 +0800
From: Chuyf26 <Chuyf26@linux.alibaba.com>
To: pabeni@redhat.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.ibm.com, sidraya@linux.ibm.com,
 mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org
Subject: [PATCH v3] net/smc: release the internal TCP sock on IPPROTO_SMC
 socket creation failure
Date: Fri, 21 Aug 2026 15:38:23 +0800
Message-ID: <178729790329.223882.15209084993558811810@linux.alibaba.com>
In-Reply-To: <20260820111229.153086-1-pabeni@redhat.com>
References: <20260813060456.b48HqF9m6NTfFXvq_PL9w_Ih493OogqAqxfAHAfU74A@z>
 <20260820111229.153086-1-pabeni@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

IPPROTO_SMC sockets create an internal TCP sock ("clcsock") from the
proto->init hook. When socket creation fails after proto->init has
run - e.g. a cgroup BPF program attached to BPF_CGROUP_INET_SOCK_CREATE
denies the socket - sk_common_release() only invokes sk_prot->destroy
if it is set, but neither smc_inet_prot nor smc_inet6_prot defines it,
and smc_destruct() returns early unless sk_state is SMC_CLOSED. As a
result, every failing socket(AF_INET, SOCK_STREAM, IPPROTO_SMC) call
leaks one tcp_sock, so an unprivileged task able to attach a deny-all
BPF_CGROUP_INET_SOCK_CREATE program to its own cgroup can grow kernel
memory unboundedly.

Add a .destroy hook to both protos that releases the clcsock via
smc_clcsock_release(). smc_sk_init() hashes the sock into the smc
hashinfo before the clcsock is created, and smc_diag dumps walk that
hash dereferencing smc->clcsock without taking clcsock_release_lock,
while sk_common_release() calls .destroy before .unhash. Unhash the
sock before releasing the clcsock, as __smc_release() does, so a
concurrent dump cannot observe the release; the second unhash in
sk_common_release() is a no-op.

Fixes: d25a92ccae6b ("net/smc: Introduce IPPROTO_SMC")
Reported-by: Abaci <abaci@linux.alibaba.com>
Assisted-by: abaci:qwen3.8-max
Signed-off-by: Chuyf26 <Chuyf26@linux.alibaba.com>
---
Changes since v2 (answering the review):
- dropped the smc->clcsock = NULL store: sk_alloc() zeroes the sock
  (__GFP_ZERO / sk_prot_clear_nulls()), so it is already NULL. The
  mutex concern does not apply either: .destroy only runs after
  smc_sk_init() initialized clcsock_release_lock.
- unhash the sock before releasing the clcsock in .destroy so a
  concurrent smc_diag dump cannot observe the release
  (sk_common_release() calls .destroy before .unhash); the second
  unhash is a no-op. Tested on a KASAN+SMC_DIAG kernel: the v2
  version hits a KASAN report in __smc_diag_dump() when a diag dump
  races with failing IPPROTO_SMC socket creation, v3 stays clean
  under the same stress.

 net/smc/smc_inet.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/smc/smc_inet.c b/net/smc/smc_inet.c
index a94084b4a498..520b666fdd8f 100644
--- a/net/smc/smc_inet.c
+++ b/net/smc/smc_inet.c
@@ -15,13 +15,16 @@
 
 #include "smc_inet.h"
 #include "smc.h"
+#include "smc_close.h"
 
 static int smc_inet_init_sock(struct sock *sk);
+static void smc_inet_destroy_sock(struct sock *sk);
 
 static struct proto smc_inet_prot = {
 	.name		= "INET_SMC",
 	.owner		= THIS_MODULE,
 	.init		= smc_inet_init_sock,
+	.destroy	= smc_inet_destroy_sock,
 	.hash		= smc_hash_sk,
 	.unhash		= smc_unhash_sk,
 	.release_cb	= smc_release_cb,
@@ -68,6 +71,7 @@ static struct proto smc_inet6_prot = {
 	.name		= "INET6_SMC",
 	.owner		= THIS_MODULE,
 	.init		= smc_inet_init_sock,
+	.destroy	= smc_inet_destroy_sock,
 	.hash		= smc_hash_sk,
 	.unhash		= smc_unhash_sk,
 	.release_cb	= smc_release_cb,
@@ -116,6 +120,18 @@ static int smc_inet_init_sock(struct sock *sk)
 	return smc_create_clcsk(net, sk, sk->sk_family);
 }
 
+static void smc_inet_destroy_sock(struct sock *sk)
+{
+	/* The sock is hashed and smc_diag dumps dereference smc->clcsock
+	 * without clcsock_release_lock, while sk_common_release() calls
+	 * .destroy before .unhash. Unhash first, as __smc_release() does,
+	 * so no dump can observe the clcsock being released; the second
+	 * unhash is a no-op.
+	 */
+	sk->sk_prot->unhash(sk);
+	smc_clcsock_release(smc_sk(sk));
+}
+
 int __init smc_inet_init(void)
 {
 	int rc;
-- 
2.43.5
