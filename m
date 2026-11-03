Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701734;
	b=EoWHcbqijDmfP9VQ7KZnHTesdwQFHARWzhfmAq5RcNP57e9NuHSxNKmvLGv8hNoaPIJO
	 WjSaJgC8ndiPu3gt4T8v79RxPKujzv3SQDoKb1/EpKsiYv1eF7MyMQUfUsQLfcGBReGTZ
	 eUFu8sUxlIj70lbVFKqh0bM/06F7VLAch+0FLwAiB1YFHge6UfKk3EfiDc8RarC+X48yO
	 AkJI/MKphLyCsfrnVe8H0mJ+QPsdy/M7rtcJcDZz25lMVDot8CyCzW9sa5xVuS8MhVj1c
	 HPRrZbKgDfy5JA6NYe6f31TuHEPwFo7fDH3wipLXayoIvQHRKf/WzPgrTRQVoifYg5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701734;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=ELxjEEq6gOyqQ6bTvgDI+S2e1blVFHjwmyf37H4AWuM=;
	b=pES/tmfJEyiqysTAKu6Bo1ptct8MvGy/iMwU1avU2kihRqb5pq52ZM2W32L5Izd5EBmX
	 o/IZwOcplsKRns/261JqmsZLEHLM868SDWGcPUbzu/lobefPrfagF9RGyu/abqAYlnIXL
	 7C6v0qPiIyLtYv9fuCyDQvtc2IvtF06oXqCbPm1313zryKMktuPynCU72vRounDkl3r3t
	 TE2lWbYH76rrgwd9OA1f5TEGh5BvuqiDT5Uk48XCE3L27brYsb3rMgmxFGiF6ZB07FnaV
	 4Ve4ZSNqILzBxcT1keb6dsKcGXil5xJrP/qb1Vo7Mqw0LVoFeWaFLM5n1UIwvZ3v9OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9813D60A5BC1;
	Tue,  3 Nov 2026 10:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9813D60A5BC1
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowACXaZpet+lqnKk7AA--.64723S2;
	Tue, 03 Nov 2026 18:28:46 +0800 (CST)
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
Subject: [PATCH] net/mlx5e: TC, fix internal port leak when a flow is reoffloaded
Date: Tue,  3 Nov 2026 10:28:55 +0000
Message-Id: <20261103102855.1340650-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowACXaZpet+lqnKk7AA--.64723S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFyDGF48Kw43JFW3KFW8Crg_yoW8uw4rpa
	1UWryIg3s8Aa4UAw47tanYva95uws3tFZ8ua4xCws3Zr1kAF47uryY9as09r1UCrZrXrZ8
	trWqy3W5CryDAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9a14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r
	4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x0267AKxVWxJr0_Gc
	JvcSsGvfC2KfnxnUUI43ZEXa7VU8jQ6JUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwIAA2rpnO5vUgACsI

For a flow originating from an OVS internal port,
mlx5e_tc_add_fdb_flow() takes a reference on the internal port and stores
it in the flow's esw attribute.

If the flow cannot be offloaded because the encap route is not available
(-ENETUNREACH) on a multipath LAG setup, __mlx5e_add_fdb_flow() keeps the
flow on the unready list instead of freeing it. When
mlx5e_tc_reoffload_flows_work() retries, mlx5e_tc_add_fdb_flow() takes
another reference and overwrites the stored pointer, so the previous
reference is never dropped.

Only look up the internal port if the flow does not hold a reference
already; the reference is released together with the flow attributes.

Fixes: 166f431ec6be ("net/mlx5e: Add indirect tc offload of ovs internal port")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 17bd92529a44..8246378b089f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2005,17 +2005,19 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 			goto err_out;
 		}
 
-		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
-						 parse_attr->filter_dev->ifindex,
-						 flow_flag_test(flow, EGRESS) ?
-						 MLX5E_TC_INT_PORT_EGRESS :
-						 MLX5E_TC_INT_PORT_INGRESS);
-		if (IS_ERR(int_port)) {
-			err = PTR_ERR(int_port);
-			goto err_out;
-		}
+		if (!esw_attr->int_port) {
+			int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
+							 parse_attr->filter_dev->ifindex,
+							 flow_flag_test(flow, EGRESS) ?
+							 MLX5E_TC_INT_PORT_EGRESS :
+							 MLX5E_TC_INT_PORT_INGRESS);
+			if (IS_ERR(int_port)) {
+				err = PTR_ERR(int_port);
+				goto err_out;
+			}
 
-		esw_attr->int_port = int_port;
+			esw_attr->int_port = int_port;
+		}
 	}
 
 	err = post_process_attr(flow, attr, extack);
-- 
2.34.1

