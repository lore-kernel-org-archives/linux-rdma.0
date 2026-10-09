Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D48E435EF0
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791552431; cv=none; b=U/ShbTRGFMcd1W2pDtdUUpbYRx7XJfrqFdcUz6NrFV7VFz3EaFD6P8eOsz1a0FfPm41v8H2+CQhCEu+u0wLF0FNkeTpmkpDFDOCLdLukbQlwIEjeT849unYrWeSyTX5uoVT6VGBmPH+H34ZtdouDM1t+oNJlniqU1jM0VuuVqms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791552431; c=relaxed/simple;
	bh=BJu7HtH+veUlHR3Z8/0m5KPVBZyVn/14MrlelkzHIPM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oT9kfyjn1XBF6/j/ed1ZLCY3IAilGuHbd3ygvpKcOOJywu3Mbj+kR24sftAcYl0DjZntsFZLH5Nl1be2mHXiPlDJSz8PwbH804kYBjf+uMq87dCt4Erh9Zf0jXIiEkNBNmeTxD42NnL6bcg8QJn9vppUPPmGpxBTEHRoGKobgHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMpsz/ZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMpsz/ZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8901F000FF;
	Fri,  9 Oct 2026 13:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791552430;
	bh=BJu7HtH+veUlHR3Z8/0m5KPVBZyVn/14MrlelkzHIPM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aMpsz/ZGabrxob69oq8kLeN35rfvIa9yDT+HzVAgQzDGOIIwfjJpB4qdG89KxrRod
	 mwVerJgNuGqXP7novUoSRAyDugiKeGi2bHHknzCKMNiUiMC3PF67CD6jTFEH5TUswd
	 upncJnPOxdq0QCzGJkUglQr4Urtsz1CU5pxITdQsFnAkzpOEivaEsgOnsAp/jDQfqH
	 4odey3ClX+3cZR9f9B/XYzY3dAeidJF18NJfLHKqp91iWl7Mvt4utf/o/oUEO5KRIK
	 eQjYtZmzZzL8BYI3wYsAFnSjV5MjucjcNLgZwjBr5iXAyf2LOxVsZIWmZFGS335n9L
	 WI4e60DWep8vg==
Message-ID: <sashiko-outbox-165628@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rtrs: Use strscpy() to cache the HCA name
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261009131715.39217-1-serhatkumral1@gmail.com>
References: <20261009131715.39217-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:27:10 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> As the comment states, the HCA name is cached for sysfs. Use
> strscpy() to copy it directly without unnecessary formatting and
> avoid interpreting format specifiers in the name.
>=20
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009131715.3921=
7-1-serhatkumral1@gmail.com?part=3D1

