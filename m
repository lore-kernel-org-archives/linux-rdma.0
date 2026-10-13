Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572BE387346;
	Tue, 13 Oct 2026 20:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924760; cv=none; b=ENwB7brLsWy02maaU0lC865g/h5wy0zWs8IxOsPSYTa/kBrAmXdhCDPhcUYauGwZItADsmPPfth0pSxqFL7PtET05ont0J6o2bbulHmIumBFgnh90YVYhG4KQIWI/tbmk7+BJEixri5BSiouOlY42xDX5HAR2NVoD6aTy3fMGoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924760; c=relaxed/simple;
	bh=g+6+0MYrZlaxlAQacy/PCxFsRVHHiM+mZMgE6h1AhPE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DJl8MR6Jjqmv/KA6PuSIHyptdAwr0zwHdGkIwQfNqVwbdNYK31B4gjtDmxnl0Zh0hOSx3Vby0y9IZEHwUmTpiwdnh0tJYDP9fz9uwHejh/6wwUOJWxABBumLkkYX3UlZlwHjVHdAP3mmattBFicX/nEjIR6ctRl5qp5C9+QGr7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loa4GsGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loa4GsGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEC61F000FF;
	Tue, 13 Oct 2026 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791924759;
	bh=g+6+0MYrZlaxlAQacy/PCxFsRVHHiM+mZMgE6h1AhPE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=loa4GsGx5yeUJJq2wU+2YjSSfWKTqSURZCNAqKdSsi0xNZdexj72CXBj8yNvcwTAV
	 ZRHL2AVTvVRj/gGe/ZHZdtMEEB9SQ/zTjR1KUJhrcqkPcc+kInkzb0JWT9ZPXXk9N+
	 jO1M1SWcdwpr985IhiR19Qhytu2xSTFb+jTznXR2l/aWHvDXDiPy8CIrRNtQqRtxfo
	 iNfQlQQokvm5ctu88OwP5KmlLLxthzJ6dSt+4q90P9rTjiysbLJhlaFosexjkDe7AR
	 t71eyNOFn1oE1sSjCEc7HJU/dQNZ9KqriBsyB3uy7qvipUwIONd8GqdZwici/TmXPK
	 gJgmZkpdw3euw==
Message-ID: <sashiko-outbox-170491@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: queue the copied chunk when
 smc_tx_sendmsg() faults
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-disp-872a3689-v1-1-2a4c63b04761@proton.me>
References: <20261013-b4-disp-872a3689-v1-1-2a4c63b04761@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 20:52:38 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> When a send wraps the end of the send buffer, smc_tx_sendmsg() copies
> the data in two chunks. If memcpy_from_msg() faults on the second one,
> smc_tx_sendmsg() returns send_done, which already counts the first
> chunk, but leaves tx_curs_prep and sndbuf_space as they were. send()
> reports bytes the peer never receives, and the next send() overwrites
> them. Any caller can hit this on its own stream with a buffer whose
> tail is unreadable.
>=20
> On a fault in the second chunk, queue the first one. The next pass
> retries the rest and returns send_done if it faults again, so send()
> reports only what it queued, as TCP does.
>=20
> Fixes: e6727f39004b ("smc: send data (through RDMA)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-disp-87=
2a3689-v1-1-2a4c63b04761@proton.me?part=3D1

