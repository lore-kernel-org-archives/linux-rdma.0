Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961ED37F74A;
	Tue, 24 Mar 2026 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376069; cv=none; b=ouJtsV0u+3yKGC0tURzEZ8vMFXeX75RxG7DecIVmj3chQmSrjenkYP7NkOtbWiDSrf/Tu0iTHqE7Nk4rvw8JtgPxzbx8hJ6JtKFt8HNQEn6ZGVbaHqPUuEcEVbnOz6HjIlZIAFn9oJgPOJwyrCRzYPAfKM11APNPHR1RdKFPbFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376069; c=relaxed/simple;
	bh=KXfiWxpy+C5jFNOWJQ/IWXZWe8UJGsgxBv5kXFkf/UE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VOdCrgIikb6zSn1sGkLcQtKxlMLFwosiw/Qa6+xWlA/tss12emDbh/w6/uK5NThne1xbTqBVBnuOKw4RoGDW2AtfXdyR4NrGbnY4aH5ruJU6WO1PDPWCiGn9wzXOK56Us2o88DcPO0WnZut0PVnyEn5QiH9gQ0YGnaC69hJrxYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=YbtLOCAC; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="YbtLOCAC"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 7993720B7128; Tue, 24 Mar 2026 11:14:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7993720B7128
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1774376068;
	bh=TuXznKRwDxdzYfAQryePmlO/GRLLn9GYbXhWTGxvXWQ=;
	h=Date:From:To:Subject:From;
	b=YbtLOCACzcb1UZHBCRzMmTGC3hAJ7oeAjM+5v1WAW6prakF0EdxdF/WSV61fv2fvS
	 BWaH0On/EQ1qFdQU5s+pPwtpVXCt2uojZGUxFe+41rL5rVKEEYIWknJxJkdh3MvgGA
	 96wev3R2NrkrssR7wn8pVA1Nf0cWACJSi6MO32xE=
Date: Tue, 24 Mar 2026 11:14:28 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	leon@kernel.org, longli@microsoft.com, kotaranov@microsoft.com,
	horms@kernel.org, shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com, ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, stephen@networkplumber.org,
	jacob.e.keller@intel.com, dipayanroy@microsoft.com
Subject: [PATCH net,v2] net: mana: Fix RX skb truesize accounting
Message-ID: <acLUhLpLum6qrD/N@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

MANA passes rxq->alloc_size to napi_build_skb() for all RX buffers.
It is correct for fragment-backed RX buffers, where alloc_size matches
the actual backing allocation used for each packet buffer. However, in
the non-fragment RX path mana allocates a full page, or a higher-order
page, per RX buffer. In that case alloc_size only reflects the usable
packet area and not the actual backing memory.

This causes napi_build_skb() to underestimate the skb backing allocation
in the single-buffer RX path, so skb->truesize is derived from a value
smaller than the real RX buffer allocation.

Fix this by updating alloc_size in the non-fragment RX path to the
actual backing allocation size before it is passed to napi_build_skb().

Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
---
Changes in v2:
 - Added maintainers missed in v1.
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index ea71de39f996..884f8e548174 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -766,6 +766,13 @@ static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
 		}
 
 		*frag_count = 1;
+
+		/* In the single-buffer path, napi_build_skb() must see the
+		 * actual backing allocation size so skb->truesize reflects
+		 * the full page (or higher-order page), not just the usable
+		 * packet area.
+		 */
+		*alloc_size = PAGE_SIZE << get_order(*alloc_size);
 		return;
 	}
 
-- 
2.43.0

