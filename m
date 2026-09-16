Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7B74FECC8
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567205; cv=none; b=X3aInnLSzlTD9pOWYP+xeSVMgtg9PRTv+sXf5nHFrCIFXfDvvKrVGuDm7mtV6dWQJMUSZ/tlAhJoQ4XkRbYtVtJLU2X1w7xTMqTLjHrQeOf3oyFieTQ9jut0ppy4UFnI5yOc0IDR+D48ojLycxbRjfBgQiOXbeSrzORudXwMvDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567205; c=relaxed/simple;
	bh=5bBlS+BnRA4WVWQtpDQkGcRU4RP2X9JXzE+pw/UmKNs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lLqKJF9pvgnh/AGk5RveihXDOooT5fnUA8EwsUEGnZXsvDOq5z8/f9yyKidtlVLk/y2XdYIKPZSkx7xX9x4fyWGw7neXtnnObk9UQmvg+Vw7Ik086RXTNjAIowCQf1xKvkWZAWkBpxCSO0nt/D99feGpdvEa2p61jKAfSzL/Dkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fo5fgYWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fo5fgYWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EE61F000FF;
	Wed, 16 Sep 2026 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789567203;
	bh=5bBlS+BnRA4WVWQtpDQkGcRU4RP2X9JXzE+pw/UmKNs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fo5fgYWrvaNBsSiprgl8aAMA3Dr7AlpxYgGWT8c9O4YwHkmL8a7SvTe80Zg249v3O
	 jnqbgBZ/43+D9LXyvtK+GmDm74s5X2p+Zx28FrlvtynAMo3B3vySDzrQnHfS78v/Y1
	 la7kHt+B7m91NrV4LXlyHjG09eaCrpkCOZCgWc20N8J4WDRlWyresPhs2OEuz2aiik
	 ZfHyAE7nynb9K1lPJu8twYaxPqUq5VmLSyC4UbRFHaw8GRHlPlHXPwET4VmtOSDndW
	 E/g+kwwfz6VvnakDq4SBNO47KSs2cKWedqTsPXjBi6qnP+CXbJn5+6UMqSitOai7jM
	 gSrPCQNcR8sJw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 2/5] RDMA/mana_ib: Revise UD send posting and
 WQE definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916134835.2380971-3-kotaranov@linux.microsoft.com>
References: <20260916134835.2380971-1-kotaranov@linux.microsoft.com>
 <20260916134835.2380971-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 14:00:03 +0000
Message-Id: <20260916140003.88EE61F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916134835.2380=
971-1-kotaranov@linux.microsoft.com?part=3D2

