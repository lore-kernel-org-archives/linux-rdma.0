Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CAA4C33E9;
	Thu, 17 Sep 2026 11:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789644553; cv=none; b=lGokgzzzXWpJG9fBzNk++FUXTfnPLaMQZNDiE8ydK+eIMj60hwtJnPgdFesjyafNMEpMUQl3UiAtkMNtGnKhiEYpJWA9OSr7q0nnQ3sGN1zCN6Qdh1dPLTlNiehh0xkRG0DoZ5Gqv3ct+UXDgdWs30XZMv6UF8q07/sePrjOxJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789644553; c=relaxed/simple;
	bh=hr6jK7hwe0rYgn9zEYI6gtwkc2fqYVxMGqQQ0mQ0UEQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KruU1dSF6T2QS/hINslGhGh7RyWHNuwGjBErusTuemG2LMaEepYqf4Vee+HQJr/y+5kwSJ2C6LaxpwY9ARqjsDR6fhKDQAx8qR4TpysJPx2mXq//Wh2B8JWuzdhlRFf/seRcq5DVup1rXDEkRkoT9dU4MczY7Aj5qTjGmdgiRfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACXAz78zqtqV5N_CA--.1651S2;
	Thu, 17 Sep 2026 19:29:01 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: agoldberger@nvidia.com
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	mbloch@nvidia.com,
	moshe@nvidia.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] net/mlx5: Fix ent use-after-free in cmd_work_handler()
Date: Thu, 17 Sep 2026 11:29:00 +0000
Message-Id: <20260917112900.2148932-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACXAz78zqtqV5N_CA--.1651S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr15ZrWDXF1kGr48Xw1UZFb_yoW8ZryUpr
	4Yqa9rKF1qqFs2yr1xZr4kua4rW393KayUC3WfW3WFvFn5Jr1kKFyrKry8tFW8AFZYgFy2
	yr40ya17Jr4FywUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7
	v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0E0s8F02x267IIx4CEVc8vx2IErcIFxwAC
	I402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrw
	CF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E
	5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZV
	WrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY
	1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
	0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x
	07bnXd8UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAQNA2qrrJpsHAAAsB

In the two command slot acquisition error paths, cmd_ent_put() can drop
the last reference and free the command entry, and complete(&ent->slotted)
is then called on that freed entry.  Signal the slotted completion before
dropping the reference so that the waiter in wait_func() is woken while
the entry is still allocated and the entry is not touched after it has
been freed.

Fixes: 485d65e13571 ("net/mlx5: Add a timeout to acquire the command queue semaphore")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index c89417c1a1f9..2dac131c5f86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -998,6 +998,7 @@ static void cmd_work_handler(struct work_struct *work)
 		if (down_timeout(&cmd->vars.sem, timeout)) {
 			mlx5_core_warn(dev, "%s(0x%x) timed out while waiting for a slot.\n",
 				       mlx5_command_str(ent->op), ent->op);
+			complete(&ent->slotted);
 			if (ent->callback) {
 				ent->callback(-EBUSY, ent->context);
 				mlx5_free_cmd_msg(dev, ent->out);
@@ -1007,12 +1008,12 @@ static void cmd_work_handler(struct work_struct *work)
 				ent->ret = -EBUSY;
 				complete(&ent->done);
 			}
-			complete(&ent->slotted);
 			return;
 		}
 		alloc_ret = cmd_alloc_index(cmd, ent);
 		if (alloc_ret < 0) {
 			mlx5_core_err_rl(dev, "failed to allocate command entry\n");
+			complete(&ent->slotted);
 			if (ent->callback) {
 				ent->callback(-EAGAIN, ent->context);
 				mlx5_free_cmd_msg(dev, ent->out);
@@ -1023,7 +1024,6 @@ static void cmd_work_handler(struct work_struct *work)
 				complete(&ent->done);
 			}
 			up(&cmd->vars.sem);
-			complete(&ent->slotted);
 			return;
 		}
 	} else {
-- 
2.34.1

