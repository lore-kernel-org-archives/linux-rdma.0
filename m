Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE64942DA4D;
	Mon, 24 Aug 2026 14:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581014; cv=none; b=jvhD9ufMJxOOfRZAPsSeCLNBjnTroLvpb12Keh08G10FT6IGdsmn1obiKyn1R/sRupHZMl4zZyR/HmgDzaHcW62dsYiT6tbC46GN7hmtOERPEkV0my/sEFHs/u9Arc64+jq+83b1NbcBQfnX4Gzvzj+vlYLtYhwHVjAPRDrIIBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581014; c=relaxed/simple;
	bh=EIHCMUQc/JLupmOSZV2pOn2JscGhvZ9UDM+cY/Admmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co/fxl3vO7UcM8wOeAaDr5+wZug7nFkhWaCWWwklPkKyy2rK42DEQUrEXHqJ15aWpIWqhGtg0K9q/fOVlTMOcF/ThsO+0lzvImyvKUksR1+ZD3QXlY2M2uZb58iMX6m7QKS4XRkSMS2nFOsgwArffUlXYp8a0qBlfbyW2rLRTwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=XTNF01MG; arc=none smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="XTNF01MG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2099; q=dns/txt;
  s=iport01; t=1787581013; x=1788790613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q7ne7I+tVhtIe/1r7EzMVEOlt/B1u1kz/bTxSe2FFUw=;
  b=XTNF01MGDTbGWXzbINRw/6O+Py4pKHaKJPxkkLrPO2I7mdODPsucz9xA
   DDyurt3dd70Gwvp61Lo2U9kzEYhxkXXoRtSrWTwSPSDVPRRKR6LnZ84nm
   BG+iy8ee9WZGltwAEzJI9YNxILpMbvu9qWxwm2lbg06kWEuTDBScJlKWx
   LFWY1oUIHRLSkkA29QZtMWwmOVYp15tEISEpJ5kUbsAXLWcj5kn+L0pKS
   AhdrxaBSAt7Udse5OPgU9pNmi2BlHCfmX0SbAwxsJZqy5y8SB4sxzRkOw
   Q+5E5bAayW90976bujg0EoL4nc2Ed6VVpqKrahrfI6is4+RFI3mKlQ8gH
   w==;
X-CSE-ConnectionGUID: 2EGB+J+dQw23ZghRG7NdGg==
X-CSE-MsgGUID: PV/UhBSUQ2af6Ps8rTMzhg==
X-IPAS-Result: =?us-ascii?q?A0BCAgArUYxq/4sQJK1aglmCV4FSQ0mUKYIhgRadCIF+D?=
 =?us-ascii?q?wEBAQ9RBAEBhQUCjWwCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBB?=
 =?us-ascii?q?wWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ1A750gXkzgQHeR4FmAQsUAYE4jWF2h?=
 =?us-ascii?q?HwnG4FJRIEVgnMHb4UQhXgEgy6TVUiBHgNZLAFVEw0KCwcFgWYDNRIqFTI8M?=
 =?us-ascii?q?h2BIz4XgQ0bBgWBHVlPhBAjGTZ8gQlegSspYAESF4EJggcCglqCBQIBSUMOB?=
 =?us-ascii?q?0ciCxgNSBEsNxQZBD5uB45dH4JMMUoJCgo5gQErbpZdsCOEKKFcGjOXX5MNm?=
 =?us-ascii?q?QipQ4FoPIFZMxoIGxWDIlMZD45fz19FMj0BAQcCBw4DC4FokX4BAQ?=
