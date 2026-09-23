Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933644756B1
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 19:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790190758; cv=none; b=DX+tdeaE8ICuE2HiMMP1+YqwtflgRhoZsYSfvD2J0aXNHxEPzOaOogG9xy3Pew5MRJaLha81wugSYAK1SBpn4nTp00d1MQI93CnNQiqcJMoD35GsNzH3VJoLbFymnLIB/lWdquti6HRtacoUBtyZhPCFZqXkdAGjW/ZC5BgV3rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790190758; c=relaxed/simple;
	bh=MoFcJe0TZyPVZ3e1fAG+vOqYDDPYsNcEAxMS/cpBnPA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fwLyCQsIu/LuUUTReEzLEH4Df5bR0PlFjl0T5HJvmKEb6jgNdGhuvvTyLGCVWP4WQNhU19RGlG01jtB2I2HWC8s7eP5H1uXh3anE69Lio2zZ7mzbVqLFZ0yTiTaMhWUCIQNXwzhXwl+6zSXyCPPgM3+3px3pqo3MIVNMnecQAzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gr6CfrH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gr6CfrH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3AA1F000FF;
	Wed, 23 Sep 2026 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790190756;
	bh=SPttctf7natD5+QZWI103np5Dgx8oUAm5AtyyxkT1/E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gr6CfrH//KyRQJMPFhSaXfFnj/rZJ/jqHKVJSNheFP6jDBAglkr2Z2/QdZQDuhQt5
	 8Fdrj5sSCmE+PoDYSzDbOECJFJUVcPhX5h6ZrIXyFwFZWfJJbBBGoDoFqxm5H4ZvqS
	 Ljs0U3QAIuc05HL5/6wtU2blxV2tr/j73nqbpqYridcMOEuIV2Hy++BUEWx8nrIxEQ
	 bRnOObltx0M48lUbf3axJOX+iPjXtf8y0XbA4VTgtroGAKwR1/i5vxySOZlLvuwmIj
	 nQOcqJv81BWYEaAMUvVnTmrG5htIiFfKaeeHsjLm0314aqACVBQmpswQ8oWpcveLy7
	 TFfVkifsrcaAA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/mlx5: Don't return firmware-owned command
 mailboxes to the DMA pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Danielle Costantino" <dcostantino@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923190542.848049-1-dcostantino@meta.com>
References: <20260923190542.848049-1-dcostantino@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 19:12:35 +0000
Message-Id: <20260923191235.CC3AA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> On a command timeout mlx5_cmd_comp_handler(forced) keeps the entry and its
> queue slot, because firmware may still complete the command and write to
> ent->lay. cmd_exec() and the callback path free the mailboxes anyway,
> while ent->lay->{in_ptr,out_ptr} still point at them.
>=20
> dma_pool keeps its free list node in the first 16 bytes of the block,
> which for mlx5 is the start of the command payload, so a late firmware
> write corrupts the allocator:
>=20
>   Unable to handle kernel paging request at virtual address
>   0007c830040001a0
>   pc : dma_pool_alloc+0x48/0x430   lr : mlx5_alloc_cmd_msg+0x154/0x318
>   Call trace:
>    dma_pool_alloc+0x48/0x430 (P)
>    mlx5_alloc_cmd_msg+0x154/0x318
> [ ... ]
> allocator.
>=20
> Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slo=
ts")
> Cc: stable@vger.kernel.org
> Signed-off-by: Danielle Costantino <dcostantino@meta.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923190542.8480=
49-1-dcostantino@meta.com?part=3D1

