Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316261;
	b=lswdFT3o6JB+aOA/jdE8IWQt+J5KLgZ5O1NpRq9OdkrB8n6zmYm7TrQjyUmMGdYrZbSW
	 O8H7EGcm6mGKWWv3R8rIk1DY32RYoCgQfIwA17mLzygDx9X/yQHHu5Jroa4d5/tV0GCPs
	 jLZZtdCNcyp43MklXGu9CfWVDyZ1ixN36saZu5PMLzD0gV5GRRYc+tyeugywlhpw+zqB5
	 6kZB4CkHOoZvcX4FEQXxSvZOjUf9EEidauQYL3XNqsLwRI/fB5FEznwQy6Qd5S9YeLvur
	 lgRbKlZCG63OPE3MJW4Sas1ub5fohPq6JUp8xlxoLvwFiQS6xcB5wdXyzqcL9etGNyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316261;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Wx0NuSTtqnR0/iMsQSQQx0pqp8U9Ksr2IwExTe3LZ2Y=;
	b=Su74P9eA3gPFq3mjIEhka/J24LPYsJk2ZL8bHaj4WINQf99Xe9c8rdCMsG35YzrZJUme
	 a/UNtkcSKb/RWcz/YJKHDknyhxWcLXVlToAHCENWv7wp91uawDd2CKfWLD/i+XCZys1H8
	 qSLAtMVN0X+zmNqFl69q8PY2ebr1uLnP25vJy206vZnqkN/Z1oESfLphm96+Bm7iN26MU
	 qOApibR5ytU0rdwBIH+o4n/d6J61ewyRW3fiTa5qD9lgoqbp6exOrbXuErL7EmadAE734
	 0iFOnWrqf2CRpAAzEmAvDMzT6SXOl8AcmSMIBdxRbN5dbpmx/MM640kXECW74FPmgJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGqDZSq3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D14606A743
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGqDZSq3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A891F0089F;
	Tue, 10 Nov 2026 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794316261;
	bh=Wx0NuSTtqnR0/iMsQSQQx0pqp8U9Ksr2IwExTe3LZ2Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UGqDZSq3iCCWcNjaXbrqYx1edpLcefdW9uI+7Gaw0RcWgUfXsqgWTBHQYnZ1f+Vo3
	 jsvVJqNi10z+UO50g4bK7EhNrmdbsd7ehjZhBSKfF7Ok11pXIl5Meq/KAL0ntTUUZz
	 IrTtOAfxjOJdQHYuhM18Qws6PxNQNYYoHxhEot5yNaM4NWjPHTE+zQ35HA2L7bs4uc
	 YHO2tJlPwOYWJVZxaaDaxLsscsps7+/w/eadda5xpf0eFLX9XUa/beuTJ374U73sRe
	 NLJ/DsK5lJwHurjfUf+sPeXH0QITGcLJltvEfscl2eJm/2SoiyBCLtJXXZmLs4yhnf
	 +m4q3cRp4qvng==
Message-ID: <sashiko-outbox-207092@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 03/10] nfp: flower: refuse a tunnel key wider
 than the VNI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109131039.959438-4-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
 <20261109131039.959438-4-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 13:11:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> VXLAN and GENEVE rules shift the key and the mask of enc_key_id into a 24
> bit VNI. An exact key above bit 23 already selects the wrong VNI. Flower
> is about to accept partial masks. A mask that only covers bits above 23
> would then match any VNI. Refuse a key that no VNI can match. GRE keeps
> its 32 bit key.
>=20
> Found by an AI code review agent while auditing the users of enc_key_id.
> Build tested only.
>=20
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109131039.9594=
38-1-acassen@corp.free.fr?part=3D3

