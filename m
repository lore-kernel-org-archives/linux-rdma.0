Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id D633649CF5B;
	Wed, 16 Sep 2026 12:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560592; cv=none; b=M2nEm/4bmshGvoMFYjQOOtuAEtfiirEJfbH69laeF396hsS3AIIdiwt5pvmuOg2bqJeAs9/veQh5YbKLgSPzmUTs7jDy5uUNERGapy+Mmye+MZVN4H7yRPguWsh/dK/sx6aZHJhwyiQsxDJ/ZgL4ESE6lHpPvOc2sLdk1Hi+BHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560592; c=relaxed/simple;
	bh=9hrzyYTAmvl6HBgR/z5BmwUnjS1zqwzNrvoe0CqaqIE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d8gi8JLxpuogqlUGZf7G5UivIrtiFJqyC2ovdER/l14xedxR3nzdoJfiMR2XmjhA97L5Y011PlOhtHvreSRTzmTRQPyIOCgIdyGoa5dGD3EthNeX6o0qBmz5KRaApCe8yTGpHUef+NlOHwf7MPTr396j8MWHwun+wLIQAI//2qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=OWspnEYI; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="OWspnEYI"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Li RongQing <lirongqing@baidu.com>, Willem de
 Bruijn <willemb@google.com>, "Jason A . Donenfeld" <Jason@zx2c4.com>, Nikolay
 Aleksandrov <razor@blackwall.org>, Alice Mikityanska
	<alice.kernel@fastmail.im>, Maor Gottlieb <maorg@mellanox.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
Date: Wed, 16 Sep 2026 20:09:26 +0800
Message-ID: <20260916120926.1761-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc11.internal.baidu.com (172.31.3.21) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789560576;
	bh=zCUCa1aFhLc7292IZNKa1P7NteY5zl568GcdObROk2U=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=OWspnEYIGQVxrLHFGeQCvVwgNumxsTPt0ZtRd6MErNRezvQoZmipCErga5NmUoNMk
	 adJ2Kez1GmoNsTDoQBardVSUK2IgYeGYodx7/91KwCrqorlOp3BysCDI22RzCfzqFX
	 +JkEbU4jGxZQE/lXopK7GHNS/qGu2oi0jjeEjwmYuh7Wno3DDDqY9V+hAD2lk98GrP
	 KesE4Cy7AOWZBsjmLkL6vhIm2R7DoIHwuIov5uzJUhwOHXsEV8hMBEVTvXOYwUR2lC
	 Yb0wmFLymZ2/s8Bgf1xxCIezf9cedUK8vh/XZWEskwPts33X3EOaYbSSPDNPCw+jBb
	 jCyPGRxHRcjWA==

From: Li RongQing <lirongqing@baidu.com>

rdma_build_skb() constructs a synthetic IPv6 header for LAG slave
selection and copies the flow label from the AH attribute:

	memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
	       sizeof(*ip6h->flow_lbl));

ipv6hdr.flow_lbl is __u8[3], so sizeof(*ip6h->flow_lbl) dereferences the
array to a single __u8 and yields 1.  The memcpy therefore copies only
the first byte of the flow label, leaving flow_lbl[1] and flow_lbl[2]
uninitialised in the skb buffer (alloc_skb() does not zero the data).
The resulting LAG hash is computed over one byte of real flow-label
data and two bytes of kmalloc residue, so IPv6 RoCEv2 traffic on a
bonded interface can be steered to the wrong slave.

Use sizeof(ip6h->flow_lbl) (the array, 3 bytes) so the whole flow label
is copied.

Fixes: bd3920eac1331 ("RDMA/core: Add LAG functionality")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index 00fe241..88aac91 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -59,7 +59,7 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 		ip6h->version = 6;
 		ip6h->nexthdr = IPPROTO_UDP;
 		memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
-		       sizeof(*ip6h->flow_lbl));
+		       sizeof(ip6h->flow_lbl));
 		memcpy(&ip6h->saddr, ah_attr->grh.sgid_attr->gid.raw,
 		       sizeof(struct in6_addr));
 		memcpy(&ip6h->daddr, ah_attr->grh.dgid.raw,
-- 
2.9.4

