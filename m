Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793612205;
	b=hkh88w+HC47D6bDbzNJTIOx/DmlMVtRFc/gXI/PX9dbSBRoArkz3GbgnqCaPB9Q9lT7n
	 BweDGANWBipZqRVUs4TH4TEC97KRJ4w9dk9KdNT5K+CU2WK0kEiqoSDay8OXoNZWGKvE2
	 eUZzUf6jUxvn19KIFKJxYTv6AoPFzbz4WqlftbvztUetLcf6f7ZdLPP25/nU4t/w9tDUb
	 kw5XCctiQWVtuB1rIiXuBpJlkdacFH/MhNe2k9lio4Fc8CVpy5kCGDZ5zC9/A34HW1ZPR
	 JFHsmFt5Pyi4wJEBjHesCFq7eMOuLWFeff275cmjtCVg4Y1CdtRDNON+gVqYicYLbEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793612205;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DxYUFZNoXGbyI9RGhsj8BxZSDRf4a1gYI9pXgMZiNYg=;
	b=0OzAB1iB21/qIEr2CsjCYrouX0ss9aTSxvSdJqdvmTQ/F2Ku4rc52nqybsZDvWShieA8
	 FN8Ac1PZdxMZLELnpEvawIf11vuGbJo7vAC0UVb8iEac1UbQ9ISeYpIJEhufqaDXFIFs5
	 sMLM043fKwBhTGFCpsQwcrjEdt4nb5u1NbiS+yl+Uxqx5yQUOL4sClopCtmiHCrEEyVKz
	 Ym4L5RJs6RZpM5h5WI3qumdfiI7KGufDuj/ciSDI9zvnc5HuvcJDu2cg2bmsRTFzkt17N
	 aNT7XIgxw9j5sA2HoIET5q14gDbXI4kehaYyRaPHcelwzU4Feg5Lc1Me5Z+B3HruvTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PmgtVlpR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE239606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 09:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PmgtVlpR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F211F00919;
	Mon,  2 Nov 2026 09:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793612204;
	bh=DxYUFZNoXGbyI9RGhsj8BxZSDRf4a1gYI9pXgMZiNYg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PmgtVlpRcw7QUP3SwgYQURPOqahPmO35EruoWohV+odTrmhVFiZRzRjI0S6K4KmgB
	 +87ceslfkN26tQhaWQeplrnH/HJIn//ojmo2q1yMhLaaEYmmTANTKzdIBCLjRb7m6u
	 oBvYkmaA0GXbdQLmk32VfmwBvwhuFLD2Tf7wBIYYFbCU6ZvTk5RGBfn85ArHdOHBBH
	 /T646B9hOTsxWYU4uCK8laqL0AEjdgQLyE/uPZ+7kJYS1Ok0wG4s4BYLVPgIyYtFII
	 Mc9KHfR2+wPMAYzUXiueqrLitPasKnb3zu9R9arLQQQTHG7MH2hDFPwNERTAdvygy4
	 /1lNbxV8snPFg==
Message-ID: <sashiko-outbox-193185@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v8 6/7] RDMA/zrdma: Add device probe and remove
 logic
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102082026.2645777-7-zhang.yanze@zte.com.cn>
References: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
 <20261102082026.2645777-7-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 09:36:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Implement the auxiliary bus probe and remove functions, including device
> initialization, hardware resource setup, and IB device registration.
> This replaces the stub probe from the initial skeleton patch. The file
> is modified rather than deleted, so every commit of the series builds on
> its own.
>=20
> The device ops are installed right after ib_alloc_device(), so that the
> dealloc_driver hook is in place before any resource is taken. The hook
> releases the pci function, the hardware resources and the address handle
> list lock, and it only destroys the lock when it was actually
> initialised.
>=20
> The netdev is bound to the IB device and the DMA capable device is
> handed to the core before the device is registered, so that the port
> queries read the netdev the auxiliary device belongs to and the core
> does not have to fall back to the kernel virtual address of the
> scatterlists.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102082026.2645=
777-1-zhang.yanze@zte.com.cn?part=3D6

