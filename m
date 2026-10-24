Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792861618;
	b=v3jKQE5FVn2mSHfobumfg0Pg9qY0yaQcCnahHDkR93/zeYk9H4C7coRsHgoJFp8+n/r/
	 6zQHTleX+DsFamo4I14SgQYsloHHpDKKYzbMFiJqKBpSsRg1ixk08LS6dM80Rp0W48vG5
	 1VXDw5jYoxywsp70BEP9R8yx5J2RPAEUX8moUimArtbm7JXDx6WL3eMyfH18h0AUASS95
	 +X535XOdcIeae0TCjWNWOJtRssxQZc75ErXcXuD9ScSWdI1lzYK4d2Teh8wPKrWmMeDHY
	 vf6EUIMDD2pPQW2wUQXILv2B844C1Hz2izFFXb7+3neyfsNHA8vM4qcBCDrO6OhVwXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792861618;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oeoM2TMsWghRgj7db/pOVmmLge3UEPMn4GDw/KxDpyE=;
	b=g6TLD6Um03YUnbT0/R6B5PaR9poLZ87G7zDiBpoE9yh7PZcXFRgNFWDNXnbJ3cpqeHUO
	 394AxtaO4UGS4epV6dIuvKojucf+TWhUYrX9Pz9kUIwnnIVkSdVVt/J5IMqsTOHKEgPrg
	 o+kLLCBXbbmT/53TUHEKmLP3fp657Fg0c0CW/po3ERUfrwJ039MLF3Qbz45tU1lBrLs8n
	 S+bVVmHinXwShRUIBlja+/j7UuKfWRVjsovspXYVVC63fOmRXgO+aDYACfwkotdKgnQdr
	 o3vzrzII4w8ocg1+z8BbCF7P9KAu8R0IzEl+47vAzcbLgfhFuPfGlm3a5ugprNZ0BHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XqHWavwK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D5F606A31A;
	Sat, 24 Oct 2026 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XqHWavwK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9731F01825;
	Sat, 24 Oct 2026 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792861617;
	bh=oeoM2TMsWghRgj7db/pOVmmLge3UEPMn4GDw/KxDpyE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XqHWavwK679ouX2lWhi5b3tNZRleGJJ62hvDwrxB9K6kIK5UA9Pc0SXygzpOHsIWT
	 t0FD8g6vAvbT1ahQIX9zqvr5mybPNQASCO69pBmJzLQES+llUOiTuFJGgf5XNc8Xkz
	 G3sFtWTiNqjKyE6mdFMNH4D/wPBVbR/m84GhwwDuRwI34cR+x2xis1MavAXgMmleyf
	 jRX6grZKCiz7Ll++b7r5DaqwIBnvTthwfmHzz/VBkH1qvySLnKlPMMbckNvyEX8XRS
	 Z8NgeteA3LIljUZzCbcX1BZpuKpZZjdI3EPTK65KGBsGZjhjEDIqajxPwcqViZ34fY
	 Be+LgRDvhtncw==
Message-ID: <sashiko-outbox-183819@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] RDMA/srpt: bound the indirect descriptor table
 to the IU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261024162852.3528224-2-yhlee@isslab.korea.ac.kr>
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr>
 <20261024162852.3528224-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 17:06:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/srpt: unrejected zero-descriptor indirect table in srpt_get_d=
esc_tbl()
--

commit 8189d07cfa54a6ae2404e7715f0d334dafe9c38a
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

RDMA/srpt: bound the indirect descriptor table to the IU

This commit bounds the indirect descriptor table in srpt_get_desc_tbl()
against the received IU length (recv_ioctx->byte_len) to prevent an
out-of-bounds read in srpt_alloc_rw_ctxs().

> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
> index 43c3ff1ad8e7e..21264264356a2 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1117,6 +1117,7 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx=
 *recv_ioctx,
