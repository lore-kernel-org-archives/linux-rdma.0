Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3302B469847
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 19:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791229656; cv=none; b=C9+R4MibKCqeI7jkKnHF49uw6pMiPkgizn+RntHjLRe9hT5e8goM/Zt4vwpxZpsnN0HP+7adEVwQRs7nbzODKZVpOnVIdr7wV/Ks8xNxa15T6cuNNkR7oIKLparpjYYWIBX98fPcCF2Wbdyvpvv/H5JTNr3vgvzsaLhWWrS7ws4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791229656; c=relaxed/simple;
	bh=osQhHsCm5qw5ymd/Ktd0XhLDZj2LxiygACMsOH46qyM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mWvj3eny6DJeHeqFnECEhQqOLFNzXrpyRF5G2f+4iIdnjb1nsOwCSZoQ1iUl1hPYVeOt+aNmH0q9xAHBDzC8EAyDAiFwO03Gs50Wqe8fRnOhuMfmnfgASuDcdISp710k8m2qHy7fkF0srK+bBzDDiRmlp8frnuEsohnCAofgQI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVgcvKKO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVgcvKKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D451F000FF;
	Mon,  5 Oct 2026 19:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791229654;
	bh=osQhHsCm5qw5ymd/Ktd0XhLDZj2LxiygACMsOH46qyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KVgcvKKO2MV2BPBb1ZFc1K4lXl8jfI5FHSApsLgm0xLjz1Up1GrhDenY6FfeqDYaj
	 qm1S9TexrT9XVym7NTOqZfPBvEDCROkhhg799WQKgx+NC4FdROcWd181DHMGN2rK6P
	 frsM+vpB9sOhvm1Q/ZNhsvL6R7Ptq26vewwOQUqe6RbFvVrUgj/cJH5dhjofbE/Tra
	 wUs3H7EZaNvoOPzWa3OPF3K9XuZcGyjEhGdrhA0RDdrHaHRD6uYhf4BTVDe4LGmT7C
	 xAmxpj+wOu124XsU7SlaqIBXSu+YT9tA1eLL7e8i/zGV9wQL96xcu9LjHVPCfBSnpa
	 l1EiO0KGNMXIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] smb: smbdirect: don't wait for
 RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stefan Metzmacher" <metze@samba.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <22ab29ca3288e96cf92d4991c32b8975297d9a28.1791229120.git.metze@samba.org>
References: <cover.1791229120.git.metze@samba.org>
 <22ab29ca3288e96cf92d4991c32b8975297d9a28.1791229120.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 19:47:33 +0000
Message-Id: <20261005194734.62D451F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791229120.gi=
t.metze@samba.org?part=3D1

