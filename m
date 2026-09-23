Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC1440A93E
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153683; cv=none; b=jth12MBxmdbEu6UkAEWoW52ZtMVR2RPYV4/PJPft5OQzDkEssmSN1yzohgq4rUlYkhn/fZbeb5RZalpo1Lqkv5W97ZnmDtgX11Nkmoq6hcah1fyv81maRhz1QCIVBXh3qFMQZ7YizGwOu0PAC6M+OYYE90DCTIcl443SRq4+N4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153683; c=relaxed/simple;
	bh=KLKH/bYSuZkTMCvUqnP8a/dvaA0RnNelFJJHANPy6MM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f0KlqrMxVEy01et5JWae3lvc3UTe0CgI7z1l5mrXYR1yQt44wEcru8lMPyarVCgg9+E+jQ6NX4ULeI1oMvwFr+nXtL7AqATZEYv5KO8h0txCc2f8/gsyZ7nyM/NqGc5KAHGdYLr/VDdjRFaUymspjTx1MLfId+v5A8EFOp0zWHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LPhxGUEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LPhxGUEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4271F008A5;
	Wed, 23 Sep 2026 08:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153669;
	bh=p2ccywch+v99M6fmzxvupG+eaKcPpaxwfM3jLV3yixw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LPhxGUEvj38RcfxPakaLLcoKhrASGTqxu491qhH3D+21DzSX3tANk8rOh1bZg47FP
	 ri115Sy7jUP8W+j7iXM0lxfLo8PZDDcNYux2nxACJ7t/x4C7UdsPlOEBOiVYDFgp5b
	 3CeFknrRBYnP53Gn0QBDxkOyyh3BJuVPnlAY3ehXzAcND+2hYct898Kx6HCmHPA7fE
	 qJaT3z8k6+q3Xnh9bhke0dXuUcraUxbqqXVD2o0Menddqt6Fuj9GAwuEz30uHufsks
	 hGTvCEIQ6HmNG8oGFl+wZcomgGyEahQ7V+TIxTaBpIUQZfxxVraIqzaaic6+QgyiuO
	 kX68d/5Zz0fSg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 10/12] net/rds: pin the connection across
 RDMA-CM event handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-11-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-11-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:28 +0000
Message-Id: <20260923085428.EF4271F008A5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_rdma_cm_event_handler_cmn() picks the connection up from
> cm_id->context, which carries no reference, and holds c_cm_lock - a
> mutex that lives in the connection's path array - across the transport
> callbacks.  Before this series that was already a use-after-free
> whenever a callback destroyed the connection, since rds_conn_destroy()
> freed it synchronously and the handler's mutex_unlock() ran on freed
> memory; the one such callback, rds_ib_cm_connect_complete() on a
> protocol version below 3.1, has meanwhile been switched to
> rds_conn_drop() by commit f97d8c7bab78 ("rds: ib: use rds_conn_drop()
> on protocol version mismatch"), which also removed the deadlock that
> destroy took on c_cm_lock.
>=20
> Now that a connection is freed by its last reference, the remaining
> exposure is a callback that drops the last reference other than the
> handler's - which has none - and the reference handed out by
> [ ... ]
> away, and nothing would tear them down again.  Re-check
> rds_destroy_pending() under c_cm_lock and reject the request instead.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D10

