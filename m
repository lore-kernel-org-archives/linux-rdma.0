Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BDD274658
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 04:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792126739; cv=none; b=JgXodkiq88CbLZ9KjAyemvH99xlZBSP65KdaTQT0ngUzUkfEDLz587kzb5KhFVIyPae/PuuMgcwkR79mdyxXsxIb8dL6AtSdyzGFSQuD2cNm6IL9AjvzWMi26ZtY1+SQXzKOVnMHBa11n2M2Zcq3ZsL5VlO8okwXz43/YC+OQbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792126739; c=relaxed/simple;
	bh=a2BsZE6dv+6I+aTRbpX17rDQThX3Q83NqPSPwlUFrFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nKHHDd+feq6G6m8kjo42SEKO0Z2A2UKrr3wp+nsN/6WL902/ZZj8RKTMrTjFQdJKGOBi2SbC1suAPSOjc50Bav6kgLia6V9ovhSPGneh1Z6OILQd5ww8a61QMdDudVRtktCsRhtnv3brK9RKvmmwKShFyezUsgaZAZSe04V1HxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JnxlVo9G; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnxlVo9G"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93cc31c18ebso405297985a.0
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 21:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792126737; x=1792731537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ygeSD0sT4ambcFZx7uodzqrYQ3oDSNoYKD5DO2Bfnek=;
        b=JnxlVo9GK/SxFWH83zIzE7Ln92P7qT8WzoJbKQaU5MxKnuGFIA6cF4tTHTABGoI7dS
         4G956IwfIP0jBP604igZtoy+aD5o9IuIUksGcAfYrYDGR/uY4qb6frDVuPGQMzN9meme
         ooWgXhfCKaPWCazuQVC9PvVbUjfBDzHOW+/vtARIaqZZRwiFfNwulsNqOv9X3JVaCjlL
         /OvuPu4GuGKuoe7SUCgagj5l5/5i1No1/wg8I05bI02/8OUgV8ECZ+vgJoAOgN5ASe6j
         UvF9x2MASDV0K1nGkJf+5+NG2VTxn6I6BjRCZJSPu7j9DLw0YEwbjq5jXWvFhJhEjnpQ
         adnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792126737; x=1792731537;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ygeSD0sT4ambcFZx7uodzqrYQ3oDSNoYKD5DO2Bfnek=;
        b=zI1GjsKHWEegmifu6i+TCGKmDaRxuyiQGeVI5RemVe+p9tmYJRrakx1gA88NJO4K+A
         Kd5hhSYTS5vf4DOu8juA3Y2+UCybVqceKDWGDzy55p1k/f7S1mccrZVWXTcEVldfHJmQ
         dHD24mv6KoKEvjau9k60bRQ06KPr1n+jZgcG0xPDHoYFPku0OoLsLJcBzHtni/Uq+SPQ
         IG5n7jhI0crY2pJThLvRtBk3HrBakfWAbAKlHva1xIO034pPayKFasdhJ7hMfSGn3ffa
         zfJ15diN3EPIShKNYqG/lgOQHpRX41cJsssJT9bNBneKzibQZde3DQ8hHS0mx+GGckhA
         1kYw==
X-Forwarded-Encrypted: i=1; AKwUvBzrwEYee3bq5O2DTCdWZCVO/rBhStn0kZ1Ve/2EIXC9EX6PWWVnX0PF018DT+RCnsKB6gYxw2DZw0+y@vger.kernel.org
X-Gm-Message-State: AFq9FYLjUW8Hy30Dz9zfsbiu3EbkTV1VUDAT3IJNYTQj5Mnl6wAJn2bn
	2sUTatmNVMN0isJPGRqlbAR8Nh59W4RwNx9VOnzrJhNEP7ABXuXvO51b
X-Gm-Gg: AYBFou0qHj0uQwQwNO8seN1bAeja90Qdio0x92eCWdvmVrv/Dg9DQIMrO4LjjbNeKX9
	UpiNMBOAiv9xHuhpqYFa8iZwF8HYpOZAQKp1pQbP/UK6N5qQ5Ddz8+jt8PfkGdpIWk3FWeXkBuC
	QA1PLlsa/VzPk2kz6y3saa5HhUY7pEf8COvd93q+gqPBo0bTXTHdq5agmzKblAvREKp3iGJP18q
	Zv4t9jKV5Lgha3pwq0psfd2lSTaOqBfC6+lFZWo5cS+Bwlzs5kDUbqnarcUVM7Pn0UDXxGO7Q30
	EKvehpD/hyr9t4Rcz9vMyiaEG//dNhsI/8TDPmop0OKAvud32pUt4sS7UaDVONECCWghe2/bv4v
	j6dEj3kT5ORi7DdO3qx8KhP9eq0P6jLLG4Wrc2XjylDvWWmvxQfpO0ivo6ni4VqV/vcubH+ryJl
	QBxzaFglGSC64BW5tltcvA+lmmgxPXWuSdp/FiFxhlHQzRGRS8o3zLdyLsCgGT048Kx4SrNxHTM
	7otkbvR5s2wK12zxTalKQ==
X-Received: by 2002:a05:620a:470b:b0:93c:2c0e:7ac with SMTP id af79cd13be357-93ebd259cafmr2987788785a.53.1792126737441;
        Thu, 15 Oct 2026 21:58:57 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a198372sm118038685a.27.2026.10.15.21.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:58:56 -0700 (PDT)
From: Yuho Choi <oss.patchbox@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Ariel Levkovich <lariel@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Alex Vesker <valex@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Itamar Gozlan <igozlan@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuho Choi <oss.patchbox@gmail.com>
Subject: [PATCH net-next v1 0/4] net/mlx5: Don't free CQs whose destroy failed
Date: Fri, 16 Oct 2026 00:57:45 -0400
Message-ID: <20261016045849.813696-6-oss.patchbox@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mlx5_core_destroy_cq() can fail, and when it does the CQ may still
exist in firmware with access to its buffer and doorbell record. It
also returns early in that case, without waiting for EQ handlers that
may already hold a reference to the CQ. The four helpers in this series
ignore that error and free the CQ buffer anyway, while their teardown
paths also free the object that embeds the struct mlx5_core_cq.

Keep the buffer and the object that embeds the CQ when DESTROY_CQ
fails, as the regular mlx5_ib CQ destroy path does. The HWS send ring
CQs are polled and never armed, so the HWS patch keeps only their
buffer rather than passing the error up through the queue open and
close paths.

The issues were found with a static analysis tool from ongoing, not yet
published research, and confirmed by code inspection. None of them was
reproduced, so this targets net-next; I can resend for net if you
prefer.

Compile-tested only (x86_64 defconfig with MLX5_CORE_EN, MLX5_ESWITCH,
MLX5_SW_STEERING and MLX5_HW_STEERING, W=1).

Yuho Choi (4):
  net/mlx5: Don't free the ASO CQ if destroying it fails
  net/mlx5: Don't free the WC test CQ if destroying it fails
  net/mlx5: DR, Don't free the send ring CQ if destroying it fails
  net/mlx5: HWS, Don't free the send ring CQ buffer if destroying the CQ
    fails

 .../net/ethernet/mellanox/mlx5/core/lib/aso.c  | 18 +++++++++++++-----
 .../mellanox/mlx5/core/steering/hws/send.c     |  4 +++-
 .../mellanox/mlx5/core/steering/sws/dr_send.c  |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/wc.c   | 17 ++++++++++++-----
 4 files changed, 31 insertions(+), 12 deletions(-)


base-commit: 2f2f7eeef8b0a1a9b9ca998231419873ccae8d4e
-- 
2.43.0
