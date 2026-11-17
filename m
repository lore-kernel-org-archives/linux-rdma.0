Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907778;
	b=wsj/H9LS4czPjLO1LszL/r3RasoUrEJbbvqqdMOOqvppCxra5WSNFZXqxTdsSZnHciJV
	 vkVWngR85ybWS2StLczMCGbpzZOc4ZRx4XoC+VaH9tAPDm0y/M/m4I76P4jKmxE4270KX
	 AKx169Hc0KKzcIz0StieV011e+3qg2S0168JRGI+AbLEry4gxBQsZDjxsaIM3cQJxMics
	 EpRYAy3HUS2Y/JYPvwAgKdKti/Ib2nrauQsiusYne1Y1829x9lvGqzrYxs3Panci3gS3x
	 9+nVeOoUwcQg8VKdQLp9fRPPr0f6oxThyqD5DFYP/TyT69mFQ8ouR07g46B2QcW74hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907778;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JjKytr2/tdOSIX1OKYCfq3N0QO6/0vvrQU+SOUmNoVI=;
	b=q77PUjJVwVe/EYpnSDi4LifUl8MBQJjtM+YoRre4wYH7R17jXwjUrhUoDVgGxgyCAC+y
	 2RzFWe2lOLVWjghttl6xCoQwnxDfjIrvK4rEwPWq4tDOVLFBDGMp9WY1XiGpImONK7+jx
	 Ty3jSpvjvRHaz4OY6DeW8U20H5SQn/hEsQfxSh3OOgT93K5XZPewad3qffY1eRqRnwceL
	 Sl6agfby5Fios8LcIr7BFsNJ1z1M7JtdXNTk1Xh4CpY+MreEONmjgdrq21Xo0y0EPSe4Q
	 X5+oqTyFYhhEUauGVyZjD36K97nv4xDmjT+2ugB/ewH+8I654achNJmDnLk50I+0NKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=dE7Xg3E0;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE68606A891;
	Tue, 17 Nov 2026 09:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DE68606A891
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=dE7Xg3E0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794907762; bh=X4BR+3z4bCtFQxk/fhJw5fcoAEWXU2M/R6/BtbKsNB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dE7Xg3E09HpdbROVl79BHlEZZFxLk6yO9R7gnTqNL/yWq3kzoAir7FLoD3xSSuhne
	 10vZGRGV9NJbrtQxqTKd/EyPhaRfNp/1gE3VBmqSUIusPZ6cnjk412pjejpf4pqPpM
	 ch6xKAt1TgHmwBJE4qaptTRu8k8Me2xXx3kuxZg2bHSg5xCDMAxSTustHMvb7BKjqN
	 zymcfWcuTIOuQetUPGKDp+sD1UmaSbga+nYZfXQt9oj26gAoLGJZeaEoiEPHefz7Ry
	 Xg5i9rz9bBMF68yi6KQ0YOZoyWdTJVcN5QorXmhq54hKv4CajhdWK35Do3+jx4omHQ
	 5oMcbQj6YiRXA==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 0DF3C44C0B36;
	Tue, 17 Nov 2026 10:29:22 +0100 (CET)
From: Alexandre Cassen <acassen@corp.free.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net-next v2 01/10] bnxt_en: require an exact tunnel id in TC flows
Date: Tue, 17 Nov 2026 10:29:04 +0100
Message-ID: <20261117092915.255194-2-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117092915.255194-1-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
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

bnxt programs the value of enc_key_id and never reads its mask. Flower is
about to accept partial masks. bnxt would offload them as an exact match
on the masked key. Reject them like the other exact fields.

Found by an AI code review agent while auditing the users of enc_key_id.
Build tested only.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index c6b4a14c0e6e..e493c85ecf28 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1081,6 +1081,13 @@ static bool bnxt_tc_can_offload(struct bnxt *bp, struct bnxt_tc_flow *flow)
 		return false;
 	}
 
+	/* Currently tunnel id cannot be partial wildcard */
+	if ((flow->flags & BNXT_TC_FLOW_FLAGS_TUNL_ID) &&
+	    flow->tun_mask.tun_id != key32_to_tunnel_id(cpu_to_be32(U32_MAX))) {
+		netdev_info(bp->dev, "Wildcard match unsupported for tunnel id\n");
+		return false;
+	}
+
 	/* Currently Ethertype must be set */
 	if (!is_exactmatch(&flow->l2_mask.ether_type,
 			   sizeof(flow->l2_mask.ether_type))) {
-- 
2.43.0

