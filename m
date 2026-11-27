Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795816698;
	b=48Uu16jVDiYGvPWD3PELtraLxXiVd9S23oWblFv9gl4LOw+CSsKy+fuONm4q9JlT/ZGr
	 1p7J4AjnfRJDi7BV/7ZKddCKPXX+DCsvvJ0OE2p9mHJ5DGU8K/CgLs1KKrf+gEmbPZJYL
	 bsVnPIWPOap2MUx/J5ep6MRm6PY8DXmm98p8olIcFBeciVR0Q7wSjzhek3PqPs9CyJSLh
	 90BtFXQq4Du65qpBh5fm3WxhsVcLYy2yYuD2/X5A7wEcpIxb3/IVwFc4bHxPaE2iZVlgV
	 iei3kITEjKvgUBFk9Ryp7LKRTdxfdpZia+zqFhq2BkUhAhcDj1PvpumZByV6XmSqgDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795816698;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Rlu7bmV1L7HSrYVjLKEZNMCKaYUuVTJgvh3mWEoorT0=;
	b=1j0M8PL+AgBc6vk0s1suXa8i/4KpdCVPBunsNWiloKmHeB3q6hI3aRQIbu3p9uG0s/GB
	 P7EMoeZISWAYZ+qGNVNa0dcoDt1/QvwqSaYFO9XP+uGqgEHmDfwUerfJi5Guq/BFQkN5x
	 cqGml9SiZFT/LtFHztJWPLKBzp1yw5CGHfOU3uYOxD2Rg1iO3xbXgGZg76IUE6icUJ7QQ
	 SNrRM4GCqhVJcqkS3X2icRtN3waL19LuwI1nCxCQFl4vsp9WOHrShmvGqMCCeI/RSkre0
	 +yexjBLL5lYMIw/FYrVhw+tEI6/BRDI9yycj7UsqOFitEoOnLXvF/NrCa+FhYtfwhbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hgqZzls5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA56606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 21:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hgqZzls5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45B41F00898;
	Fri, 27 Nov 2026 21:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795816698;
	bh=Rlu7bmV1L7HSrYVjLKEZNMCKaYUuVTJgvh3mWEoorT0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hgqZzls5FaVzWpOArgtlpgu7B1l2yKbHI7dxmocY3mPgZPUCSbhw/UBnt4Ryx+yXB
	 LQYhb2/1izf3iuu5PiWml/8c9um2HeoBqfC6tE7Pi3Rj+tmgtWxqX65fdQz+OGPqzs
	 FN6IVd7uLMXtObWGjLNuGhWb8khDzcU+Hd87zdJ7bGmIJcYHowxwez7SOqkuCjMiXY
	 XvAnCR9Rkn/oPT6NO8hYsqTJC+BmslSzx2LBEOwahDWdy1suRJ1VlFcI+xr8+ER8Ef
	 DM5Ns+vBm1C+v+FDYXebiM6/HDTCr2iDD/kAz5QD9IAYKUnUoddk5mCsOg2kN4IJOr
	 AZ5o5MVWSqxWQ==
Message-ID: <sashiko-outbox-238314@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 00/10] net/mlx5e: Fix IPsec SA races and neighbour
 handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126215614.792598-1-tariqt@nvidia.com>
References: <20261126215614.792598-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 21:58:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 10-patch series:

- Patches 2-4 and 6-10: no issues found.
- Patch 1 ("net/mlx5e: Initialize IPsec XArrays with XA_FLAGS_LO..."): 1
  related pre-existing bug noted
- Patch 5 ("net/mlx5e: Drop IPsec tunnel traffic if the neigh ca..."): 1
  related pre-existing bug noted

Detailed reviews have been sent as separate replies to patches 1 and 5.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126215614.7925=
98-1-tariqt@nvidia.com
