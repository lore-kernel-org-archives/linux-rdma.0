Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A90439350;
	Mon, 24 Aug 2026 14:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581020; cv=none; b=f2NbCVFXx2ylt9m6idEy2493572W9Wk6awWgdB5sjqGZcDw/WcNxjXUOTmHsq9ArKLVs1NFiAvl9257OwcbShdw6B9qGghWjIROYf6BUAhNj2Tl37JvmlwVVtYyTZN7hrwmqhHpy8C8wNhCgYlMQFzD617TT7coSlZklc4ibaF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581020; c=relaxed/simple;
	bh=417JJ8HfvZqxBwx9TnceZv6+AqItQoNyWs1MKKbognM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMtn9eizlHCqTGzk4RE+3eWM30MgIY46R5h500wGR6N1fjXQ0OZXqWfnqTPkgPiZRmdFMxD1BbCigGq80GNgFNT6xJW3kKshCz87+FEIFkt3wBHBlX34N1/h02mh4YcSwqjBRPgSdK/VqKfPm8mGjUszRWWIhJuLqo9dabEOE2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=QZ/xh+1s; arc=none smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="QZ/xh+1s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2306; q=dns/txt;
  s=iport01; t=1787581018; x=1788790618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uZV/9zCpF//Rk6myhBgkCKBajP+80C4IYP3ESSetPxU=;
  b=QZ/xh+1so5bq7SPhqgsKm5CrIHpq73+LC9gnFGj6/Q1KwUQe6vi0fl5Z
   fgD/4etbV0QZAJlUHc/9n9cIadHKq4CvolkgHxNwQRpDPGkhlaXoNAR5X
   s46zM3LUKj05Ql8lBXeCugXxgvln4rsgyfZwips/1reox//OWs9ey71xO
   yMiF6BBkoad7jNkiM1rfpmPm7LqrDHDw4uzSBMEHOL9Xd65HG203nD/T6
   QXknJrptnF9FjmGkwIIdSnSf9eXWWz56+dF5HL9CHYBP9XfwK1+EmADDp
   bCXIuknIoohQAbq+zMWKAQUKfCoZWJffcZWxg+d1efD58yF2Zuf4WtkJO
   A==;
X-CSE-ConnectionGUID: tWnTOmTTQiqnjzeCG/MlWA==
X-CSE-MsgGUID: 6zTyvV2bSdCgHswh/atKHg==
X-IPAS-Result: =?us-ascii?q?A0AdAwCVUYxq/44QJK1aglkCghY/gVJDSZQpgiGBFp0Ig?=
 =?us-ascii?q?X4PAQEBD1EEAQGFBQKNbAImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBA?=
 =?us-ascii?q?gEHBYEOE4ZcSQEMAYYEAgEDJwsBRhBRVhmDAoJ1A75ZgXkzgQHeR4FmAQsUA?=
 =?us-ascii?q?YE4jWF2hHwnG4FJRIEVgnMHb4UQhXgEgy6TVUiBHgNZLAFVEw0KCwcFgWYDN?=
 =?us-ascii?q?RIqFTI8Mh2BIz4XgQ0bBgWBHVlPhBAjGTZ8gQlegSspYAESF4EJggcCglqCB?=
 =?us-ascii?q?QIBSUMOB0ciCxgNSBEsNxQZBD5uB45dH4JLATEiMQoUgTIpUQWTSgGDKrAjh?=
 =?us-ascii?q?CihXBozl1+TDZkIpCOFIIFoPIFZMxoIGxWDIlMZD44tFoEUAQLOZEUyPQEBB?=
 =?us-ascii?q?wIHDgMLgWiIZYkZAQE?=
