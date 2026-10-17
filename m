Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2C939769B
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251570; cv=none; b=LEOcI6EpqRuGhhQ50vEbqbHPDvt5V4mNdcyKXux7byeq8gk/V50k0OCYWOqM45ZUqCmmRArZtX/2iMjaW7/y0g0f4K3qxFwq3aMh5bDkRmLE7iWiWhOlc4W6lwiBXEmLL8po78NbTNggd6ZgjS2Q79bDJztn6YFE2jKfOlgQIno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251570; c=relaxed/simple;
	bh=hqhC42NbpiQwyJnV70p2PvhCPZUe2EtOKr/Va5CthQQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=NDHOjN3Y6nFtBMbHFOCT6BorTYlpJJWqBdHBeO9ugQhKSClEtIKoU4I+HtJalBmwYmc+8Uo3d6y/gjMDPex1ORjg2bfFjjropwPlRYSbKeinasm168ia+5V7gZLVG7TWogEjTeWtEQnQuZPpXvgNHhwAw7ByONOLcPWqfpbSwLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhdRypKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhdRypKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D931F000C5;
	Sat, 17 Oct 2026 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251569;
	bh=hqhC42NbpiQwyJnV70p2PvhCPZUe2EtOKr/Va5CthQQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NhdRypKcI7vYLsq9gjUBw0Q28fJtCziHel+pKTr2F2GgmW/BcP+xZNp5bzr4ZdG0e
	 hYBzUqycGIoDIzEsRIQGQmLPFxZGZUBmSPmvpumlwdMAje9FW5I4iZyVuBoVnWtc39
	 2yFJYp3hmpBUdvmMYjN8Oy8TZOMCGbHxv91HOk+53H/PVnWoEIlMirpNKwvaPki03h
	 U4yDaYt8nYP0cBYHBWWADKFdH6Yr2vCRLqxse4TK1RD/OQKNL1BHZPvzYNSwwlcEsd
	 Ka+7a6C2wwdkKL5vejuXPea6LkU5SIyFstwUipmdgkS0XSuEObNPrytWtHHPN4uQpu
	 7q1k4CM5PSmDQ==
Message-ID: <sashiko-outbox-175608@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 08/13] net: mana: swap queue sets in
 mana_xdp_set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <c2e32fdbff549ac0d561716819d20ffad6236c5f.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <c2e32fdbff549ac0d561716819d20ffad6236c5f.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:28 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Carry the XDP program with the queue set and install its per-queue
> references before redirecting RSS. This keeps the RX buffer layout and
> program together during publication and rollback.
>=20
> Do not replace the live program during allocation. This also avoids the
> pre-existing failed-preallocation stale-pointer bug; its standalone net
> fix is linked below.
>=20
> This full rebuild temporarily keeps both sets of SQ/RQ/CQ objects,
> RX buffers and page pools live. The port-owned EQ pool is shared,
> not doubled. Device resource limits may reject this temporary peak;
> allocation failure preserves the live queues and configuration.
>=20
> Reserve RAW-QP admission under vport_mutex for the entire live
> replacement, including unpublished queues, fail-close and scratch
> cleanup. Preserve validation, no-op and down-port behavior.
>=20
> Link: https://lore.kernel.org/all/20260904202640.3900685-1-longli@microso=
ft.com/
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D8

