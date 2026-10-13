Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BF152FE4D;
	Tue, 13 Oct 2026 17:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791914382; cv=none; b=N/IPDtEiP0HgtVyhAjdm9cmw09DKl4oNwEzw2QGmDReBaBKi3uw8W16seAwULMpS8gvZGt0dSCak7IovngyBd5qSUmkaJLnjpyYhMvC1oe+y6k+Qj5VOYdth/Rkqp2sWRJr8ISjvV/F1Ce+oy5bNewzClN7L3pzpQ37Uwd3ODI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791914382; c=relaxed/simple;
	bh=RJYc++3DGbQU7SWPU94aPTo56XfzCrHIYIPitNMTWBc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=M95JAocguB8XjIY69kC6CqywDcI8vAcMiI5RNnk3M8NH5WH7VozCsw6iX3WL8XeYeftVRUMH5MJznjKsPiUsosSiF9o0vFFETKCHAWe4Yf8JUaJnW6/4iK71O2ksmhHEb+Ejk17qGxHweXMZ5G6ZrE55ouQr2d0rsO+x0F0434E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9Yc/Dbu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9Yc/Dbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5AB1F000FF;
	Tue, 13 Oct 2026 17:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791914381;
	bh=RJYc++3DGbQU7SWPU94aPTo56XfzCrHIYIPitNMTWBc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d9Yc/Dbuehx26w+ZQjXGI7FN2S97nczHLnvmIIdw9/q4Uc1OHHJhM/zT7fbOiHgaV
	 IMWsSaZOQ2As+T5rCvomZa0f4KmaMtkwsVQEEvZ7lW+UJ9vx2fQX0mRz95e1DCrsRZ
	 PhgOcj+I03GiiSmeYob5wKy6CgnpptKXRZV/fT54nz4kgLau5kZoz0s5+FbntpqEg5
	 DxEgLXfHMIPrbmxhfXVQG8C2aBr6XTs0kAq7med65ss95hHOnpJ1mtU5mBYLWV271l
	 aH0ngrx5+sNw6z+mYiwRfEo3sZRF/bVxxn4l5XhgUQ6Emtpktn7DbAixQxTCHh6p+I
	 Qd0MPgMGlwHYg==
Message-ID: <sashiko-outbox-170285@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 16/39] mm/vma: only allow mmap to clear
 VMA_MAYWRITE_BIT if not mm-managed
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-16-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-16-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 17:59:40 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
> the underlying file is itself read-only.
>=20
> This means that mprotect() cannot mark a shared mapping of a read-only fi=
le
> as read/write, as doing so would violate the read only attribute, and
> permit writes.
>=20
> In general, we do not want file systems to be able to do this for
> read/write files.
>=20
> Doing so would violate fundamental user expectation of file attributes and
> likely break userspace.
>=20
> However, drivers pose a tricky problem here - the /dev/xxx file may be
> read/write but provide access to a resource which is fundamentally
> [ ... ]
> mapping, no functional change is intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D16

