Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559CD382380
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 03:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271442; cv=none; b=ZbclNFMHzK5QSNdDWWCHpZORVzSBLQcgSWLoUIcDqcz9aRA30aAYLjaXr2bovoCkB5RZY2zIopmybHyWgLLhASG7DuHGigSvxaKw3R2gNcXoPqNFLrC5M4+XmL37hb/T7Mkluq81KdPwZ9YbsetAFc+H8ihK4KVCbzcsKrPVzEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271442; c=relaxed/simple;
	bh=XC1Hv956iFfQIKLcECWlqjmBNeCFROjyqaAleLV7gas=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NpXGvU/22HCpwlZ3i7/s0QYglhSH+W/CUxDGJ2lhuu+uSx67XmAVe6ReTx04Fh6SjTxkOGslMvA6jpCNohJRia9IOerLXeHYjbIbLmFY4dAw0qcYSOEdEBRDpi4pb4Q9SE5u0MeeNvoEymqZGNvgcLFp3sZcI23ZPn4cdPbpeTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQyGzTkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQyGzTkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49471F000FF;
	Sun, 13 Sep 2026 03:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271441;
	bh=Y5G7JoeZJKJ4A9nlCedBvQd0vKsYi249FZtTHPRNDS0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KQyGzTkHvXVu8ygLRY0xZVp1cunDarudRvknlpf7GvmLFzbMGF8/xySxv7rpwrVn5
	 YXpoaRDGDAQgcTvSYcp0ERWrVoWYgkYupKi2vbSSCyABgp92DTc+8jDEvzlqbdFila
	 xPCRNf+FSuWgFPbLPlh5MTMpOa76DkJc9K2jnVMFrzcbDeUIdJolWwORvcu96Nnpon
	 yGIcIq842sBn1AyONQufVFePUPo8S2JtxAkRnQI953rg+vz1CnASehlfDPjANmaFxe
	 qgEtktCp/uDJswZnTbASr2PVtxpySYXy4nYEx1HXhQa+nwnixiR+4NHrpo/F/947jn
	 e7VYiwfxgNUvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 7/9] net/rds: pin the connection across
 RDMA-CM event handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260912035027.27447-8-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
 <20260912035027.27447-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:50:40 +0000
Message-Id: <20260913035040.D49471F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_rdma_cm_event_handler_cmn() picks the connection up from
> cm_id->context, which carries no reference, and holds c_cm_lock - a
> mutex that lives in the connection's path array - across the
> transport callbacks.  Now that a connection is freed by its last
> reference rather than by rds_conn_destroy() itself, a callback that
> drops the last reference other than the handler's implicit one leaves
> the final mutex_unlock() running on freed memory.
>=20
> Take a reference for the duration of the handler, and ignore the event
> if the connection is already being freed: its cm_id teardown is what
> stops event delivery, so an event that still arrives belongs to a
> connection whose shutdown has run and whose memory is on its way out.
>=20
> rds_ib_cm_handle_connect() has the mirror-image hole: a connection
> whose destroy has already quiesced it sits in RDS_CONN_DOWN with no
> cm_id, which is exactly the state the DOWN -> CONNECTING transition
> claims.  A connect request arriving then would install a new cm_id
> and QP on a connection that is only waiting for its last reference to
> go away, and nothing would tear them down again.  Re-check
> rds_destroy_pending() under c_cm_lock and reject the request instead.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912035027.2744=
7-1-achender@kernel.org?part=3D7

