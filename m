Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D374F85DE;
	Thu, 17 Sep 2026 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664378; cv=none; b=SwZtIfA7C9XVHWAzk6VFKcyb2brBJdrouv2uieWP0+Kq+BEDwd5wkekGVF9OXponGovOG8kwJEl3EhoxrkpDSZyvFvSkUxugKNvzXJ2picHJH8CHEaqNjY7L8JF9LugYmAFhFiIuFE3p0yoplYIPRHF6IOFQqgyhvHsT/6gm7b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664378; c=relaxed/simple;
	bh=9Fp0aOqzgq9jwdH9wTTN4AfkVE4y+//5dJD5YNp7/0I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rL2PYs29Ingl28vYAlIVWMzQRqsvb9JcFWtHdamlecIUMohC4eD/rN2ShYJm2cAc3zukJWaZcnQvAZHeek+Wvwp7CgJ8/vsmmxhiqvrV923H6AP7vuGuyTJHpcsmf1X7IPw4FK/tBgspKc6ob4jl2O1lAtnJF7IeT2DSI2jNLWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbSRYUHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbSRYUHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9377B1F000FF;
	Thu, 17 Sep 2026 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789664377;
	bh=9Fp0aOqzgq9jwdH9wTTN4AfkVE4y+//5dJD5YNp7/0I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RbSRYUHde1dDl/MK0C25kFR0u57jhCOgEV6rzE0Gs6ceGN4pL3LkAJWKK+hn2yT8c
	 zmzL2fbH/AYXuEu05IQarJ3un6DUnOjruovXpMS/BOqfFgUP6kAvLuBp/FqE7mqS4l
	 0slr8n04KBVwhVw+lh2lNTaREhe5+1qcPfI9qH0Vn3utXAPCwdyQDpEvPAwuM4KL42
	 CMNoyc0UWUnut6KvYBvBMPp6QdK+f+0OO7Yo8ceYKAvXh6gGxqy75aXiZKM2W9dzwE
	 7Yx1LaatTwQKwYcOR49dHRY3FQLGAMtUqLUoqlm6i3NFHqzvUEvmaZt5IBG1nd4Qrv
	 xcrqZozcmoq4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/smc: Fix socket use-after-free in smc_shutdown()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20260917163956.2162779-1-vulab@iscas.ac.cn>
References: <20260917163956.2162779-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 16:59:36 +0000
Message-Id: <20260917165936.9377B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> In the fallback path, smc_shutdown() drops the passive closing
> reference on the socket with sock_put() and then still uses the socket
> by calling release_sock() at the out label. If that reference is the
> last one, for example because the passive closing reference was
> already consumed by an abort of the active link group, the socket is
> freed while it is still in use.
>=20
> Move the sock_put() after release_sock() so the socket is only dropped
> once it is no longer used.
>=20
> Fixes: 1a74e9932374 ("net/smc: Fix sock leak when release after smc_shutd=
own()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917163956.2162=
779-1-vulab@iscas.ac.cn?part=3D1

