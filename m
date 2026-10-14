Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE2C2D5408
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 12:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791980624; cv=none; b=hr+IO1wyknzoEsMYQLDlZ+Idwa96uRyJH7O/lbJN6aVDEHLxg25BsJGIdI9y4nijk7wpQoaGbfpdZOdZ7y2Pw+9uZ+KY100NxyOehf7RWlLmImiFeoQHKolJsdl7FktYuZe+j7mw8mHX1mHMnU6cQGRy9588kvF0R22d2c0V6Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791980624; c=relaxed/simple;
	bh=97xIkj6ozkx/jfFKBmvwQSKJ2UXcC1rXk3p2gIEjNUA=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=GkkveM5hFXuXH9LqgXdbrzVvIDjQI2C3y4D5wv6HMQHeceH0psDnyJove2mQf9Yej7+CSpAFlj6NsvxvvESJf/mq9qCeF+iFcoqFo3CI5g2IgoGCN3PpdKTWzXqoqTNgNdQmvjQOORxZurovZnPhnWigO7eMuxjo1i888rs/FOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oj40Qr58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oj40Qr58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080441F000FF;
	Wed, 14 Oct 2026 12:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791980623;
	bh=gdF/fRMXm4HVUKsdiqicWslikC0x7qITV/qoC0O6yvA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=oj40Qr58x4SSAThGENZXLvPNnqfZ9Tlj4ZSc+E/z30FHeeelNJ5mK6PtnruyhxjMi
	 t/NQZLEulf9QBnrRlsmnd+9aw3FecK2fFInM8SQ6/vyBy/PyoyrsDBmcBOsGHLx5k8
	 Zm/bjCExrWUraB5IoS3Xk6/oakXZ1GcdV72S4eL+GVy6oLONovpfMsFph6gjNp3SoA
	 o6AGYgwDio3udn+zFeQwsudmnlwZDEnreXeOq5J4tVgTjVWGYX3od4nY2H7tuE1odg
	 3gNvov41ragOdJzIICagIVn5XWf0LtQK5apbZedkq2NbxS9lGIvMosOcau6st6XJxb
	 y54vjdOmoxYjg==
Message-ID: <sashiko-outbox-171271@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/mlx4: Avoid requeueing executing CM timeout work
Reply-To: sashiko-reviews@lists.linux.dev
To: "Praveen Kumar Kannoju" <praveen.kannoju@oracle.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261014121344.100048-1-praveen.kannoju@oracle.com>
References: <20261014121344.100048-1-praveen.kannoju@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 12:23:42 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> id->scheduled_delete is set by schedule_delayed() itself.  It is used
> in two cases after the RTU timeout support was added:
>=20
> * A new id_map_entry is created, and a 60-second RTU timeout is
>   scheduled.
> * DREQ or REJ is received for an existing entry, and the normal
>   30-second teardown timeout is scheduled or adjusted.
>=20
> The following race is possible when the RTU timeout expires while a
> DREQ or REJ is handled:
>=20
>  CPU 0: timeout work                         CPU 1: DREQ/REJ handler
>  --------------------                        -----------------------
>  RTU timer expires
>  timeout callback starts
> [ ... ]
> cancel_delayed_work_sync(), because the timeout callback may be waiting
> for id_map_lock, which is held by the caller.
>=20
> Fixes: fa09adf4231f ("IB/mlx4: Fix stale CM id_map entries when RTU is ne=
ver received")
> Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014121344.1000=
48-1-praveen.kannoju@oracle.com?part=3D1

