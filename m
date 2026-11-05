Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881780;
	b=DNNDN+Vr1zAso2JRBHzU9NnQb7hym9wPscdt8fDVBzAtOD4L4mJs4h9qYDi6mENmzuIA
	 CgKm4uQPTi0hJ1S2X177gJGgGtlfapIgFAQCzSObLfIE2TaGtisGqxfs7sTYxuEkrOLko
	 H0st/qyIhl8oHAOPzOvwAZ5tIPAZFhNl/M1HyTzgf+39APs8XvLoj+O+0oMc50b6T218M
	 RIrzo0fMjweFdIiq9s+nBVqcFUk8PFRxCnQ0p2vEG+N9whozW+lyer80aOzvpfNuuMe2y
	 sTIlEjzxNfYRSFiqqdgiqzzNBUtEDiWDyIJtAaNT6sJhcREwEvpssfj2i4ZnhVxpruA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881780;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=D5S4W5vSdBSNZTLOQrJOrdQp+B+DZSJb/o2MJtxfemg=;
	b=AZhx52eNVC/DGkj7K9dfVaCEO0yY1BFnv063VcfEEsPdcyBHAQ0cVEYU9Jca1WhrGpJa
	 UWW1eAUcORLIyX8tvLJx76Xuns4kVw352m4TYgRu1HU0lvAGHGoNyVpQp0YZABREfKBVp
	 vdAiRrS0GRTS+YN+Hu2xsZ18bGLVlvPv62L+40RIDs3VxdSSWCxu7M2ArxJda8NWvOnx0
	 gLSE4GcZ3cBJzEiLFcd8jbi9ErSe1iHQTAVNJcyuBI//dsfx2hNaOtFTfVXCoUDoi9LVs
	 w2EzVgAlSpfaesAlrfBJ2hQjmXoq9TRHCe3dUd0T8eK3dS1I0vTEmjR2LcTQTdbgLyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbBD1eIe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F403E606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 12:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbBD1eIe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722DC1F000C1;
	Thu,  5 Nov 2026 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793881779;
	bh=D5S4W5vSdBSNZTLOQrJOrdQp+B+DZSJb/o2MJtxfemg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kbBD1eIec4dSGR7Yv8e3Dnh23HQk+w+3JX8fwM+rZneMF6AEcX6mlPfVUnq3bXsWD
	 6bO8s+UtZ1MXu5Bwtbb0ovi4rTfxfd5h/JF8xWGxPwfsS413k1Ruq6cXFIvWhvOFdj
	 HznmkaRLPkrOEaIBZ5i2hjYp+UynmtsX9yEKaZf5E2jypVtKl1TFLTGFEORTG4nJJt
	 EjNAy16GLFMnRf7fps74yXxV4cMjpMH+Q8CDEQuNgafQt9mEfpd/sF63O3LsyUt/fE
	 dbV9GuzOZm0tCSIaQ20ZkJgKzljInMDFn1TFdNDfmuS7I62kK+WfFjUDpo8lzbS50T
	 E2V9JoZBB3KKg==
Message-ID: <sashiko-outbox-199032@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.6.y] xprtrdma: Fix endpoint leak after address
 change and device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Xiasong" <lixiasong1@huawei.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105124224.4051975-1-lixiasong1@huawei.com>
References: <20261105124224.4051975-1-lixiasong1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:29:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Commit a562485c359d ("xprtrdma: Fix ep kref imbalance on ADDR_CHANGE")
> is the linux-6.6.y backport of af9b65b29af34. It leaves the ESTABLISHED
> reference outstanding after ADDR_CHANGE and relies on a subsequent
> DISCONNECTED event to release it.
>=20
> However, linux-6.6.y still handles DEVICE_REMOVAL in the CM event
> handler. Consider the following sequence on an established connection:
>=20
>   ESTABLISHED:    acquire the connection reference, status =3D 1
>   ADDR_CHANGE:    set status =3D -ENODEV and request asynchronous close
>   DEVICE_REMOVAL: observe status =3D -ENODEV, skip the disconnected path
>=20
> Before invoking the DEVICE_REMOVAL callback, the CMA sets the CM ID state
> to RDMA_CM_DEVICE_REMOVAL. cma_ib_handler() then filters subsequent
> IB CM disconnect events. The DEVICE_REMOVAL handler has skipped the
> [ ... ]
> The flag is initially clear in the zero-initialized endpoint, and
> all accesses are serialized by the CM ID's handler mutex.
>=20
> Fixes: a562485c359d ("xprtrdma: Fix ep kref imbalance on ADDR_CHANGE")
> Signed-off-by: Li Xiasong <lixiasong1@huawei.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105124224.4051=
975-1-lixiasong1@huawei.com?part=3D1

