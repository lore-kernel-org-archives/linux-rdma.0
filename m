Received: from alln-iport-5.cisco.com (alln-iport-5.cisco.com [173.37.142.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F284543934D;
	Mon, 24 Aug 2026 14:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581017; cv=none; b=eCPZx68GNzQUYcs1vW35eqyh0WBS7it5aTdu7HpkH2AEwB/ihTwGVRqV+kc/qH2h29BynUb6ZiJrXazfAD4kAuTnB8zPL9pHn9RwiuSFqsRFF32WnSE8Nc7S4FPBMLfTMdJVadr4vT9+TMvdh4kWi5UT1WfRx+DY0vV2sTRnq6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581017; c=relaxed/simple;
	bh=YjZZ/PgEjYNvr8pcEiIS/sYV77/sLXgR3jVgEMwMgZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axxbHjI60NM+3OE/y6YnyqWW+rm3xC/ozd7xZZvMFhwB+ygt8ip/CjHWb0PlVYZzJv2gokMI+QUpJM8+k/kDlXsbD6+KHh37zhaEKbo50z8PNsdt9fBGqTLhbuDeRqrkxlPLkbFt2CkwhPTgek1crge3RQ0JC9CceBPLfTBWSP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=g9obsqck; arc=none smtp.client-ip=173.37.142.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="g9obsqck"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1598; q=dns/txt;
  s=iport01; t=1787581015; x=1788790615;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qlBjLbbWHOzQMtsDD6gH8OJm9yf6aXkDkYWCkhUWpBQ=;
  b=g9obsqckN650liQ1BPjvV0sEEdNUwuqSeOeazDIJoP4sIDSFw5t5B4mj
   rprqdaW3WlFgPA1qoLmpBB0GXdR0OvP7QX8u1oPaIyxoNwjKNdFZmei6p
   TEA6ZGVr6zPQiTP1yJCR3hxa1Pgk03+EHzaKBR5Iw82jtQdIohkpbcTwQ
   SPE4UxdmPMY4aOil76ppORZ/2c95JKeKcVT5QVSVMnZVVWaAcHcygxs3a
   PJPvivhCS2csSNs0nWpdY0Xv1xEAAkZ+cAoF5TCKiLCma63cK4LVgd4mf
   sb94Q02QMx7+po4szjSPejGQCxFkGwEruqzc5tqycxf6Xy2a01DhHEZsb
   A==;
X-CSE-ConnectionGUID: x0nc4xriQg+tobB/AvdXtA==
X-CSE-MsgGUID: fLO9AkTlRs+aW4pyGQNpig==
X-IPAS-Result: =?us-ascii?q?A0BdAwArUYxq/5AQJK1aglmDS15DSQSUJYIhnh6Bfg8BA?=
 =?us-ascii?q?QEPPRQEAQGFBQKNbAImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4ZPDYZbAgEDMgFGEFFWGYMCAYJ0AxG+Y4IsgQHeR4FsBhWBOI1hdoR8J?=
 =?us-ascii?q?xuBSUSED2+FEIV4BIMuk1VIgR4DWSwBVRMNCgsHBYFmAzUSKhUyPDIdgSM+F?=
 =?us-ascii?q?4ENGwYFgR2BKIQQIxk2fIEJXoErKWABEheBCYIHAoJaggUCAUlDDgdHIgsYD?=
 =?us-ascii?q?UgRLDcUGQQ+bgeOXR+BWXMxSgkLKxeBAStQAZZ6sCOEKIwilToaM4QEk1uTD?=
 =?us-ascii?q?ZkIglmLMZVohVGBaDyBWTMaCBsVgyMSQBkPlzbHCEU0AQEBOAEBBwIHDgMLg?=
 =?us-ascii?q?WiQAi2BTwEB?=
IronPort-Data: A9a23:sXZO/68hpOmjAUaBZpunDrUDsn6TJUtcMsCJ2f8bNWPcYEJGY0x3z
 GNKCm6FafaOMGrzfNpxb9/i80sPucfUzIc2GgQ9/n9EQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4mvyyHjEAX9gWAsYjhIs/vrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kmZYsTpvZtAFhBt
 uAfIhpKRw6Pt/6flefTpulE3qzPLeHiOIcZ/3UlxjbDALN+HtbIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2cP3WjOX9PYH46tOW0gX37fiFwo1OOrq1x6G/WpOB0+Oi0YYKOIoHbH625mG6Wg
 kWX1mfFBisBd9WglSKU3UuKnu7AyHaTtIU6UefQGuRRqFGa2GEWIBEfS1a+pf63lgi4Vs43A
 1cY9AIgqq0z/0ymUJ/4UnWQonmEuFgSUsFMGuc37g2lxa/d4gLfDW8BJhZMZMEjvd07WRQl0
 ViGm96vDjtq2JWZQHSc+7O8rDS9NCEPJ2gSIykJUWMt6sL/iII+lBTCSpBkCqHdpt38BjLYw
 D2QqiU6wbIJgqYj1Lix9HjEjiiqq5yPSRQ6ji3eWG6/4xw6YoO5a4G2wVzG6/AGJ4bxZlWdt
 WQZn8WXxOYQDJ2MnWqGR+BlNLWk4PCfNxXan19jHpBn/DOok1amd4RX6zFWIlloPscNPzTuZ
 Sf7ogpc6ZNWFH20bKN2asS6DMFC5bTpD9X8StjScNtCY5E3fwiClAl2bESd2WHFikUgkagjf
 5ycdK6EB24UIbpowSDwROoH17IvgCckygv7QZH90gTi0reEYnORYakKPUHIbe0j6q6A5gLP/
 L53M8qM1gUaSuH7awHJ/oMJa1MHN342AdbxscM/XuiOPgZrBkk/BPLLh7AsYYpom+JSjOigw
 52mckZczFy6gTjMLh+HLyg8LrjuRp1463k8OETAIGqV5pTqWq73hI93Snf9VeBPGDBLpRKsc
 8Q4Rg==
IronPort-HdrOrdr: A9a23:u6kDzK2I8RUnHzpTj3Aa1AqjBJIkLtp133Aq2lEZdPWaSKClfq
 eV7ZAmPHDP5gr5NEtLpTnEAtjifZq+z+8R3WByB9aftWDd0QPCEGgh1/qB/9SKIULDH4BmuJ
 uIC5IfNPTASX5nkM39/A60V/wkwNWB7eSUoN229QYLcemvAJsQljuQzW2gYytLeDU=
X-Talos-CUID: =?us-ascii?q?9a23=3ATAHLq2tA1Us/nW2bwkG5hFcj6Is1KnvWkGfKIna?=
 =?us-ascii?q?3SnpuQpfSYEGcyL9Nxp8=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AILjo+gxWUiMM3H7B/DEdy3DGuPKaqKqKLxEkkqk?=
 =?us-ascii?q?CgdLHPBMsIyaytRKvQ4Byfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,240,1779148800"; 
   d="scan'208";a="819030592"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Aug 2026 14:16:47 +0000
Received: from localhost (unknown [10.228.224.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPS id 738B0180001E9;
	Mon, 24 Aug 2026 14:16:47 +0000 (GMT)
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
	Jerome Tollet <jtollet@cisco.com>
Subject: [PATCH net v4 0/2] net/mlx5e: Prevent stale XSK buffer release on refill retries
Date: Mon, 24 Aug 2026 16:16:43 +0200
Message-ID: <20260824141645.23700-1-jtollet@cisco.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787347981.git.jtollet@cisco.com>
References: <cover.1787347981.git.jtollet@cisco.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.228.224.45];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.228.224.45, [10.228.224.45]
X-Outbound-Node: alln-l-core-07.cisco.com

Prevent duplicate XSK buffer release when a deferred RX refill fails and
the same WQE is retried.

Patch 1 fixes legacy cyclic RQ. It is unchanged from v3 and retains
Dragos' Reviewed-by tag.

Patch 2 fixes the analogous striding-RQ MPWQE path. Following Dragos'
review, it now fills skip_release_bitmap in the common error path of
mlx5e_xsk_alloc_rx_mpwqe(), consistently with mlx5e_alloc_rx_mpwqe().

Targeted fault injection covered both an early allocation failure and a
partial 8-of-16-buffer unwind. With three consecutive failures for one
MPWQE, the original 16 XSK buffers were released only once, retries saw a
full bitmap, and a later successful allocation cleared it. A clean
20-second AF_XDP zero-copy pressure run exercised 1,575,262 buffer
allocation failures without invalid descriptors, WQE errors, or kernel
warnings.

Changes in v4:
- Keep patch 1 unchanged.
- Move the MPWQE bitmap update from the release loop to the common XSK
  allocator error path, as suggested by Dragos.
- Validate both early and partial allocation failures and run an
  additional zero-copy pressure test.

v3: https://lore.kernel.org/netdev/cover.1787347981.git.jtollet@cisco.com/

Jerome Tollet (2):
  net/mlx5e: Prevent stale XSK buffer release on refill retry
  net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry

 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)


base-commit: 4e15e89faac9f308baeb01f46c13a051814d2449
-- 
2.55.0
