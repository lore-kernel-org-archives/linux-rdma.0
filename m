Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795143873;
	b=nibncIVoP04Qb2uiX5y6fAAdIjQtlS9D+FhAWXHZYFw8m/X9KZ0gCshnYsHbRAxpWm0T
	 F/A3OPje6JixawA7q3KrO4QNAxt0BaiNVpudrJoXK9wtrcH6E250GCDqzorxe1LB5axHR
	 DbhNhXH4PELMBeAJi63bDBtwpgz7irCsTFBgBGswMafkdCO/LdWM0/jJ28nGP9CxfPO5W
	 lVSLUxLkb9JAAgq51kazfTbWjxoOOXUFFCWdjm1rKQgB4R6JkLXaR74uorxnEy2KY2a4T
	 /FRixXuHwMaMw/rXPmv6BsOlhVh45wmTLqjvd457PD8tbGbdHsxvinmd3sxzVYqkD7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795143873;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yp2WcdnHjYf3nN6zctQ2kngrjSw70weixIKC1j3OjVQ=;
	b=OiR1Hw+LjTH7Vpc4lmsv5cxynbfegxqxKlvW5STkZUh6derYcQXhj0e9/D0bhKKLKmWC
	 t5VbMzMpufEr7xNjKveJI44PNdwMEsjBPSYrtYsVcbShClVzPBpkdwXK+qF17FGriWqKd
	 x0XI57tuyG4c9zLBrGDLDzd4MgNcmBYYWSG4pujg9zcLdrLMoEAf2NRC8Wayx1GyBYAV+
	 cRcv8ME50mkSqr02xW03Hk9IAamc0p6zNudotFBjysZDvzoscuYsUOJX0Ta9o1qFW4RC1
	 G9sdGKb2K0AaqAVbT570npjVsvcr5++oHrBC6qFbUWCZc3AaqLER2Y23XHspSWiSwCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ZIhs/YDg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1735E606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 03:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZIhs/YDg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5991F000C4;
	Fri, 20 Nov 2026 03:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795143872;
	bh=yp2WcdnHjYf3nN6zctQ2kngrjSw70weixIKC1j3OjVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZIhs/YDgOBtdaRkDCwv401CSUD/NgAn2gu3FteUIOayoHwPEJBK++g9G/NConQJQm
	 kbrsl624fwv9CsD1KcbODkydPqssnXNugrHy/bW7O3fc4vUtGFUFlCJu6I+M9ppzpR
	 WeH5NS1lTQJUVp6CNV1yuuAXc9dEXn7AZ6mAfGp5rBNA2HqdhTIAxmFl7H9v+rh9yE
	 ICHQiXmfe69a/bhfRkUwYdYZltXrDHhgUzwMu39mVfIbJnFTWZIGji3x43+eSyKbgX
	 cp8ZqFS/WT5JsH/DD9QQXgs7JBZ8zEdgWGHM30ML95nZc2bgZZoPxJ/kzwNEWVTmeO
	 xUsm/IJ+cfAzg==
Message-ID: <sashiko-outbox-224390@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/mlx5e: IPsec, Fix RX mapped ID leak when
 adding a rule fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Changyul Lee" <lcy8047@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120025501.1675212-1-lcy8047@gmail.com>
References: <20261120025501.1675212-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 03:04:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In switchdev mode, rx_add_rule() calls
> mlx5_esw_ipsec_rx_setup_modify_header(), which allocates a mapped ID for
> the SA in ipsec->ipsec_obj_id_map. If a later step fails, the error path
> frees the modify header but leaves the ID in the XArray, and
> mlx5e_xfrm_add_state() then frees the SA entry. Each failed inbound
> packet offload SA leaks one of the 2047 IDs. Once they are used up, no
> new inbound SA can be offloaded until the IPsec context is cleaned up.
>=20
> Release the ID on the error path under the same condition that maps it.
> This label is reached only after the mapping succeeded and stored the
> new ID in rx_mapped_id, so the copy that mlx5e_accel_ipsec_fs_modify()
> passes in never loses the ID of the original SA.
>=20
> Fixes: 91bafc638ed4 ("net/mlx5e: Handle IPsec offload for RX datapath in =
switchdev mode")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120025501.1675=
212-1-lcy8047@gmail.com?part=3D1

