Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C3332E121
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 10:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540619; cv=none; b=mStn02gzkCzUD2/WEjMDJH4q2dsd6W04pnPBnHZzic6tVhc9yIvHtnH7Ew22AuZYkyzswOU1OeFUc+Y0kv2vxlszKqSuMXhk9yxF4CzD5EMzMz6muFeFmtmo/vFdigKuCrciaXxeTckDWO3jCoW+0ZFkf1J9ZDlK5AuI0CxlpAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540619; c=relaxed/simple;
	bh=6e1bV/LgFsa52z+5TbAxOKUGbvToJS+u5Ixj5Ma0psY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=dB5rOaomtpTINYLZRTxUcIKaVLrQtpNiMJWU0F4OXP5bc+P7xozuqkYleyhfC7+n/lQAqPCVkmNX6xKsEi8S7fuWawQPXdYd59uWKPGvBJsPPJGxtSB8ZAsYiT/O5+f6fFfIIRAphX4rLgviD+cqdxX17r+Ageed45GDV5Y2Crc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RO841hA5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RO841hA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AC21F00898;
	Fri,  9 Oct 2026 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791540617;
	bh=6e1bV/LgFsa52z+5TbAxOKUGbvToJS+u5Ixj5Ma0psY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RO841hA5TPUdytzexun2gGkcX+Wsj6Vtu9cNGqj0A+7AXjc0vDgCz2+spL6u9I8vc
	 Tv6KQgsEGhCSFFp2h3byKCUiksDdnQDDeRxZmiUZTCxvH2FSoHZiH9uhVKeCD/DqNY
	 LqKSJz4lTky8Q8FF4Smx4k2NarhZe2TbuLrrOhLIOf/LrJXQm/5Y9tZgEjikHVMv9l
	 tW5iIJQ8+GnjbKL8Pc96Fvg2NEVTdGwpJdxF+rPRKzTlE1WR/a3osSTjyC8+5qmpGe
	 2wVXiyNBbRA63Qlostkpxr/pbswYHt9nWaIQ9234KLMyLkw5UmV9vPPT4EQh1SZkcc
	 heJqwPQacBk+w==
Message-ID: <sashiko-outbox-165199@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/3] smb: smbdirect: don't wait for
 RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stefan Metzmacher" <metze@samba.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <22ab29ca3288e96cf92d4991c32b8975297d9a28.1791540051.git.metze@samba.org>
References: <cover.1791540051.git.metze@samba.org>
 <22ab29ca3288e96cf92d4991c32b8975297d9a28.1791540051.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 10:10:17 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791540051.gi=
t.metze@samba.org?part=3D1

