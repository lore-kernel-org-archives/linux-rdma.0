Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794382051;
	b=bDdLLh4Ok0CIBbDdnklIA9wwcYuBnODYpdc8yPjEyIEdDeTlE07IPnobhHQj6Q9rHPHs
	 GCxzhbC/Mz8NRxKJVMS14PUGv7TwleLwMmhMAdwFkVxB3UQGisvMpmmyu8zQr3z/vBrSH
	 /aTMRlnjBSH+YXdXHWTQx1jRtZEZLwi0sU/fWRcatWa27y9h6Cmtr7GhhvSbDLKSBNkl6
	 MPWXaVo/gK6zlXFcBatHT1uuDkt83HydZsZEb+LfywfqLWajbrdQ8jJpvVaDHAM2lIG8t
	 cj2YsmqmtWv+r4TkNQeKhuqa22TpKOm263ruFj+vnpwjaA1dazmxQ8Qn0ggDzqWWWFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794382051;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oe/96u8k5RLK6RsFxupQ1/UKunugUVbZa7qlhbZZAEw=;
	b=Yh5pm0l9by3e2pSDJ6qJShcGyWuzp2tdksERBIrcaRxQkimlMxVrCpEpHBUKCQdBWpjv
	 N+IuQcuZnkUU1OsjP4qD7uMCAY8kmjnfJxAbWCe01Iwo8o5bBsjviLh73f0TcztbYsj2A
	 0MqoM86tOL6N5eilTZlycKL61uOm8JiLwhY6vMfAdcdUxbl2/S/m6nzAXcBfh1d28m8ZV
	 /Q8lNpFgmzsDBI2pocsdipBU5UkcvBrvHIbve+Lea01r6cTv116j24xyWz7UbCze8dOQO
	 03+34UghWwcgz+g35xO/pvEDfLmvm9y7f1s/B6B7DBi0gugzHWw6OZpsxnpFwuUfVIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FMwuj+jS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D84606A31C;
	Wed, 11 Nov 2026 07:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FMwuj+jS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E741F00A05;
	Wed, 11 Nov 2026 07:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794382051;
	bh=oe/96u8k5RLK6RsFxupQ1/UKunugUVbZa7qlhbZZAEw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FMwuj+jSqKrkhZpCu0J8tHt/Az0PceOp+5LzFc1yxNaDdrVxf+2MOKEnWlwYCH4fK
	 lOb+k7ZpU5H4PLzy0WqaQvsXwgKsfvI7qHmk5u81JCg5CkemJzdb8H+FnVzFJG7j8F
	 P0M3oU019J0/zJN5QBzLpyMgyFxdLGc/dO+5mRmBQ+3xeGN0OeDbx0AUlJ1nEftvuF
	 VUzOLHlnvJG3ElDxCqTCFanIeZYdiTJjfjzRcC+K6jeuwlU6LjT0HoIeQcDCbgZ0uC
	 QMIa/0oQAaJ+lnFM4h6HMaBJDKLT+9CbLkOgw0V5o4nMH5CWWeQtOb34jceMsT237O
	 D1oqQMICTRp9A==
Message-ID: <sashiko-outbox-208513@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/srpt: Prevent uninitialized read buffer
 disclosure
Reply-To: sashiko-reviews@lists.linux.dev
To: liuyong <pkfxxxing@gmail.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261111065342.1282709-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
 <20261110052827.963143-1-pkfxxxing@gmail.com>
 <20261111065342.1282709-1-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 07:27:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Critical] RDMA/srpt: uninitialized read buffer leak in
  srpt_queue_response()
- [High] RDMA/srpt: Signed-off-by trailer uses handle instead of full
  real name
- [Low] RDMA/srpt: missing Fixes trailer for srpt_handle_cmd() busy path
  fix
--

commit 399b6a57609f765986bec0107faa12263b13a643
Author: liuyong <pkfxxxing@gmail.com>

> RDMA/srpt: Prevent uninitialized read buffer disclosure
>
> SRPT allocates read buffers and creates RDMA contexts from the
> initiator's descriptors before parsing the CDB. When target core reduces
> cmd->data_length, a backend such as rd_mcp fills only the shorter
> length, but the prebuilt RDMA transfer still sends the full buffer. This
> can disclose stale target kernel memory to a remote initiator with
> access to the LUN.
>
> Reject indirect descriptor tables whose direct descriptor lengths do not
> sum to the advertised total before allocating RDMA contexts. Also
> initialize commands rejected during descriptor parsing so the BUSY
> response path has valid callbacks and a command reference.
>
> Save the original buffer length and zero any read tail beyond
> cmd->data_length before posting the existing RDMA transfers. Synchronize
> each mapped SG list for device access after zeroing.
>
> The issue was discovered by Qihoo 360's Tulongfeng multi-agent system.
>
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API=
")
> Cc: stable@vger.kernel.org
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: liuyong <pkfxxxing@gmail.com>

