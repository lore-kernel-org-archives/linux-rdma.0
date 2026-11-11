Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404810;
	b=kgbqSZHHxc+VvxleS97QsXiJfUrg0GFxEcoydsKvvgP2V7TDnhCEG77LNVfOA2Sog0Pi
	 WlBiUJNCxOcH/WlesVIPiMFVUqBrrU3TDlv7awzb8BeIKlsSKKZjjQEPr+LUU6o4SZQLd
	 E7jx2fDcAAuUTN5WfE7ILN8PaMuoNJhcQ763OSfbrzElbMW1Zks3Y+MAVAf+jSFip9nbe
	 ave05DHjpg/DugnPdERzC3OEpdwTUmNyGIBI85rikjJHG15LE5do5UnJv1MxbU8u71DHk
	 eKmIgzDGVt1EWv7bWilucHaNSBBQbDGRPSyWxF/SnUBedx8bMJQlj1tAmm5bbMdhbPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404810;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bftA7G5LyKTNEGOnaHAlfckAc8ZrJXdBehyG4EgUPc0=;
	b=defCjmmz60wxaEbL+Ahslc0mwJ2aRHdkLoGmavZmKLansyBz9V/6HfvdxMTRLUv/1uQa
	 i8J141zJVKdFmcyyQMudxRK8rvovnjQ3joMn15TqNz0rnby48gvYAPYItfue2qHhx7CSD
	 LvI0QcXhxMbDvpsLWuqOxpMswhtG+rKy9iYuw3b9QPw9+z7zirinKxQyKPA1X+Axe4RIZ
	 63FAMLLc2wFCjkmAaeM9xMjEqKbmDtHmDRnPxz9ATvf1KyVtGilS64qVKawbfk/PLrPRN
	 UcF4tirQpOEWmfx5+Ies/0rMwWc4Ae1DPwMVsFv8rNQzr5O2uWq518zngBKut0OarEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UPZteA/U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6CA606A33B
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UPZteA/U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0256A1F00A06;
	Wed, 11 Nov 2026 13:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404810;
	bh=bftA7G5LyKTNEGOnaHAlfckAc8ZrJXdBehyG4EgUPc0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UPZteA/U60ohNU5lcIcjzV1Hhj/oBVavZdKa82HOcr4oT0V2A4R7L04Y84GqWey0J
	 zlYu//BplmWPRZUgLVN8bXkpdRGLcOw8h3O2wwLmsNgu5Brt8nb3AmcCxiCC+zWdLZ
	 Ix/kc3oeeStCOGTx5KBxu4HMlJbW1/BRnJC94KBa+HDLBErd9FiLMUTfc5SDhdSdcc
	 jaCVO8qVQZLETc8otxVgJPHrNm2b2pya4/zy6dLt44AHXaORslSauxIioKkW8MZGta
	 AjsBNtN7+j8DoIQgIZXT1jGQTWj0Nk8fNwy17UdlLxzM+BwfQmn0znJbIoaY4N+l6c
	 Xhqt3JcGsg5/g==
Message-ID: <sashiko-outbox-209094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 09/24] RDMA/core: Suppress kverbs_provider
 for adversarial_mode devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-10-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-10-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In adversarial mode the NIC is not trusted. Kernel ULPs such as MAD,
> IB CM, rdma_cm, IPoIB, SRP, iSER and NVMe-oF trust what the device
> reports, its completions and the data it writes, so they must not use
> such a device.
>=20
> Add an adversarial_mode field to struct ib_device and clear
> kverbs_provider when it is set. add_client_context() then skips every
> client but uverbs, the only one that sets no_kverbs_req, so the kernel
> ULPs never bind to the device.
>=20
> The driver still implements the kverbs ops, as the uverbs path shares
> them, so kverbs_provider can't be cleared by the existing check of the
> mandatory ops.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D9

