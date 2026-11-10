Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794283078;
	b=qzuyi7nrsLU3q4xMVEjiTkATPdOgX/TqT2Myf9fY/v1iVkeobOKk+cyC1EJKxNIggVlA
	 GI/K83Zicl7V+NDkcdDH2QAlpkbw3Uueh+/PrOaCCKZczC8K0P/gN8hTQIxPJ4rB/g0bT
	 InXKxiuLw2Io9HE5oETWftW9M4bg8yq4caxVCp1cIocaqiAe+cGqiGpLWeBKFC70DZg6F
	 n6ay+Msc6Vr7kPnsx3V4mD5nwAoO2thkencM+J+eXl77W7lcRL2FHnfyDPiB8ra4Qt4Hf
	 yBYiXsfR9GjzDj8K2orwmOnTysaPWJS02asvzecXU6FOx/RqXGQ76+5atch/n/+Lx/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283078;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CXkr2SuKnzOJFNr+1uuWJMDmIGWuxbgW0PPb+hSRh9s=;
	b=ydPTA0TEp/Mh8PavS7Epqc+opVeQPASM8k9XDNKpfgDhoP+mKFVd6poOccOQikJnESHJ
	 Ec1VCH+9AIK+KMpbmzrDFTDhdXQxSEKhLeZ5gyl0dc4WRuHGyd71DwhMMMoPeUrH0/mRC
	 r0mgOybuqUIUfdIhxDqFOCJUqfs/pw/X9bxb3d4uBJXjpGrE/t584Vgrz1zE3rrF0HjE/
	 e+AEJzuc9VJqU3cx/nCSrhzVQkV7l98Nt4KrIVp1CHaKe70qEmdX2z2WJJHeg5eJJlVTO
	 9UvlRGu2BL6Tw1aSicttr5RaUKMT2K+ffg3TNzDf2R2a4cIgZQVFnDHu/Pkf7yD3/gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eWioS0GS;
	arc=none smtp.remote-ip=74.125.227.131
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E259A606A333
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 03:57:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E259A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eWioS0GS
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3ada6c66964so478996a91.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 19:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794283077; x=1794887877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CXkr2SuKnzOJFNr+1uuWJMDmIGWuxbgW0PPb+hSRh9s=;
        b=eWioS0GSjJlvh6ZHCBGxaaeRsfQzkJcz33RP+AaoFNuh3hDMddsz7w5znvRQzJ3Dls
         n+Fg0ZOheqMQcJc8Q1ya9lPIqyKWWgjAjKOQmXd7s340JImqVg5F9F4RUxdITsykRs9P
         jV9CUDMEkySfso4mcRKycLxZnApuuoxPWjmekbsYqg2akOLS+2tbI/jH4KehIv7IwDb6
         2RaVvTZegBY6dX+8qAyKHxsHqCSZ0ti8aBCLCPEiAimi4Q/mU5i3/x0xdSNTeRataRu6
         m/ZMf43HMHWsEfeym+ATo4mX3nBntTDnUgOq+qsJJZJUEPkrEArzQjHCZxTFPZYI6sBO
         676A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794283077; x=1794887877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CXkr2SuKnzOJFNr+1uuWJMDmIGWuxbgW0PPb+hSRh9s=;
        b=lLEsK7E0ggmXA6p/cdZahmsuKD6xcxkIo0JApGKTXcAJAYStB0NUV4PQ+SwfiaAU73
         H36Kj4fIjHVHg2IrMfQj90vrtZMQc2KL7V451OjD0cyY92awd8BXquiZyax0sqvceqN0
         Dm6NI//xHBhmoyUEuTy+n4sFnAQ/16k5huo4E0ZTvjcgPQvxOMJUNjv9R2djOvDoGzro
         eu8hHU0RXEOUPGoJvr+nldhn6801CQAGihq5NvClxIr3iYLEVD7PCYdc3hMWMZc+2Nxl
         D6nin0nL9rWOvjnay4+wnFd+usjboJ8XEvtLMhZrFJDG2ecSAy+NhQ6rwhSgPP1CqSYu
         JF5w==
X-Forwarded-Encrypted: i=1; AL+hErFWedIg4XZbtBtyunX5j/1udoB+br7ErqjyhAUnoc0Km8IqgorGG2Er9ccY5XsAAqG+CXY5fJOgexus@vger.kernel.org
X-Gm-Message-State: APuU4Z/Q494Rk7UnnpLqzOEjMIMSdYfFT4GVtxevnFAmIR7ldth++nwK
	IREHOoI2A8EI67VuHMnk0yeSttgwVK2oCRuLEBFelvteSKUCIn6PFEQy
