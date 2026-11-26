Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795699407;
	b=quAP/ow6PP5xmKWZ1fMJV61diT9yLfl/31KnOgq5rQzCGTDSLWt/we09MUtcFKUAEWWg
	 a8glDJXI3UObyIrcHxjwR0OHKgYd7c3KNsOW+8A0lNJenYJ7eno6k8+o0PG4RipRHeA/v
	 VL74OQJ6yhDGJRiSB8UAZahoV/OTOInuzUJmELzGaw/vksvlnheewBceeAHHwPoqx3lrF
	 0wgg5kmby5xdHCOfnT0+TlTwJE9AYpZmC7e7wuWKIR+lSeuySksgcX1rRNXdDvlc7dac9
	 l9oDaDIlPSrqZFI7LiT88zBoxqFS9D8SA8Sb2AlGzshtj9gysYbIivJB4owjU3pNcyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699407;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=VPJNEZ0w+fecGZ67xGVeEEGgA50Vo62jyAy0OFUtf/8=;
	b=yh53dA+oV32I/9hFhKY4oc9y3AGQSYDAQqLkYPDcBp3IWAzVJ1ZGpL0w3sLC7yp/nwNP
	 WdH0gKj3cgIBmURUfHrTVuFIa+aLP6MIy/msB/AhmUwVXf2grH4op5ExWMmIeT+RNy/gs
	 p8t7mXQVy3UMjExlX3wLH1j71h2xBUtZlLwQ58O3zI0B5BKu6SZh6HTD/4XHMk1uL81Dl
	 ztZ3OHlPkF2gI9RwKvh77FrrloWYwcpjK8vt3qRkfb/sXUULU/iRwxC/fT4VWtkiqeOaj
	 h7wiUy4vQMjgSgs0MhdRP7R3WKbqLRzUh0Ar0OvuLwv1fJDsZzs3J20RDd4ISAVeLYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LUvPEdtU;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C3606A323;
	Thu, 26 Nov 2026 13:23:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE7C3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LUvPEdtU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=VP
	JNEZ0w+fecGZ67xGVeEEGgA50Vo62jyAy0OFUtf/8=; b=LUvPEdtUtQLOwm3dvT
	8315t85FJcj+1kxNeISt4dUtWpjjtkWRsR/C1PhjsMtdbQ+Jpbf57kiT28iU/Tx8
	eGYcHjVdbKUP/UQmbylDZcTUwhWZit8bl430K6CGqewkkWNDaR+qpxOo8PdGGdkv
	sWGThj0o3ndonhJR1qv/Cupdg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3X+qkMghrAivcLA--.44539S2;
	Thu, 26 Nov 2026 21:22:46 +0800 (CST)
From: Wanhui Fu <fuwh1120@163.com>
To: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	kliteyn@nvidia.com,
	muhammads@nvidia.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Wanhui Fu <fuwh1120@163.com>
Subject: [PATCH] net/mlx5: Free the table after storing failure in mlx5dr_domain_get_recalc_cs_ft_addr()
Date: Thu, 26 Nov 2026 21:22:29 +0800
Message-Id: <20261126132229.4028110-1-fuwh1120@163.com>
X-Mailer: git-send-email 2.25.1
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
X-CM-TRANSID:_____wD3X+qkMghrAivcLA--.44539S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kry3Zw43Cr1xZrWDCw47CFg_yoW8JFyfpF
	W7C347Xrn2yryxGw1DuF4rZ345Cay0qr4q9w1fX3sxWr4kA3Wjyrs09FW5ua4YkrWUJr90
	yr4xAry3ZFn8X3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Up7K3UUUUU=
X-CM-SenderInfo: xixzxiqrsqqiywtou0bp/xtbC7gaSMmsIMqbB-AAA3C

If xa_store() fails, the entry recalc_cs_ft has not been stored in
XArray. Therefore dr_domain_uninit_csum_recalc_fts() would not destroy
this entry. Just call mlx5dr_fw_destroy_recalc_cs_ft if xa_store() fails.

Found it by a self-developed static analysis tool and compile-test passed.

Fixes: c0e90fc2ccaa ("net/mlx5: DR, Support csum recalculation flow table on SFs")
Signed-off-by: Wanhui Fu <fuwh1120@163.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c  | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
index fedefb565a21..3747c217b61c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
@@ -87,8 +87,10 @@ int mlx5dr_domain_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
 
 		ret = xa_err(xa_store(&dmn->csum_fts_xa, vport_num,
 				      recalc_cs_ft, GFP_KERNEL));
-		if (ret)
+		if (ret) {
+			mlx5dr_fw_destroy_recalc_cs_ft(dmn, recalc_cs_ft);
 			return ret;
+		}
 	}
 
 	*rx_icm_addr = recalc_cs_ft->rx_icm_addr;
-- 
2.25.1