>  		struct srp_indirect_buf *idb =3D srpt_get_desc_buf(srp_cmd);
>  		int nbufs =3D be32_to_cpu(idb->table_desc.len) /
>  				sizeof(struct srp_direct_buf);
> +		size_t desc_off =3D (uintptr_t)idb - (uintptr_t)srp_cmd;
> =20
>  		if (nbufs >
>  		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
> @@ -1128,6 +1129,14 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioct=
x *recv_ioctx,
>  			return -EINVAL;
>  		}
> =20
> +		if (desc_off + sizeof(*idb) +
> +		    (size_t)nbufs * sizeof(struct srp_direct_buf) >
> +		    (size_t)recv_ioctx->byte_len) {
> +			pr_err("received SRP_CMD indirect table (%d descriptors) that does no=
t fit the %d-byte IU\n",
> +			       nbufs, recv_ioctx->byte_len);
> +			return -EINVAL;
> +		}

[Severity: High]
Does this check actually reject an indirect descriptor table when
idb->table_desc.len is smaller than sizeof(struct srp_direct_buf), as
described in the commit message ("and so is a table_desc.len below one
descriptor")?

In include/scsi/srp.h, struct srp_indirect_buf defines desc_list[] as a
flexible array member, so sizeof(*idb) is 20 bytes (only the header). When =
an
initiator sends an SRP_CMD with SRP_DATA_DESC_INDIRECT and
be32_to_cpu(idb->table_desc.len) < sizeof(struct srp_direct_buf), integer
division in srpt_get_desc_tbl() sets nbufs to 0.

If recv_ioctx->byte_len is at least desc_off + sizeof(*idb) (for example, 68
bytes when add_cdb_len is 0), both the existing descriptor count check and =
the
new bounds check pass with nbufs =3D=3D 0, and srpt_get_desc_tbl() calls
srpt_alloc_rw_ctxs() with nbufs =3D=3D 0:

drivers/infiniband/ulp/srpt/ib_srpt.c:srpt_alloc_rw_ctxs() {
	if (nbufs =3D=3D 1) {
		ioctx->rw_ctxs =3D &ioctx->s_rw_ctx;
	} else {
		ioctx->rw_ctxs =3D kmalloc_objs(*ioctx->rw_ctxs, nbufs);
		if (!ioctx->rw_ctxs)
			return -ENOMEM;
	}
	...
	for (i =3D ioctx->n_rw_ctx; i < nbufs; i++, db++) {
		...
	}
	return 0;
}

Because kmalloc_objs() with a count of 0 returns ZERO_SIZE_PTR (non-NULL),
srpt_alloc_rw_ctxs() executes zero loop iterations and returns 0 with
ioctx->n_rw_ctx =3D=3D 0 and *sg_cnt =3D=3D 0.

For a write command (DMA_TO_DEVICE) with idb->len > 0, target_submit_prep()
then allocates target scatterlists and transport_generic_new_cmd() invokes
srpt_write_pending():

drivers/infiniband/ulp/srpt/ib_srpt.c:srpt_write_pending() {
	...
	cqe->done =3D srpt_rdma_read_done;
	for (i =3D ioctx->n_rw_ctx - 1; i >=3D 0; i--) {
		struct srpt_rw_ctx *ctx =3D &ioctx->rw_ctxs[i];

		first_wr =3D rdma_rw_ctx_wrs(&ctx->rw, ch->qp, ch->sport->port,
				cqe, first_wr);
		cqe =3D NULL;
	}

	ret =3D ib_post_send(ch->qp, first_wr, NULL);
}

With ioctx->n_rw_ctx =3D=3D 0, the loop does not run and ib_post_send() is =
called
with first_wr =3D=3D NULL. Depending on the RDMA provider, this either trig=
gers a
NULL pointer dereference on wr (for example, in rvt_post_send() at !wr->nex=
t)
or returns 0 without posting ioctx->rdma_cqe, leaving the command stuck in
SRPT_STATE_NEED_DATA and hanging session teardown in
target_wait_for_sess_cmds().

Should srpt_get_desc_tbl() also reject !nbufs (or table_desc.len <
sizeof(struct srp_direct_buf))?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024162852.3528=
224-1-yhlee@isslab.korea.ac.kr?part=3D1
