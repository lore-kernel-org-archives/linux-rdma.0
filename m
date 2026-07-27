Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04523812DB
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169202; cv=none; b=pUG4d4jSXBwETYDkeoJwBalWANzl7eTerFBctzxaiF+ERoZ7SU6As85yp31V5GjpMrSUXjVPJUxe1VNSQQgd4lNqgN7RGyF5LzodRxUTdgyUQGKbbcOobWKhLDHWParN0dNSsSwwRUeqSLoj186T+Gc9QpCxem93+de7EoMNTHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169202; c=relaxed/simple;
	bh=uvWfaDTwPIsxFITsDU605dsZowdF2q8743gpbMsSmvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IYxraGn8B38av9D/1tQ2NE4pW1kZSszEE75rEeTwu8HRgc0yl0oylbBgs67asSi2CI3lb8Qrf1WMnFrSHN/8WtpTDkGXIajlJ0NcwF4/P9Ut/YjPbNQgY1hXjM4DsPM6cYgb0zdzepv6Q4wNHkDTLSo0DDCGXf8QfRuFyQzz89E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhY27fMY; arc=none smtp.client-ip=74.125.227.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhY27fMY"
Received: by mail-pj2-f0.google.com with SMTP id d9443c01a7336-2cc775a0dedso1302665ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 09:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785169200; x=1785774000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EBHchiXE2dARhW+lF5cUbUC3sGgHoglb/2VvCgkoEgQ=;
        b=RhY27fMYIYue75ma2GJbsWRhGiUIpA2WeKgyWxt3xWETp2F1mNl+L1WLF72yKzIzw1
         9ajaOKAkM56OsJYNNgkKw6FM3lPHD6RVXQLfTfAN4zyXY74ii93tUMoBUWCvSFTZp1WF
         d4rnm2N8k9kGZfI3SDQrLnCOZuPMBbXGYOsWLD3pjy26bv5biKZtTaLq7IUA40mlddN8
         MzdnYWhjaBgYqozmII7DvKfxco9uzd4db1+iUhZYpou+FwWfPAK+992WK9L7zUEReUPW
         dQ9hDJmGR1XtMmKAZ8K40aFKqo5hZ42c8XUd5P1QS3ULrLlgK48+aykvyotubM5clDdC
         vjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785169200; x=1785774000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EBHchiXE2dARhW+lF5cUbUC3sGgHoglb/2VvCgkoEgQ=;
        b=QCiuxAIeeaycBSa0l1jsxNC/TY7Fm4ejXi+0xTB7NowuDNnH+Uygrt8K+T90iK678Z
         Hu0wBucUMkD+BZKaSpApAOJKPewJ+ofSJNSnFK59NC61rcHd5XvuD7mCbz/oLkxO1YWe
         tnviXX2nZrdb00A7yskfW2PZan1zW2leo0Q2g/2cVfTH+rZWgISCtG/+llXvX03drv1n
         2s3SWWI3rSLd/C57U7x7XEVznn86IzPN2y+z90OeYCoKmo/kzaRtGxDpjuC6inbLddKA
         ytWyFzhXQtPc72ruEbtEunR0VvJifFC0jc99gp5lq17QQV6eCTABqs9nlws+PKMii05E
         VL5A==
X-Forwarded-Encrypted: i=1; AHgh+Rq/hgu3l3deanplARvE1btwt2avccMiUgdnbLRkfOVCQephUSNj2lszL9VzbzZkdgsBD/CCQtDGlgUn@vger.kernel.org
X-Gm-Message-State: AOJu0YyKDza2PD29G1IHJxaHSOoxFBthb6A6VVJzxrmNQjDKng/qPIiS
	QI5Kl9sq88A5fxFILpKGxMM5rmXJObBO6Zay+wg3R8sQSUOSUa8AUEsl
X-Gm-Gg: AR+sD11dwUEtr6xlEf28V0zhqpwcx3LQpJoQwV7G4MyUZSpPxB9lo2LUNh8YbY0AFkK
	V7K1fj9peYqrxRL8U/F0NX3HtYPl2cXullX4ifEqnBjuH5XOiR6X0o9JukAeltCxLYfiyX3VihR
	fWYt+z/jpzSqgGeOsikneOhnwaS0q5Por1MBDLDLele/nyGtDARRVKI0OaNzCUbjSBLMwKycoxq
	1LAVyqskIFf7u9chdRikTfNoqHxYUnaOxT9OzOMi01oqB5FIkCw+rx6sMEg/uUgz3B2o/qnDRYD
	nZtOR+ImTZD2Q6HNfo6GEH7Bb7d/tvWi/mYRtZBvL5ieGhnQK6o8l628Ob/rd0GCJ5L2SdM/+v9
	0ihHZqOU6G9baIf1pOzp48fYcglmq3lhRqFPqsklhQwDQAorTYZkQ2+mwIMQR1QtYeAFtug==
X-Received: by 2002:a17:903:9ce:b0:2ca:c847:8e41 with SMTP id d9443c01a7336-2d00e7f7ca8mr978145ad.11.1785169200191;
        Mon, 27 Jul 2026 09:20:00 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:2::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde5c7678sm38144985ad.18.2026.07.27.09.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:19:59 -0700 (PDT)
From: Stanislav Fomichev <sdf.kernel@gmail.com>
X-Google-Original-From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	anthony.l.nguyen@intel.com,
	przemyslaw.kitszel@intel.com,
	andrew+netdev@lunn.ch,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	maxime.chevallier@bootlin.com,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	aleksander.lobakin@intel.com,
	horms@kernel.org,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	witu@nvidia.com,
	alice.kernel@fastmail.im,
	dtatulea@nvidia.com,
	yoong.siang.song@intel.com,
	martin.lau@kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	leon@kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>
Subject: [PATCH net 0/6] xsk: harden TX metadata validation against races
Date: Mon, 27 Jul 2026 09:19:53 -0700
Message-ID: <20260727161959.885642-1-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cen Zhang reported a KASAN out-of-bounds read when AF_XDP is configured
with a TX metadata area smaller than struct xsk_tx_metadata. The metadata
is also shared with user space, so reading its flags more than once can
produce inconsistent validation and processing decisions.

Require enough space for the flags and one request field, validate the
launch-time field against the configured metadata length, and use one
snapshot of the flags while processing each request. Carry the validated
decision through completion handling so later user-space changes cannot
enable an unrequested completion timestamp.

Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Link: https://lore.kernel.org/netdev/20260720155210.34229-1-blbllhy@gmail.com/

Stanislav Fomichev (6):
  xsk: require at least 16 bytes of TX metadata
  xsk: pass TX metadata pointer by reference
  xsk: clear metadata pointer when no timestamp is requested
  xsk: validate launch-time metadata size
  xsk: move xsk_tx_metadata_request() to xdp_sock_drv.h
  xsk: validate metadata when processing requests

 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 15 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  4 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
 include/net/libeth/xsk.h                      |  2 +-
 include/net/xdp_sock.h                        | 45 ++---------
 include/net/xdp_sock_drv.h                    | 77 ++++++++++++++++---
 net/xdp/xdp_umem.c                            |  2 +
 net/xdp/xsk.c                                 | 11 ++-
 net/xdp/xsk_buff_pool.c                       |  6 +-
 12 files changed, 101 insertions(+), 71 deletions(-)

-- 
2.53.0-Meta

