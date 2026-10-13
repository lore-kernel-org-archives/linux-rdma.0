Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458743D8122;
	Tue, 13 Oct 2026 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791905882; cv=none; b=H4gThPawV4UjEUsYLAPa8Hz8zSxCutLjjjeWZpu/HlfcJo8nFV6v8OHRluYDOiH5ZoO6VCLEwZY7zkBYCDqSMHTZBW17BMRMQ1DL7tiHttjI2MuW8oOvi6meRgTFbYTuoGS7s7XvY80TzMmu9An6+eWPPGgKS4E6t6ctvxDeo4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791905882; c=relaxed/simple;
	bh=b7BEX7RqK1tAfOeOC/1TWzW7lzn6WVYtXrqoq7PBtHE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=hwHLmJRWyA/qD0ZTKzxhC+vgNkE/oJITBK6DNGS7aqDX9wWwky6PgCv4Q3OrziIoFsud235kw0vpgI1JcC0tz0jsARZGhiQZEZxaxLUkGnLv+Mj3hIR4FCaWXJZw+83MSHxubDqVhzE6TFfCWdj4NWuxW7G963jm8XhVbwSJmPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kyVnD0vi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kyVnD0vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7991F00893;
	Tue, 13 Oct 2026 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905880;
	bh=b7BEX7RqK1tAfOeOC/1TWzW7lzn6WVYtXrqoq7PBtHE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kyVnD0viTxZoVJ9bu6itNYTU2ZtQevVFxw9n1WVUWWFqZ/ATZqGM91S5a5cy5PC5u
	 bNgfFvT43aA72DDaRky53ZXKl7NO3g8VRKggFJUFKxaCRe6XN4iHX2AZih09co6NO2
	 UYPBu4veN8g3thIU5uWtnUNZOKGPv6UtuIY6gxJ52VmKYEPtsm5qMbBkXzLd9Cc3rW
	 hnlC1O7cuZhQ1mwc/KBWyxs/6cB2nRAxLy8tYpkk1iAjaalqRnQiTvRnehfyY7gmj0
	 tHpXZL+dOLQutORFeOp4QBapqwV83xLGXNgc/W4Um4PNuNNwognk2CWGkUSqoBEojO
	 owSTriZJM7Zkg==
Message-ID: <sashiko-outbox-170026@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 02/39] mm/vma: introduce and use
 vma_[flags_]can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-2-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-2-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 15:37:59 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
> two new functions vma_flags_can_merge() and vma_can_merge() and update the
> merge logic to use the former.
>=20
> This abstracts the check and expresses it in terms of the desired behavio=
ur
> rather than an arbitrary and confusing VMA flag.
>=20
> This also lays the groundwork for making further improvements in VMA flag
> usage.
>=20
> Also update the userland VMA tests to reflect the change.
>=20
> No functional change intended.
>=20
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D2