IronPort-Data: A9a23:W/g69Km90lXkHr+y5EICRl3o5gxLJkRdPkR7XQ2eYbSJt1+Wr1Gzt
 xIdDWjUP/rcZ2v1ed8lOY7koU4H7cDWxtQwTVc+/Co9RltH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raf658SUUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+ZC31GONgWYubDpEsf7b8XuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05Fdc11cw0IyJCz
 ONCcwICbiqs2MS6773uH4GAhux7RCXqFIobvnclyXTSCuwrBMiZBa7L/tRfmjw3g6iiH96HO
 JFfMmQpNUqGOkYeUrsUIMpWcOOAhGX4dzlVtHqepLE85C7YywkZPL3FYIOLJYbTHpoN9qqej
 lr4uFn5KConDYaWx2S96SK2usrdnSyuDer+E5X9rJaGmma7ymUNBRg+WVKlrPy9jUCiHdRSN
 yQ84SYghaY18U2gTtTjGRi1yFaGuR4aHdRZCPEz4gyLxoLb5g+YAi4PSTspQNEqqco/VzE2/
 lCOmNztCHpkt7j9YX6U8LaZqRuzPicYJHUIYj9CSwYZi/Hqu50bjR/VSNtnVqmvgbXdGTjvw
 BiJoTI4irFVitQEv4244FrOqzGhvJ7ESkgy/Aq/dmuj4hl0e82japCk5Ebz6etGKsCSTjGps
 GQNh9Wa4ekmC4+MmC2EBu4KGdmB4/uCNifbqVhxHpUg/nKm/HvLVYVa5DZ1JG9vLMcIeDava
 0jW0StK7ZJeMH6Ca7F2b4O4Tc8tyMDICd3/V+nIRtxQY5RwfUmM+yQGTVaZ1W3rkWA2nK0/M
 IvdesGpZV4QEapP0jW7XaEe3KUtyyR4wnncLbj/zhK6wf+daWSTRLMtLlSDdKY64bmCrQGT9
 MxQX+OOyhNCQKjkbize2ZAcIEpMLnUhA53y7ctNeYarJAd6FGw/I+HezKlneIF/malR0ODS8
 RmVQVNRwl7yrWPIJB/MaX15br7rG5FlohoG0TcENFKs3T0nJI2o9qpaL8Fxdrg8/+slxvlxJ
 xUYR/i97j10Ymyv01wggVPV9eSOqDzDadqyAheY
IronPort-HdrOrdr: A9a23:0LJdcKDh5cuB53rlHemM55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDDH5ZmtZ
 tIQuxZFMD6C0R8gILR5Qm1FMtl/fy8mZrY4ts3CxxWPHhXg2YK1XYeNjqm
X-Talos-CUID: 9a23:04fQd2BCjeuTWIP6E3NK22RXOIMpS2KHl0XfI3WXVkBlZ7LAHA==
X-Talos-MUID: 9a23:6WrzmQZ6jZF+YOBTjwGruTFID/pRua2gVngWwY86ntuEOnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,240,1779148800"; 
   d="scan'208";a="816721370"
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Aug 2026 14:16:52 +0000
Received: from localhost (unknown [10.228.224.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPS id 7CBDB18000216;
	Mon, 24 Aug 2026 14:16:51 +0000 (GMT)
From: Jerome Tollet <jtollet@cisco.com>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leonro@nvidia.com,
	dtatulea@nvidia.com,
	daniel@iogearbox.net,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Jerome Tollet <jtollet@cisco.com>,
	stable@vger.kernel.org
Subject: [PATCH net v4 2/2] net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry
Date: Mon, 24 Aug 2026 16:16:45 +0200
Message-ID: <20260824141645.23700-3-jtollet@cisco.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260824141645.23700-1-jtollet@cisco.com>
References: <cover.1787347981.git.jtollet@cisco.com>
 <20260824141645.23700-1-jtollet@cisco.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.228.224.45];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.228.224.45, [10.228.224.45]
X-Outbound-Node: alln-l-core-02.cisco.com

With AF_XDP on a striding RQ, mlx5e defers releasing XSK buffers until
an MPWQE is refilled. If XSK allocation then returns -ENOMEM,
actual_wq_head is not advanced and a later NAPI poll retries the same
WQE.

mlx5e_free_rx_mpwqe() leaves each released slot marked as releasable. On
retry it can therefore call xsk_buff_free() again through stale pointers
after the frames have returned to the XSK pool and been reallocated.

Set all skip_release_bitmap bits in the common error path of
mlx5e_xsk_alloc_rx_mpwqe(). This matches mlx5e_alloc_rx_mpwqe(). A
successful allocation already clears the bitmap after replacing every
buffer, so retries become idempotent without changing the success path.

Fault injection forced three consecutive failures for one selected MPWQE.
Both an early allocation failure and a partial 8-of-16-buffer unwind
released the original 16 XSK buffers only once. Each error left a full
bitmap, the following NAPI retry skipped the release, and a later
successful allocation cleared it. A 20-second AF_XDP zero-copy pressure
run exercised 1,575,262 buffer allocation failures without invalid
descriptors, WQE errors, or kernel warnings.

Fixes: 4c2a13236807 ("net/mlx5e: RX, Defer page release in striding rq for better recycling")
Cc: stable@vger.kernel.org
Signed-off-by: Jerome Tollet <jtollet@cisco.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 4f984f6a2cb9..55ec6387ab28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -3,6 +3,7 @@
 
 #include "rx.h"
 #include "en/xdp.h"
+#include <linux/bitmap.h>
 #include <net/xdp_sock_drv.h>
 #include <linux/filter.h>
 
@@ -156,6 +157,7 @@ err_reuse_batch:
 		xsk_buff_free(xsk_buffs[batch]);
 
 err:
+	bitmap_fill(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
 	rq->stats->buff_alloc_err++;
 	return -ENOMEM;
 }
-- 
2.55.0

