Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795485651;
	b=zTAUMOC6FZBYRarbJ51si4Kj9KGfStBNwu2/+5CF6OT/pWn0OSSO6G4ubEhNf0DtodWa
	 Ik7yRLUxUY3Y5h6pdSLoRuoaqdsDD7VtmJC6SIDrsQtke2v8Y76lnFTaUOmyqIFw4lSp0
	 Ubt6rcJwhptehvTlPUn/JmLhfiz8ABoY+39M4RyUpFGqJ8JKul/grf8nuWrbaNXtHEhuN
	 Nhpf3HHzfqpuFuw5PMWNJw2cwtCN+eJ7LyIvdIPd+R+OHOlo3zVebZKGtvVHRrMPgw7kd
	 xmQ3BoNDTeR4d5NRrOOhadjj7rKbnjnp0AwNXSKn7i2Lk5y/kZNKu0M2o4bHeiZ/A3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795485651;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Jj0n0+tB1x+X4Bbs6JlM1I7E4oFUQII92KkP+nrLRZo=;
	b=YX4NomTUuyAGH/OhltOmfqw4VbQJn6vnqwi6Xl6hzyYQqfcpVyLuIdIJwXwPNziBE74l
	 QK5XWNwyU7TkW4gUXFQWJOPemO9DmO3cUuOY2cCh+sRwFV6E29J7WR2GJFBeXO8oSaD4x
	 BCuOAp5M2yAXW1V1tSkwmOlj0QAWARUf6VkWMLzbXjYA/vk4Jg8Y0tMyVHKipZLZzKvQ+
	 jK3xoD8ZZIlUDThGeE2Uy8D4GNZ8rJRICTZbJmIMXK8zKrnpJN0kV2Sp0B+G5ekZujkJy
	 ScpuZUXue+M7Czd7RE7lsXQsD3fFvrl/us1y36QH8yC/HXwHRVgHfLoUMbpHU/Usg8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2tBsdTS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EE9606A321
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 02:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2tBsdTS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485C61F000C0;
	Tue, 24 Nov 2026 02:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795485650;
	bh=Jj0n0+tB1x+X4Bbs6JlM1I7E4oFUQII92KkP+nrLRZo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C2tBsdTSe0PkyMnZ3iFQc8A7rNTbF3dUfP3QWZRLZZvHVwHeTbMXcLoIwND52S2Ph
	 xZuj4ctoeKhg5PFS2kSIUfzIQupm3MHbhbCgeB2OP7Q7rkEMaZ5yo5nuAQ9qTrfYQ5
	 Q+YqFvemlNb282Ml21BhhuyjqWtzHmnfRMCb1QciJLpRGJ+EViFI+Irtp859qdWNtY
	 2lHBH4IqyO9zAt4jPIrDNWj90PnuXHzr6BM1wCPSRphqzrRbr0fEUQqFIaxq/6JQSd
	 XbVIztgOuhUCIsJddXbqvcgxIt2N4xwHroEO8NkaBj4hWm9xbfSqB4iaa6XHoI/GA2
	 lwpx0YJGbGheA==
Message-ID: <sashiko-outbox-230364@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Don't republish a QP whose
 destroy failed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <oss.patchbox@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124015141.294866-2-oss.patchbox@gmail.com>
References: <20261124015141.294866-2-oss.patchbox@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 02:00:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] RDMA/bnxt_re: data race in bnxt_qplib_create_qp1() [1]
--

commit 1b21d21008b23e4ba7182837a1d5e17b617eab26
Author: Yuho Choi <oss.patchbox@gmail.com>

RDMA/bnxt_re: Don't republish a QP whose destroy failed

This commit drops the rcfw->qp_tbl rollback in bnxt_qplib_destroy_qp() so a
QP is not reinserted into the table if the DESTROY_QP firmware command
fails.

> diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniban=
d/hw/bnxt_re/qplib_fp.c
> index 5301e4f21ade0..a5660002d1840 100644
> --- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
> @@ -1473,7 +1473,6 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *re=
s,
>  	struct bnxt_qplib_cmdqmsg msg =3D {};
>  	struct cmdq_destroy_qp req =3D {};
>  	u32 tbl_indx;
> -	int rc;
> =20
>  	spin_lock_bh(&rcfw->tbl_lock);
>  	tbl_indx =3D map_qp_id_to_tbl_indx(qp->id, rcfw);
> @@ -1488,16 +1487,11 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *=
res,
>  	req.qp_cid =3D cpu_to_le32(qp->id);
>  	bnxt_qplib_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req),
>  				sizeof(resp), 0);
> -	rc =3D bnxt_qplib_rcfw_send_message(rcfw, &msg);
> -	if (rc) {
> -		spin_lock_bh(&rcfw->tbl_lock);
> -		rcfw->qp_tbl[tbl_indx].qp_id =3D qp->id;
> -		rcfw->qp_tbl[tbl_indx].qp_handle =3D qp;
> -		spin_unlock_bh(&rcfw->tbl_lock);
> -		return rc;
> -	}
> -
> -	return 0;
> +	/*
> +	 * Don't put the QP back into qp_tbl if the command fails: no caller
> +	 * uses the QP after a failure, and most of them free it right away.
> +	 */
> +	return bnxt_qplib_rcfw_send_message(rcfw, &msg);
>  }

[Severity: High]
This problem wasn't introduced by this patch, but shouldn't
bnxt_qplib_create_qp1() also hold rcfw->tbl_lock when populating
rcfw->qp_tbl [1]?

drivers/infiniband/hw/bnxt_re/qplib_fp.c:bnxt_qplib_create_qp1() {
	...
	tbl_indx =3D map_qp_id_to_tbl_indx(qp->id, rcfw);
	rcfw->qp_tbl[tbl_indx].qp_id =3D qp->id;
	rcfw->qp_tbl[tbl_indx].qp_handle =3D (void *)qp;

	return 0;
	...
}

Once bnxt_qplib_rcfw_send_message() completes CREATE_QP1, firmware can
emit events for the new QP while bnxt_qplib_create_qp1() is still running:

CPU0                                  CPU1 (CREQ tasklet)
bnxt_qplib_create_qp1()
  bnxt_qplib_rcfw_send_message()
                                      bnxt_qplib_process_qp_event()
                                        spin_lock(&rcfw->tbl_lock)
  rcfw->qp_tbl[tbl_indx].qp_id =3D ...
  rcfw->qp_tbl[tbl_indx].qp_handle =3D ...
                                        reads rcfw->qp_tbl[tbl_indx]
                                          <-- data race
                                        spin_unlock(&rcfw->tbl_lock)

Without rcfw->tbl_lock, bnxt_qplib_process_qp_event() can observe a
partially updated qp_tbl entry, missing a QP error notification or
dereferencing an uninitialized qp_handle.

[1] https://sashiko.dev/#/bug/linux-c8dafdae-4eb3-4ddb-a2a2-5d1da6ca2da5

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124015141.2948=
66-2-oss.patchbox@gmail.com?part=3D1
