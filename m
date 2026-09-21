Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF50C35C6AA
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 10:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789984996; cv=none; b=BbiVWNG2iKyRkbBIDKGWeLRuxZxFtwgwhALhmS1KITG9XGQWpXoMQWtQ38RRZxn+pSIE2s7n3Lu9PhRTWKJ9zhx1sunYtI8wC5NfPI6w4O3JXKD1Ul73wi5Pyr3I7z78owyEZyl5dIvuS7wTsY8aPUmXWX33YSF+PZ/ho+QMXOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789984996; c=relaxed/simple;
	bh=Gx8V2sQXEnLqEaS7eJ4NinSN9v3z+ICexqjLReza4bc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H8nIjqvmra8OCkSrRCSotzy+PkhGuAsp0epU7khB7Mgiqpr2CqPRF79NHsSzjOTON8wIzfuDSqGCoBLoBYQ1h4NhAqTZfmPb3WoTEChPdv23jRGEDlQVtzmov7V58Tpm5heVDysoeQIrDVXc5fg6Dfgdm5QtvNYDABbUJoStP+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQaJuVtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQaJuVtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293EF1F000FF;
	Mon, 21 Sep 2026 10:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789984995;
	bh=Gx8V2sQXEnLqEaS7eJ4NinSN9v3z+ICexqjLReza4bc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZQaJuVtlxi5bApbrqpfw5of7tFoPiN+oAokEjJwqkFbgaNwDRPihHG5JwvNIyO0Am
	 +9lHdb58U5pYeREzNF6Q6ExuX33RfcD8F+zN13cVlhkrU8XE7lzTlO7g1rv2t7T0fs
	 K65dXw+SzwXU/R90CcBUt1mxGosUqnJCJwOj9fMovswLZbFnT8RFjHAl52eLwDYM3T
	 dCd1Y4YfLr8LzRWckSJMUIawlVx1p2hjoWXF+V/3YzWIsYr2qhSP6enIQU/17CmFYE
	 /yAXE7BafYKbgHyY8H46VrOI/ENHMJR0J1ykQoHr3mvzeXle+u4ZgBFwKcGuWeOIVJ
	 g4gTl332Xd89A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 1/5] RDMA/mana_ib: Optimize shadow queue
 bookkeeping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921095352.3524691-2-kotaranov@linux.microsoft.com>
References: <20260921095352.3524691-1-kotaranov@linux.microsoft.com>
 <20260921095352.3524691-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 10:03:14 +0000
Message-Id: <20260921100315.293EF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Use compact bitfields for the posted WQE size and send opcode. Flatten
> the UD receive shadow entry into the common shadow_wqe_header, retaining
> byte_len, src_qpn and the cached status until direct-CQE polling replaces
> their readers. Use this common entry for both send and receive queues,
> including allocation, posting, CQE handling and WC generation. Derive
> the receive WC opcode from the queue rather than storing it per WQE.
>=20
> Publish initialized entries and release consumed entries with matching
> release/acquire operations so posting and polling can run on different
> CPUs. Retain the legacy completion cursor until direct-CQE polling and
> software flush lists replace it.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921095352.3524=
691-1-kotaranov@linux.microsoft.com?part=3D1

