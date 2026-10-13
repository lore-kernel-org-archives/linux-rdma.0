Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CCB47A89B;
	Tue, 13 Oct 2026 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791909001; cv=none; b=Wiw41FYG+cUJKijeDtebA4NQ8lsR2tw5c0D5uwsjWgjbCV1Y7mrp0n3Z/uaIAsncy6ZC7olbZoYCZbGLI/pcAeySQBhblFAhUSNG+RYWf41En229YWyvBt4Zx41eqe1eFgzgvOxr0y7I6XPlHHEcf/pzLxsCo8oo3eSc8tlIiDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791909001; c=relaxed/simple;
	bh=QkdvX42D2Hj53JhIAU6Ao7OyWHSuvTeGOTMEFCBbK/w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jOcwKOhBpjCiWECcZX5EEG0MfoWSCbshpEN43utpJfQxaz9sU668KucOkr2UVJ5TBuqw60+zWfD54Ejbk+WodW313Kd1y6j8E1vu57st+1lQgF6ayBZSJLNnQweAbJ8UM2DbtYVS5biEkUEwyHqG6FgG9SpT9/IiM32jENrqoNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bH99gLcp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bH99gLcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819731F000FF;
	Tue, 13 Oct 2026 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791909000;
	bh=QkdvX42D2Hj53JhIAU6Ao7OyWHSuvTeGOTMEFCBbK/w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bH99gLcpRaw/0fCPvUbTUrCv1cyxI7gIi17Aw9gJHST2XjVaFY6WPfILqqqoY+aU2
	 9OitxUshMIy4FmADKH9HSsS8p2fei1lVCaWC8q7s+pJHGSIAqX6F47cmqgI1E/CHyK
	 vtvpNGVThcfSGH3cW4ZlaACozjxzkuutflv9zZjAGY1x2KSgZe2Z/q7J2qyqKZCU1K
	 5Gs/9HQ359GXMY+UXN7tYYuxSdeLzukP7RdrmSpzKYr1BFQGdG6jz/0s8S73HJ2XXO
	 ZqBEFrZjlPy06G1Sk40kPaLUR9kDdGPsEy6umymOgS9rWxzqPBas3DVHKDDivk9O1k
	 e1xpv1R0/kHng==
Message-ID: <sashiko-outbox-170115@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/39] docs: filesystems: update mmap_prepare docs
 for discontig kernel pgs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-9-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-9-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 16:29:58 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Describe the newly introduced discontiguous kernel page mapping mechanism,
> detailing how to use it sensibly and how the API looks.
>=20
> Explicitly detail the various discontiguous actions available and how to
> use them.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D9

