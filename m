Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795531104;
	b=XajeON/2gWL+peMMYnXOS6Hnt/aauPqkQ7yOS9SsDLksYq25yd0gFKPQ4w3fQXKz08eG
	 mX5pLwysnGH/HdeqYHUjZ7xlY5E/oEeDH10I5TngLrBJju7f0BJoGZTzclhYMVtcEvfP/
	 5DdJ6LSDfC+HwoDffcXHqJ9+lIFB9xn6MzDVs7sbz46qFAEEfXyP/Y2rjB4ColIh1l+O/
	 waPn/TtcEUUbAmv2WKxWeTSf0DqM+02rCpxlkze8Gr/pTBJKUDUPFZe4LeIPuLzUGzzGl
	 Uy8HrTYzkeSJ5qkiq1FJJzHeM/cBKpfwnLZAmOinM//2Hl4qm/WuP2CoqeuYXHFLQ+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795531104;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wKqags/2HWcM/AtpMuhwk4eIZVZQKp5VRdYMbaHfPPo=;
	b=JXS4MC7wOlzA4yxFjy/c8eriZlJJ9mHiojBOGcaN5Th+iEV+xqiMHk5HNtCBp/e2fQ9F
	 rZ6mShSeHdVcZSxN0m375T7fyHE424oFDbWFgWRLjd3Kt8kLxFzhQ8I7n+DJwicC8Zi0t
	 BLrdkw3PTMQuGRojYuO/sSQDTGBUuzl+tIFVdoJBv63MF825tmHRrWcEVSwn0V45u4cVT
	 tuLQclFs0zIChZ/g54O3rgTF0E8Q/8tOLR2e99DX9Au6Ia8DKyuRjtpa+dp7MXQbUxCFh
	 l3davaf3/91GuTDhLdeufJj7K3eKQIvjXw1vwS3xvHJUintzUVdl9ODCsyhv4iAA4/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQKU+Man;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42871606A321;
	Tue, 24 Nov 2026 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQKU+Man
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534FD1F000C6;
	Tue, 24 Nov 2026 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531103;
	bh=wKqags/2HWcM/AtpMuhwk4eIZVZQKp5VRdYMbaHfPPo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iQKU+ManraUJbfpNqXmU2z0b4x46X4ixVAq15hjwhtN0NMUTnXE6an4ml3cpPq4M8
	 RtDeKZLv9Y806dVTWxXrkgXw8OPY7nU/h2Z/BBRgeW35u0tjbjpcZWm7cV+nf2u7Mt
	 kz7nZd1nmBL+nIsekXSdWuqy/t5HeJaSQEqOjAeMKM3kldqHT9LHobt/4VCmLbBA2Q
	 K0neTVeVpuyBrl64En/g8Fmr7hQNuwiWAVHD0W8nh2O7+K1VIrJNGl3GjySLy+YIni
	 fmb3sgL8rv1+v9nTJXqmcme9XLVhy12DPn/emyv2FYfddVVGCU69J2PUfMVMo3k7pQ
	 5ukOisBRpr47A==
Message-ID: <sashiko-outbox-231366@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH bpf 0/3] bpf: Reject sleepable struct_ops programs in
 atomic context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sechang Lim" <rhkrqnwk98@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261124143123.1182108-1-rhkrqnwk98@gmail.com>
References: <20261124143123.1182108-1-rhkrqnwk98@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 14:38:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 3-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124143123.1182=
108-1-rhkrqnwk98@gmail.com
