Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794978023;
	b=QPNPntRc6MrsaVN2/8Mqc8QZMkbKNBewPWlkOQmuB3/Gzmt3ibZ9h+HV6hI8vnetW6Gn
	 GxxduQPm+duXaDeI3N70OLDUIxENW8g4gaQzp2g9eGmshlzlFq0EpirY67AsTgRyuvqoY
	 WGysfbSXVRGMzD6qTjdhtisXKvyfmC5f6KPvRvgpr9YmizVTDVc0GQGc0/gb6lGSRBLNP
	 bPSeMTtvcFkZ1KEqpbI1Gg3zRJSgeaAIyyFbZktqu1aNwoRetyycCxAR1ZJMBd97OWH4G
	 0JsxLjQ/uaj61vfJEfnTc0A5nIVCyBCsplUK+LAYNdRlL7DjQetBCYe93/gzSfmCMmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794978023;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/rdPiR1HFWOMagKWkEOrSOp2gPGJEyxI8PCU+JuAoQk=;
	b=so20bK883nUI1EZbcglHxdRm7OxZk5SAuUgCpGFCNbFu1EzclDQr7/9hGz1fn0QiD+pz
	 bM4bvquFANeo0ld+gir1cAXVPOZanDgiSvtNdp2oI/+qzcyhVOKrca5CkM24M12uyHxSR
	 C0zfUJbPMnvjH4lOrWZT0DWkXdhv6tjEOTDCg7ZmpK56o0/paYbA6Sc6eLR8MsNHIJW5E
	 T0ojqw3MKxX/ci+0v5kJs/0BUa5SA7/lY3miihdP9+x1RceEFQ0udLPz6aK1dD0udcfJC
	 8LIaO6gWAkV4xryCciSuXHZnzqx0TlH69e8FlPSdICDIBDjMQBDqAcIFmtRs9r6/cGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WMjfBRvV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326BE606A325;
	Wed, 18 Nov 2026 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WMjfBRvV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDC41F000C4;
	Wed, 18 Nov 2026 05:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794978022;
	bh=/rdPiR1HFWOMagKWkEOrSOp2gPGJEyxI8PCU+JuAoQk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WMjfBRvVpfPYCM8m2sHQxPwI6qPnbOkpZRfHWCT/cIXXjI1ZlOXaiCImHTqpxx613
	 sHa9zmITXq9k5enJi5MoOQ66SE77QnGaSsEsEOwnAGs79Mh7V4oR9ozYuJO9KXWE3Y
	 7EHveBbQ+3zyo761pniNie+4k1MxdcfMPryij8VKaEMOqIrfXBaE8fWTqnbLxpcTH6
	 kEg9fhdo05/734Ikj7WEsHUtWg185jbXuYymcs+fOnD8dZRI7NM2m83nYt1wB3XLqd
	 aBj4mWvdVUPxymWe80jlUSJ+D3LOl3wFdIEluunvHldfr8qDL3yWuouVu5tH+r5OAU
	 unlhZRXk8PFsA==
Message-ID: <sashiko-outbox-220134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 4/5] rds: annotate data-races around core
 rds sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261118045137.174026-5-jiayuan.chen@linux.dev>
References: <20261118045137.174026-1-jiayuan.chen@linux.dev>
 <20261118045137.174026-5-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 05:00:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> reconnect_min_delay_ms, reconnect_max_delay_ms, max_unacked_packets,
> max_unacked_bytes and ping_enable are read without any lock while their
> sysctl handlers update them with WRITE_ONCE(). Add READ_ONCE() to the
> readers.
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118045137.1740=
26-1-jiayuan.chen@linux.dev?part=3D4

