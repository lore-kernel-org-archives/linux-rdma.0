Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74082389455
	for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 08:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790411344; cv=none; b=Cwi6KJ3vqDV9bAg/0rcuCGsN+yQTUwbhsalgT/6/3RvaJZ/vb45nUKiiIva5AA2ZZ0VvCbaNOddmDNopPw34ZDqhiKju30nZvi2UK/4joy8yebtMFwPQ/12xB/cnXvTW/9VoYsqWmJmhZC3X8FVR2ELeM2nUj67RhUgk2jl0iio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790411344; c=relaxed/simple;
	bh=Lzykl4k1Gi4ueaR9fEoYv/JPHXMhsbLy8Y+85SMlHDw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gnXdyVOzrXkj5SNe/B6jtSVsEsTsI4l4B8N1LAOVmsrGzb5f5e1FwineN6fgIMNNmbeT/3iJReD9kEso1pltsdqJP2kv6qhqhxShaIv6tuJXYguglsc21ddgPzUQNVfnwWvwhwHiKLe1x45NxzxxrlxQsuc+silViK+Bc3I+7uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgrX1WN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgrX1WN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF87B1F000FF;
	Sat, 26 Sep 2026 08:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790411343;
	bh=Lzykl4k1Gi4ueaR9fEoYv/JPHXMhsbLy8Y+85SMlHDw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VgrX1WN1RdC+W26Z66+85dKhaIBYavH9o6uiGD7/I+6mHyuKBjpL5tSzYcrlZEHeI
	 yjt1Qe1lA0JHQdByclNg9bEIqLHVWT6Y4YrQGdNyAk1RE68lxQGp8IqTSnHaE2wza3
	 DqWp7/v40ZGzF0goqOXX75zXoxhhy1w0DciNgCwzDOIAVVwtbFxxJOu2E4ciHbl5Fn
	 XHI/ePlskIirrA3h1B5C95RzZ5hyFnxhWMXOrs9DfClAgnPGlF/gYIxuZxjFWiHypT
	 47qHtdIFFUkBceoGWLDfBFMW88fTRzL4m2vNlqriX6NbBz58YBW/7Y6xQxtBzg9I3T
	 ccebwAhy1b9oQ==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v3 5/5] RDMA/ionic: implement SRQ event handling
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260925082802.2675902-6-abhijit.gangurde@amd.com>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
 <20260925082802.2675902-6-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 08:29:02 +0000
Message-Id: <20260926082902.EF87B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Amit Kumar <a.k@amd.com>
>=20
> Introduce SRQ event types and associated events. Report these events
> through the SRQ event handler during event processing.
>=20
> Signed-off-by: Amit Kumar <a.k@amd.com>
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925082802.2675=
902-1-abhijit.gangurde@amd.com?part=3D5

