Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794400670;
	b=dDgt2tr8Ku2ZNnjvlw+xK6P8u95/I4LpaNynLq5Zj2X7yhdeyGWwjFiKXXzpIIyP6LYt
	 Ta5EYmMl+qTg5esDtIyElyxMBUoytnhBte4POoz9kYhd9JPaVJ+0fca66I+wvWPMVklM3
	 v1hpbWSLJ/9oBWoTg7/Dvhwx3E4/MgKKftUgKQRD3yJ2h2Ph+eZwj5Kyc5GFLcA7eLj0g
	 SllFWpnscnBFiLEZ2SYxIWqg8AZuIV3fJISiHsIEBbVvPXhw4hSyXFjypsH96RxRjF0Bf
	 fD5OCqfpNejgsP1kgWu7exhTxyEyjB/jQEOSCsoRFq6b4ekOdAS5niW80MExfZZ1gSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400670;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mYZx9KmWoTVvixVEDalx8TXfVPEkruHXZnl9AqQA4m0=;
	b=pQQ4OZGgghbU9D5+7bfy2bUb21kpgcieCKKQ2audNVVU/OAQOy1k5l7MXV62dbGAr9OK
	 TAiYDY1SlEHDWHvaqQ+djzVDhf8Qt6bBvyw7CPZtW0iv/D41t3sqiQJF1chN8kDoV2ycq
	 XrJllpL60C61LUulkAwQ8FBPuIh2hNJLYs674VHeMUuGKZ4HEaiouzkZZj0wL3ljIvPIW
	 nRkXAUZhYyaRdqzniLK0eGhQvp9aFiJaOmPuArPVV/+Ravhi1ZyN+6T6XAIvdJgUy6h6j
	 LETMegTzgwOsNuVMV1oz7YndXxj5pL63thyCqDVo2Fzj4Wth/jJnuhTKKBzQToS7D5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vhbt+TcE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAEF606A321
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 12:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vhbt+TcE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D0B1F00A09;
	Wed, 11 Nov 2026 12:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794400670;
	bh=mYZx9KmWoTVvixVEDalx8TXfVPEkruHXZnl9AqQA4m0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vhbt+TcEtd5QnX7B/y/mgRmqsje8K8ppRFlwMLxmEp1A5pHmjEXjMrEbq4mxip3Eg
	 8NQerrEn3ttllo1FvZwclmn8I1/UPOdpaC8saDjQTEd75UUNuerAAp94CKseD/VzSu
	 LYnfm3VeMrrPcQQ1eAenbe4QypnHMPUFZLKPNglKH6OU9dNxeStFX7eJl7Pvqdsq77
	 u2EofTq+tYCCXa8AdiIvGWIy44cCe09N4lUmWWFvz/OkviHfarANvQ0KDk/Y4f3asu
	 Xn2IuA9omUuXImviQgw6oF4kkjGBQzP208bKDxg/d26T8L9a2yMBnR2OmvlybZx7wq
	 ZnZsD3jF+Aeww==
Message-ID: <sashiko-outbox-208987@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/srp: Fix potential fast registration list leak
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <liguangshuo@mail.sdu.edu.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111-e5624093d6-rdma-srp@mail.sdu.edu.cn>
References: <20261111-e5624093d6-rdma-srp@mail.sdu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 12:37:49 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> If the indirect descriptor allocation fails, srp_init_cmd_priv() returns
> without freeing the fast registration list. The failed request does not
> receive an exit_cmd_priv callback. Release the list on this error path.
>=20
> This issue was found by our static analysis tool under development.
>=20
> Fixes: ad215aaea4f9 ("RDMA/srp: Make struct scsi_cmnd and struct srp_requ=
est adjacent")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-e5624093d6=
-rdma-srp@mail.sdu.edu.cn?part=3D1

