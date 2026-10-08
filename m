Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3013634C98C
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 06:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440336; cv=none; b=pLPSwk91cbEFwi+xCUQLdTE29ORGfVGqrPvdQqbuMfp+w3OrnbUfgW+OaD2/qABKTn926SvrmHNcWY+PsL1wBnWBI/chZ2gJlzLpggGHv9u8sFLgQW5BNBQImTZrcYy8F96yHAKPdAO33fMzll/GRDM/tW/6F4/JeOvoUalj2Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440336; c=relaxed/simple;
	bh=Yv00K49y2YmvkA4MYbi9GV3M4rk21OLq+ANtCl7SwYE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=lhvyFC5o9+e9zSTiT3Lx1T1m5u0fZgEdPDZadIfAPImNRDzN2G3JSCkX8cGv8cJ5umqLJY3I6BReSFnhST8ilhJoD7yUUXhkBdZMhukELlbMqXEmdK12+ypBPzC8QSPNXzYy113Ygah6ySF7RMpvMx+rx2dUURP8Gk6UhgXzBk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwK3BSv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwK3BSv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7321F000FF;
	Thu,  8 Oct 2026 06:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791440334;
	bh=CoreVgQQeOGfVvCfkui94jf5geNxkda1jAT8agJSvn0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jwK3BSv9uej7bEAmouULDkhX4if1ngU24UBDKYcLOev7/Ek8JBG1qu0nuvYsygZSa
	 Ugk2nHG4/aPchUDf/7EZZvhmjVBF4w1/iPBo38Y3PPe6Qq09XlFCtwlgc7CKSjHYEk
	 szzhZ4LimSQ6CYUrTiY0jIEproHcO13MmW3u7c15SYBmwkfCd/msGqv5csF14c4y1G
	 Ml8bknCRIijU1ojpgCzsJB1u6Jitgi1GqfQbLlG8cQ6RGUZ5UKNxe5pl54tUdUIlJQ
	 X9jmOYUWcdHj0RQzYr9HJ/gc8hUSupFxrpPz5o+5R9ZEe3NT6shVUNxmU73P9vwt3N
	 DF1XIIwFfvwfw==
Message-ID: <sashiko-outbox-163679@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: enforce memory window ranges
Reply-To: sashiko-reviews@lists.linux.dev
To: "sung byeongchan" <tjdqudcks0424@naver.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008060751.183786-1-tjdqudcks0424@naver.com>
References: <20261008060751.183786-1-tjdqudcks0424@naver.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 06:18:54 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] rxe: replay of completed MW-based RDMA READ fails unconditionally
- [High] RDMA/rxe: spurious MW bounds check failure on RDMA Read retry
--

commit 75bedbaf8f14c7951915e41ef579bcbb28d9e507
Author: sung byeongchan <tjdqudcks0424@naver.com>
Subject: RDMA/rxe: enforce memory window ranges

This commit enforces memory window ranges by validating the window and taki=
ng
a reference on its backing MR while holding the lock. It ensures requests s=
tay
within the delegated interval and requires later packets or replays to reso=
lve
to the same MR and interval. The changes aim to prevent unauthorized access=
 to
userspace memory outside the bounds of the delegated memory window.

> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw=
/rxe/rxe_resp.c
> index ba3b2d23b36b7..19eb60c317d00 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
[ ... ]
> @@ -892,27 +900,33 @@ static struct sk_buff *prepare_ack_packet(struct rx=
e_qp *qp,
>   *
>   * Return: mr on success else NULL
>   */
> -static struct rxe_mr *rxe_recheck_mr(struct rxe_qp *qp, u32 rkey)
> +static struct rxe_mr *rxe_recheck_mr(struct rxe_qp *qp,
> +				     const struct resp_res *res)
>  {
>  	struct rxe_dev *rxe =3D to_rdev(qp->ibqp.device);
> +	u32 rkey =3D res->read.rkey;
>  	struct rxe_mr *mr;
> -	struct rxe_mw *mw;
> =20
>  	if (rkey_is_mw(rkey)) {
> -		mw =3D rxe_pool_get_index(&rxe->mw_pool, rkey >> 8);
> -		if (!mw)
> +		u64 addr, length;
> +		int access;
> +
> +		mr =3D rxe_lookup_mw(qp, IB_ACCESS_REMOTE_READ, rkey,
> +				   &addr, &length, &access);
> +		if (!mr)
>  			return NULL;
> =20
> -		mr =3D mw->mr;
> -		if (mw->rkey !=3D rkey || mw->state !=3D RXE_MW_STATE_VALID ||
> -		    !mr || mr->state !=3D RXE_MR_STATE_VALID) {
> -			rxe_put(mw);
> +		/* A replay or a later response packet must still refer to the
> +		 * same backing MR and the entire originally authorized interval.
> +		 * This catches invalidate/rebind even when the object survives.
> +		 */
> +		if (mr !=3D res->read.mr || res->read.va_org < addr ||
> +		    res->read.length > length ||
> +		    res->read.va_org - addr > length - res->read.length) {
> +			rxe_put(mr);
>  			return NULL;
>  		}

[Severity: High]
Does this strict pointer comparison fail when a completed read is replayed?

When a Memory Window based RDMA READ completes normally, read_reply() drops=
 the
MR reference and clears the pointer:

    if (res->read.mr) {
        rxe_put(res->read.mr);
        res->read.mr =3D NULL;
    }

If the final completion ACK is lost, the requester will time out and retran=
smit
the request, causing the responder to replay the READ response. During this
replay, read_reply() calls rxe_recheck_mr() to re-validate the backing MR.

Because res->read.mr was cleared to NULL upon completion, but rxe_lookup_mw=
()
returns a valid mr pointer, the condition mr !=3D res->read.mr evaluates to=
 true.
This causes validation to fail and returns NULL, leading to a spurious
RESPST_ERR_RKEY_VIOLATION that terminates the connection.

The direct MR check later in this same function safely handles the NULL sta=
te
via (res->read.mr && mr !=3D res->read.mr). Should a similar check be used =
here?


[Severity: High]
This problem wasn't introduced by this patch, but does the new bounds check
cause a spurious failure during an RDMA Read retry?

The existing duplicate_request() function handles subset retries by advanci=
ng
the origin virtual address without modifying the read length:

    duplicate_request()
        ...
        /* Reset the resource, except length. */
        res->read.va_org =3D iova;
        res->read.va =3D iova;
        res->read.resid =3D resid;

Because va_org is advanced but read.length is not proportionally reduced, t=
he
computed end of the request exceeds the MW boundaries when evaluated by the=
 new
bounds check. Can this result in a spurious rkey violation on valid subset
retries that span to the end of the MW, incorrectly tearing down the connec=
tion?

> =20
> -		rxe_get(mr);
> -		rxe_put(mw);
> -
>  		return mr;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008060751.1837=
86-1-tjdqudcks0424@naver.com?part=3D1
