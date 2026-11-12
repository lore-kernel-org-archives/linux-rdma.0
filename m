Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443460;
	b=LfIQwEHQcGP0CeZc2ZAtRPESSx0bQI2yxyYg4/3K1/tctPJopt2DfKONjW+kFufoBbSk
	 fCCxk3yQTqxaXFI/4O2rvulMGHmkTPjt8+bGfrqrRfVVsU6mddcK7whB4RK/NFy49TJ/N
	 YZIIJD5ZShW57kdTfUJse/8fdWuhwrpsb2L0p3mo+JPOvCWdktvil8nqPR6BwefCyv/98
	 4inGbCIT62eYhQ/oY4VLjLvjUpatFRj3cSK8iShEKz2w8sWeBDXrJShp9lBH4OtbBmVMp
	 TpvFP67Uhu5f4mzlU/5MpLT5cpyVgvW+8u4XJcTeEt8ZlUMBgiE5cGytO43YN3gSw8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443460;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UvHJOLNXDfvXkzY+7QiG88AZjnDZN+sm3b5gCv20AOw=;
	b=U/x/J71HLrBzz+0WwJM4cK99t408wnC9ykAVjNYAYpo4LOP66KnmUR22Ol4nyCKbIyQM
	 DPo5VxjrjUNQSArG37KdT+iVUykutU0vRF5vShEIpAblDFBpy0BleOuMz0uxhnBOrYE1l
	 YS2nx5ZRV/WHifm4YREqLDfzNytvUqb8pTnYzBnYvvKCvuIo5t9KwtzJBbvR5fCVhX++E
	 f5ZGTPGelyworrOBZ18E+4Fsvjgcv69biZpCEFnEM3LM53TbRPGfnlI41kwL+/Y8HLR4c
	 /fQWY2NOW1gM/U73RfAX9Xnftjy0WbAQRlN1brMEBOCKElDIs3mYIu9MdsO14eGW0Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CNIWofbm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC32C606A333
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CNIWofbm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CE51F00A06;
	Thu, 12 Nov 2026 00:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443460;
	bh=UvHJOLNXDfvXkzY+7QiG88AZjnDZN+sm3b5gCv20AOw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CNIWofbmoSD5q0q1SFSv3Nw5dxo8+hUJHRgIVZvT7CyM7VLbJmDpD2UjpBGkZXhrS
	 PPvevUKXQGmqLVkuauIEe8hrMlo7Yh4Wvq56IKxFcuDXbb450P49hvRI2e6wcrkLpt
	 feffMQKk7XegDjNvzk5e7MyXHOR2/dS/WyUOIgIp3XvgMiLs0CHmTFhdNdXlD30Yy2
	 QI5ccpSQty/8s3FWtpd7IpuubNJV0gsnaTtUO/ijl6a5LhZwedVEPPhOL4MEasjju3
	 3yG5NCHmFFA9pfy7xCohXBs36/8DB6lX0zs7LVZ1hH0k1NVLTAyv3gjMTWdFrpLxSQ
	 aSwSbpLkSl6Wg==
Message-ID: <sashiko-outbox-209927@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v5 3/8] net: don't fragment decrypted skbs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111001831.3710881-4-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
 <20261111001831.3710881-4-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> on transmit, skb->decrypted means the device must encrypt the skb.
> if it can't do that, then the packet should be dropped, not transmitted
> in the clear.
>=20
> ip_do_fragment() and ip6_fragment() on a decrypted skb produce
> fragments which have skb->decrypted unset, and can be sent out
> unencrypted.
>=20
> tx of individually encrypted fragments would not work anyway, because
> encrypting needs the L4 header, which non-initial fragments do not have.
>=20
> ktls could encrypt in sw before fragmenting. that would not work for psp
> offload which does not have a software fallback path.
>=20
> tcp sizes segments to the mtu, so psp and ktls socket packets normally
> [ ... ]
> them; with it they're dropped (Ip6FragFails).
>=20
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Fixes: 659a2899a57d ("tcp: add datapath logic for PSP with inline key exc=
hange")
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111001831.3710=
881-1-toddfreed@meta.com?part=3D3

