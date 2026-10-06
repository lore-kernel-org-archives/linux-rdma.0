Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA9114A4CC
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 19:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791314224; cv=none; b=cCQ3CzsookNoBXxKxnnbq8Wof43R7XeKCccLcgEKudzsPSNKJMnlmrDA8FCOW3rP+wSCuQuYyZL0RkLnGVF/W81/1unzvVakDzUzUjvxb0edQS//Z2V8SluifkUc+8Vt7WbSeLc9DQ+yO3KI7vM9pVoLI6YppXXmlSeqIXbw6GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791314224; c=relaxed/simple;
	bh=vq7qr4R9slrnYGGa7LHnv4kQzAME1/L3e/N+Yi4qpm0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Xjap5kChIPcvCFWcsd4Wau8OobOIiVLRbl4yByRWri+Nz+WNdqbSlqcaYD9HHzdVe3qdZBBQeQjLiimxMu6ieKofwGXI8EulGKGAAQmMzRtpnZ4VKzvqmT+rNA5H3VWaDbyeF0ffw/XYZtlq2X3Gg+yVTSUUR+RRUDIxwoOOTxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fgb/J+R5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fgb/J+R5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2AE1F0089B;
	Tue,  6 Oct 2026 19:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791314222;
	bh=vq7qr4R9slrnYGGa7LHnv4kQzAME1/L3e/N+Yi4qpm0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fgb/J+R56OY0qMYYuxN6xQvGV5BGN9dPwKvfy0+DKSok0K3U6kxCnOuFBWAXPVV4G
	 K/qS9dUaU1KLcV0Lm0dywtJ2kyI17GkGijgMrygld1U5s+j9tHkzxK9O8dxBxWUtLh
	 mq7s1sMv6ID6/WRi8kAA4EZdhXAIVTcg32cUQbiHsaZxSy8c8R/NpQ5Ti66Yc5szZu
	 +3mSW8tBUFvXyvQTCf7ewa638ZkRaBZal4/oYNFV7FgeePjJgkVHc7dlg82+mip+cA
	 HWILKPTfZB0mnC6Zj3bjSYKlFGOpJQkQQ1Cj5ejffGxBfG5yEcoBPcN0E3T6B5EuAc
	 wo6qb96nuFp9Q==
Message-ID: <sashiko-outbox-162389@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] smb: smbdirect: don't wait for
 RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stefan Metzmacher" <metze@samba.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <22ab29ca3288e96cf92d4991c32b8975297d9a28.1791311817.git.metze@samba.org>
References: <cover.1791311817.git.metze@samba.org>
 <22ab29ca3288e96cf92d4991c32b8975297d9a28.1791311817.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Oct 2026 19:17:02 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smbdirect_socket_destroy_sync() waited for RDMA_CM_EVENT_DISCONNECTED
> after smbdirect_socket_cleanup_work() called rdma_disconnect(). That
> can take very long, e.g. if the peer just disappeared, until the
> rdma cm gives up, or forever if the event already happened, but the
> status was overwritten afterwards.
>=20
> This is not needed: smbdirect_socket_destroy() drains the qp under
> rdma_lock_handler(), destroys it and calls rdma_destroy_id(), which
> only waits for a currently running event handler and makes sure no
> further events are delivered. The rest of the disconnect protocol
> (DREQ/DREP and timewait for IB, abrupt close for iWarp) is handled
> by the rdma core asynchronously. drivers/nvme/host/rdma.c also just
> calls rdma_disconnect() and ib_drain_qp() before rdma_destroy_id().
>=20
> So smbdirect_socket_destroy() now also accepts
> [ ... ]
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Cc: linux-rdma@vger.kernel.org
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Stefan Metzmacher <metze@samba.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791311817.gi=
t.metze@samba.org?part=3D1

