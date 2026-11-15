Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794753238;
	b=PRr2L4w8kxo553bR9emuBLLOQgLb751BXR7KZPRs+S3tte87b2KF2ZwtAdZTncukBZ7+
	 lDPeLEY0eBw8KmRkes2sL/eiyUPwS5Wfsw7DJB8D5TnIAUqYIBM0qO/dkqy5cjEFcjOlr
	 VwdUWC2H2OtULVx+vmNCwDk350pMK26kLbQ89wYgOUeiqhMpQjiuHr/toIM5X4j/z00bJ
	 cxnITTKW/lSjN9BZlC2P1mg2ukf/6L1ZfFXyPwFt1eDefpz5lWcOey69vp4Gd+ZDVGiyn
	 +//8W58TzcvnwevUFW+tvhvLr7vls31JL/SmFdeDHXli/GDOnjDttdmj27Or48QxRJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794753238;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Nt6CsjhPcGCP3oY22pkuOZWYxxSBtpmuA509H8CRupM=;
	b=p1uwBteRtQIqVv4OVkVrIWccJny//2uxwp60Omiux4sQ4naonkMTkSaInssof+yK4tC+
	 9AsxagIxJ8gcElWSXxog7cv6SvtrEUvxMBgn4DbSDKNK5N1kkebOlMjXmAulxijhBSZ1H
	 nYR8Dp9GWA7Oi/wHCa2lZVXY6vuVAzWciQryLIMEYSeS6aI6D54ifxqScAhE4X/bVzd6/
	 lIJ/S8We2Mv+enXlWGn2kUtsdIf6bEPsyVh4zcawo2kNcRRt/9eHaqrmsrf6ttQ/zD3yc
	 cd/RVq1btQysorgog66Zzs1Znw4tOTM3i3T+ntqVKI0yrOvaK77HEJMCU9lFRCutYhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KNtwCIaU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0B9606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 14:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KNtwCIaU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D2C1F000C4;
	Sun, 15 Nov 2026 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794753237;
	bh=Nt6CsjhPcGCP3oY22pkuOZWYxxSBtpmuA509H8CRupM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KNtwCIaUpXrn/xdT0hPxoHwpO1AgM5iKUgjSUeyzbOCSK++uPbYFTJboLgEEIZlH2
	 zKBnkwFTHfI2KxB77qySAHpPcAzoFRDqM96Kj0KmlqQF3NRmrchU/W+BOLveOPFQW4
	 q9bJ1tHRdGW4qFks6l1ALcqvoITjtMQDLMyPKxfEHrpLiODtA4/VkhIgxAzT6Tq4Hp
	 BeZk2XDcz3dRULKK7JlfWjkr4k0wrVBkThe0t4Yy68X6bVqR1xv8mhJ0ybP5uxQHJG
	 Xb1Ju5jMqLyNKa2GPGHTCmwyBxjM/mMMZk2uFiaF2Ft29iVwWqv0pM83LUFDBI+KRl
	 xv5Vv+9FtqKyQ==
Message-ID: <sashiko-outbox-215584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/uverbs: Free all radix tree nodes in
 uverbs_destroy_api()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Deepanshu Kartikey" <kartikey406@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261115142911.21321-1-kartikey406@gmail.com>
References: <20261115142911.21321-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 14:33:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> syzbot reported a memory leak of radix_tree_node objects allocated
> while registering a siw device:
>=20
>   radix_tree_node_alloc+0x81/0x1a0 lib/radix-tree.c:276
>   radix_tree_insert+0x140/0x390 lib/radix-tree.c:712
>   uapi_add_elm+0x61/0x140 uverbs_uapi.c:41
>   uverbs_alloc_api+0x85/0xc50 uverbs_uapi.c:659
>   siw_newlink+0x36a/0x3f0 siw_main.c:433
>=20
> radix_tree_insert() can fail with -ENOMEM after it has already linked
> intermediate nodes into the tree, leaving them with no entries.
> uverbs_destroy_api() only removes populated slots through
> uapi_remove_range(), and radix tree nodes are freed only as a side
> effect of deleting an entry, so these empty nodes are leaked when the
> uapi is destroyed.
>=20
> Call xa_destroy() after removing the entries so that all remaining
> nodes are freed.
>=20
> Reported-by: syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd60be66dd00b4490fa96
> Fixes: 9ed3e5f44772 ("IB/uverbs: Build the specs into a radix tree at run=
time")
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115142911.2132=
1-1-kartikey406@gmail.com?part=3D1

