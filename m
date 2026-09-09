Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B982D9EDC
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788943662; cv=none; b=baO8tL+159zirzVKEO/vbkeO4FQuEo0OHrxNWAeHZLCEz8+8rdzO52kZfHNXgfo+0wiuhy40DZVGrWxvDU07fqIHzKRLiuMzz3DqRkQRbHHw3hIWFcw67WIO3baB2utH/yh2bU6/Ze1nodZ5onOGbCQzJWyNzY/B8KgNdtTDPYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788943662; c=relaxed/simple;
	bh=fruCVPt/TP1Y2fodnGCzQARlnumcbwAK0jifWhlpecs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KDwMMxC53quNrQsUaBx993EMy8pA5gz6HkB7M3A0nxjoVdHp7DezDxsyX62nJ6CqwhGtjtr9tCWme0TKgw2tPwOwJzEnHCaYuKk/a5f0g+MWtwVzB0ysjmbGqxaNmrtggHKtm/MdGKcGu3cOp7iOlEmrTGHpsSTgecnbDlZNaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BawIjqV4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BawIjqV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77541F00A3A;
	Wed,  9 Sep 2026 08:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788943660;
	bh=O5738LsiaEDkTBbKNaCTrQ6QYFd15cvvvXr6ddW0TGk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BawIjqV4k/gEIMK+7VMkKYFjRZcBpspOMU2PRgrtiy6jZmgYeUoGaW/1DmodlnXtM
	 C2jdkKnoF0YpTzdnf0q/COAZtOV5bT0kFTi3RR2wkUJrR6YBBclNB1OTEfGPSmlNuy
	 uR1ZngOaasVjlCMZx/68FZ40BkbqAjC/dMohHoXoB+2lb/py9HuD5m1RlshoyGBYNr
	 b15qw2e2INva9JBVs99JgpIZ5ou2OSLtkwEZ96qKE3yWnwcZJtyv/TJp4RYar8HnGE
	 XLSEQ0PLI4JJ3FidqaQ371JaxKt3dPgimSOxfm6F3fCukz9jpQmYCiwRJUxur9g5RH
	 yMSPbk2NTxJJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v2 2/8] RDMA/bnxt_re: Detect wrong sge_len passed
 for inline
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260909135244.122747-2-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
 <20260909135244.122747-2-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 08:47:40 +0000
Message-Id: <20260909084740.A77541F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Integer overflow in `bnxt_re_build_sgl` leads to improper rejectio=
n of valid large RDMA payloads.
--

commit ce7a03605a13da6e57de1f53a8c0119ccee546dd
Author: Selvin Xavier <selvin.xavier@broadcom.com>

RDMA/bnxt_re: Detect wrong sge_len passed for inline

This commit avoids handling wrong sge_len by adding an extra check to see if
the passed length is more than the inline size supported.

> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniban=
d/hw/bnxt_re/ib_verbs.c
> index d80a22e4ac70d..e56830a669bf4 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -3168,8 +3168,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_=
dev *rdev,
>  				wr->sg_list[i].addr;
>  		sge_len =3D wr->sg_list[i].length;
> =20
> -		if ((sge_len + wqe->inline_len) >
> -		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH) {
> +		if (sge_len > BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH ||
> +		    ((sge_len + wqe->inline_len) >
> +		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH)) {
>  			ibdev_err(&rdev->ibdev,
>  				  "Inline data size requested > supported value");
>  			return -EINVAL;

[Severity: High]
This is a pre-existing issue, but it exists in the directly associated code
paths. Does bnxt_re_build_sgl() have an integer overflow when dealing with
large RDMA payloads?

drivers/infiniband/hw/bnxt_re/ib_verbs.c:bnxt_re_build_sgl() {
        int i, total =3D 0;

        for (i =3D 0; i < num; i++) {
                ...
                total +=3D sg_list[i].size;
        }
        return total;
}

Since total is declared as a signed 32-bit integer, could summing unsigned
32-bit size values from multiple SGEs cause it to overflow and become
negative for payloads greater than 2GB?

If this overflows and becomes negative, it appears the negative total is
propagated here:

drivers/infiniband/hw/bnxt_re/ib_verbs.c:bnxt_re_post_send() {
        ...
        payload_sz =3D bnxt_re_copy_wr_payload(qp->rdev, wr, &wqe);
        if (payload_sz < 0) {
                rc =3D -EINVAL;
                goto bad;
        }
}

Would this cause legitimate RDMA send or write operations with payloads
between 2GB and 4GB to be erroneously rejected, breaking core functionality
for user-space applications performing large I/O?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909135244.1227=
47-1-selvin.xavier@broadcom.com?part=3D2
