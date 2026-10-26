Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793010150;
	b=AGbUqFK3eco20M4TD2QvH2OgIe/KmpJ1Dta1YASxjRWkVLEXam076yb7/jnD51PhFXCi
	 pNfEjZhxQjE7mSoXaQ41qCEiHf1otRgfDpnEz0UUCMoQMSX+gn/F/aLd1Z5oVk0dVOtWe
	 MSfh/ISrYGABTKH/dUx2StOXbZJ3JQqIFzi3CO4sn9Q3ubnVQcSU9Wx7ijBkib6REr1t6
	 jHOGV3MXejmDnEAnoZdjGWMFUwfX5cq8XkuzIMpVJ/dihE9w90BuaMZyYzTqRv7FdFWgL
	 exYEv9ZsZJ9bwImfvlDlmA+bMb8gMirwQFMMMkgN1BzwqJntYfBQnZIf6yWbuqlS8iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010150;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HgdgpmWKJjgElGaoGA1hDePLvblJoL8w4a8OAK/8yZk=;
	b=LO9vOrTQPdJ76cgmJQ9fKCxFWY78LMrSLeQvSFXK68vMb++2WMlZtJKyPbf/ZnascwOG
	 RFENrHu7ZZRX+K6ZCLu2c7sXlB8m4FiQBQTsDOebeezerRZ8SRrEEmkwR2HJINk9XsYqa
	 gHx7CyWEr7rQiJTm1eFaLz7xCRUAaPY3nNFsADnq64S6fbzUPAWsJbPncZ1wKhcHxuT+t
	 bMAvBmcLUyLy87xqyigHk8cO2mEpiNRqLxqMEDpmVMgxxDjG7iOdCktbLNLMV7LJG016o
	 xlpOO20V56DVwLMX0glA3HzqGRAlVlA9bIgu83mZ0EOsNjleT2m6N3iqKbLL4LlVLGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A7u+lGbb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CD760A2609
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 10:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A7u+lGbb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28EB1F031E1;
	Mon, 26 Oct 2026 10:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793010149;
	bh=HgdgpmWKJjgElGaoGA1hDePLvblJoL8w4a8OAK/8yZk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A7u+lGbbzLlK0oIjWgILVY7UD9p22XxDKHNJLCmq4/p6tI51OoNn51CQapm7cjjnJ
	 UnE2jAtAo6AIWfPILY0uCnA6pSb5xzOhTlB5QelcQBmy6mBo/YYmkp7YDdPpDMIaow
	 5SjhWiT4aChM7NEZdkKBueqbAqlWsMpktKZOx1dvlBQr57vQGQUEka9GSWDcMh9fI7
	 CvqsfuuXrPrJZ6vNh+iAuHj6xRJcMy164Xboa7nOjRzQK2lS++wBHl0laBcf0VzW5L
	 JyRfX/PNOvrtfHRpbwgbLhDjGNo9hjBJ47s2cgTXiEIoERssOQ+FKxsN4bEEm7DNpy
	 +ou3fiXbtG7EQ==
Message-ID: <sashiko-outbox-184930@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 26/26] dma-buf: Add kunit tests for mapping type
 selection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-27-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-27-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 10:22:29 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add an offer list and a select_mapping() callback to the mock exporter
> along with map/unmap for the two mock types.
>=20
> Adds tests for the exporter/importer contract.
>=20
>  - test_match_set_is_final: a later importer attaching, even one the
>    exporter answers differently, does not change an existing
>    attachment's match set or default. Later attachments influence what
>    the exporter selects at pin and map time, not previous attachments.
>=20
>  - test_select_at_map: the exporter chooses a non-default entry
>    at the first map and the result is tagged with it. A pin taken
>    under the live mapping inherits the type and the choice survives
>    unmap/remap even though the exporter would answer differently. Only
>    dma_buf_invalidate_mappings() allows the exporter to make a different
>    selection. An -EBUSY from selection leaves nothing established.
>=20
>  - test_select_at_pin: pin selects, and the choice survives map, unmap
>    and unpin so a pinned importer that is never invalidated keeps its
>    first type for the life of the import.
>=20
> Assisted-by: LLM
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D26

