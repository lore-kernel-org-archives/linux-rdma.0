Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793348988;
	b=RpLtL5MKrogHieQkfl4mYsBeVXK1kcqkMc/tFBMbFQnsUYi++e5yXGqSDHvn9ES8GQr8
	 tngYyVAcCxA64llqdjlrGD8puhcJ7xsaByQRcz8i3MTABN3LYZGh4Uo7PCsXuaoietDWq
	 oJhzMHwpeDU11HxOZ+T+SWOxIgccsty+VQ5tiDKaEKx3O6RKLHXRZPd2rO8UQ+YrBFuZJ
	 wdjrJbw701wA+GFkjl2bKk4ePvJvsCJYVgU5xBFD5nzxN6cUNfKwBwlxZNWb1iS4B6YRO
	 mimKCWoPX3gtlDZSmj60i7qO+KQFcrDDaTMzQmg52UKa4KzxL49QW6LcnrfpbiqaPew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793348988;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=C9mnaW+7KH91D0EOToDqT5T0vSssYqdzjBymO1K3Nhs=;
	b=Ho1jKdIrfbXYrfnFGZH0n1Pv7Lg7LJnDf9dzLUblAVB+pFNAuPB8Hf3vnOAULIW51AUe
	 +klB3e5O/HpfE2o54U+CRqc/z2gpI8LzypgwrCFXD7lwXXXUAIdDKsAvXHEfFD1urqzH5
	 22gaITIlc2HnKvtxUcNEWGCQ80dSxSCJUXBrqurZWiGScWryxf/SGIaWB80si+3ZXTca1
	 /NRyWwVCoyEh2PR0VB+O+k/MK6dgwPivwpDN8Q9OO14ae/HnKFgomndSUxeyD2Tslmp92
	 KoO1NY2GoTB71I80fXCdIbfIcFWh0DyID8AU1hP+ZiAojJOsl/AOdtRmXQSHS/PdvHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LkqWpVa2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206B1606A321
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 08:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LkqWpVa2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801331F0093A;
	Fri, 30 Oct 2026 08:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793348987;
	bh=C9mnaW+7KH91D0EOToDqT5T0vSssYqdzjBymO1K3Nhs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LkqWpVa22RyI71OUX9fE2qK8eVFkiFSbfSZ3Yr3kVPv6IAHL2i6JAOjW+ITE2T2wW
	 6U+h4jMti5QD0EfwJAGJRHu4u7ibg7/96HIS2fh0V+gq/DDk++eonwv56VVEI1jIo3
	 SyGrEWmzK6GWzn3EmB8gl6N6mCvAvv1tnsWgh+rzt6Qs8hLcTw5Q6m5j0+SrzVL3hi
	 0veFvkGY5ZsEoXoZX3Y+3zbxX2qYhVbkmhZpX/gouuFalcwj7APCUKfWgdbttJf6K8
	 pKSBqVz1uYhTenowoSjOEk9mQJ71NeRqrtzy3RDepTUb7a7IFthCISQY3iX9b5D7Lk
	 fv7tBS5msxfpA==
Message-ID: <sashiko-outbox-190690@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next 1/1] RDMA/ionic: Use a linear QID space when
 udma_shift is zero
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030082402.841751-1-abhijit.gangurde@amd.com>
References: <20261030082402.841751-1-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 08:29:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Firmware reports udma_shift as the log2 of the number of queues in
> a queue group. A value of zero means the queues are not striped
> across two UDMAs, so the QID space is linear and the device has one UDMA.
>=20
> The interleaved bitid/qid transform treats bit 0 as the UDMA selector
> when the group shift is zero. QID 1 then becomes bitid
> 1 << half_qid_shift, and freeing that QID releases the wrong allocator
> index. Skip the transform and select one UDMA so QP and CQ allocation
> uses the QID directly.
>=20
> Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
> Reported-by: Keith Lucas <keith.lucas@oracle.com>
> Link: https://lore.kernel.org/r/20261021161651.4020222-1-haakon.bugge@ora=
cle.com
> Cc: stable@vger.kernel.org # 6.18
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030082402.8417=
51-1-abhijit.gangurde@amd.com?part=3D1

