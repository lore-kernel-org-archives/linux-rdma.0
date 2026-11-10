Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352397;
	b=4Cp3ArL8vI/p5zZRBE85Hj9mLGusPp2P0n5G2yl+GWoW8bvFwN0bu/jQG5FRjFtRDNes
	 T0wIGV+4ISTKDLkh7YgRiv6WGOULeqLGlnGavHNrWRi8V0aV7xVzU7Vw2OHn4eMRYcflp
	 qyvOK5rcw8++VOwXUVV5t1YdKTtr9otC6717VpJeRpaP22e6SOPjcC4Z0UBxsQWjZNLhg
	 vxXroOJXsp3LFP5vkrPMQuxF0X7vLuEN4V3t0CbFXlYF0QQMIXqK/iKMspsnakGi8Feni
	 rAoP9G1PqdpFwXovCtMX2qpDWc68k5G+k1WmS4C9IPrmzJOJad8TExi3TYqiRW44uGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352397;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KsKueNaLCcMcO8fOomY84U8+zo1sTWNNmG5cOs+hZOY=;
	b=QZE1zXamaJtpgnnf+45KuLt09ETB5gyX3Ld8UygS1A6fxp7Nd2CTJkAn61GVPaPiogGl
	 lN6pyrThzRcMbZo3cyWL5AFh82e/O1CIuXbLrGBfdvTQi1ekTDbV7RIVQwRSBMtNCVaDH
	 yZIX7wVfnB9dO4rdHlvuSMJtU6eGjmd6n76hZ5Igc2sJA8/AlszlHRAVCsGr3RgYgg5xP
	 +yTxWh5x8+epFG8tGhIZi/SC7HTSk+UXqGJC07xWrUNIeAzyyw0ub9HL0vd3TcsMgFyzA
	 qwxthhJZiUJ0vyb1OCwE5yBY0SVJyFjOKa9o7ai3jdpz/qqi0tLWj0CmPeOxCRYoxCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=FK+2VQx1;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65A7606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 23:13:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C65A7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=FK+2VQx1
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cdadf7e248aso1030828a12.3
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794352396; x=1794957196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KsKueNaLCcMcO8fOomY84U8+zo1sTWNNmG5cOs+hZOY=;
        b=FK+2VQx1Rck3gtirbWEklE18mufWggWNqt0gkFomavHdTH2lDK6wGCOKuhYvkSs168
         JWb6GCiCQekKWDzmzJP+23oUZfYNKz3VcLEI4aXD8857RgT1zdkM6HJ2yD1+K3jat6kp
         FFqOGlsxx5PC4PG43cMC/K2o1FVC9ueUrziRxN8vlsAonFweSnZnQGhmMTv4OLKcRcEK
         XzPBZyn6/fVGad47aJPMDHw+fi5A6trGw75sM64+F5ch/tXwpCHR6ieTrqkkU7lhfP1o
         L8zcig4Fd9NOO8DOsX5+ReXw9f9YHDYolbqs27VMYF4U1J4wNt2kpYyv0yuGdHKgf/gB
         aBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794352396; x=1794957196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KsKueNaLCcMcO8fOomY84U8+zo1sTWNNmG5cOs+hZOY=;
        b=rfGWq6Y9LNw2ALT/fJd/ZU6LtqSKyFpEjOG1VYyd+rIa9cbmfovMpu6UQg83W5rEtf
         czEQypK/BpQM4lqGdMJ6gtZDnIwHQvAM3815zsg6ZdVaCDE7WcOPR69vig4MsLMsRTQi
         eOmxoA0hhPE2x1tCi7JxgCOn55/adCMStu1iPjBMqwn+ZXXtsehZYJZE5jI497zmjlA4
         YV2wljfvXd6gXYDRKG8B8PoTRn2lvzpKoMrM2hTUSvrbLcSTdCdG2s896mAUiqiXNZka
         +zw9Kmm67IVt4KoQb31JOb12Ysgr+I8jnPOyOHdovkcze+WjdXYiWVxUzszAJtJB1CBg
         zNzA==
