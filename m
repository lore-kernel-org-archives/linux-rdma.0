Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DE1C8D9
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 01:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791681541; cv=none; b=MY6nkyaOPj9vpb4dKUNGlRqGDGvBwys0o1Mj29K9hXkAdQ7Sr+ca6LY0Ictzs1NSubGKVdj/bBYXON+ipgj192DN8eOmedGFKpL/MpfCHAsruO0a8bOHYeC72N2tzX99sNJxHCiy3B1vIpQcyWpSMHRdrDdISPFB+R76+buOWE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791681541; c=relaxed/simple;
	bh=TOL5tvRkQqeADlnTrntGdjT7ph1UGWe+5DWadTDVisQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BFCuhmTLq/nnfX0kuatWYMDivPG/eHqCskZhygKVr0FufgaKM8OZvQLpxWeTTZ/JSZPYaYSK3LZpp8hjLMFA0Ql3ZJnKyhMA1HHjDemofpo/Zj/fpv/i224+Y6SLzbXGS0A7o0Sh81f7m+XSG7TZFVumS7AHsJ6kxakoYCq/Q9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdF3xQNy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdF3xQNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29841F000FF;
	Sun, 11 Oct 2026 01:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791681540;
	bh=TOL5tvRkQqeADlnTrntGdjT7ph1UGWe+5DWadTDVisQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MdF3xQNyv0o2NAdvudDgUfkE8ov+9bUpqKv7+wNfSoPFwF83I0inzUC5SeaJdtzFH
	 HGCE6pMeJGiunBxvijpUGVhu7ADm5VL+PZVoYNLLRNgNiZQTr6bmoqiz49qI1b8W97
	 dnPAVzEMGBefZZkXkQxaidAy9J18esLiObP6R3cW4gRe6AY7jH6KWGWMYJ0lCQFnFd
	 6LsNVMCc/9t5dd+fyc9UMp0TDdSLvFlzBgrQ/FAcqH956X81z3fc5WRxwaAszAjjoF
	 Hsw1DBUrCQGIjYtOJUKDCVSD0y5YRA4sXe78XbqsLsBVqsSBgXGZHApUvNUDDQCU8r
	 R4CFyCM/FN21g==
Message-ID: <sashiko-outbox-166955@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/5] RDMA/irdma: Plumb uverbs_attr_bundle for
 QP, SRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011011022.1445352-2-dhu@x6u.co>
References: <20261011011022.1445352-1-dhu@x6u.co>
 <20261011011022.1445352-2-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 01:18:59 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> In preparation to support modern UVERBS ioctl attributes
> (such as UVERBS_ATTR_UMEM for CoCo DMA bounce buffers), we
> pass down `uverbs_attr_bundle` for inner QP, SRQ routines.
> Since standard uAPIs provide `ib_udata`, we derive it via
> the helper macro, `rdma_udata_to_uverbs_attr_bundle`.
> `irdma_create_cq()` supports `uverbs_attr_bundle` already,
> therefore, this patch fills the gap for QP and SRQ.
>=20
> QP, SRQ uAPI will now have `ib_udata`, and CQ uAPI has
> `uverbs_attr_bundle` as a top level input. However, we think
> it is a future project to unify them.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011011022.1445=
352-1-dhu@x6u.co?part=3D1

