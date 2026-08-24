Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5511B355F46;
	Mon, 24 Aug 2026 02:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787538549; cv=none; b=bD0bNVYkFVhbCHxF5/ibQThPuHjNGufO4rw4E2L5GEeK7es01Z+MY56inQ4y7/ZJYnOyUHt9LUHTceit1FJCvwVMT+sIqTl3or59JFO7HPrtCfeTfI5+HJGjJepPI0t2RjDVIpLadlPJvOHmL/R0OiVtg2pCskkQsfdjxPOeoRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787538549; c=relaxed/simple;
	bh=wfhrvztMUc4WC1jtDFqlzkk/W9KNkCIfnC44B1Tk+3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GECcr3gdq6sMyYvLHEtc9DTaGRxqzVzw5UymK6mO54qS+74S8Jr4BiJEPxIP0f0gS+xPLQ9hqGdGJi2H9xSdTFgHmTwLR5+V/dmvV1UpsLVXw9nqpwklmur4vCZcB3HKIwy3UpsviAMeOGe3t7kZ/oi4xXdXmJIG1Aw2Cp6pMo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=M8sxHZ1V; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="M8sxHZ1V"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787538538; h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
	bh=4UXhK0/ZS+/QUhzyQrN4gXQO89r+IvUDRSmnUdprPco=;
	b=M8sxHZ1V+ZHotzmMD2pdXU2qjk3Ryno5ZsIH4NFweLKoEBRcEiGAmpHkKy+FGmymaabrZsBL7PM8sL8fekjn6QCcBC8Ex8KJcfbHFE6/tyIcR+9pZnBuScFtldPl419s7wtNf19uZ2EYtqo/98FSG3evLM8lpwj5QKtfsG4+RrU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=chuyf26@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X9Rf1Qe_1787538536;
Received: from x31j07255.sqa.na131(mailfrom:Chuyf26@linux.alibaba.com fp:SMTPD_---0X9Rf1Qe_1787538536 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 24 Aug 2026 10:28:57 +0800
From: Yifei Chu <Chuyf26@linux.alibaba.com>
To: alibuda@linux.alibaba.com
Cc: dust.li@linux.alibaba.com, sidraya@linux.ibm.com, mjambigi@linux.ibm.com,
 kuba@kernel.org, pabeni@redhat.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org
Subject: [PATCH v4] net/smc: release the internal TCP sock on IPPROTO_SMC
 socket creation failure
Date: Mon, 24 Aug 2026 10:27:19 +0800
Message-ID: <178753843966.342810.566471390946765094@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
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
Signed-off-by: Yifei Chu <Chuyf26@linux.alibaba.com>
---
Changes since v3:
- no code change: use full name in Author and Signed-off-by, resend
  as a new thread instead of a reply, as requested. Previous thread:
  https://lore.kernel.org/all/20260813060456.b48HqF9m6NTfFXvq_PL9w_Ih493OogqA=
qxfAHAfU74A@z/

Changes since v2 (answering the review):
- dropped the smc->clcsock =3D NULL store: sk_alloc() zeroes the sock
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
=20
 #include "smc_inet.h"
 #include "smc.h"
+#include "smc_close.h"
=20
 static int smc_inet_init_sock(struct sock *sk);
+static void smc_inet_destroy_sock(struct sock *sk);
=20
 static struct proto smc_inet_prot =3D {
 	.name		=3D "INET_SMC",
 	.owner		=3D THIS_MODULE,
 	.init		=3D smc_inet_init_sock,
+	.destroy	=3D smc_inet_destroy_sock,
 	.hash		=3D smc_hash_sk,
 	.unhash		=3D smc_unhash_sk,
 	.release_cb	=3D smc_release_cb,
@@ -68,6 +71,7 @@ static struct proto smc_inet6_prot =3D {
 	.name		=3D "INET6_SMC",
 	.owner		=3D THIS_MODULE,
 	.init		=3D smc_inet_init_sock,
+	.destroy	=3D smc_inet_destroy_sock,
 	.hash		=3D smc_hash_sk,
 	.unhash		=3D smc_unhash_sk,
 	.release_cb	=3D smc_release_cb,
@@ -116,6 +120,18 @@ static int smc_inet_init_sock(struct sock *sk)
 	return smc_create_clcsk(net, sk, sk->sk_family);
 }
=20
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
--=20
2.43.5
