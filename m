Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72073381AE3;
	Fri, 11 Sep 2026 01:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789091088; cv=none; b=PxGpeRiayv8A43U+ri7ZavkYdM1aguMCD0uQWFNq7HKa7zRjIS9Z+3A78/3pV4LrbPmreywAFddT26qZouDQllNkI3Peit9aVuV2bpY9912mf8FtKCPCvJFAWJsQC5AP2ycEpdvIi9kgIjEWJmo/zpqJmbuzlNm8VSZ8Q+1YVPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789091088; c=relaxed/simple;
	bh=2ejmtNlQm5+KDUNUmfH+rpp7LXW0gXxLtMtPLLFO0no=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XsYjbGDHvwJaU17q6ofuCTBtXRgxtWfTDFso1ys3wmJfkl0ysxGLI6ymE5V6lSZXIk0xAHXcD0lPsBW2yfjAb98NzSeIInWBlDFG16e9DgxiLiwNbdXPBU+3Icdab6jrT1N5C7QclLpcp8f52LxtZchn13lLI6H95IfQmmr5UU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmVMdn+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmVMdn+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005141F000FF;
	Fri, 11 Sep 2026 01:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789091086;
	bh=R/jH+TaFx7gVBbrZG2NvM76lNe38vl3paWfXBxUg5wg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QmVMdn+S96Gy8kN/l+Z05gHFJUSkpjcIyA4G5TD8Poxk8Y7kAxHpIdzp+RXXis0Vu
	 lt9CxH1cX09peSmmfcQtsBMVRtxjZgFhcXVMM16faaGhxMkkkRiGQmhULJCHDbeHf8
	 uPtHRMQ1L7zw1VSuXvpheWfg0ep7nuDQ3vKwcTY9Emy02wPOfZs0C+oYDWJQa2WRFL
	 BBH8kMHQJqzWWAHO5thjecAnI9JEoBnuaFb3xH2kM8rJoM6Ob35qM6fBrJZxW874a6
	 XBOvQsgZp4EJOjgnR3K2EjMQX0loHN5/TuITHwG+/XyRb0flwWqnR88I8OtWdgmFoR
	 e4IwhhnMRVaQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2] net: mana: Use the HWC destination queues
 reported by the hardware
Reply-To: sashiko-reviews@lists.linux.dev
To: "Manish Awasthi" <mawasthi@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260910014427.54272-1-mawasthi@linux.microsoft.com>
References: <20260910014427.54272-1-mawasthi@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 01:44:45 +0000
Message-Id: <20260911014446.005141F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] When mana_hwc_send_request() times out, it releases the msg_id bac=
k to the pool immediately without waiting for late hardware responses or cl=
earing the completion state. This allows delayed hardware responses to corr=
upt memory of new requests reusing the msg_id, or falsely trigger stale com=
pletions.
--

commit 57ce74bdb654c3d07799a1543f2838a5e3407388
Author: Manish Awasthi <mawasthi@linux.microsoft.com>

net: mana: Use the HWC destination queues reported by the hardware

The hardware provides valid HWC destination vRQ and vRCQ IDs for all PFs
and VFs. Use these IDs unconditionally in mana_hwc_send_request(), as
the PF-specific gate is not required.

Link: https://lore.kernel.org/netdev/20260903184104.3194819-1-mawasthi@linu=
x.microsoft.com/

> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/n=
et/ethernet/microsoft/mana/hw_channel.c
> index 263e7c4e29341..3bca4b683134b 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c

[ ... ]

> @@ -890,10 +889,13 @@ int mana_hwc_send_request(struct hw_channel_context=
 *hwc, u32 req_len,
>  	tx_wr->msg_size =3D req_len;
>  	command =3D req_msg->req.msg_type;
> =20
> -	if (gc->is_pf) {
> -		dest_vrq =3D hwc->pf_dest_vrq_id;
> -		dest_vrcq =3D hwc->pf_dest_vrcq_id;
> -	}
> +	/* The hardware reports the HWC destination queues through
> +	 * HWC_INIT_DATA_DEST_RQ_ID and HWC_INIT_DATA_DEST_CQ_ID, and
> +	 * always supplies values that are valid for this function, so no
> +	 * PF-specific handling is needed here.
> +	 */
> +	dest_vrq =3D hwc->dest_vrq_id;
> +	dest_vrcq =3D hwc->dest_vrcq_id;
> =20
>  	err =3D mana_hwc_post_tx_wqe(txq, tx_wr, dest_vrq, dest_vrcq, false);

[Severity: High]
This is a pre-existing issue, but should there be a call to
reinit_completion(&ctx->comp_event) here before posting the WQE to the
hardware to ensure stale completions are cleared?

When mana_hwc_send_request() times out, it appears to jump to the out label
and immediately release the msg_id back to the pool via
mana_hwc_put_msg_index(). If a delayed hardware response arrives later,
mana_hwc_handle_resp() will process it:

mana_hwc_handle_resp() {
    ...
    ctx->status_code =3D resp_msg->status;
    memcpy(ctx->output_buf, resp_msg, resp_len);
out:
    ctx->error =3D err;
    ...
    complete(&ctx->comp_event);
}

If another thread calls mana_hwc_send_request() and reuses the same msg_id,
could this late response write to a stale ctx->output_buf and cause stack
corruption or overwrite the new request's data?

Furthermore, without clearing the completion state, wouldn't the delayed
complete() call leave the completion marked as done, causing the new
request's wait_for_completion_timeout() to falsely complete immediately?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910014427.5427=
2-1-mawasthi@linux.microsoft.com?part=3D1
