Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE0F36728F;
	Sat, 10 Oct 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643323; cv=none; b=ij9ehX2vL6kThe1tuCu7YF1dfjuPC9t4AbbQDn/+mYvln+YJm3+AH3CqO7jldgljSLcFbXVBaCuFYdeDXliE0nPKMoVfkdbYQBQmfZ2q+IA+UZkXS+FgbxCOMeUn4t7Ib1+y6bDifSMrEBA/gMxGJsgQms4r6PFiI6aW2TJUiaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643323; c=relaxed/simple;
	bh=8Kb5Hbd2jVSIe6A02YK5HMoqmcs8c3JEcaRqxXceN1o=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=RwD/u+y/ll3Qi6vQq25Jh5BEDzDylHSgrw6yBZ0bXB3l2u3S6VrRl25J4EywmAnNuZW1x40DibdySgTWs0XhMf70B+Hf8E2CkwlC6ZPn44/oJe5LzHs39oGyl4Gn7ufReWW2K70Xx7ZI1/t/lIdndQjGC4hwc33V1krPXgLWVGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FONNrp6+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FONNrp6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148B21F000FF;
	Sat, 10 Oct 2026 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643322;
	bh=8Kb5Hbd2jVSIe6A02YK5HMoqmcs8c3JEcaRqxXceN1o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FONNrp6+az8+MhXKAm3cK1PHh/q4FPMjL8rFVsVmR0FQ80e0r0lK5AytALzPH19Qb
	 q0ymoofHnKcuZnRomF+SAJgGu6fTVZ6b5WhLJnGp8c66/0TWbNx9u6s6zAAcIaKcHc
	 i3Ps1RCOjxzSOAdQ4/Nf9r3mw++sYnjOOJjT4QP/NdvSL2pItcOjeHpcVEeL1l9rXU
	 ffrUkNlQ1PcmFN0FXxj23vy09N+PbC9SaViFHUbV2tk+NxhBa4ZcRmrz57US0xfCqc
	 ANoBR4oHV2thAOE8Ci/kkwN9n+YllDfkanb0+dvLWcVYvSKv4PpU8N6iD287dJa1lu
	 5ZSTmXcLtybOQ==
Message-ID: <sashiko-outbox-166656@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 08/13] net: mana: swap queue sets in
 mana_xdp_set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <3d43962ea65efad5e6bc8652f887b1b21dec4178.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <3d43962ea65efad5e6bc8652f887b1b21dec4178.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:01 +0000
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

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D8

