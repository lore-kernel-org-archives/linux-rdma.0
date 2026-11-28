Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.103
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795878852;
	b=KkmlbwX1AIDEiZCbBucD3i9g02CKp2Lr+Mv7pByBDpGyE2LMS988AuygcMtMDjjsSdyF
	 wD9Eo8jyP5Sv50zR9UQf1joh/ZvDYpSGcp1nac3ZUTN7cizL8Mm3SLna+/I6X+HIkk6UK
	 Db4zffdARdOV2pRPb2hzGW3O3LzBuHrBa6QSa/tXrc+Xw34bGVE81JqkJOQ2YVy1q0L5C
	 mDvSF3pBct6U1ZtqcTa3mzaDk4KuFUIg6FYbpOV+oxjAFHwtB2uwtFbUprWdIxMKhMRi6
	 0OCdvKZ25qgLX4+xAlgkppmbrRmcVh5n32RkmK8dmYb4wBLx1jeh0xmsQDLxXiq9kew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795878852;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=RHwALuKOJaqnmrZwnUI8quIQFbcLwNyIBVQC77ua6Hg=;
	b=A9K9OtrrpZGZtzFgUEX5CeY0fRejpWu2NBvuOIjzLSx/XYvxoJ9ALcBCeNuzjnz+4ewL
	 32uZqwOt2CIZrpzsZGsG3Di4cKltpfs7ShZG1xw7v7VjcwJHzKE5hN+I+1bzFc6kSzQrX
	 NV/GZ8+xwdkk+zx112DpAqJ8zYVAS/V0TgEcy7XemukWBtNz20Dv43rjMRQUozeWFMRjz
	 goEGj/EB8gfxHkmuB9QZq/dMXNIgkSmq8HKfzFicSl2Q6LrjeQwjGZfx2XGUeYnYlHZ9f
	 oJa0XiETj5Je8La8VfAnMRlJtRkUm2wM8N4efRpMlYikQVAPVMGzGazHFgpdQGPJlSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=RgWHSi1n;
	arc=none smtp.remote-ip=185.70.43.103
Received: from mail-43103.protonmail.ch (mail-43103.protonmail.ch [185.70.43.103])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25E4606A323
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 15:14:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C25E4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=RgWHSi1n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1795878849; x=1796138049;
	bh=RHwALuKOJaqnmrZwnUI8quIQFbcLwNyIBVQC77ua6Hg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=RgWHSi1nIW98OEBnO1qSvT0m/pUb9fFlGyLmIp0fS4BgO59rxKnkFL/VKwFlTJ60r
	 2SHmwowQCplFc+ta5QRaRksJgkdA4JvGrj+LTDutJncy37G2vVw2FmLg65qURNoWS3
	 uf2gLJlOZ6kvJYDmRTHKIu8AQ/bUvHin3ITaWIgL4673ShAumFBB7rqqWdkVZPckxo
	 T4SFs/GUDUTHekyFnRXCGNco1oiMK/SkVgAItYVU0EKoWzm7u22nXCMbRDzvWva5A4
	 SzvqJEwp36QwiWXBey0x006/zozV86jtDACTcTUjuqsJt5qdUKOZIG/RZQVIwtcX7g
	 iqSqqhAlnvCsw==
Date: Sat, 28 Nov 2026 15:14:03 +0000
To: Alexandra Winter <wintera@linux.ibm.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Dust Li <dust.li@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, "D . Wythe" <alibuda@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, Wenjia Zhang <wenjia@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>
Subject: Re: [PATCH net v2 0/2] net/smc: do not reuse the DMB of a nocopy device
Message-ID: <20261128151356.1410299-1-hexlabsecurity@proton.me>
In-Reply-To: <d0ab5673-9bee-422b-87b1-001dd598d2f4@linux.ibm.com>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me> <d0ab5673-9bee-422b-87b1-001dd598d2f4@linux.ibm.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 82327c43fd57f1a49fc079b5410cb223590302f2
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Nov 2026 10:06:44 +0100, Alexandra Winter wrote:
> ISM does not provide an attach operation. So nobody will write into a
> receive buffer dmb after dmb_unregister.

Right. The paragraph was about a DMB that is not unregistered: when a
connection ends smc_buf_unuse() zeroes the DMB and clears ->used, the
DMB stays registered in the link group's pool and the next connection
takes it with the same token. That was by reading only, I have no ISM
device, and the series doesn't touch ISM. v3 [1] has no ISM paragraph,
and 1/2 carries your tag.

[1] https://lore.kernel.org/all/20261128-b4-disp-2c190c90-v3-0-c566f64196c8=
@proton.me/

Thanks,
Bryam

