Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2E64D1789;
	Thu, 17 Sep 2026 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663206; cv=none; b=EGGgj7+knmt+BJIGQ5sEl47763g/Q0stfIm4DimJtYTkCK4kFKTTKyabKVh7Ns7XlXgrt4/YgThsRecDvvXr6n6/y8qlikJmpNQq1EjAjmsZI+p2ZMP9lJ/yujH186hBIntCI/wiAuH2+GgEE7sN6WgWxc+J+ZreTL19S87TGH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663206; c=relaxed/simple;
	bh=z2M5maiT2WCx5mP6DoUrxCg3RRCltBcb2kG2YlhRQAw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bpG7sB7RJX1hHaAGHidh2TVpWC2tII+6s559Awlq90ptTuM/qyRYqUmFq3HZMlCSnhALi9nIEZ3kijzXhJdzPibmXBHJO/SDHVzyTGdbeKFAowVxuEwvgN51Qa5ePDMUVoZzpNYoTm2AI3P4G1fALajo37bICsPboCRaE1QKgt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAAHcTvcF6xqFqiECA--.649S2;
	Fri, 18 Sep 2026 00:39:57 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: alibuda@linux.alibaba.com
Cc: davem@davemloft.net,
	dust.li@linux.alibaba.com,
	edumazet@google.com,
	guwen@linux.alibaba.com,
	horms@kernel.org,
	kgraul@linux.ibm.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	mjambigi@linux.ibm.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sidraya@linux.ibm.com,
	tonylu@linux.alibaba.com,
	wenjia@linux.ibm.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] net/smc: Fix socket use-after-free in smc_shutdown()
Date: Thu, 17 Sep 2026 16:39:56 +0000
Message-Id: <20260917163956.2162779-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAHcTvcF6xqFqiECA--.649S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFyDCFyfXw1DJryUGFy5CFg_yoW8XFWrpF
	4DCF43ArnxXr1xXFs3JFs5uF1vv3WFyr4fC345K3WfC392grWrJryqqay2va1UCrZY9F47
	Aw1kWa98Xr43ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4
	CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7Cj
	xVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr
	1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I
	0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7sRE-BMtUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwMNA2qr9thOWQAAsy

In the fallback path, smc_shutdown() drops the passive closing
reference on the socket with sock_put() and then still uses the socket
by calling release_sock() at the out label. If that reference is the
last one, for example because the passive closing reference was
already consumed by an abort of the active link group, the socket is
freed while it is still in use.

Move the sock_put() after release_sock() so the socket is only dropped
once it is no longer used.

Fixes: 1a74e9932374 ("net/smc: Fix sock leak when release after smc_shutdown()")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 net/smc/af_smc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index dffbd529762d..420701762c8d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2943,6 +2943,7 @@ int smc_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
 	bool do_shutdown = true;
+	bool passive_close = false;
 	struct smc_sock *smc;
 	int rc = -EINVAL;
 	int old_state;
@@ -2980,7 +2981,7 @@ int smc_shutdown(struct socket *sock, int how)
 		if (sk->sk_shutdown == SHUTDOWN_MASK) {
 			sk->sk_state = SMC_CLOSED;
 			sk->sk_socket->state = SS_UNCONNECTED;
-			sock_put(sk);
+			passive_close = true;
 		}
 		goto out;
 	}
@@ -3011,6 +3012,8 @@ int smc_shutdown(struct socket *sock, int how)
 		sock->state = SS_DISCONNECTING;
 out:
 	release_sock(sk);
+	if (passive_close)
+		sock_put(sk); /* passive closing */
 	return rc ? rc : rc1;
 }
 
-- 
2.34.1

