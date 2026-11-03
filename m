Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793702708;
	b=uaSKJxWJQMmTqlkjOmHlWboMtakiN6AJ/I3QJVkjcImiv/vWJuz8Jh9aLKtHx6R0Zu9b
	 PPQ7WkiegI4v8O1971HzYMILsmVek1YDWfWzIBD54unIepJpiA8jAvB+5ki9x96ax8KKB
	 k7oy5x5RUKDvoY8mt3rYAizm7k90qlaad3GrqYOE8OsqV2kfJN9h1LXoQ91i7Ji/Z9Ab9
	 9T4TZ3Day0j6FQtVDk1qZFmhSGb00GlqWxmMfsAf6Hbjh/qQbHn0tUNHHLLstZgCmE7GX
	 0vf6N1h6WYGWyBTsyyCK+PgXWG6x/YcEpYU4KZ3FFcUn4Tr/JYejCt+6wQ925qf+LBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793702708;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qnS50xnySAL/6F0jbhmiWNpPeJrO3ISpGQeuKxN4ZQY=;
	b=a11BMtbVnNfyJyXEWCikr8MQ1E3OZ6Ulo56hWFt//1ImMlo+l07KHDLlXl2tDKxk4dLN
	 NqdWi3wKytjrr75YpCSxHF9wZyr8VElVYWB4xv0nfbXCnuPEaY+z8/yo1e165MLzrUDB0
	 MI9cyuWfOi6p8/U8uqgzfT3UD/Z9TOky3P4IxkhhnTRm2lFQyNu8OAsrvk2CU2TUCUki0
	 zKX/PxiiY6ETctoDpmLrIHmZzc2KLxvYzexfsiqusZkPBm4u3knurW/pVkY+/AWJfsAdk
	 q3Voj2vAhkuhcqcm7N/TjjU/MsEVXMK7m87ELUDVcLiq17cjktbOgvNzII71bo4a8Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZahngiXW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB5660700A9;
	Tue,  3 Nov 2026 10:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZahngiXW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D671C1F00919;
	Tue,  3 Nov 2026 10:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793702708;
	bh=qnS50xnySAL/6F0jbhmiWNpPeJrO3ISpGQeuKxN4ZQY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZahngiXWtOzdD9btYHY2QEX7lG02wm0jFp1z6fypAdYkNQGyHqU1l1+7IYcfibP+w
	 UCL3jCFhzOBN4WpnLkS5YHEZ5jaCnt+oZlCRiwuGbC/Mt59y+zEnxP1sT8JlNmVnbZ
	 9M4dvMS3F+Bh3levPj5B+xmMjTCzuufpewvndiwMXs7qJBIvUKJdbv8Iz1B3XUV7ZO
	 0YYHV1/y25oQSeJ4i4ktyNdWanUWR0wEnvP1RbvliOinnICyitt/qJ57I2LQmolTkz
	 FY61wBNRj7Ui+UULXaq41Bm3BcDraFENkGpPWhmr4+hWli6FisIS3VMCICj5vPNdZo
	 RORfz9yul/5Ig==
Message-ID: <sashiko-outbox-195066@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 11/19] PCI/P2PDMA: Route Translated Requests under
 Direct Translated P2P
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-11-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-11-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 10:45:07 +0000
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
> A Downstream Port with ACS Direct Translated P2P enabled routes a Request
> whose Address Type is Translated "to the peer Egress Port without
> redirection, regardless of ACS P2P Request Redirect and ACS P2P Egress
> Control", per PCIe r7.0 sec 6.12.3. P2PDMA assumes every Request carries =
an
> Untranslated address, so it sends an ATS client through the host bridge
> even where the fabric would route it straight to the peer.
>=20
> Consult Direct Translated P2P for the PCI_P2PDMA_TLP_TRANSLATED classes.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D11

