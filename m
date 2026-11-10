Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794289710;
	b=qgO4lFBvsmelVqn2J5Bvt6mKUrix+D/N/sAEtPEnXR+Jw4/sw43ToDXlvEbJZMVKbSLF
	 H/56RWsbNJnTsrJD3ptqneOpcRuxHxYth170bMyhf0AVCtOyUNHvhbKQ7FZhe9bNYepxx
	 sZksJL3fEc3dRB/+onm5XI/6ObQbdczfFew009Y/bavqtbwzTc539q4mhCLddM0CrwhLh
	 z3sJ12VxafReGelPcF2hUPB1p4VvGVLH1lphDFMTgb+TUEMfd4UdnX+sr55rH+2axf+sh
	 xb0dL5TYMTGzzrijn8YHjWqY0ph9HGUb9SF+q9T5uLIipuceG+Flx/J8eGLds1Res+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794289710;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0mVvjig4gSbX7ysVnMzLxDyagZeFr48l3DePvn0OAmE=;
	b=heCHvTu9R7pYBsUYGTmBuoAYRmrAzj0pvumYSnIzfoiS112nnMRdvjwasSJSrtVzIABj
	 0Vux2sI19W8ZPq1qNltbzJA2aef6uceTi8VpqJqj0FiPDtFAmxiStJJIR/h6UUeJ6nUw5
	 8wcxP5NCPy6oERIqew0CVaBO7lp+Am824ll5R4dL/c24O88ASTcoGLrHoLl+Q8jfe22dX
	 TLpX7L7/vgdl4TQqre9DCJjHtEckRJubi8dJBw5vyrqPwZiOEjdtsQakCn0Rm8lRnSqWs
	 Y3jdMkCgO61Ab5QjxahXLc+3mNGwjo6avgjYU0AtDsLAp+/0cbnQgwzy4VonLYuWkrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kBbg/vjv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24E2606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 05:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBbg/vjv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4976B1F008A1;
	Tue, 10 Nov 2026 05:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794289709;
	bh=0mVvjig4gSbX7ysVnMzLxDyagZeFr48l3DePvn0OAmE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kBbg/vjv4vjdtCOOpp56ubV3DQTNQufc3FIod/Z3w51kFnhJPzdRGxvsuS8xBLURH
	 WcGih3wVGykY6jiVFxup6fXWbWXEnYW6nQv2pYrraKNrvD/1DQKAbuXKqBSytSIJHS
	 piNC1zCJejFTcUHB44sO88Z0kGkF3v9CkPofysM22jk2mSwKB9ln9mGkil9t9gtwnh
	 u5kQ80vqVGYsNrqVdBawSZBr/gpFPGJ7uxuqQF9aML0Vb8o7qWH1FENfgiv2UcL6F0
	 6kH3f3W8COysO3RXJA2eqqvFX7kiljcPPCpqpuk6ttDkkRamoh1P0h10c6qvs4IA3j
	 V/1cdvVS3N6Sw==
Message-ID: <sashiko-outbox-206343@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/srpt: Limit read data transfers to the command
 length
Reply-To: sashiko-reviews@lists.linux.dev
To: liuyong <pkfxxxing@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110052827.963143-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
 <20261110052827.963143-1-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:48:28 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> SRPT builds RDMA contexts from the initiator's buffer descriptors before
> parsing the CDB. The resulting RDMA WRITE requests can exceed
> cmd->data_length after target core shortens the command or when an
> indirect descriptor's buffers exceed its advertised total length.
> A backend such as rd_mcp fills only cmd->data_length bytes, leaving an
> uninitialized tail that is still transferred to the initiator.
>=20
> A remote initiator with access to the LUN can therefore read
> uninitialized target kernel memory beyond the requested SCSI data,
> potentially exposing sensitive data left from previous uses of those
> pages.
>=20
> Limit the data SGEs in every read response to cmd->data_length without
> depending on SCF_UNDERFLOW_BIT. Keep MR operations and WR accounting
> unchanged by retaining excess RDMA WRITEs as zero-length requests.
> Clear sg_list when num_sge becomes zero so that providers such as irdma
> do not program a non-zero first fragment from the original SGE list.
>=20
> The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
> system.
>=20
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: liuyong <pkfxxxing@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110052827.9631=
43-1-pkfxxxing@gmail.com?part=3D1

