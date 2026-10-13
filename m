Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DC44A2069;
	Tue, 13 Oct 2026 20:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791922155; cv=none; b=JpaWQNylNW5t3rqLMyWaRPIEfLqHOzasqAYD7xzCtDdUzwhCA52EWwO8TPyKVpUtpN+1mECN5OSiSm6theY1O6gQs6bOmGEUe528Erh8hIFNfvjRiHlXAY/TnbI5U5LQxsliEyS0ai0tG48Y2GJqLrLU4lAkV/7D7x4U/4RSXro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791922155; c=relaxed/simple;
	bh=LXyVU+JZ0l8nvPpUUp2Li/k6o2VOtZBJjVBR1MyZ2iw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=q8oVXMFoZC222MKFtdiAWSekgntKcZCCwYPyb+EBYMV458fNaqwg3CXnJsM8sK215gLYb+cGFJNd4wvocR3d8VB9CkMlXWXqCLLnf8HZCf6avofY2Ogwu2mg88dYTNZrixjQ8Zvsk9WtWGXxcwwdx/59lywi33CtWnf9cr7/66M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkA+qaHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkA+qaHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548831F000FF;
	Tue, 13 Oct 2026 20:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791922153;
	bh=LXyVU+JZ0l8nvPpUUp2Li/k6o2VOtZBJjVBR1MyZ2iw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZkA+qaHBVLtKqX73xrzipYVhvehnr2b/hhQ7I43Nc+R4VKVlxw/KNqsa3UZe9/6O9
	 GFgG51nVpSPAsCugIh/x1nG6oSF7/iACzgWJMVdz85whxRrvqJEhzkNvbmJJoUBWCq
	 dSXIoV2HRa8WvK7kgwHxEhlMMeJkwGrcejFbRdwFWl+GkR2g1SaNBWgXyLMa7ysFX1
	 8/pldAQ32+pyNdBZCEXY0lKT/BerusHkxtJIS5132wmtz0H7r5tygHXeRRfHY6NoxB
	 Hw6MulAJlpaMTGpNa+6GiC623DO3FjojDzOYUYvP7J1ygEjYAMDuFH7q28DLn0RPR+
	 4lGT0r2LZW1Iw==
Message-ID: <sashiko-outbox-170440@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 27/39] mm: remove hugetlb_inline.h
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-27-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-27-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 20:09:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> This header really makes little sense - every place it is included mm.h is
> also included, and the header itself includes mm.h, so it does nothing to
> reduce header size.
>=20
> It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
> VMA_HUGETLB_BIT is unconditionally available, and will never be set if
> hugetlb is not enabled.
>=20
> Simply remove the header, eliminate the odd ifdeffery and place the
> predicates in mm.h.
>=20
> The naming of these predicates is odd, but to keep changes separate, we
> will address this in a separate patch.
>=20
> The file was never put into MAINTAINERS so there's no change required
> there.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D27