X-Gm-Gg: AYBFou1R/aVmawmqEZS1up2Q0AKSKfq5TyFa7XmhauGgze8UlcDQ1f4ySgoLg3W15jD
	ytgqJXSDW/gsumycYREP1i+fnVyB4Sge2+phoMOiHUmKclDK4QnlyHTKpHbuv7/foZ0vzB8k1PR
	LfOKqIXsR9dM9DocMaUv250jKtLS2yIXXRavaZA0nOiBU/8TddAzKvINPkU4hdyM6OJFHRec9Qp
	+hJuNkxhkBV/Fc3LJCRFKepzis+4ZuZet/S5mCgHLMPvuSa4zKK0PeySzDmpGnf7R1Rw42c+CNI
	VbrN/KG1H23FpdeIXbBebFd3NgqndGMVG8Zlw8d9HJI/j4r68S2s71/t+LhiaLtb+alZAOMn1ya
	yE1pR4M+1yvlqT59mrQHeAE/itNRnoscMRL/YpGpLFst2Hw4vGqum+YkopA21ZcuGfzDZPU/JFN
	uQjhS3hJ79MVHhbiPfe5QumCVVr+fo12GA7J5tLX/6fjoeMieA1qisXQVKM4n8wlwux5U1ywL4J
	EBcXhhnAeKp7bKvoHZbFhh1Me148TJ0stvWm3LY4quoyx7ttaHYfJsFVHrwWFmXzxUuKDJj1Zgb
	eIwLe4EaVl1geM54VgNp4TXaq55L5G9UhsYFIYjUriyk05U=
X-Received: by 2002:a17:90b:4a48:b0:3b0:d365:f8ed with SMTP id 98e67ed59e1d1-3b166cd7209mr1698733a91.21.1794283077269;
        Mon, 09 Nov 2026 19:57:57 -0800 (PST)
Received: from localhost ([164.52.124.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d7b37casm322833a12.22.2026.11.09.19.57.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:57:56 -0800 (PST)
From: Jiabin Deng <dengjiabin2023@gmail.com>
To: netdev@vger.kernel.org
Cc: Dragos Tatulea <dtatulea@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v3] net/mlx5e: SHAMPO, Disable end padding when relaxed ordering is supported
Date: Tue, 10 Nov 2026 11:57:23 +0800
Message-ID: <20261110035723.26587-1-dengjiabin2023@gmail.com>
X-Mailer: git-send-email 2.56.0
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

When SHAMPO and relaxed ordering writes are enabled, aligned RQ end
padding can corrupt received TCP data. Due to reordering, alignment
padding written at the end of one packet can overwrite data from the
next packet.

The current RQ end padding selection avoids alignment padding for LRO,
but not for SHAMPO. Extend the condition to SHAMPO to prevent this
corruption.

The issue was observed in a two-host test using a BlueField-3 NIC and
an NVIDIA H20 GPU. In the original test with MTU 1500, 354 of 400
transfers contained corrupted data before the fix. After applying this
change, all 400 transfers across eight message sizes from 32 KiB to
4 MiB, with 50 transfers per size, completed successfully, with no
incorrect bytes or corrupted intervals.

Fixes: e5ca8fb08ab2 ("net/mlx5e: Add control path for SHAMPO feature")
Closes: https://lore.kernel.org/r/CAFxp=AY2cVRQrZvB9WNnigbsobuw11NMG-cagHx0_V+ur2ToFw@mail.gmail.com
Link: https://lore.kernel.org/r/atZKOtjrb9HKSNHF@dtatulea-c5.nvidia.com
Suggested-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jiabin Deng <dengjiabin2023@gmail.com>
---

Notes (shampo-submission):
    Changes in v3:
    - Use lore.kernel.org links for the original report and fix discussion.
    - Add Tariq Toukan's Reviewed-by tag.
    - Cc the netdev maintainers and linux-rdma mailing list.
    - No code changes.
    
    v2: https://lore.kernel.org/netdev/20261109034444.11241-1-dengjiabin2023@gmail.com/
    
    Changes in v2:
    - Clarify that the corruption is not specific to GPU or DMA-BUF memory.
    - Explain how reordered alignment padding can overwrite the next
      packet's data.
    - Add Dragos Tatulea's Reviewed-by tag.
    - No code changes.
    
    v1: https://lore.kernel.org/netdev/20261106083719.22798-1-dengjiabin2023@gmail.com/

 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 5caf7820a136..159f79302a08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -911,10 +911,11 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 
 static u8 rq_end_pad_mode(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
-	bool lro_en = params->packet_merge.type == MLX5E_PACKET_MERGE_LRO;
+	bool no_pad = params->packet_merge.type == MLX5E_PACKET_MERGE_LRO ||
+		      params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO;
 	bool ro = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
 
-	return ro && lro_en ?
+	return ro && no_pad ?
 		MLX5_WQ_END_PAD_MODE_NONE : MLX5_WQ_END_PAD_MODE_ALIGN;
 }
 

base-commit: fafbc4051123d5459ea6950899cec08ed946e278
-- 
2.51.0

