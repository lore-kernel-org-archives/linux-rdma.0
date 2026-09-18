Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5671F39B956
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 14:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741058; cv=none; b=cXYAJGrX1SSibZJ4ZBcPbAPtsuGUteMINTr2KD+BQp7DDDlunc98Wc4fYiviq+/20tYWvdCgt+c4fE5rH5bd5n/5SWGiAJkyBbexXmQJHyA8nxAYGun38OId0ylAKnKH/VLf8fvDmTdBezaL8KO8I4CIfHUYdoY/hNtBC4tXOTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741058; c=relaxed/simple;
	bh=hmOrdR4/5O3SQ6oeCU0eMPW+8kjs5hgVL6zm7dZ+Vtg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CyDP2Jk2SS1JRF4D/2/eYRfx7VJ4ch02fnz4hufvMc1fJutmWo/nxnmXXdqwRR5A4ewoInSH2177YBuhLuNcl1Cp9EGEDt4dp0EjTBrure4kCIYG5hSI8xgaSmhV/VUxvFh9cxZpjoIdFBdHWx2r2t0s1JNDlJs632NQRktBD8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeuNdijb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeuNdijb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C791F000FF;
	Fri, 18 Sep 2026 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741056;
	bh=hmOrdR4/5O3SQ6oeCU0eMPW+8kjs5hgVL6zm7dZ+Vtg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FeuNdijbBu2YbskFqPHbiq2cxYdBUBNBhv1uXOLPxPswlboJ+J9GKR+MFaaloxMvN
	 H25W0ChsXth7JPrxTfA0N5B3dtAe3yttxqGFv9gBcOmgOzCfkRyrqwaGQpHn2MZ7Ds
	 WxbpteRepOTvH40Lg9YuXvxpXUF9AdglMnpifuPtmKiChn0u/3YVQfgWKWYtCdSeaH
	 JWdLxulXuX5ajIcOTyZGJqTJRuADc7oDSFhr+HVSXklA8MPAqgPVdSQtAziaJRUlUP
	 sF2fBLtlzdKSTYyXRHd2CYz5BmW939nW5Jk3VPg4QwT/WwLBsbCsmCK7j3Lj1OpPEs
	 Npyw047NyIMGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 2/5] RDMA/mana_ib: Revise UD send posting
 and WQE definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260918140407.2922819-3-kotaranov@linux.microsoft.com>
References: <20260918140407.2922819-1-kotaranov@linux.microsoft.com>
 <20260918140407.2922819-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 14:17:36 +0000
Message-Id: <20260918141736.C5C791F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Batch a linked list of UD or GSI send requests behind one doorbell,
> returning the first failed WR while publishing all successful entries.
> Move the send PSN into common QP state and describe the extended RDMA
> send and receive OOB layouts needed by subsequent RC support.
>=20
> Keep UD's inline OOB explicitly at INLINE_OOB_LARGE_SIZE even though
> the shared software OOB structure now describes larger formats. UD
> therefore continues using the existing GDMA encoder; extended GDMA
> WQE encoding and RC feature gating remain in their later patches.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918140407.2922=
819-1-kotaranov@linux.microsoft.com?part=3D2

