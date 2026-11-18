Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794994194;
	b=XqfFGVHvYUl8trtRwlaBNBA1i3fqupTZnHykIiOUxLnyClOHVmzCung+p45uO3zlcRuu
	 l1R3szxQHXCKt8GGrC27TolEg1Ts1UW3XR+AMlqMqyk9JFn0rox9fjT3VXc5Gdid5Nabb
	 IK06cBJ6HKU6k96QaxtClvLbk0KH9TFqY9mJRUlXCOxyAJNIRm4MFJ7uxIb6jqWPviWsd
	 nERbZVOupa+JIL8J3yjqnHJs5KS5wBvCxMw35GI6rLI48Zu1ZZ26z+DGKFIL1VUxC9aRp
	 Rm5h7oH9nA71qXKUJ/dBXqrCCGrxiQ5F2gECbuyfTJO4VgezvmAn0MnEIDOqax1G/Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794994194;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bGFRVvzAkGgMWoUYWVVOU38CHLbbM0wdeQIE9sZbY20=;
	b=a03RDb4Eih1hgmiyX5kIC2GDrdZwYnqaCajwjciOG0j9Sauth3FgRWi3n5k1ScWYXY1m
	 ofpZteUfVhVyLBs2L6WVQl4Ub57HIr9aq2lTTj5rg+MDQRWbUSE1GCm4DHTMksesGrev9
	 J9anBevi5YUixmdmW8hPfqu50AjCmA6WRe3ZqPgzj+SV8StkDLcBBL5xcD91UYLIodABA
	 ZuUdh0nie0+20Pec5MAPjyXlyCepTakUhxI1mvpEVAC/Z720ZZRd0C236uHcNMZaXGbAA
	 QOzIHg5Z7XQwJm7MI0h7OHoMhceQDB/7HOQfEXHs56p7vMo4FY1SPMMyaoTyJtzt8pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=evaoQnGw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4B6606A334
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=evaoQnGw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4429F1F000C4;
	Wed, 18 Nov 2026 09:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994194;
	bh=bGFRVvzAkGgMWoUYWVVOU38CHLbbM0wdeQIE9sZbY20=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=evaoQnGwbdTcjyddVgzmrDM2xXncGHHcohwsFDvlgZLru2cxARxGvM2Gst9j60u7K
	 UBULnVZVTNXh2Q39KjvoaFnC59d+s9Mcb1TOrgepSa/HJB4ckUUYXpHeEiGphd4x30
	 DGQmwbikJM4piuirT0R5uMARWvjBMsJD2HsSZwLdmYDmwzCB94R8Lon5xS9PSAzhvD
	 asn+A4isCSk0mPBojRRU5Gyca5fvjeiqJl7M8SVYkD8913Y4f9fabEQotNJG2OgkDg
	 SKjzlqFKJHk4qALjMuYwReUC8VUWU9k1buqUtu564any+wNuTv7l904gcm7x3TO8E2
	 LuBX7P5g23AQg==
Message-ID: <sashiko-outbox-220568@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 07/10] selftests: forwarding: tc_flower:
 test the enc_key_id mask
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117092915.255194-8-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-8-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 09:29:53 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> A filter on a block of tunnel keys must match a key inside the block and
> no key outside it. It must also dump its mask. A second filter proves that
> the frame outside the block reaches the device.
>=20
> When tc does not know the mask, the test only logs this. Reporting a skip
> would turn the exit status of the whole script into a skip. A tunnel
> device takes no skip_sw filter. The test only runs in software.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117092915.2551=
94-1-acassen@corp.free.fr?part=3D7

