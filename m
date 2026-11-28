Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795876981;
	b=zg6wU21nCMYKT/jgiRsVNQM7dSK9nJNOqQkpNIlOXjQlWoYik81++6MltTLgwatjYnh7
	 +Ge0u1e7rGHyAwXec+Rh3dAiGTAd8H5Xp56soN7ZNF16mfRvrmwHX+jn1oKglqts9RpAs
	 vEQ7CqSl/AMLn7cyXOYVs6ix2If/gUubHukl7Ukjs9n33JAHpVzszOXR4eWEHS9+IEwrU
	 PCop4klYnGwWI4hok2TSBu2/lC6kIW2b6yHtaiVwUhgKUtO/kzpzCXUtwRZMmmYtcm8lr
	 PcPL2TPHsCu3E7meBerfUBIHuN26vUWRig00iGkfX+l7dSN9vo14OIakHWF3jvvvwxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795876981;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9JecI1SpR/owvvV2sdC8RVebXSr0RVxMT35ip4x8cVQ=;
	b=rR8l/h1+3KsuYVbeTXYjWNKxH6DF8M78vazaD4Eq/T9Oe218hdKWFToscp7B6J8hOvWr
	 UD5SpZoAaepC6Xj6CYkTnWeQsMAi/DWRm2PC6ySCxfJrHbr1G/chELm4oHZE/i5hAx3m/
	 mYVj2jeUH2Ybc5XOg2tGjXmMBSGtdKNSv5znAMsVJ1iszcZDPyfDWO3IQt686Yxp0xUl3
	 NFOBD3iiYcs55Q3m977pAfb77PKEKtAzDJDkoYVC4n/EWbmMFZUJCiYAQITkg3kfknPO8
	 LNCcNwg5r9EOWaXh0Vs580tJ+j2NtnlhRY4ASsiwKy+Ag2yuqKJdVNhMeKf+Ok+rO2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MoI80TeN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CCB606A31C;
	Sat, 28 Nov 2026 14:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MoI80TeN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915761F00925;
	Sat, 28 Nov 2026 14:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795876980;
	bh=9JecI1SpR/owvvV2sdC8RVebXSr0RVxMT35ip4x8cVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MoI80TeNCEHJ5n6k9xD5tJYgtY8VKNCHQSH1FkED07RQipQCsoAP+oS5aD1cjcbe5
	 o9QX+eqIUNQTwuHT20A/k87Iq2Ms7ekAzCuEuOkt+HMR2Tu+PApy0SqBO8XRDJs6Un
	 ZAAZDuR03lmYYVarivAxLz2h91X/6L0ILrft3iQx4bLhbCB9XfdItDr/udGltNSMhk
	 qKSqb4H0U89PhoUDUKZLsS7aDiP/HSCqqIGR3ic+JH/UbqwGC7kST2ZKpAzo2e8hU8
	 pK5XVDGxLZFCp607ItUYZNMTajRqoZaMjJJ6J89K134bWfjIjB0nK0n6a8NFGFRnO1
	 /fzf6z60FRHPA==
Message-ID: <sashiko-outbox-238800@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 0/6] net/smc: fix the failover cursor switch and
 wrap rollover
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261128-b4-disp-360e65c5-v2-0-d9c05004d430@proton.me>
References: <20261128-b4-disp-360e65c5-v2-0-d9c05004d430@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 14:43:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 6-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128-b4-disp-36=
0e65c5-v2-0-d9c05004d430@proton.me
