Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793610874;
	b=M6PAGIiVE/MTeRSqomfBKWrOq1JSEh8HTkamx1VuyfeZ/WnCwTQ3dl1gstqR6O3oFZUc
	 HkMIxgncubn5DEtTCjnL0tRaPrNRgCMPSGRkfNpkj6nphLeNNcCBsdp9V8pjv6PTiKHnT
	 a4RSGG09/pU2QMDoHngRFLdg2yhaUMiVJaWiOn8YN6Kx5cfaliDc4XKlnz16ETq4Niygq
	 pIY5HrYBMRxLmZNSvMvNqKWbLqWu99LBioUThGfQ0olDNB7jSqg3eaNPdYpKW76uxYEmP
	 yw6A8s6TDWGPw04d6VfrIdkBHAwPJ/gtiBiO/uM78+NT7EWEkc04EYNVaNMsONa/Dlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793610874;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VrNTS+0aolB6DAQ3iTwcxgXFDXiKL74psB4iVZHUzUg=;
	b=dkJLQ3NTI6YJ6rCzAp6b2i0x/YkYKqTjfBcdbNYBpZ+zg25cbaxOyw2RcllIdqQ/Ql4Q
	 ojwoRQRyHccK1o2Vx9QXK3S6zy4JoSD4aRUFrGQOCvVcAWL9ZERBoRLQAa/19s/datzOH
	 qCbRWM6m3f6sdf7/MKaTCJE0pK9mzcLNl5ho6tW9EK44WO3+f5gnUWe/dAWAMx90qZXu9
	 PC8+1tw7KL+SIMR+NSiETpxT0ulqeXvtNRZJKp9mVod8UOG/neaGqF/FWNS9o9yMQhBXI
	 NcyNd5m/I6b+45FoO259qBH7gmQpw8sivBOF1wlwaKDRLdepiRWmH7HcUHpiWZ2ppPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDQbJo4L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800CF606A329
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 09:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDQbJo4L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B0B1F000C1;
	Mon,  2 Nov 2026 09:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610874;
	bh=VrNTS+0aolB6DAQ3iTwcxgXFDXiKL74psB4iVZHUzUg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iDQbJo4LcbkxcvZunojGWlHTX9pwKAdjLwakGnC5yktjia0uWYQLRvpgxof176nhP
	 ILyXhwcAfnWI96u6xdrGNPvjozvBiWPUoFIdSDv8tkbCm/pAlCcI+iisC5U+PBg81f
	 3IKVeOyfiMGiI9Qd6iSDIOD5+sUif+FIN4JW/Hw8GGlLbcxc2KWrV4z1ijbW9laxe3
	 P2qndkys4+htj1vpH+37q+3ovQz7uZjtUB27c4mvep+ICvRTGWncx/k7GSc6b9rUfN
	 5A+K40bbrFOx/VvkZ1E9oihvfi5yubu3iOka01MBfz3Ll7VRbNw1zex5kHfnSpck6J
	 RqXUpn9wUaBug==
Message-ID: <sashiko-outbox-193163@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v8 4/7] RDMA/zrdma: Add hardware resource
 initialization and verbs skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102082026.2645777-5-zhang.yanze@zte.com.cn>
References: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
 <20261102082026.2645777-5-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 09:14:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] RDMA/zrdma: duplicate ib_mtu_int_to_enum() logic in zxdh_mtu_int_to=
_enum()
--

commit 6c940106ffd314fb52ef54d2c5282f1990d4be08
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add hardware resource initialization and verbs skeleton

This commit adds hardware resource initialization logic and a minimal verbs
layer skeleton for the zrdma driver. It allocates resource bitmaps and tabl=
es
in a single allocation and registers the RDMA device with basic device
operations.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.h b/drivers/infiniba=
nd/hw/zrdma/zrdma_verbs.h
> new file mode 100644
> index 0000000000000..a4b628651bf02
> --- /dev/null
> +++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.h
> @@ -0,0 +1,134 @@

[ ... ]

> +static inline enum ib_mtu zxdh_mtu_int_to_enum(int mtu)
> +{
> +	mtu =3D mtu - ZXDH_MTU_HEADER_RSV;
> +	if (mtu >=3D 4096)
> +		return IB_MTU_4096;
> +	else if (mtu >=3D 2048)
> +		return IB_MTU_2048;
> +	else if (mtu >=3D 1024)
> +		return IB_MTU_1024;
> +	else if (mtu >=3D 512)
> +		return IB_MTU_512;
> +	else
> +		return IB_MTU_256;
> +}

[Severity: Low]
This isn't a bug, but in zxdh_mtu_int_to_enum() in
drivers/infiniband/hw/zrdma/zrdma_verbs.h, after subtracting
ZXDH_MTU_HEADER_RSV from mtu, the threshold comparison ladder duplicates
ib_mtu_int_to_enum() from include/rdma/ib_verbs.h, which this header already
includes. Could zxdh_mtu_int_to_enum() simply return
ib_mtu_int_to_enum(mtu - ZXDH_MTU_HEADER_RSV) instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102082026.2645=
777-1-zhang.yanze@zte.com.cn?part=3D4