X-Forwarded-Encrypted: i=1; AL+hErEGiWY0FY+KlEeA0oCTubGg+tH+BwYiCrDKm0JZAgxWpbQccGhJMe5aw/j1WOMNHZI8KIp74PLfpn3r@vger.kernel.org
X-Gm-Message-State: APuU4Z9qnwW0KDXjTo0S2k/7Mnj+EauF9aUFEq9JWpLpIh1WkSrOnBbJ
	Kv6LIL/+rs2FgAUBZyNT4PssS4iQJjcUyoQA0Gc5LjPds6rCOV3uGqEBlTBEyb5qgJ8=
X-Gm-Gg: AYBFou3VNvWrRvvogX+1xDCKP0G+l6XhvA8FMjKCE8nTnG3l1To6Z0uN8hmqvQnChD+
	5bRk1N0fHERKPRbxihBe2fVzD+xAi5h04OnvPoSfNwqJp5yK/Vopx0ax29HQSHguP6+KyZ9W5BV
	vKBCb1p7bpHy5bjw6XjCrz2EeoNwN2DP9SD/Q4g4zgXLlBxXXbjhPLeUsYA2NLi3wuQMtAVrKa4
	xnAg2IAgf72Eh6Bj3DIKO6BfcWqJQuTbY+IqakE7tjOM7WjkqHA7X6PXB5Zcmt4sTn3sbif+RHe
	Fx3Sc/7nwiUWYFGHDiACf3IQAEoXALfMOlPwuikxPsBfWLmLGcS5JK78anpY1dLcESr87DVJVJl
	BVhnsLqitsO4E7boZNVdd/z1/eoEJWi17y3ZJCAjBk/f19qe9xUMU652GeyxAprH03sKefA9oH+
	w/7p2Tept3ZppAHpzNQfq+9HMzfZuaM7mU4FMK6VoYknu7vXIxMcNsBtCnhxLkSvpFSExTRbQJ5
	E52ncOKCJI2poAnr4q2V/amRSDQbw9xlD//2GLpIO3WSSwDoYF9b6bHCaCqijIwaVmlqTBBJ4hD
	m8THBKAacSSpYLJJYrMZUiquDMMDbp90SCTYRUHHJA==
X-Received: by 2002:a17:90a:b107:b0:3b1:83aa:5b53 with SMTP id 98e67ed59e1d1-3b183aa5ed3mr229122a91.58.1794352396089;
        Tue, 10 Nov 2026 15:13:16 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:7::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17da51f80sm1524296a91.1.2026.11.10.15.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 15:13:15 -0800 (PST)
From: Joe Damato <joe@dama.to>
To: netdev@vger.kernel.org
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-kernel@vger.kernel.org,
	Joe Damato <joe@dama.to>,
	Eric Dumazet <edumazet@kernel.org>,
	linux-rdma@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 0/5] mlx4: cleanup and doorbell fix
Date: Tue, 10 Nov 2026 15:12:54 -0800
Message-ID: <20261110231304.1859217-1-joe@dama.to>
X-Mailer: git-send-email 2.53.0
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

Greetings:

I am working on adding support for SW USO to mlx4 and the branch I have with
those changes locally is becoming a bit long, so I thought I'd try to break it
up to make it easier to review and merge by first sending this prep series.

FWIW: I plan to include more detailed data in my SW USO series, but I'm
working on SW USO because it significantly improves performance on hosts with
an IOMMU and an mlx4 NIC. I have a lot of hosts like that in production that
would benefit.

Anyway, back to this series.

Patches 1-3 factor common code out into helpers which currently have only 1
call site each, but I will be calling these helpers in the SW USO code I plan
to submit next.

Patch 4 and 5 add code to track when a doorbell is deferred so that the it can
be written in the drop path. This is technically a bug fix (and I need this
to avoid the same type of bug in SW USO), but since I have never seen this bug
occur in reality I am sending to net-next.

Thanks,
Joe

Joe Damato (5):
  net/mlx4: factor VLAN parsing into mlx4_en_prep_vlan()
  net/mlx4: factor csum flags into mlx4_en_csum_flags()
  net/mlx4: factor HW loopback DMAC into mlx4_en_set_loopback_dmac()
  net/mlx4: track whether a TX doorbell is pending
  net/mlx4: flush pending doorbell when dropping a TX skb

 drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 95 +++++++++++++-------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |  1 +
 2 files changed, 65 insertions(+), 31 deletions(-)


base-commit: 97ced2c090bfc2156db31fca9f52cf253e4bc186
-- 
2.53.0-Meta

