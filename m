Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793377918;
	b=QUKLVuLqI8Tx1X3cwPZtyfr6sobdEjCokRiRpg5SZH0FhMLT0VwgeEIJTTko8O61oY0R
	 QNPJmAm0fB2Q9rSRPCn2Q8nz86edwQrsNDtkD4TYDJf5E3dD5RRXw3ZVcQqHAgYNhUkq3
	 cgiaDnv4FH9X726wxegONNpB5o5nKKkA5J5f1j9QqvfWxYESx3VX80uynandmMMmxgh0H
	 vH5vJTNWvEyj8Jczrp5LRmUnQXH5/KFSFQuoTAcPSvGuSvGTUY5sQIubgxb/XT+UjJpmb
	 lhH2CJgXbRwv9xTOeJnewv+yAgoqlXUHk9VbDpujtTHL5ZWCO8Q5wyQQA2b7BYa3EoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793377918;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Debian-User;
	bh=Pq+i8rJi/9ZoV6LFHD0nn/AL1YjVYkhOQnH0yPWO1Xc=;
	b=EGJVHQbmDc7uAZZz/WFgfgzESn5d7UShSSy9r16UYG7znGbDJQUeIkaKT5gfhBbkAEcT
	 prgmeD+Pg8QPgX4eCGTOLC7RU+fPgRCy4E5wZxCivcVe3mWMDuCsFDjNnXYcuPOB6KAX2
	 IHfeG/4ellMyeX6c2WRILoX+h6YJ7uGGQATKtZSsPHNrJxO1BeOB9nhL3YpS1EIv7UNQn
	 s1+06jRUb/k+Kvof4IF/amknnKokbtubwZZLQJDYySZLMKfOQL6pSyeNjIFCyOPlEV1SS
	 4iX4Jdv0cmVl1sM1ZfO4qlhzkM61s5Leo1594aGomSHHBO7poW6CH9eDVk8PMbebqxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=kmJA83O+;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB568606A31F;
	Fri, 30 Oct 2026 16:31:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB568606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=kmJA83O+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Pq+i8rJi/9ZoV6LFHD0nn/AL1YjVYkhOQnH0yPWO1Xc=; b=kmJA83O+MQfglZeCpSQOE4P75x
	ull6C2vVsipPfVK7BWmaTdd7EdxnKHQt8oDYQ8TCBPiJqs1MLx0fQniY1wScXct7QQbo5KpyCT3RY
	7MV5myrJmIn/Uy+YrNClos9+yKJjrS95t8kBFcatMlO55ehbd6FdoCAQdy1pEtXUlMAjdxtoXIQMj
	33raxOS/q9ehBseYiDaFuj6l7yrf9LjCBvJgX/0+Uw37xOvOAztuMPcJ3WxlZ52T+oUM00S3oQ/p6
	cZjJ/gbx1uWUvZ6xPLt9ZSYJUfXII52A3Ubvn8cryTSJDYKKfaWMBmMXy8bRmUnOj89Ebf6HPgRG1
	gAKUH1Bg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xMpWD-003x1v-29;
	Fri, 30 Oct 2026 16:31:53 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 30 Oct 2026 09:31:43 -0700
Subject: [PATCH RFC 1/2] net/mlx5: Submit blocking commands from the
 caller's context
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-mlx5-cmd-wq-v1-1-1458b2aed637@debian.org>
References: <20261030-mlx5-cmd-wq-v1-0-1458b2aed637@debian.org>
In-Reply-To: <20261030-mlx5-cmd-wq-v1-0-1458b2aed637@debian.org>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2270; i=leitao@debian.org;
 h=from:subject:message-id; bh=/85JIr0ETe8f+4pRr4MDFjchmH9gZ5ulHRVINwtreoc=;
 b=owEBbAKT/ZANAwAIATWjk5/8eHdtAcsmYgBq5MZyYdCWBWfs86LIQZNZeYvPd6p/gMZp20vuj
 gh2L5AaMM2JAjIEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCauTGcgAKCRA1o5Of/Hh3
 bQEzD/isKA+azalzoS9OvSRRJzHF5gGcjOoH7b+Xc9CLDP1o16VxdvZ+euLjRzFyAyQmi6WMdS8
 irl41IIE/jmr1n5e3PfeUEQ77BdH25QaAK3zQ8FpNW1zquaiQ4qjkVk6LBnRQP0HrxTKKDAOA89
 eNssF9n3IkSMeSzg9hf0EbKM25NHbu5Tv4QZtKnM9/pgdLbJyi6VHkhvvv0RSoO36BO6dPddN41
 XX7MNVLSxnKz5xGjtsKq57Gx7TJJt9aR+7vSErCq7fcwPbUEv5fZRx7kauIAnLruqp0ykw9bDoR
 FPgMd0MNFGL/B/Dso/oxH3YUefj9ZgYQWynR31Nzh/JWxwtWNKr1MIVJYb/3fCvNDJ7hYp2d0J9
 HUnEDxcYOIHlgQWNOJxQDEBZr5o0O266aOo//DWWNJWuTJRcOzEKvQ3OOZ5w5IKWcsljPS7Jmm0
 cyilxznT5bx+35y0KlaLAb2wquPebkKGcBBS/P6XXD35xzXRDA5n7XFPdDPauexXB0fZLHYDyU+
 eOiw+H/b4x2WvxRbjFbvTupHaCNXaJz9OvSiw/Jr1y8BjyCTwFRZUY0293wEiU5z3tHJLIMqFV9
 nwnZzbIDa3aKpO2TsMSnfvUDce58YxtGmPMbgpWrtDgOoy8EpxAVxu1IWNUjWJqgJqKqiZULUWM
 Pbo1DyBEkdq2q
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

mlx5_cmd_invoke() queues every command that is not a page-queue command
on the ordered cmd->wq, and a blocking caller then sleeps in wait_func()
until the command completes. The work item only takes a command slot,
writes the descriptor and rings the doorbell, so each blocking command
pays for a queue_work(), a worker wakeup and a context switch while its
caller sits idle.

All ordered workqueues share one unbound worker pool, so the command
work items of every mlx5 function also contend on a single pool->lock.
On an arm64 host with a dozen mlx5 functions in switchdev mode, where
monitoring daemons read /proc/net/dev, lock contention profiling put
36% of the pool->lock wait in queue_work() called from cmd_exec(), and
the rest in the workers running the command and stats work items.

Page-queue commands already call cmd_work_handler() directly. Do the
same for every command without a callback. Callback commands keep using
the workqueue, since mlx5_cmd_exec_cb() must not block.

Firmware runs up to max_reg_cmds commands concurrently, so callers could
not rely on the submission order, and the slot semaphore still serves
its waiters in FIFO order.

With 32 parallel ethtool -S loops on a ConnectX-4 Lx, this removes all
46.7k mlx5_cmd work items of the run and cuts kworker context switches
from 50.7k to 3.9k.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 84583dc5eb1c05..988518155582a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1301,7 +1301,8 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 
 	INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
 	INIT_WORK(&ent->work, cmd_work_handler);
-	if (page_queue) {
+	/* A blocking caller waits for the command anyway, submit it inline */
+	if (page_queue || !callback) {
 		cmd_work_handler(&ent->work);
 	} else if (!queue_work(cmd->wq, &ent->work)) {
 		mlx5_core_warn(dev, "failed to queue work\n");

-- 
2.53.0-Meta

