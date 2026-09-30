Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97431459AE7
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 08:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790755327; cv=none; b=BcH5odiPTyxlaSxMuOZbiYfLQbghXmEx6TibJo0YDM8DAjvqvoe7/eV5JSHwOVMjucc541IrJXN9v3iskoPaXwJIUDZ/mdNJkrUtaXs4T+gGivEEHId9nGz3v6avog+API81aMBX++DkK37uXRMnw9aDoWuLatcgIEiLtldRXK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790755327; c=relaxed/simple;
	bh=/j9rwRSUN1pEz8TpBD9cV9ohB8fg/5T5+1bW1eDHGLY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AZeRG2WYPG0SDFklNtxnps6UwNPxBrLVhxUyIRpx6BnrrZ7jP7BMuZE6rBhLFQKzMjOXrN/MZNhYtEPx3n6s3LuObvb4aneJWXOl10sa7SeBc8mzLHZ9wNaUabmgP7BBXOu8MCImfAWmzstshYj9PCOgLp41Uw8spH9gHD9BekQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PWSfF/2u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PWSfF/2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B331E1F000FF;
	Wed, 30 Sep 2026 08:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790755326;
	bh=KKo+cCn3FURSl9nopR5JD+2IdPV0UMzF4IDGQiFeXnE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PWSfF/2umG1DNPSZ+k8NVI+M42uanU6zVoImcn9p7UPd6qJgo8GaQSlV3agc8LRFv
	 yoBAHC9Dh6S36flHMrTWJQn+29H/3qhhK5mUkZuw+LxiNansZ6XoHxGrjObrQoxbbS
	 E8X8/Oc2NMuJxdYhA+9nF4y5BJYhSWV+SsAn8bI4upteZmKTftXNF3CNacW3OC73L1
	 SigKbpwS0wK6esnHs2udcbrnqPbqcCt5uWXrHP0NnKQMnpTJGKEQkTT0Rfih0ADuDd
	 LYu/7+0uNHBQz3jWWPrQxsdMFgh7WqKTzavPeTCwn1qaUo//TBIky0FT7b6eIfZz3H
	 l2tEaCRneP56Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/irdma: Do not move a fresh RoCE QP to
 ERROR on RESET
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Tmd1eeG7hW4gVsSDbiBDYW8gTmd1ecOqbg==?= <nguyennvc@greennode.ai>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930-irdma-reset-fresh-qp-v1-1-065327274e2b@greennode.ai>
References: <20260930-irdma-reset-fresh-qp-v1-1-065327274e2b@greennode.ai>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 08:02:05 +0000
Message-Id: <20260930080205.B331E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Nguy=E1=BB=85n V=C4=83n Cao Nguy=C3=AAn <nguyennvc@greennode.ai>
>=20
> irdma_modify_qp_roce() handles IB_QPS_RESET like IB_QPS_ERR and moves
> the QP to ERROR. On a QP that was never moved to INIT, this makes the
> following RESET->INIT fail with -EINVAL, while ibv_query_qp() still
> reports RESET.
>=20
> RESET->RESET is a valid transition. The Mooncake transfer engine
> resets every new QP before INIT, so it cannot connect over an E810,
> while mlx5 accepts the same sequence:
>=20
>   ibv_create_qp(RC)        -> RESET
>   ibv_modify_qp(RESET)     -> 0
>   ibv_modify_qp(INIT, ...) -> -EINVAL
>=20
> Skip the hardware modify when the QP has not been moved to INIT yet
> (iwarp_state is IRDMA_QP_STATE_INVALID), as there is nothing to flush.
> RESET after INIT still goes to ERROR.
>=20
> Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
> Assisted-by: LLM
> Signed-off-by: Nguy=E1=BB=85n V=C4=83n Cao Nguy=C3=AAn <nguyennvc@greenno=
de.ai>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930-irdma-rese=
t-fresh-qp-v1-1-065327274e2b@greennode.ai?part=3D1

