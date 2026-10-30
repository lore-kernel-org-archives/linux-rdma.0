Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336038;
	b=cBSNMdgsllGqRtiwCbMF8PUSZ4llImMNLAaxyoURMhtewzee3+KMbKmAtj/bNZcZOg9j
	 hgc5EETQLdCPh8rNbJ1LMEMlDvQVE6EnBNOUyfIuhfD+8fBkDEUkYS0q6hZmVaAfYNDZc
	 4d8nkmk8j1VmY7ZFahS9o66f4C/4E+607oQod66HddiSpIhNfJyG9MVBzEVwHB3dfurv2
	 J/MA4B0UMJwJpcG1t/Sk5Lj3Sb7M+CsKEQmE+3vSAgoM9ERlgF7DzG0WWv8o54xiLaBRW
	 8EEVMxWHOo3XXJzhFXndl0OWb4H77v6FUfNl8pVDYuaAvJS9X+w3wE3Zrh17KDx2qzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336038;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ap5fjsTKF93xb0//tjYl/5pW49Oonq/BsiirDZkY3pg=;
	b=gaI9jyYZSS8N0mrI/2ofUZ67pAIALknoyQKicKiZ3oRAOdn6F19W44NmyRI4n1uSHG9J
	 Xnu7A9dDryWpRd4WexdASl678A4DYFJHsT/KG4dQ2sHQWR6acKspyCtYbJaRvQBs/mP+c
	 8MCpU+tTbjBZW4XEVgHxS/ap8DOBKbAknGhJY+PZe438Q3Nbsy4pEGIj2bQzlJE/r8oMl
	 FhgHaXKOBmgNs4Y59RrQOUsWbFNKZnfvlHytD2/qg+ZqTUJ1DhOT4PHM8a5H0qbaWaKoM
	 yNhpwuLG/At4/5okgH4FwVddW+InbGbkSYWsHDdpHqABO8uzS+TMbJIb32WbeL6pLgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=apGK59Kg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DEA606A320
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=apGK59Kg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153511F000C1;
	Fri, 30 Oct 2026 04:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336038;
	bh=ap5fjsTKF93xb0//tjYl/5pW49Oonq/BsiirDZkY3pg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=apGK59Kgmu6Ofyh39Y+uGm8suxrnNoXdbdd+BBFdM3kFLiMedz+TTwl6JI4bD8sT0
	 khBSXspraQqiGGek2lfjcgJF6iW61DQsFy+pZy6zfjf/ttLGViFSncncGWlOOMa3x/
	 thCS65Djp2J2Py7gyUsK2+r7CbTxM3A7DorptejOVGPAkrRG7bxD795oJpU+3ISoVM
	 V5UgHLlH01w3yMiR76AXdmtPxdPM0mLSEuWvknC5gtFTB4nte+qA2F2zI9jiB8C9Hf
	 xhA4u53t+GlSnkrc0AZdHjaEmGSL4oxim1pHL0TOQ4lT/g0kUR6VE5/KSSkWmtCoef
	 rafq3YajlSU4w==
Message-ID: <sashiko-outbox-190386@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 5/8] selftests: drv-net: make attr
 _nk_guest_ifname public
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bobby Eshleman" <bobbyeshleman@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260507-tcp-dm-netkit-v3-5-52821445867c@meta.com>
References: <20260507-tcp-dm-netkit-v3-5-52821445867c@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bobby Eshleman <bobbyeshleman@meta.com>
>=20
> Subsequent patches will use the _nk_guest_ifname as a public attr for
> setting up devmem. Rename to nk_guest_ifname to avoid angering the
> linter about the '_' prefix being used for a non-private attr.
>=20
> Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260507-tcp-dm-net=
kit-v3-0-52821445867c@meta.com?part=3D5

