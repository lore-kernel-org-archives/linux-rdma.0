Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700394;
	b=KQikn0S3EzQwC47aIyJg1AXFqR22f0IAMAFrYuvgJlDj9N+yTqayjmIgZJLy37lMDRXh
	 1a9t2K7L0lobFeTwNSGxJ9lFe+OY37S6JIG3gt9ck1uSq2qmJpcqK7xvXWF78QfUMFLRu
	 Q2zF3UQCfOQN3n7980z65Ajnlv/v7hbjvDTIpwtfZajcuUNWmLo0d/SpIbEB/HLzwUjkE
	 cIkBxnh7q2vXTi7/+PLQUlkCv3aGt8Si/kz78dLuvYXLYHaD/1LtqxncZZ+aBXT9SAHh3
	 Stxto5d2oR2J3Hjb0Dronvt2+OAKIm2/3bwnlpo/1IHe0J6ySM6oVuc1GRRevYOLhHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700394;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1JC5Ei3rKaTIU20gKiF/xHhw+gO0QmFDnSd6+yboxAg=;
	b=tqstMX0LfZWQRng+gNU90iwW/Q0ONmkvvFs1KcHqkqQtQTkiLymsyg5OeT1lW20Er/se
	 TxawqRyIwzH9JoLe6eu3F8LrHG9rxCfLoinxPW+d8NZlndBGQkDIKSL1CZdfoL8MCWno3
	 N/JR5jZBuut5OfLe+bd9ekhAOsypERK+JG/NQdT/g9xERCiXUAUz/PbewBTAgGauSuspI
	 09Dqbcd/9B4tF0NoPBDdoruPHSe5LLCXGy4EREiFduLC9ce17pa1Vl3pBqdLq61gd3tm1
	 wSlreRMoDO3TxMkDb2vsePYO0MsD9aOUJ1y7ZMh9KA8byp6qEG5h3AC6NBgAiTkOLpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+RRU3+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15D1606A800;
	Tue,  3 Nov 2026 10:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+RRU3+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AF61F000C1;
	Tue,  3 Nov 2026 10:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700393;
	bh=1JC5Ei3rKaTIU20gKiF/xHhw+gO0QmFDnSd6+yboxAg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H+RRU3+XKAiEQuyTeR0lTM9AWAcQMuufQuUnqEOX5/K6tkD/TFsYl36394YI4Na3m
	 XWiV3y2/tGe0Cj87GQjM82QdI+J3CWth027XGF0hh8GJ+fFvdwW3MsoEdq4I3yTUQB
	 98/wRrOgI8NlYBvSAdiLjI3ef+InP2GJ1HYWS5DgPXVyZq9jTija41oNwu1oq8qqhi
	 ZLmcY5TPOQ9MhK8pACUFDfL7aWKXHFKuN9gmoEnlWZFaH5Jr9gZa+aPFt1LSU0shw6
	 YjmyN/5nZZKLq95CyRgiP5K9/etnn3RVV1QFHuo2WGFzBP7PQcjrbhRhjD+zqjDZwU
	 dvrTzJF9KJwUg==
Message-ID: <sashiko-outbox-195001@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 08/19] PCI/P2PDMA: Answer routing per TLP class
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-8-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-8-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 10:06:32 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D8