[Severity: High]
Documentation/process/submitting-patches.rst requires a full real name in
the Author header and Signed-off-by trailer rather than a single-word
handle or username ("liuyong").

> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
> index 43c3ff1ad8e7e..0bef01e20ce57 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c

[ ... ]

> @@ -1597,9 +1606,13 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *c=
h,
>  			pr_err("0x%llx: parsing SRP descriptor table failed.\n",
>  			       srp_cmd->tag);
>  		}
> +		target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
> +				scsilun_to_int(&srp_cmd->lun), 0,
> +				cmd->sam_task_attr, dir, 0);
>  		goto busy;
>  	}

[Severity: Low]
Calling target_send_busy() on an uninitialized se_cmd when
srpt_get_desc_tbl() fails was introduced in 8b8807b9e982 ("scsi:
RDMA/srpt: Fix handling of command / TMF submission failure").  Should the
commit message also include a Fixes tag for that commit?

> @@ -2866,6 +2879,31 @@ static u8 tcm_to_srp_tsk_mgmt_status(const int tcm=
_mgmt_status)
>  	return SRP_TSK_MGMT_FAILED;
>  }
> =20
> +static void srpt_zero_read_tail(struct srpt_send_ioctx *ioctx)
> +{
> +	struct ib_device *dev =3D ioctx->ch->sport->sdev->device;
> +	u32 data_len =3D ioctx->cmd.data_length;
> +	int i;
> +
> +	for (i =3D 0; i < ioctx->n_rw_ctx; i++) {
> +		struct srpt_rw_ctx *ctx =3D &ioctx->rw_ctxs[i];
> +		struct scatterlist *sg;
> +		unsigned int j;
> +
> +		for_each_sg(ctx->sg, sg, ctx->nents, j) {
> +			u32 skip =3D min(data_len, sg->length);
> +
> +			data_len -=3D skip;
> +			if (skip < sg->length)
> +				sg_zero_buffer(sg, 1, sg->length - skip, skip);
> +		}
> +
> +		if (!ib_uses_virt_dma(dev))
> +			dma_sync_sg_for_device(dev->dma_device, ctx->sg,
> +					       ctx->nents, DMA_TO_DEVICE);
> +	}
> +}
> +
>  /**
>   * srpt_queue_response - transmit the response to a SCSI command
>   * @cmd: SCSI target command.
> @@ -2907,6 +2945,9 @@ static void srpt_queue_response(struct se_cmd *cmd)
>  	if (ioctx->cmd.data_direction =3D=3D DMA_FROM_DEVICE &&
>  	    ioctx->cmd.data_length &&
>  	    !ioctx->queue_status_only) {
> +		if (ioctx->buf_len > cmd->data_length)
> +			srpt_zero_read_tail(ioctx);
> +
>  		for (i =3D ioctx->n_rw_ctx - 1; i >=3D 0; i--) {
>  			struct srpt_rw_ctx *ctx =3D &ioctx->rw_ctxs[i];

[Severity: Critical]
Can srpt_queue_response() still send uninitialized page memory to the
initiator within the first cmd->data_length bytes?

srpt_alloc_rw_ctxs() allocates ctx->sg with zero_page set to false before
the CDB is parsed, and __target_submit() only zeroes the first SG entry
(cmd->t_data_sg[0]) for non-SCF_SCSI_DATA_CDB commands:

drivers/target/target_core_transport.c:__target_submit() {
    ...
		if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
		    cmd->data_direction =3D=3D DMA_FROM_DEVICE) {
			struct scatterlist *sgl =3D cmd->t_data_sg;
			unsigned char *buf =3D NULL;

			BUG_ON(!sgl);

			buf =3D kmap_local_page(sg_page(sgl));
			if (buf) {
				memset(buf + sgl->offset, 0, sgl->length);
				kunmap_local(buf);
			}
		}
    ...
}

When a command has multiple SG entries (such as a multi-segment indirect
descriptor or a direct descriptor larger than PAGE_SIZE), entries after the
first remain uninitialized.  If the initiator sends a command whose handler
does not overwrite or shrink cmd->data_length to the bytes actually written
(for example spc_emulate_request_sense(), which copies at most 96 bytes and
calls target_complete_cmd() with cmd->data_length up to 255, or a
control CDB handler that leaves reserved bytes untouched assuming a
zeroed buffer), srpt_zero_read_tail() skips the first cmd->data_length
bytes and the subsequent RDMA WRITE transfers stale kernel memory to the
remote initiator.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111065342.1282=
709-1-pkfxxxing@gmail.com?part=3D1
