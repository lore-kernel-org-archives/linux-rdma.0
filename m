Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336049;
	b=vmVxaD3377wpUMIEH0G36DeTcEACpzB44hVlKtJxgHRzRUBsgy7kp4nYVBcDtYmOGnCq
	 RXwscChlSahwh0WrqtSAhUd02QWLvh3o7+nn4uOrEj9E/VBBz4vJTXDSU4EwrKG2HRo4Q
	 mAhXKI21YJAInS2H+0l/Xx54Ui73GbzxIeiXES+RnSemy7BoLUMs68qE1jMzO3FxUHGCA
	 VqN7q9tcY9IFeg3PLRdzinjO+ena8+P/bzxJ7lFxeO8bWop0OG4YvIknlKgrU85GVZRXe
	 qQb8WMN7KAknHWVYomeCOJBc1sJ6vpmXqJz+XygQJFbUDA922SbE/bDLZFjYzKS0veA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336049;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tzXU5Ohw0o+iKBJGbB99nc9lDjWCws2QOyOWMUeuRUI=;
	b=I+xHsApb3XFANCLoKp6dkWW/QwU9HMRLE0KYsM3Hb0+W9KnvLRy23zrPwecqnSFUI3cr
	 gbaTj75VEl94wY7Gr1yQPP1aMv8+q5syxzC1j6zIwf8O7QJCDn/qZnpqGH46D4c+K1c5T
	 GstwIMwVtHSKhs+39iwxSFDQL3jIO92/x+xa31beHR2kbwo8rXguQm3gCR1/aJXhsKujT
	 QCYYyWIzEjFQ6KNCbgtS+pRqD/WPVHnXuch2DlNlQsp1r9nHa+AqN6Ioh7LQDVIhfFiUe
	 9lCpqJKWR/rqtbjNrTL3B/MslzsuWX5R93tcW0XUqAeWN2dHgzqZ31dswuGCOMa1JiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEu+s75y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE09606A320
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XEu+s75y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C458D1F000C1;
	Fri, 30 Oct 2026 04:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336049;
	bh=tzXU5Ohw0o+iKBJGbB99nc9lDjWCws2QOyOWMUeuRUI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XEu+s75yR6Bv9CdfuOczMizHfQi1xP+ClrJVVJzbhMLk3SiCdUc/O9mNEU8sdE7ZI
	 tGk4mrpuGD4WbdxYdA8eGEMyXGBbc3O2HMiv4RwkJH4w1ITRupKsU/KAz98jWj0iEk
	 o0hy3+KE+pcurKO8fijdVgXD+7vwJi7i6c0nV1wucQbvTIq6WPVK2mES2BHn4InRrQ
	 FThiPgncaYM8UquOCch6fwuYGvLluPFOK3aOUrx8x2aHk4SrO7gONHpseOD25dGQf+
	 iUeeN2EmRbWsh584A3GDnfV3YlyAHHevOAcmlfeh101n+byYcKwdpLhakiHYcoRWyZ
	 i23A/WbgIkRfA==
Message-ID: <sashiko-outbox-190413@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 2/6] net: mana: Query device capabilities
 and configure MSI-X sharing for EQs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260508221202.15725-3-longli@microsoft.com>
References: <20260508221202.15725-3-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When querying the device, adjust the max number of queues to allow
> dedicated MSI-X vectors for each vPort. The number of queues per vPort
> is clamped to no less than MANA_DEF_NUM_QUEUES. MSI-X sharing among
> vPorts is disabled by default and is only enabled when there are not
> enough MSI-X vectors for dedicated allocation.
>=20
> Rename mana_query_device_cfg() to mana_gd_query_device_cfg() as it is
> used at GDMA device probe time for querying device capabilities.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508221202.1572=
5-1-longli@microsoft.com?part=3D2

