Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DEA46AA9A
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 09:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791453304; cv=none; b=IX0glMx7mCiDiAAfEQuNcTec8lwe8APgO88C2tMQ7kKP7szFYiuG93pocjXdAbGy/uzoGRF/t+s6GR30WQgAc4OyvoYTWoONhTW71CshEr6rxEhJVIemGb6SMM6XGRCHxkxLPHBPfzEb82fj9Xw5aQq45IjxRRU8zDnwFkRTdY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791453304; c=relaxed/simple;
	bh=1oZy1Gnd9qJn+2r5OBMbPsTVT3q9RKHfjDCbRAdnTBU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=M5IIFV5lPvSyc2m/7hlOjaGas4s0DMFH1UgG5Q3aMtrOp40yA7xHIXE9+ixsbINvTrzBq2PlIoijCMiJEKsmzNDm0yUgrOJgiMDRvJRb19vNdkJ20zvmHiLcne7K2hreUCOmN+I92jxsraeKMFDzFoqK4POcL0yhBK7cTkJINMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2VHVSAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2VHVSAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A011F000FF;
	Thu,  8 Oct 2026 09:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791453303;
	bh=uWWaZVzSynB4eKKjDBsFjMp1GPROjSBFEEnHDlstSMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b2VHVSAeHRtLeBASgGwKHHhbgBl8FxbTHfB9s4bYsHmvf192vNWBnxY0qy09G/CwO
	 PL3nkTxYQNYLd/NEe7zVTfJu+3kHVaD2R0Oti/PYjiTdi01TGbNzfTM4icwRmPMHbe
	 mew4KfFizfN6iBeKTRd4GMaHW4K5x+3WG41uKq1xhm29RXR0nDXz8ev5aUEMrnd9l1
	 0gcaMKFwqK27tHL6dA+R/oxFtLk9FpyTXAjNP0vVHUv/YsUh7itmSICFa08i4VRq4P
	 2Qyo6W5E1FKR35PEk3gMk870PDXzXTmPsE+wAmzMwLomKDn84b8T1Xv4LyEvp3yDRA
	 xH1ckA3lueyyQ==
Message-ID: <sashiko-outbox-163969@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/2] RDMA/rxe: copy send WQE to kernel buffer in
 completer path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008093740.3034881-3-tristmd@gmail.com>
References: <20261007223222.2342804-1-tristmd@gmail.com>
 <20261008093740.3034881-1-tristmd@gmail.com>
 <20261008093740.3034881-3-tristmd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 09:55:02 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] RDMA/rxe: Out-of-bounds array access due to unvalidated dma.cu=
r_sge in copied WQE
- [High] RDMA/rxe: Incomplete TOCTOU fix leaks shared WQE pointer when wqe_=
state_posted
- [High] RDMA/rxe: Broken RDMA READ retry logic due to omitted dma.resid wr=
iteback
- [High] rdma/rxe: FORTIFY_SOURCE field-spanning write warning in get_wqe()
--

commit cf86a77297c64ab74c16b59fe4e3de0489c867e4
Author: Tristan Madani <tristan@talencesecurity.com>

RDMA/rxe: copy send WQE to kernel buffer in completer path

This commit attempts to fix TOCTOU races by copying send WQEs from the
shared queue to a kernel-private buffer in the completer path. It
introduces local copies of the WQE to preserve DMA progress and updates
writeback logic before advancing the consumer index.

> diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw=
/rxe/rxe_comp.c
> index 1390e861bd1d7..5d8b692114a33 100644
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
[ ... ]
> +/* Write back completer WQE fields to shared memory */
> +static void rxe_comp_writeback_wqe(struct rxe_qp *qp)
> +{
> +	struct rxe_send_wqe *shared =3D qp->comp.shared_wqe;
> +	struct rxe_send_wqe *local =3D &qp->comp.comp_wqe.wqe;
> +
> +	if (!qp->comp.comp_wqe_valid || !shared)
> +		return;
> +
> +	WRITE_ONCE(shared->status, local->status);
> +	WRITE_ONCE(shared->has_rd_atomic, local->has_rd_atomic);

[Severity: High]
Does this code fail to write back dma.resid and dma.sge_offset?

If a timeout occurs, the requester's retry logic (req_retry()) reads the
unmodified dma.resid from the shared WQE (or its own unmodified private
copy) to calculate the retry offset.

This causes it to retry from the beginning (offset 0) but with an advanced
PSN, resulting in the completer writing redundant remote data into advanced
local offsets.

> +}
> +
>  static inline enum comp_state get_wqe(struct rxe_qp *qp,
>  				      struct rxe_pkt_info *pkt,
>  				      struct rxe_send_wqe **wqe_p)
>  {
>  	struct rxe_send_wqe *wqe;
> +	u32 state;
> =20
>  	/* we come here whether or not we found a response packet to see if
>  	 * there are any posted WQEs
>  	 */
>  	wqe =3D queue_head(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
> =20
>  	/* no WQE or requester has not started it yet */
> -	if (!wqe || wqe->state =3D=3D wqe_state_posted)
> +	if (!wqe) {
> +		*wqe_p =3D NULL;
>  		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}
> +
> +	/* Pairs with smp_store_release() in rxe_req_writeback_wqe() */
> +	state =3D smp_load_acquire(&wqe->state);
> +	if (state =3D=3D wqe_state_posted) {
> +		*wqe_p =3D wqe;

[Severity: High]
Does this code assign the userspace-mapped shared memory pointer to *wqe_p
instead of forcing a local copy or returning NULL?

If the completer drops into COMPST_ERROR_RETRY (e.g., following a timeout),
it evaluates wqe->state =3D=3D wqe_state_posted using this shared pointer.

Userspace can concurrently modify wqe->state to bypass this check, causing
the completer to erroneously process un-started WQEs.

> +		return pkt ? COMPST_DONE : COMPST_EXIT;
> +	}
> +
> +	/* Reuse existing local copy if still processing same WQE
> +	 * with unchanged state (preserves DMA progress for multi-packet ops)
> +	 */
> +	if (qp->comp.comp_wqe_valid && qp->comp.shared_wqe =3D=3D wqe &&
> +	    qp->comp.comp_wqe.wqe.state =3D=3D state) {
> +		wqe =3D &qp->comp.comp_wqe.wqe;
> +		*wqe_p =3D wqe;
> +		goto check_state;
> +	}
> +
> +	/* Copy shared WQE to kernel-private buffer. Use max_inline
> +	 * as copy size since it covers both SGEs and inline data,
> +	 * which share the flex array.
> +	 */
> +	qp->comp.shared_wqe =3D wqe;
> +	memcpy(&qp->comp.comp_wqe.wqe, wqe,
> +	       sizeof(*wqe) + qp->sq.max_inline);

[Severity: High]
Can this memcpy trigger a FORTIFY_SOURCE field-spanning write warning?

This memcpy targets the wqe sub-object but copies a length that spans into
the adjacent sge field.

The compiler's bounds check restricts the write destination field to exactly
sizeof(*wqe), so this triggers a fortify warning (and panic if panic_on_warn
is enabled) when max_inline > 0.

> +	qp->comp.comp_wqe_valid =3D true;
> +	if (qp->comp.comp_wqe.wqe.dma.num_sge > qp->sq.max_sge)
> +		qp->comp.comp_wqe.wqe.dma.num_sge =3D qp->sq.max_sge;

[Severity: Critical]
Does this code neglect to validate cur_sge after the copy from userspace?

A malicious userspace application can set cur_sge to an arbitrarily large
value.

During RDMA read or Atomic response processing, copy_data() indexes the
dma->sge array using this unvalidated cur_sge, accessing memory outside
the comp_wqe buffer.

> +
> +	wqe =3D &qp->comp.comp_wqe.wqe;
> +	*wqe_p =3D wqe;
> =20
> +check_state:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008093740.3034=
881-1-tristmd@gmail.com?part=3D2
