Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6888A19D065
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792208295; cv=none; b=GQDmpHm/Gg7m17yXq/7339ImE1Wtu5ksFQTCDXeFZ0ZzqXUqH5ptUdWIDIQl/Lgs83ey413KgmdWtBTDrWQFHjpi6nMIRT9Cx4FIHUO2LfJPdJWYuY7zarJiFtk6qY425lpx0Cpatzh/BWeFrwuIpBZzAYgYe1qG4T4U+STp0mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792208295; c=relaxed/simple;
	bh=Cd+oucU1UCb3iL6QRaEHHWVMbxj6Q+oM2UCDa6Ah6pI=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=LI5M/vVpf8RJgGnWGYrhCt8HH1TSsjCLZIoEjKgDCfGL4h6+ad9AI8iyt1rPcdQYw2vTtnx3BOk8MxnRNF7WQ9D+BvTLM94PAS/sEY9O7ENjHZkdymhmOr3FaulWBn38ti+90IHGY9NWT7N+cHor6TZFgG4/bDa8jUVSEnyv2wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GC9KN9bJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GC9KN9bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC3A1F000C4;
	Sat, 17 Oct 2026 03:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792208294;
	bh=3ZX6AOzg68deAzy7ArcTrM51ZnOgVL/nUePq04i6gBg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=GC9KN9bJot0Ju7K+DRF8UmPKM7c6WzYo/TQUBsA8RzLGh6ZukZa8rSBIKp3iaR7Iw
	 tqEo1jGNfMxx7ecOBdH7wDCRT5xZ5sYbgdTLM31Gv2nJhQnQydoVucEbWTi0tRgj/z
	 Ow6S5lUnKQNXyLHWyeBuMYxFXotLzqv7OFfgTObUAIyoBdarUZKbG+uvZtFxQLjGr0
	 xYv9iXuKV3T6hRVqVrvomHe+E3F6LJLlpy+7dErt4BZQCCvTFXVxI0/4Bz0p4RWQZz
	 Zcv8Zea0V6eNuIw5uV1BiQWm1fJWvXjJrRX+6/SvTX5vlHQVLvRYUXiR4KGbJvoKwA
	 JxDQ9wIlfDz6w==
Message-ID: <sashiko-outbox-175255@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 03/13] net/rds: ib: refuse to attach a
 connection to a device being removed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032319.2563014-4-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
 <20261017032319.2563014-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:38:13 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_ib_remove_one() drops every connection on the device's conn_list
> in rds_ib_dev_shutdown(), then clears the client data so that no new
> connect can find the device.  A connect that is already past
> rds_ib_get_client_data() when the walk runs is not covered by either:
> rds_ib_setup_qp() goes on to rds_ib_add_conn(), which moves the
> connection onto the conn_list the walk has just finished with, and
> builds a QP on a device that is on its way out.
>=20
> On a hot removal the rdma_cm still catches that: its own client
> removal runs after RDS's and delivers RDMA_CM_EVENT_DEVICE_REMOVAL to
> the connection's id, whose drop shuts the connection down and returns
> it to ib_nodev_conns.  On module unload there is no such event - the
> device stays registered - and rds_destroy_pending() is already true,
> so every drop short of a destroy returns early.  Nothing drops that
> connection then: the device's shutdown walk is over, and the
> [ ... ]
> rds_ib_add_conn().
>=20
> Fixes: fc19de38be92 ("RDS/IB: disconnect when IB devices are removed")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032319.2563=
014-1-achender@kernel.org?part=3D3

