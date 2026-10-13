Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3295349D3;
	Tue, 13 Oct 2026 18:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791917295; cv=none; b=cXp5Ye8BJTFQBRnDmPR+iGPhhL5uEH3pCGH33i8iBWbNfvWRKXlrTN2aQlBx3UCzc3932sZLv8yNgSyGzzyjT/ddZERTJfoQHqhX+tuWRtBxSNUC50vvIJnyBmwruhLfcGhBqWIS/XHxfcq8R/5CyApWej3lDg9Sy1UL+pO7/NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791917295; c=relaxed/simple;
	bh=KGkiSUEm7T+M2QpqIbPQYgCZZ4RLPI9BusTdgCNEPe8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JT90qknp9Ptx1/GPVlTYlCRADCDAea6mSVskgO0bD5wRMB7BpeLeWG8nhlhJIwMERX7I3Qj8Uv5TC3xAeW3s3o2oKTvlJ5gKwOsLkfy/BOZ33LI5aw0WcdVqio9+TeNJOokGPTSAkyFiFLayZJGJdUF0DTc52FtPdC8SYjZ3EqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l8cyxV+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8cyxV+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EBA1F000FF;
	Tue, 13 Oct 2026 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791917293;
	bh=KGkiSUEm7T+M2QpqIbPQYgCZZ4RLPI9BusTdgCNEPe8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l8cyxV+2kNgbFvRUGUgrXY3dGyxuxmmqRyr4kz/rES9NNx0Fs7BbMXB8uDpVgyEpo
	 OEwBNmlM4p/aD1WHnTtiIWOmC88bRinVPFOgiHsFaJcBv+Iz8E2CFLiy85YMzk1zR0
	 YvJJ2CBzZSvLOdXOBmkmZIWLSd8o0ug0n3WRI9d9Doa6pVZgwgg5NQuK+JzrfrZ9yJ
	 IHcmOQUaxwMKH4ri9XYMY1yA6e+kxPqISWjR/cuNXIfzjBTx0tW08IVYucSFH6g43V
	 I4cpj2olHCHKb8kMAA9/uVcUC+rI+VkW9bcAu9WdWwqc8kb5UkBxNs7awODr/YngzA
	 k0Nu7Ef/jt45w==
Message-ID: <sashiko-outbox-170352@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 20/39] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-20-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-20-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 18:48:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Use the mmap_prepare in favour of the deprecated mmap hook as part of the
> work to convert one to another.
>=20
> Since this is simply a refcounted kernel page that has been allocated, it
> should not be marked VM_IO and should be inserted using the kernel page
> insertion mechanism, so convert it to do this instead.
>=20
> Use the VMA descriptor's private data field as a scratch buffer to store
> the page in - this stays valid throughout the kernel page mapping
> operation.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D20

