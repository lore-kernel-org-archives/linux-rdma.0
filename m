Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792512736;
	b=BuICJgLHiV5sDEWg6zAfSOlin53T5HvLOjP1qG3x9jFbeWw6qvNAKOHhT4h3Dp9eXHmd
	 IjulQW8KvTs5els5z+AVK2+pJsaLm6jGzSInDgtKQydE5rwWAXYUW1kYN9DWAlJEDWUu5
	 ybuC3Cww4kWkByZP8sZV301KwHCDs+FanEHUBEFg8wQH8yS6x5n/j7n1kVpbUCRnPKYUy
	 8BuKC9Y0i9hvgIw2UrAxgtNXHOwtfgzwC++ibYJr5X149RTkefU7DOyJq9x5K7ueO+zzC
	 6tAW5clSrRnAVmplDLK9Kws14KL5XCy28pXaHgcQfNsnO0b9++lauSQMlRsjuxlqldw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792512736;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YZ8Mx1QpIlE8BaTM78cQLZ/jR43apTG9y9wplK6oxk8=;
	b=ahkl3/PitWtmdD8TsOfrHR/Ne4EF3BUTPUeBGebk0DSq01/zC/uCBRUP+bRVAiEfE+Kd
	 hEEwHrjAidlfLwmj7b4ssGHscJua3IQM0iSxUBywcEUj2Jv6bxrSjp1qeTUIYSqup4HgA
	 gexQa+w65BykZMKWnKVIEXtq1pXK1FzAmclr1Wx6xk5PzwECvfcj/F1nJP5f1nv3qFdQM
	 kJ7afB00YjYdR6BvGClUL9y08feVtqbIuelaH6fsX07jMpm8W2cY0mSdF+/hHUvNb2otK
	 ca69JpTNLVt1C7sZnKgFdXCWqh22NKjJx8TF7SnOAUB44KnSmn9ncsmwb8GIDqn+TYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+Vudzjv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F8B606A32D;
	Tue, 20 Oct 2026 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+Vudzjv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D761F000C4;
	Tue, 20 Oct 2026 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792512736;
	bh=YZ8Mx1QpIlE8BaTM78cQLZ/jR43apTG9y9wplK6oxk8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g+VudzjvI11dwIEKnCi4IzzQCd5VrEbaAUEDmfVpYONjtQQ3su0Uj1L1T5QVzVbmi
	 4ae6KLNMicTrMONab3SoFXY9KbK0+asS5YfNdFFM8A+Ln1oKKx1E2FjyDE0StaUpXJ
	 29VhGwOa4wL0LUpauFZ3sIeKGjFZE67vK0EBWx7NQJ4wLAgb6NLRxzrBCqoQOD9E64
	 4mPXKeOBSSh+QApSvYvnRKi8xtWAIvPUYSBCO1IhGCjbziQ4I2soqHIDvbdJcudHs7
	 hSImbd+r9MXhBxK52EW3JJltrqF6FkKRmZgYhTOH6UE40AjJZua564XVMsP2D01bQm
	 Rk+1GeNmXepnQ==
Message-ID: <sashiko-outbox-179333@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/srpt: widen the RDMA context counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261020155725.2251969-1-yhlee@isslab.korea.ac.kr>
References: <20261020155725.2251969-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 16:11:49 +0000
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
- [High] RDMA/srpt: out-of-bounds read in srpt_alloc_rw_ctxs() via unvalida=
ted nbufs
--

commit 59a5707e41afe2c64f3f73bdc878e66abce7dc02
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

RDMA/srpt: widen the RDMA context counters

This commit widens the n_rdma and n_rw_ctx counters in struct
srpt_send_ioctx and srpt_alloc_rw_ctxs() from u8 to int so that SRP_CMD
requests carrying up to 510 indirect data buffer descriptors do not
wrap the counters and leak scatterlists and RDMA contexts.

> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
> index 7197d95f2216b..b174d58ca98a3 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -959,7 +959,7 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx =
*ioctx,
>  	struct srpt_rdma_ch *ch =3D ioctx->ch;
>  	struct scatterlist *prev =3D NULL;
>  	unsigned prev_nents;
> -	u8 n_rdma, n_rw_ctx;
> +	int n_rdma, n_rw_ctx;
>  	int ret, i;
> =20
>  	if (nbufs =3D=3D 1) {

[Severity: High]
By widening n_rw_ctx and n_rdma to accept up to 510 indirect descriptors
rather than rejecting counts that exceed the receive buffer, can
srpt_alloc_rw_ctxs() read past the end of recv_ioctx->ioctx.buf and
past recv_ioctx->byte_len when walking idb->desc_list?

In drivers/infiniband/ulp/srpt/ib_srpt.c, the call chain
srpt_recv_done() -> srpt_handle_new_iu() -> srpt_handle_cmd() ->
srpt_get_desc_tbl() locates the descriptor buffer using
srpt_get_desc_buf():

	static void *srpt_get_desc_buf(struct srp_cmd *srp_cmd)
	{
		return srp_cmd->add_data + (srp_cmd->add_cdb_len & ~3);
	}

In srpt_get_desc_tbl(), the SRP_DATA_DESC_INDIRECT branch bounds nbufs
only by srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt (up to
510), without verifying that idb and idb->desc_list[0 .. nbufs - 1] fit
within recv_ioctx->byte_len (the way the SRP_DATA_DESC_IMM branch does):

	} else if (((srp_cmd->buf_fmt & 0xf) =3D=3D SRP_DATA_DESC_INDIRECT) ||
		   ((srp_cmd->buf_fmt >> 4) =3D=3D SRP_DATA_DESC_INDIRECT)) {
		struct srp_indirect_buf *idb =3D srpt_get_desc_buf(srp_cmd);
		int nbufs =3D be32_to_cpu(idb->table_desc.len) /
				sizeof(struct srp_direct_buf);

		if (nbufs >
		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
			...
			return -EINVAL;
		}

		*data_len =3D be32_to_cpu(idb->len);
		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
				sg, sg_cnt);

In drivers/infiniband/ulp/srpt/ib_srpt.h, receive buffers are allocated
from req_buf_cache with size srp_max_req_size, which defaults to
DEFAULT_MAX_REQ_SIZE (8276 bytes, sized for 128 indirect descriptors)
and can be configured down to MIN_MAX_REQ_SIZE (996 bytes):

	MIN_MAX_REQ_SIZE =3D 996,
	DEFAULT_MAX_REQ_SIZE_1 =3D sizeof(struct srp_cmd)/*48*/ +
				 SRP_MAX_ADD_CDB_LEN +
				 sizeof(struct srp_indirect_buf)/*20*/ +
				 128 * sizeof(struct srp_direct_buf)/*16*/,

When an initiator sends an SRP_CMD with nbufs up to 510, the loop in
srpt_alloc_rw_ctxs() reads up to:

	sizeof(struct srp_cmd) (48) +
	(srp_cmd->add_cdb_len & ~3) (up to 252) +
	sizeof(struct srp_indirect_buf) (20) +
	510 * sizeof(struct srp_direct_buf) (8160) =3D 8480 bytes

from srp_cmd, reading past both recv_ioctx->byte_len and the end of the
req_buf_cache slab object whenever add_cdb_len >=3D 52 (at the default
8276-byte srp_max_req_size) or whenever nbufs exceeds what fits in the
received IU.

Should srpt_get_desc_tbl() validate that the descriptor header and all
nbufs entries in idb->desc_list lie within recv_ioctx->byte_len before
calling srpt_alloc_rw_ctxs()?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020155725.2251=
969-1-yhlee@isslab.korea.ac.kr?part=3D1
