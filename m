Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701734;
	b=XrJI36EBvTYQiXg7Ox5PZ1VG5K4RafO4cxlidP73OSXnAs8pX9L1GOYAyr/IlM1J23uf
	 hw1jA+eIX/SyXQimmTOEqzYC00aL/MgD3vmYppqXwCnTAEwFPD2+d6zY9ZK+LZBt7K6I/
	 TM4yyRDKLxYf43QUk0gxX6vknfX9NZgTSu2cCoiz4ifpC8DJ4zUj0wQNd46KW9AbK6Qfh
	 WrJ5jhtgdzWsnqSTqipc+Q34mdtLyghfUXtcPM7yWtp7lxpe5LvdDYEOoRmIXNrWu7BXO
	 yeVI1hUjc3/n9yRbxeQOTemGLk2fOOQsn0SalUIswgIPS0Y4hrKUaJebhOF51S/Qd+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701734;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=390o3YbRhnmm390quMy8CCMR9NiMxLhl4RRsXOSIFdI=;
	b=l3OGN87mndCEM5xCy31aXqmZ1YjrVfI4rKPILdMDG5QeTuqA/+VehDXSjS7A7ccBHrc2
	 ytLTeCcvkRoqSyrTr3qRobKK4/gDPY+0YcOg21bwFpffpEIvvBsBnTpuzaqwkYECBon7U
	 FcFGgJxDEYJw37q4t1hWITepzI8rBDq1hRY2zMSvxYrH9Rucqz2uMB7J0RTWuK3194rT8
	 prmcKksnI/He1KtCkZNb9ejS+xp1RwtNjPM6l/tYsbKdm+OCAQsNZff4QrwClfLFm9Mqo
	 BEtN4b6mAYptkOfVe87S1hLSuy90aTI+973D/nkm8nkEdDD3AiJN3zrA9iyP7dX8UKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7061060A3824;
	Tue,  3 Nov 2026 10:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7061060A3824
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowABHWJlft+lqoqk7AA--.3119S2;
	Tue, 03 Nov 2026 18:28:47 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] net/mlx5e: TC, release meter if rule offload fails
Date: Tue,  3 Nov 2026 10:28:56 +0000
Message-Id: <20261103102856.1340672-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:rQCowABHWJlft+lqoqk7AA--.3119S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy8WryfJFy5Zw4ftw47Arb_yoW8Cry7pa
	y8t347Gr97Za4UWw47Ca1rWw15uws3tF45CF1Sy3yavr1DtFWUWr95W3yUur1UCr1UWrZx
	tr97uw13A3Z5AFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9a14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6r
	yUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x0267AKxVWxJr0_Gc
	JvcSsGvfC2KfnxnUUI43ZEXa7VU8jQ6JUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwIAA2rpnO5vUgAEsO

mlx5e_tc_rule_offload() adds the flow meter to the attribute and then
adds the offloaded rule. If mlx5_eswitch_add_offloaded_rule() fails, the
meter reference taken by mlx5e_tc_add_flow_meter() is not dropped.

The error propagates to mlx5e_tc_add_fdb_flow() and the flow is freed
without the OFFLOADED flag, so mlx5e_tc_rule_unoffload() and
mlx5e_tc_del_flow_meter() are never called. Release the meter and the
post meter state in the failure path of mlx5e_tc_rule_offload() itself.

Fixes: a8d52b024d6d ("net/mlx5e: TC, Support offloading police action")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 708b7987ea4c..17bd92529a44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -491,6 +491,8 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
 		      struct mlx5_flow_attr *attr)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_flow_handle *rule;
+	bool meter_added = false;
 	int err;
 
 	if (!is_mdev_switchdev_mode(priv->mdev))
@@ -503,9 +505,14 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
 		err = mlx5e_tc_add_flow_meter(priv, attr);
 		if (err)
 			return ERR_PTR(err);
+		meter_added = true;
 	}
 
-	return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
+	rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
+	if (IS_ERR(rule) && meter_added)
+		mlx5e_tc_del_flow_meter(esw, attr);
+
+	return rule;
 }
 
 void
-- 
2.34.1

