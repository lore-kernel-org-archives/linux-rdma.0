Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279692;
	b=f09pJ1odENYd27y/3xYXTES5IVisRf9lSJe9hh1l2qU/piplW/Eya2Go32abOnwL9h+z
	 HcAi8Pm9ayu3NyW6YW5fKK1g9dNZX16UjrpqOZf871988E7IFqBTtrT7tMiO/5QIgzCr3
	 7ktlM5WjWT+3vpRdxuBCsxdC8gJIDYl81YXSPj7jOzTQwb6NivUC7Ga6GEkw8Ubp79b3M
	 iAzLD5+fnPYcWi4BSZT5VAbCROlpz9K/6AzAf4H3WaGHPYmRv8EA9pxmkDYSevlwK2HD+
	 etp4J5o4yxi29dT6Zqzn60fvMBDGkwnvFztzw8hOsraTKey2FJdy/4hSd9WZ1hrxlUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279692;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6YtTYJQv+7yEocSA+DJIIyGgpqAGV3j2YzLTaOeD/hY=;
	b=zdl1qp1aom+/Fj763LtQtQXNiV/As+fec1mcnW5EG7CdTMmr+s4k2xn1y7I8gcQMdGGj
	 TV7k4TnXcAnsz1GzjK0OuTz5QsI+ula+ZHM7RY8ll+UfO0XnzwfGNSFhXanFlxSdyTDoZ
	 izU34soYBlxz7z+syin1E82QCnpxMVOWX9frCUipr4x0MoC0YrfwQ6d7UeNTGk65/23ov
	 UkBU+44gCBR9I0+vjqQXtm04J5JzsQHLjD5+QYNHJ65LiGbhMfpWm8pUgENSTFqvaZzTt
	 ijWSiYmHQ4GM6cgGj8ejev2pXpxtSoQUcDRC4xzBZDoCLXmyNllQEXD2/5StzrFhc/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IGdunTB4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65615606A326;
	Tue, 10 Nov 2026 03:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IGdunTB4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C711F008A2;
	Tue, 10 Nov 2026 03:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279692;
	bh=6YtTYJQv+7yEocSA+DJIIyGgpqAGV3j2YzLTaOeD/hY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IGdunTB40IWhPRaySUO2WjQ8DXL3lIA7lWkcF28EfZ1VofduXOHky3iTbGNQSl5j8
	 Qq8Xf/UWlEBA5f7P0lHqDDG9g5R8DLNp/AiU8eejyXjIA3CkTX+mA3l9+RtuWgAtct
	 li0XvBGqJvI+j4AIqzccSB8xkSMKmLi3EHRC6iS2l82zMp+FIpg4SDChD8MwR43Mm4
	 XZUKaCVkpsFVE4SamzvL4idejPk6essiKYBaaVnGYlUe7/qa2LiddcWOu3uj7egXCL
	 ctQ1qOv8b0M6NTlGE4bxYtmtcPBgCVgNFtMTuZ+QPJ6Dr/p6od9K0mN1rwLURvbZdW
	 2w7K13I4pemrw==
Message-ID: <sashiko-outbox-206084@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 11/14] ipvs: annotate data-races around
 lblc_expiration and lblcr_expiration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-12-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-12-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:31 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> sysctl_lblc_expiration and sysctl_lblcr_expiration are read without any
> lock while their sysctl handlers update them with WRITE_ONCE(). Add
> READ_ONCE() to the readers.
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D11

