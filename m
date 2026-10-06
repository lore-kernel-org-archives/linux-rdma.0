Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541744A2A5F
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791312887; cv=none; b=jeVs9Df1E9qV48yj5nek51Lw9sZOsO09/jlQWV0V4eiRGTqxIKpkxep3FOKpR9YM9YXClwTbagqck4kezyLNB63FPDDVYGQrPp9C8C7CunqgkHhZUZVOOgGNNl00DvSpAyOci6HI+bl1rOco2SMcvIUzGdPcdDYjhZsiF0pXx4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791312887; c=relaxed/simple;
	bh=k73IlG3g7n5Dk+vW/OQDAtyvp38KtJS9kg1m9v8Gwv4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VhJlASjhuXwnzzoZMt2pxFCYbVA9Hxducoia95zu79Kfez0gd9DKtQF4mWuf+c2sYP0zXIhEiZnZPwtyEq5qPpzvTpbbKxMya3HgiuMgVARrQBRWUVwYF8gVqgs/QM5SVxKhzMIpbsiTQ0rG9gRzwxd15TSjSiKsWX/1gNHqRwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izA/G9ft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izA/G9ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DB61F0089B;
	Tue,  6 Oct 2026 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791312881;
	bh=r/JZU5H4d5OgN0iGBnB21hGRgsxVl76eWsvdHJN9oYk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=izA/G9fto7LJZU1iptfCwkA61qOznBKjdv+aUm+1sA4PVKpjKJgFTVl0Jof4vA+Xl
	 ny7qjqgcrSfU7Axt8DasvrEzFPu9sz+1QwAueB1D1tGLI61i9oi0t7xFWAdy1Ztmdj
	 QTZChdpVZqDhlwMWcvp9oPURp6t8+sqYRWBAJtyN0RFmyKaqjEhrZYxf/2mJlWtuqa
	 3yncv7WhxumIU2kaSFl8+JrvG1OhDTsnpuIYnlG/132YVA6H3mLf8DEt5ZJbUnnY+f
	 NLQOK34MfLzlMyC/MZrhkyobLkKLQNat1iEVwU6+D0JQ+ep9FlfQ66jje+v+hfA7gD
	 wZF05xLsYNGAw==
Message-ID: <sashiko-outbox-162379@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: enforce memory window ranges
Reply-To: sashiko-reviews@lists.linux.dev
To: sungbyeongchan <tjdqudcks0424@naver.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261006183919.1304642-1-tjdqudcks0424@naver.com>
References: <20261006183919.1304642-1-tjdqudcks0424@naver.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 18:54:40 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rdma/rxe: Data race and read tearing on MW properties bypasses bou=
nds check
- [Medium] rxe: false R_Key violations for IB_FLUSH_MR packets using MWs
--

commit b3dae41fdb80e5db85c15f3370a6417776daa69e
Author: sungbyeongchan <tjdqudcks0424@naver.com>

RDMA/rxe: enforce memory window ranges

RXE records the address and length authorized by an MW bind, but the respon=
der
does not compare a remote request with that interval. This commit checks the
complete request extent against the MW interval before selecting the backin=
g MR.

> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw=
/rxe/rxe_resp.c
> index ba3b2d23b36b7..e5b6c461665c4 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -522,6 +522,8 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
>  	pktlen	=3D payload_size(pkt);
> =20
>  	if (rkey_is_mw(rkey)) {
> +		u64 mw_start;
> +
>  		mw =3D rxe_lookup_mw(qp, access, rkey);
>  		if (!mw) {
>  			rxe_dbg_qp(qp, "no MW matches rkey %#x\n", rkey);
> @@ -529,6 +531,14 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
>  			goto err;
>  		}
> =20
> +		mw_start =3D (mw->access & IB_ZERO_BASED) ? 0 : mw->addr;
> +		if (unlikely(va < mw_start || resid > mw->length ||
> +			     va - mw_start > mw->length - resid)) {

[Severity: High]
Does this bounds check introduce a data race?

Since mw->addr and mw->length are 64-bit fields, can they be modified
concurrently by rxe_do_bind_mw() or rxe_do_invalidate_mw() running
independently in the requester tasklet?

Without holding mw->lock or using memory barriers, could this lead to read
tearing on 32-bit architectures?

Even on 64-bit architectures, this might allow the CPU to observe inconsist=
ent
states (like an old rkey but a newly inflated length), which could defeat t=
his
new bounds check.

[Severity: Medium]
Will this falsely reject IB_FLUSH_MR packets?

For an IB_FLUSH_MR request specifying an MW R_Key, the packet lacks a RETH
header, so the responder does not update qp->resp.va or qp->resp.resid.

Because this new strict MW bounds check runs before the existing FLUSH logi=
c,
doesn't it evaluate those uninitialized or stale va and resid values against
the MW boundaries?

This would falsely trigger an out-of-bounds error and drop valid flush
requests.

Furthermore, if the stale values happen to fall within the MW bounds, would=
n't
the operation skip mr_check_range() based on the existing FLUSH logic furth=
er
down in the function, and improperly flush the entire backing MR rather than
confining the flush to the MW?

check_rkey() {
    ...
	if (pkt->mask & RXE_FLUSH_MASK) {
		/* FLUSH MR may not set va or resid
		 * no need to check range since we will flush whole mr
		 */
		if (feth_sel(pkt) =3D=3D IB_FLUSH_MR)
			goto skip_check_range;
	}
    ...
}

Should the FLUSH check happen before evaluating the MW bounds?

> +			rxe_dbg_qp(qp, "request outside MW range\n");
> +			state =3D get_rkey_violation_state(pkt);
> +			goto err;
> +		}
> +
>  		mr =3D mw->mr;
>  		if (!mr) {
>  			rxe_dbg_qp(qp, "MW doesn't have an MR\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261006183919.1304=
642-1-tjdqudcks0424@naver.com?part=3D1
