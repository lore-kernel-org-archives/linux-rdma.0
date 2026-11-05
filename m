Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873826;
	b=dNU981mpVZu+eSC532Jf++YxairGtSuSfWmOmu46SqtrxzyC9RAA3LNcZWfqDOtYIJ1k
	 gphS+gDRGszxaPOQAwbeV6prO5VXKKMtAY4d1DNH+cqh16iaGgV7NzVVmnDRi31d4h0AI
	 HWMbDPPUZbQ242ZW/uXp0bEPLB0S6kqhpqtI10F/3UnDlSDdPW0jdV8Mw0l9fkx+2fwZi
	 supNHpWLuHdN4G6xjvUTwOQXaX/eZ6ivFjvsAr+c9YA6CvmsCE/8CB66n71Ta8kyi0x3w
	 M/hd/kP3dyt1zAii3Ni2CgR+RcyokgnBifUrwv8UpWo4i8yTjhznvdCSTmfDzWixU5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873826;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YG0lDmY/EQUEb2juPEQ9C/YGBw4zklymEC/Cpw5PHxo=;
	b=wVFZaPklXrSXtUgCRxCT7U3AAeAoD56ssHPbyrHFPHWwIYIfLaTzwDJGQgxIqJxlsi2u
	 yQ0nJFyob5HMlRo/rvfKyP3aDZIF6/sJJtJ0WpimsgLFLWNQPuO6fCJS0EDny07/qcBgG
	 jQnEXI4JQWYgI4Q5nHKq7NXNOj2+WewS9GsbzFkx/D7ibvdPKo/LNAdvdSNpEUc5iJPPG
	 pcOBizCMKP3q7HjHLy+P3gjp0lF1LQ+S7+x/wR/+F3uFp1c21EOZkGIzxRFcb3+O4eBkg
	 YnM3KkuFKbAMVxcF0AqDtfcumAqcD5v0W2zjxm+rcCT6k3rdEcLBF7sy3PxQ63ha+Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AA2606A326;
	Thu,  5 Nov 2026 10:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D613D1F000C1;
	Thu,  5 Nov 2026 10:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873824;
	bh=YG0lDmY/EQUEb2juPEQ9C/YGBw4zklymEC/Cpw5PHxo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jkWWnW5HPAwUm6Ebom6SohEGxJGOYo8//GYeOfPB/0Za8G69mC4gTHq6/CycgJ5Rp
	 6BANfcc8ifplmzWpWwFppviynz4NSCE1NCBv3YsEPeCtqftaQp/7bNJAziCvWwGD0K
	 cr2q5HyzJNHi2UhdbR1AXLhwelOh30mxKH2Z04oabhUEIiGaD2PF6f398OtSRAPct2
	 5lBjRgscTTHiwOhtbVGZcDgvaADWGV8zUoR9Q8+IqEkjrCNQgLLSmQpztTPa0GSm0r
	 ZSBVgy3WGA+Y/2s6cwuvh+2VgrGSyoQwvocvgVXWM0CTl+P9+cbyDB635zhWpymbCG
	 Bn/NtBZEtZVEg==
Message-ID: <sashiko-outbox-198833@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 15/19] PCI: Add KUnit coverage for ACS isolation
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-15-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-15-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:17:03 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Direct Translated P2P does not weaken IOMMU isolation because a Translated
> Request carries an address supplied by the IOMMU. Config-space reads that
> fail or return all ones, however, leave ACS state unknown and must not
> report isolation.
>=20
> Exercise both cases with fake config-space operations. Also cover missing
> and unrequested controls and a missing ACS capability.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D15

