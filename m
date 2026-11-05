Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793874151;
	b=fKGZexjtFIqvroq584vJ0s3sCRmnMQmPrSLgbJFN7tWFpSBkmlILvIWKrJnTKlg0eFHf
	 EAfAlANd5f4HEt6bXPL3A9Ysd653j/bDr9jrzKxUlvmhmGeD2UL58nBPuFb3i2S9gpOU8
	 fBwr8YJDr7IJZUZW4s2E10JIkUk8MR6s8R1W6Mcg6Sf/NTX0FKsiNY9n8L8IwjXp2HIER
	 32pG674ktxJTOCJLL6mOnsgofFCulgnToeIOST4IGr0bfN2/HKD6zkKJBslUU9XQVYFHD
	 1ppEoDm/ITYQwABkagwYsN/3pHAHPkPFxxwaRcYgjS/j2SvI01j9g9t53inbL/VFKUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793874151;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FPDSsjDzF1sLea9jIThiMx8yqmPYGl+iDwuUnxwBj6g=;
	b=tuhvVhWXgjyXQ3NF8Za8vWsjzhHJirQ5M/PUckfSEhqMPmwrBGuE8JN/n7qVGGWIDJyL
	 Cg8cX4uRk02MpbUwjhSDrov9WHMyFLB9H6wgkjabxCtsNZzWrNpSaoTSiBaUygow4slGQ
	 czoRZv6UKtn5COh507/f2bYmDS8scvl1bBcykHWjbPXlF+t4Rt92vbIXURRFYvP6u5rY+
	 C9miQtk7ZOSDPh1hBw0dOtonoLw0xnNTQoGj1vgVu5k6Ag65RtokzQPztecxLXNJSoZs4
	 nvPb3MOZWjG/7YxYB9necJpk1lMJzWV9mWHHdadjXbHG56+UdBQYh6N/kSVXYRYzvig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XGKB8buh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1401D606A326;
	Thu,  5 Nov 2026 10:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XGKB8buh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731111F00A02;
	Thu,  5 Nov 2026 10:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874150;
	bh=FPDSsjDzF1sLea9jIThiMx8yqmPYGl+iDwuUnxwBj6g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XGKB8buhAr3VuIx2JgDzIhb0V99uq1dQ9iSyOU0zy+pQOhbbJprL0WAy/gkbUzGiU
	 zFVqRcZO5QPjFK/Vkzt9JHTgaUkHKWlDDfEmwpu2CONtxX2owV4JWqzFjxBeDO48/f
	 d3g6obRX/5UOf6xss710jYTbVkQztw+4nqYg2PHepOH+Wg2ExX0TR94vqCxApEWUn1
	 TZl3BLGM4P6fJ+u7TC+KI0e34SxKVgmwt8qvxDMxC4x2ydf9KA6nxZ8HEkYPOiM8az
	 iGpUD3LCtGLX6LzdRc30lJPgAvaxNqf7kJYiqzkOxwTrthvuaKTWWhCb7s9sp8aIEZ
	 /Raf/ACLNJhpw==
Message-ID: <sashiko-outbox-198845@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 08/19] PCI/P2PDMA: Answer routing per TLP class
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-8-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
 <20261105-fix-p2p-acs-v4-0-v13-8-3dd065907c3b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 10:22:30 +0000
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
> calc_map_type_and_dist() returns one mapping type per provider and client,
> valid only for strictly ordered Requests carrying an Untranslated address.
> Clients that use Relaxed Ordering or ATS cannot ask what the fabric would
> do with their traffic.
>=20
> Add enum pci_p2pdma_tlp_flags to name a class and pci_p2pdma_map_type_tlp=
()
> to ask about one. The topology walk and the ACS Control reads do not depe=
nd
> on the class, so decide all of them from the one walk and cache them
> together, four bits each. Every class still answers alike; the controls
> that tell them apart come next.
>=20
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-fix-p2p-ac=
s-v4-0-v13-0-3dd065907c3b@nvidia.com?part=3D8

