Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794143799;
	b=UQ8yx9en8/+nV9THz6Zo+U9YwbNt4rtXoB3zrgi9YYZJim0YP6VXrHqvKR2Bw95zsyhY
	 vwZ5vJF7PxKCninNpue9tjuyWqkNrqi055VfYH8B8gidvDC/1kOBJA5uk5SeMuk9YDWrG
	 78n0VYadcgNOiI3Udk1jc+Ufdqlo+INzvZPK40fpUyIGQwYJZWJ4Mt30h3xXCDwb/MQPw
	 uUvyD3RBMAL+6IcvOcrORunmKgM8iyUbiZFFF4odAoNE5ERZ04HDqShiGSeZ/AFVG16kC
	 PihvZPbtusF+NHaO6+ftZc1Kd0On9QaBF4gkZ8c4CNrNK/zzCiEQBlwLOMwq3Xo76aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794143799;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=wyuD9PdZZTyd8Ezh2sp77+2jgNbxGbIBu3YTZsnhh1c=;
	b=1aZuY2IvbJR1vdylfpvpyYGf2Xpt2BzkoKwYbpnBVWBI3jzNiKmiwMOT5ae5KQR+wLE4
	 vmWPIfd+yrhN6s2YW/9AH+8Ukm1EX5ah9r2ExaDjDmNEkTiSHUpP4Dge4YNlkphgt9Exf
	 IWiEiPfAArBZBirJJWuPj+27OLICgUIhTHryIGvolE48uL17QAgBT+LQHGJcBE/TtRM5L
	 0loI7GenuooXw9T0P3vDDGyenjBGSk6JUzbvebEFkJVDiJeOERDLqK21AaaWme6gegvEl
	 m4v7qFfqdhT8ClMe6vlAOTxS+V16F+CqfY1ZbFqqzbgQNvPGMftdZBMDq0rTY/i2CVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88D0606A31C;
	Sun,  8 Nov 2026 13:16:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A88D0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [172.100.0.8] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAXKJkrdvBqYNOUAA--.21299S2;
	Sun, 08 Nov 2026 21:16:27 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Wentao Liang <vulab@iscas.ac.cn>
Subject:
 [PATCH v2] net/mlx5e: TC, fix internal port leak when a flow is reoffloaded
Date: Sun, 08 Nov 2026 13:21:00 +0000
Message-ID: <20261108132100.315011-1-vulab@iscas.ac.cn>
In-Reply-To: <04665957-efb5-4632-878a-6a45fa1553f5@nvidia.com>
References: <20261103102855.1340650-1-vulab@iscas.ac.cn>
 <04665957-efb5-4632-878a-6a45fa1553f5@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAXKJkrdvBqYNOUAA--.21299S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFyDGF48Kw43JFWfGr1fXrb_yoW8KFy5pF
	WUGry7KrWDXa4xAa17Ja1rZa4ruw43tFW5ua4xA39xXrn8JF17Wr9I9a45ua4UCrW8WFyj
	yr4qv3Z5uFWDAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9G1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Gr43Wr1UJr1l4I
	8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
	xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
	AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8I
	cIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r
	4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VU8nNVPUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgcFA2rv4zLYsAABs6

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

The candidate was found by a static analysis tool we run over the tree,
which reports reference-count imbalance candidates. DeepSeek-V4.1-Flash
and GPT-6.1 Sol were then used to audit the candidate and to prepare
this fix. The leak was identified by code inspection only and was not
triggered, so there is no stack trace or error message to report. The
patch was compile-tested only and was not tested on mlx5 hardware.

Fixes: 166f431ec6be ("net/mlx5e: Add indirect tc offload of ovs internal port")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
Changes in v2:
- Fold the internal port check into the outer condition, as suggested by
  Tariq Toukan, instead of re-indenting the lookup.
- Describe in the commit message how the issue was found and how it was
  tested, as requested by netdev-bot.
- Drop Cc: stable@vger.kernel.org: the leak is only reachable when a flow
  is retried after the encap route lookup fails with -ENETUNREACH on a
  multipath LAG setup.

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 708b7987ea4c..88e620654f9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1981,7 +1981,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 			goto err_out;
 	}
 
-	if (netif_is_ovs_master(parse_attr->filter_dev)) {
+	if (netif_is_ovs_master(parse_attr->filter_dev) &&
+	    !esw_attr->int_port) {
 		struct mlx5e_tc_int_port *int_port;
 
 		if (attr->chain) {
-- 
2.34.1

