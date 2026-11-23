Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446156;
	b=Y+a+0JwJeEjFGRSh/nhi4ilth3ofWynxjh0Zr6axqW28ij4gol8UzaTjDyMMbUEwKtQ/
	 eo/gFSmJ3jdK8TKu1cqCkdTMsSW0cFJSzyB4aMfOhS6BUAEuST5kGjs+WAOQY4qywmz3U
	 6H0kU2eO8k5NYbjVZamm8JJtmoXX3TlW413psEWZYFdWkMkDZjACfJmN5LwAyUEIgAFh+
	 NhTYnCPQ+hl7j6znva6iO7K+rUyqVkzgY4HMC9U1iSeF6Sb154NEijmAZYtbE0ck3z8gf
	 SHE4nCStN7rq2D3tfzzRGCaIzwm+zYSXujz0upKEu9jH/piDa0FMjaCVrphjTqyx2ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446156;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=W5RWbJiraCOaRRtzXNZhfWCde7w7xlZtx4jexRA2pPM=;
	b=P5p6jrRQnU5/dqI3gsADs/FUxRBsTSq65dSA7yDouxVQe6kS9sft7YzTnMgx8EVZTbJY
	 CcuO6msJq+tK1o9mX8579CxesqX/fzmZWaEW8l8pbu0l5QXdpvqKQzcersrKQoDtZoIfK
	 t6hEgVVdPKo91Qaco6LGnLeZbK48i8ZM5sQhZNPNkpxrFxwIN+zZtm7reqTv8nrZeyu8i
	 fgXGMM2dN9ArQerUdLiC6SSsw9Hik7AYvH2Folg0KkxrkOs9kHy8vFRvql7Igmu0JgSI6
	 93iW1S9xJe9pyQuFtXeL5IHz5y7VY8J2B+AsqKKv1EwbCCpZtbAKGMqywf7nfV0eazw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IbTkV2HK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74A2606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IbTkV2HK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A7A1F000CA;
	Mon, 23 Nov 2026 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446156;
	bh=W5RWbJiraCOaRRtzXNZhfWCde7w7xlZtx4jexRA2pPM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=IbTkV2HKNMs4DmnI+70bjftrKZ0QQmJM1XdN8w83xWV2sFv2A56FtvEZrxtovXiAg
	 xG6V7SkrEvtqldwtPGLWmMT0SGal4kf+FcWDt5g7NJW47smuQRCJLN9XYiREHVtKWT
	 ja2SnMs7EDfNiJ20l+c1oGUbm4RrlT3m0jB+SVjw7dBpJjPAYnrCVzW0eeSuKrmAYY
	 ieesyPZYsWn/gdEsV55OaBZbBvFPhbs3CzTjp7MmpnjvgllZWm/pty6ZbJ9t700uuO
	 Mq/QFBrxGsIu9hK2GFwpz+D9B3mcIg9Y5KFTymsMBO4qdXEHZw1r4R4qcHawsNsLmE
	 IJ3MdLgpI/Uug==
Message-ID: <sashiko-outbox-229468@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/9] RDMA/rtrs-clt: Trigger error recovery when posting
 LOCAL_INV fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Md Haris Iqbal" <haris.iqbal@ionos.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261123143719.938876-4-haris.iqbal@ionos.com>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
 <20261123143719.938876-4-haris.iqbal@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 15:02:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] RDMA/rtrs-clt: early return in complete_rdma_req() leaks DMA
  mappings
--

commit 61b2b66e033c3217c1bebe6348e99899004f5550
Author: Jack Wang <jinpu.wang@ionos.com>

RDMA/rtrs-clt: Trigger error recovery when posting LOCAL_INV fails

This commit clears req->mr->need_inval and triggers RDMA error recovery
when rtrs_inv_rkey() fails synchronously in complete_rdma_req().

> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/=
ulp/rtrs/rtrs-clt.c
> index de226e6ba1246..5ef912a472cda 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> @@ -436,6 +436,19 @@ static void complete_rdma_req(struct rtrs_clt_io_req=
 *req, int errno,
>  			if (err) {
>  				rtrs_err_rl(con->c.path, "Send INV WR key=3D%#x: %pe\n",
>  					    req->mr->rkey, ERR_PTR(err));
> +				/*
> +				 * No LOCAL_INV completion will fire, so the
> +				 * rkey is still live on the HCA but we cannot
> +				 * invalidate it from this context.  Clear
> +				 * need_inval so subsequent reapers don't
> +				 * wait on an invalidate that will never
> +				 * happen, and kick off error recovery so the
> +				 * QP (and MR) is torn down cleanly via
> +				 * fail_all_outstanding_reqs() ->
> +				 * complete_rdma_req(can_wait=3Dtrue).
> +				 */
> +				req->mr->need_inval =3D false;
> +				rtrs_rdma_error_recovery(con);
>  			} else if (can_wait) {
>  				wait_for_completion(&req->inv_comp);
>  			}

[Severity: High]
Does complete_rdma_req() leak the DMA mapping on req->sglist when called
from fail_all_outstanding_reqs() on an in-flight request that still has
req->mr->need_inval set?

During recovery, rtrs_clt_stop_and_destroy_conns() drains QPs via
stop_cm() and then runs fail_all_outstanding_reqs(), which calls
complete_rdma_req() with can_wait =3D true and req->ref =3D=3D 1.
complete_rdma_req() increments req->ref to 2 before rtrs_inv_rkey(), and
neither the if (err) branch (when posting to the stopped QP fails) nor the
else if (can_wait) branch (where rtrs_clt_inv_rkey_done() only signals
req->inv_comp without dropping a reference) decrements req->ref:

drivers/infiniband/ulp/rtrs/rtrs-clt.c:complete_rdma_req() {
	...
			refcount_inc(&req->ref);
			err =3D rtrs_inv_rkey(req);
			if (err) {
				...
				req->mr->need_inval =3D false;
				rtrs_rdma_error_recovery(con);
			} else if (can_wait) {
				wait_for_completion(&req->inv_comp);
			}
			if (!refcount_dec_and_test(&req->ref))
				return;
		}
		ib_dma_unmap_sg(clt_path->s.dev->ib_dev, req->sglist,
				req->sg_cnt, req->dir);
	...
}

refcount_dec_and_test(&req->ref) drops req->ref from 2 to 1 and returns
early, skipping ib_dma_unmap_sg() and the clt_path->stats->inflight
decrement right before fail_all_outstanding_reqs() fails over or completes
the request.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123143719.9388=
76-1-haris.iqbal@ionos.com?part=3D3
