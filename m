Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705694;
	b=q8UUqJzGzuXQC/8EHTxnhMb+pMtATGT/3q0yLR+bRE3PAth4FcqmKCHAEN5GcGX8tf73
	 8L0cDkurB5n2Sgak8uo7RFMaLxpax5yTEXyG5LULluP5ovLSTMB0uBzs+v5brH5HZ9wqp
	 X1W4Tppy6/svD2HS312InHIg82lSZCUi1Mw6rW6bHcMc9XPmv22xjeW1aAoHaTimXaq20
	 j6CAzBUJLlOXqN8WXsnoudin0HmjDbW9le9Ah+N27POmjPONgAHEGqxx+XssCK89XqB29
	 e4yrxVlV3vEo2dxXuRC0VqZmy26xNqHUY+fEYE22WQXoSzjyiqSgbWebQbNj5/f+mOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705694;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QrCFbd1VGIf21RIFU7MuZ1HHoSCvFb6kLlo6vyw3Az8=;
	b=iTUmCvMXlw6g+r0PTdzaXHGvI9uF85h9BKN9MPnRRGzlmrktAdNb2Niw3NkN9t/Ulvbo
	 9ke2ob70AOPxDHvdd5Y31cRak7RY066HCM8n/0qEWjokTKQzRWQqHARn06e2D67Z8i9u5
	 LCjJTIIMtNdiyuGi7USxOrB7NBRIWvqUBzxDG8zUQVYpedTor+0HUV87g1UqrQDq8B6xN
	 +m/4rc71/gTewj1wU31SFxiadQjJFruR007ieAnfNFri6l30AJicIv0N5dLntu2g1qDt6
	 M+nuKhU9G9mdAfb+anvJqz6EisolzntKupcgQwGlJ+R6XKY0IeCb0x9mEH8i9Ff7gMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k4KpyAsa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3EF606A324;
	Tue,  3 Nov 2026 11:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k4KpyAsa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2321F000C1;
	Tue,  3 Nov 2026 11:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793705693;
	bh=QrCFbd1VGIf21RIFU7MuZ1HHoSCvFb6kLlo6vyw3Az8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k4KpyAsaDFTrtMMsNd5arUameqhdCN3cNJwVw5n1c4GmHIWTSIrrhKHvVvmVv19sT
	 hrlUbJRaPeiprRJ4r6GnO9VZnTdngxKSPvZAdbllRZII6sfZKUvTGS8H/8UUSMkHKn
	 FQtytSax+mya6tweXoilakCPxf4rzPOWA0S69414+MsJvqElKAtu8TdVdt7vvkKtHu
	 ZVK+j37U5vxvRMOqWyxJROpbF3lvCGsE14IfSwXx1EaGADFcd9e1lm5jngYBbrSlkg
	 isrhu/L1K4v9fLVYQWupOFQVYHEgzsYAYIKln6CR9Hl6cGffH9K9wkSNA/bHdggooU
	 wqOAaEJqFH1yg==
Message-ID: <sashiko-outbox-195157@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 18/19] PCI/P2PDMA: Evaluate the ATS path for clients
 with ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-18-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-18-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:34:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> P2PDMA assumes every client issues Untranslated Requests. A device with
> ATS enabled may translate any address it is handed, including a bus
> address, and Translation Blocking can reject its Translated Requests on
> a route the Untranslated answer called usable.
>=20
> Unless the client declared per-mapping ATS, take the Address Type from
> its ATS Enable bit. Never hand such a client bus addresses: only an IOVA
> survives translation, and whatever it issues untranslated goes through
> the host bridge, whose route must therefore be usable. Apply this after
> the topology-only cache, and in pci_p2pdma_distance_many() too, so that
> provider selection agrees with the mapping.
>=20
> Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D18

