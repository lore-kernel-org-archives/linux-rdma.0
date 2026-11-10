Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281598;
	b=JDSBroivS1WMSK+R9dDC5HhpQI2QrtayHVdHlkx+d8a82yJ9UQ+yM+9wN1NoMgWsK0Jw
	 SYJHMhAiiFmdZQ8kTxwcqUZCcc8Oa37gZnp7b9FyWyW5v05SlqJ2jzj0wVTvVK1WT/9wa
	 Zw/wivlrl0MOiNoD+MROFNOhMYWJ8oZw6MDuZQvHot3Ntr7g62Z0yIXpa6e6hzoxcJ4Dy
	 c48QSCC2BKvJmU/0P0kxjZ/4XK6nOwr4QReHYlwqXPZUmHVp+/McdwFq2B8JG3apIGHFX
	 aFV9Qg9tzZWkhqS0uqe8NBJsVrYVxHDXDTJOFmqtfUZfqpUKfrm9ReT1atIZzdyBDbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281598;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G4cV0qpzrSSxUu0qxWx8vpvyp1oQkWxlCcVGsNxeWrU=;
	b=40BKmNxX/rncNXVfiSHQXMWz7FfAfWvhJgBSkNkFL8oEAKbGq8WvQlZk0DRkYbHzQP76
	 xS7zsLlUTcKrCAlDaNf/VbRpmUzk7/26krvsFlj9gWs2J1vCn4Yof4PXOXsBAlLAbJsyE
	 iQ13p28VAk1h2sMKSlK08Esf3ei3jdwVZDKODvZe2f9FT26tch8ukp+mr/x5fTIM4bTax
	 YBLz2VcaKd+nrgVszOBpwUOcBp1sMqPE0uZGWwRkDStmI0nCmf+wKW6/x2xzt4gNl7jZz
	 BLg96Lkr+Yszl3CCaF7QNcCkPCEiegmKTjCgA6S2THkqVFfvxIKsl2s7U/Wft5LkA+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4kmxBtl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ECA606A31C;
	Tue, 10 Nov 2026 03:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4kmxBtl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50951F0089F;
	Tue, 10 Nov 2026 03:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794281597;
	bh=G4cV0qpzrSSxUu0qxWx8vpvyp1oQkWxlCcVGsNxeWrU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P4kmxBtlLavFxn9Hjf4L5Keokdutbl2O9g8vBRnyO6aa/XQ9m+CF3kmm2We1J/lB6
	 qYV3AIOed6BhqBxISvi5SkqI30Bkuu5IlI/bNx+jCY+o2I6YSV8J4WegKkZcDblMCE
	 pgUOxng6CP3sTmrEuyvXHYi+d7GWYA23oqBXPYohXuOITxXkLU73JYbZSrCDTAFZf3
	 tSnwsRzzoI3mKXTxIdnZorxBvqGBvhvdNu31mCNyekFnCb1/B5P1Og3EZoBMXXAtSV
	 mWU8L588ZECkkuPjr6Rv0lDBoJfyQ3zdUQ+yIoEPWT8Zt5NTchxtjDcQNZKfkSxb0f
	 c9cd05/p/DiTw==
Message-ID: <sashiko-outbox-206124@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] RDMA/srpt: Limit read data transfers to the command
 length
Reply-To: sashiko-reviews@lists.linux.dev
To: liuyong <pkfxxxing@gmail.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261110030809.913063-2-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:33:17 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Critical] RDMA/srpt: SCF_UNDERFLOW_BIT check in srpt_queue_response()
  misses underflows
- [High] RDMA/srpt: non-NULL sg_list on 0-SGE RDMA WRITE in
  srpt_queue_response()
--

commit e0d34787b9bf3f71d05931ff6cb12b336322ac7c
Author: liuyong <pkfxxxing@gmail.com>

RDMA/srpt: Limit read data transfers to the command length

This commit truncates the SGEs of prebuilt RDMA WRITE work requests to
cmd->data_length in srpt_queue_response() when SCF_UNDERFLOW_BIT is set.

> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
> index 43c3ff1ad8e7e..2f7857ef4face 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2913,6 +2913,26 @@ static void srpt_queue_response(struct se_cmd *cmd)
>  			first_wr =3D rdma_rw_ctx_wrs(&ctx->rw, ch->qp,
>  					ch->sport->port, NULL, first_wr);
>  		}
> +
> +		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {

[Severity: Critical]
Can the prebuilt RDMA WRITE work requests still exceed cmd->data_length
without SCF_UNDERFLOW_BIT being set?

For SRP_DATA_DESC_INDIRECT, srpt_get_desc_tbl() sets *data_len (which
initializes cmd->data_length) from idb->len, while srpt_alloc_rw_ctxs()
allocates uninitialized scatterlist pages and builds RDMA WRITE work
requests from each idb->desc_list[i].len without checking that their sum
matches idb->len:

drivers/infiniband/ulp/srpt/ib_srpt.c:srpt_get_desc_tbl() {
    ...
		*data_len =3D be32_to_cpu(idb->len);
		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
				sg, sg_cnt);
    ...
}

If an initiator sends an indirect descriptor table where idb->len matches
the CDB transfer length while idb->desc_list[i].len is larger,
target_cmd_size_check() sees size =3D=3D cmd->data_length and never sets
SCF_UNDERFLOW_BIT.  Similarly, on a READ command with a non-zero PROTECT
field when T10-PI is enabled, sbc_check_prot() overwrites cmd->data_length
with sectors * block_size before target_cmd_size_check() runs, so
SCF_UNDERFLOW_BIT is not set there either.  In both cases,
srpt_queue_response() skips this block and RDMA-writes uninitialized
target kernel pages to the initiator.

Should srpt_queue_response() clamp the RDMA WRITE SGEs to cmd->data_length
unconditionally (and srpt_get_desc_tbl() validate that the descriptor
lengths match idb->len)?

> +			struct ib_send_wr *wr;
> +			u32 data_len =3D cmd->data_length;
> +
> +			/* Keep MR operations and WR accounting unchanged. */
> +			for (wr =3D first_wr; wr !=3D &send_wr; wr =3D wr->next) {
> +				int j;
> +
> +				if (wr->opcode !=3D IB_WR_RDMA_WRITE)
> +					continue;
> +				for (j =3D 0; j < wr->num_sge && data_len; j++) {
> +					struct ib_sge *sge =3D &wr->sg_list[j];
> +
> +					sge->length =3D min(sge->length, data_len);
> +					data_len -=3D sge->length;
> +				}
> +				wr->num_sge =3D j;

[Severity: High]
When a read underflow spans multiple IB_WR_RDMA_WRITE work requests, can
leaving wr->sg_list non-NULL on trailing work requests where wr->num_sge
becomes 0 still transfer uninitialized memory on providers such as irdma?

Once data_len reaches 0, subsequent IB_WR_RDMA_WRITE work requests get
wr->num_sge =3D 0, but wr->sg_list remains non-NULL and wr->sg_list[0].leng=
th
keeps its original non-zero length.  In irdma_uk_rdma_write(), the 0-SGE
path still passes op_info->lo_sg_list to iw_set_fragment() for fragment 0,
and irdma_set_fragment() programs fragment 0 whenever sge is non-NULL:

drivers/infiniband/hw/irdma/uk.c:irdma_set_fragment() {
	if (sge) {
		set_64bit_val(wqe, offset,
			      FIELD_PREP(IRDMAQPSQ_FRAG_TO, sge->addr));
		set_64bit_val(wqe, offset + 8,
			      FIELD_PREP(IRDMAQPSQ_VALID, valid) |
			      FIELD_PREP(IRDMAQPSQ_FRAG_LEN, sge->length) |
			      FIELD_PREP(IRDMAQPSQ_FRAG_STAG, sge->lkey));
	} else {
    ...
}

The hardware then DMAs and RDMA-writes wr->sg_list[0].length bytes of
uninitialized target kernel memory for each trailing work request.
Clearing wr->sg_list =3D NULL when wr->num_sge =3D=3D 0 (matching
srpt_zerolength_write()) avoids programming that fragment.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110030809.9130=
63-1-pkfxxxing@gmail.com?part=3D1
