Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794148020;
	b=EGA0hCk0EySh0LxlVjgbw8QlU6TBDzufd1q3yFFHk3W+jp+ob1maSgxuFw3QkcYLLm//
	 l4u16g9lSQ9MQsuirQSLs1cXwOoKq1MF9KJ1+aGHDzweHasIR1tTBw2fKlYkdFSfbzbhB
	 oBcWno7dDOG5ys6zGhcXfPCuu0gdf2y/PD5n7NT4MoRa4vBJb+62laO2Zw36tmEpCoRb9
	 6Kl1p8QTKLpcOIK+1g6Vvj3nQ5VVZ8NCnAmGbeN71hkPgQz81Vx64fL0pwKIpoUStABBb
	 prebzjJjYhQfwPAEKqTQA1CH2g/nAj+iIOFmQ0jkG8KxXdNzky786QjwofUMNXNxxrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794148020;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=HFFMCIabuDJl1dk8Y6onVW1hr4NVtO/ZAth8uZTKrro=;
	b=BV+7Xni0IvgcWLCgT/kMcucZqmhvtOB4U+mctQr2cCoxug+CruPWKEY3PAwiVCDB0dbQ
	 bkPMyAWlI6ijkbXoFEddq9BO0fvScMQY8j7XGpmN8x77zijR4oCgItKRSrGL+15isyUNY
	 OgSKg6dvoTs1igeKNCroEBhLproy3w9VcLMt9ItYdgR+vuyIuoyW8m9fz41Z5chOTcu0i
	 XJx4s+6WIWyJfBDGWxrV5VopdZ6jc/DgWCWzY7vBEuZjpY93P4GpI/M6xLlTFqAyIkFDy
	 YODw44NwBIuU/AGFNHiLESAXLuZetcN/K7yFo0aW1MyR4PapoSAf6xmqL4rIsuYhEFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=euB1lDC4;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C8E606A31C;
	Sun,  8 Nov 2026 14:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21C8E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=euB1lDC4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=HFFMCIabuDJl1dk8Y6onVW1hr4NVtO/ZAth8uZTKrro=; b=euB1lDC40g1yzMKrSGjk35dwQ0
	VKyG0Aiszyex5H/P+P3iHUmxpchzph01kDndlrCxLAzgnaS+0VIGs6zxRCymeCaE3/9MuotjplSuT
	fB8ntYhOOAgVW/zZKr5eGemFqPu+bAgiLOPkyiCbOBwX3AfxoQsakw10v9BgGrGJAsi2fQPQDyvuE
	xLUMkUHZK0akgl6FmAaaD3ZK7hnceBjEWlh4LyZBMB+xa0RGBxRKfn24FACy5hIXhdAxW3IoMWk+w
	YJXoWKQyyKGuD+qPPBqJG5CjnX7oGOkp8XUCmwhCL1Qck5gbX9oRRnfuRsA4Q90Id6rV6tro+chvL
	X7VDpU5w==;
Received: from [151.115.150.205] (port=49652 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xQ3rF-00000008IcJ-06wZ;
	Sun, 08 Nov 2026 15:26:57 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sabrina Dubroca <sd@queasysnail.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Boris Pismenny <borisp@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH ipsec v2 0/7] xfrm: fix ESP IV generation and ESN authentication
Date: Sun,  8 Nov 2026 14:26:45 +0000
Message-ID: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Hello,

This series fixes nonce reuse in AES-GCM and ESN authentication errors
in the IPv4 and IPv6 ESP offload paths:
* 1/7 and 2/7: Save the current sequence number before incrementing it,
               so that GCM IV construction prevents nonce reuse,
* 3/7: Use the current sequence for software AAD and hardware offload,
* 4/7: Give each early GSO segment a private secpath,
* 5/7: Use the packet sequence directly for mlx5 IV generation,
* 6/7: Segment untrusted GSO packets before allocating sequence numbers,
* 7/7: Keep the sequence counter unchanged after full ESN overflow.

Note that triggering the bug fixed by 7/7 is impractical: it requires
processing about 2^64 packets under a single key. Yet, I still believe
it's cleaner to fix it.

On the crypto side, as a reminder, reusing a nonce under the same GCM
key is catastrophic for security: it exposes the XOR of the plaintexts
and can reveal GCM authentication key, which opens the possibilty for
an adversary to forge ciphertexts without recovering the AES key.

This series combines and extends these two individual reports:
* https://lore.kernel.org/all/20260925095105.446269-2-Jeremy.Jean@oss.cyber.gouv.fr/
* https://lore.kernel.org/all/20260925095128.446450-2-Jeremy.Jean@oss.cyber.gouv.fr/

Recent discussion with Sabrina Dubroca may also be of interest:
https://lore.kernel.org/all/c443bad568f4e03d05b848b1b245707d@oss.cyber.gouv.fr/T/#u

Regards,
Jérémy

---

Changes in v2:
- Rebase onto ipsec/master.
- Clarify Patch 4's description and comment.
- Remove the duplicate mlx5 IV helper and callback in Patch 5.

Jérémy Jean (7):
  xfrm: esp6: use the current sequence number for the IV
  xfrm: esp4: use the current sequence number for the IV
  xfrm: esp: use the current sequence number for AAD and offload
  xfrm: prevent AES-GCM nonce reuse after early GSO
  net/mlx5e: Use the packet sequence number for the IPsec IV
  xfrm: segment untrusted GSO packets before sequence allocation
  xfrm: leave the sequence counter unchanged on ESN overflow

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 18 -----------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 --
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 31 +++----------------
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  4 ---
 net/ipv4/esp4.c                               | 13 +++-----
 net/ipv4/esp4_offload.c                       |  7 +++--
 net/ipv6/esp6.c                               | 13 +++-----
 net/ipv6/esp6_offload.c                       |  7 +++--
 net/xfrm/xfrm_output.c                        | 16 ++++++++--
 net/xfrm/xfrm_replay.c                        |  1 -
 10 files changed, 36 insertions(+), 76 deletions(-)

-- 
2.47.3

