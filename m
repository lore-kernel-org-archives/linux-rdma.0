Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229848;
	b=lf5gXRlQTQpIjXBCgJZOlHNC08Ar+xxP7RPqnYI4b1vlyP4p/SujPKYWelM1L9IvPCwu
	 QsN50B06BxIRPGc/1EQAZusGglR3A95r5RYmfAvEH7jVpZdewd/Q1PdfOtFZt4CccJT38
	 naL4ptLn2tbu4cCWLJNWd4WF3RPZgkLs5h8yfOaZWWj231TOemVQqbiYYMZQ/GQqKVj6R
	 Am6rcabx7XLjpg3HGD2sG9U9LWVqf0UU/XQTvXO+xhnbSnSTK44d+sxZLybG0UmBPJVKs
	 5hNYZ6e8kCXCuqOIP1LX8Jdgi9l0b7PeUPz4vLesn67smPDoubS4WfjF8SJEut5J1uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229848;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JjKytr2/tdOSIX1OKYCfq3N0QO6/0vvrQU+SOUmNoVI=;
	b=3xHyw59qY49R0lFsy1Oxdr5Y2poJ3GXwMYo1v8jVDtPCzLmK3QjsH8AS96zy+2Cq2KWU
	 /wH7Q6TMjjGZOJGX4t8HW8L+RQmrkbwKgXdspkHukk3AvFpzeZPt2SL/WFOoQfyGrZ5NZ
	 hmE8M8JkIM70Bh11RTP5M2LIG3TApG4KLiOv5EhfDxqixbwynMrNep3AQbqoKJ7jEGr3x
	 WExArKgsinuuxHMzEkaTbhNSFWzMl0SbWjOjy1qVjuiweFQjzLB2BqvJwTeHvjgEy3ddW
	 bW/2c9NEk7BsARbyDFiGXT4qFsVd5t9/ZGIF9HZetK2SXAFwj5Z6ZFCR24WdQMWf5Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=iiOHQR06;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94CF606D809;
	Mon,  9 Nov 2026 13:10:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A94CF606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=iiOHQR06
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229846; bh=X4BR+3z4bCtFQxk/fhJw5fcoAEWXU2M/R6/BtbKsNB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiOHQR0603ZMg0jqyhO3Sq8VrkzLaI+1aLWXPMEbE7E960XA5HbHUA7KvKkPA1qHJ
	 R37jujHbkGfRBSzFm0lPvJJp0CBh8xqIJ90gszNQ3KgJ46BOr+OC7gW3UDBaYE39Gn
	 YwGokHTUALBpyJuS9Q06B/tQBqs33oKfDdpGWVKA6NvXWpoGWcoUQMMAhYKTUndvfO
	 Qa/f+REQWxN+rmmmB98hDCbvys0ibqMX0UW9BU6H7n1Xjlk3REFch85l8ehROakFX1
	 NXBeclFcO1+KC7qUS5r2JxqxEvFbPzUFBHOxi7kTocRqVHd23IKdyywXRlBR9PmJUZ
	 qcCZGZu53G52g==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id BD51044C117C;
	Mon,  9 Nov 2026 14:10:45 +0100 (CET)
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
Subject: [PATCH net-next 01/10] bnxt_en: require an exact tunnel id in TC flows
Date: Mon,  9 Nov 2026 14:10:27 +0100
Message-ID: <20261109131039.959438-2-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109131039.959438-1-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
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