IronPort-Data: A9a23:ZjrTt64Hs12ehOG0yfKiewxRtO3HchMFZxGqfqrLsTDasY5as4F+v
 jQXXmqGO6uIN2LwKthzYNy3oUIB7JLUy98xGwFp/Ck9Zn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH2dOC98RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wo/qUzBHf/g2QqajJOt/rawP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eIbIexsFyPV139
 OUeKiIART/EouaJ6efuIgVsrpxLwMjDNYcbvDRkiDreF/tjGc2FSKTR7tge1zA17ixMNa+BP
 IxCN3w2MlKZP0cn1lQ/UPrSmM+qmn77dzBEgFmUvqEwpWPUyWSd1ZC9aYSEJY3bFZg9ckCw+
 HD67nrHWBshOPeQ6SGa8jWlmszvknauMG4VPPjinhJwu3Wfz3IeDTUaXEW2pP2+hFL4Xd9DQ
 2QP9iQGo6839UerQ8e7WhDQiHyDvhhaVdNLD+Qw5QeB4qXR6gedQGMDS1ZpZdA7scYkSCAC2
 ViOkNfkQzdotdW9RXub97qQhTK1NiUcN2UFdWkCQBdty9D4vKkwgwjJQ9IlF7S65vX1EC7z6
 zOHti4zg/MUl8Fj/6am91nvgD+2oJXNCAkv6W3/V2Sp9A5mJ4ioe4Cl93Df8PBGao2ZJnGNo
 HEYhsyT5cgIE5CBlSXLS+IIdJmt6vGDKjr0h0BuE5gosT+q/haLeIpU5zp+DEF3M8oFcHniZ
 0q7kRhY6ZJfOVOsc657Yov3AMMvpYD8HM7kT+z8aMRPbpl4MgSA+UlGfUea0mbsuFIhnaE2J
 dGQdsPEJXwCB4x5wzesAeQQy7kmwmY532y7bZT6yQm3lLmTfniYTZ8bP1aUKOM09qWJpEPS6
 dk3H8+LzQhPFffyZyD/74EeNxYJIGI9CJSwrNZYHsaFLxZqFX8JFfDc2/UidpZjkqATkf3Hl
 lmmRkZSzFfXm3LKM0OJZ2plZbepWoxwxU/XJgQlOVKunnxmaoG14eJHKt08fKIs86poyvsco
 +Q5Rvhsy89nElzvkwnxp7Gk9uSOqDzDadqyAheY
IronPort-HdrOrdr: A9a23:SCig5K2GbyNomNzsbRSBJgqjBJIkLtp133Aq2lEZdPWaSKClfq
 eV7ZAmPHDP5gr5NEtLpTnEAtjifZq+z+8R3WByB9aftWDd0QPCEGgh1/qB/9SKIULDH4BmuJ
 uIC5IfNPTASX5nkM39/A60V/wkwNWB7eSUoN229QYLcemvAJsQljuQzW2gYytLeDU=
X-Talos-CUID: 9a23:ixK8x2OSe3p0j+5DRBZhyGkRJvwcc2TbzmXdCGD/LGJWYejA
X-Talos-MUID: 9a23:+2wEdgsb2JAlbHhjts2n2iNeJdlWua6VBGsCsY4Zu46NKQ9QNGLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,240,1779148800"; 
   d="scan'208";a="816979985"
Received: from alln-l-core-05.cisco.com ([173.36.16.142])
  by alln-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Aug 2026 14:16:49 +0000
Received: from localhost (unknown [10.228.224.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-05.cisco.com (Postfix) with ESMTPS id 8BD78180004BC;
	Mon, 24 Aug 2026 14:16:49 +0000 (GMT)
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
Subject: [PATCH net v4 1/2] net/mlx5e: Prevent stale XSK buffer release on refill retry
Date: Mon, 24 Aug 2026 16:16:44 +0200
Message-ID: <20260824141645.23700-2-jtollet@cisco.com>
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
X-Outbound-Node: alln-l-core-05.cisco.com

When an XDP redirect to an AF_XDP socket fails because its RX ring is
full, the XSK core frees the buffer. During the subsequent batched refill
of a legacy cyclic RQ, mlx5e also releases the WQE's XSK buffer before
allocating a replacement. If that refill succeeds only partially, a WQE
left without a replacement retains its old buffer pointer.

The buffer can meanwhile be allocated to another WQE. A later refill
retry can then free the live buffer through the stale pointer and publish
the same UMEM frame twice.

Mark the WQE as released immediately after the driver-side free. The flag
is already cleared when a replacement buffer is assigned, so refill
retries no longer release stale pointers.

The failure is silent and produces no kernel warning or splat. A
standalone legacy cyclic-RQ zero-copy libxsk reproducer, using 64-byte UDP
traffic offered at 12 Mpps, detected it: stock stopped after 2,854,914
packets in 4.094 seconds, with 4,542 xdp_rx_ring_full events and 64
ownership/double-publication errors. With this change it processed
356,904,225 packets in 30 seconds despite 571,405 xdp_rx_ring_full events,
with no ownership or data errors.

Fixes: 3f93f82988bc ("net/mlx5e: RX, Defer page release in legacy rq for better recycling")
Cc: stable@vger.kernel.org
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Jerome Tollet <jtollet@cisco.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 206cf9db3466..7bd0606a5253 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -410,8 +410,11 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
 
 static void mlx5e_xsk_free_rx_wqe(struct mlx5e_wqe_frag_info *wi)
 {
-	if (!(wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE)))
-		xsk_buff_free(*wi->xskp);
+	if (wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE))
+		return;
+
+	xsk_buff_free(*wi->xskp);
+	wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
 }
 
 static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
-- 
2.55.0

