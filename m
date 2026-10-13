Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AC752E050;
	Tue, 13 Oct 2026 21:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791928499; cv=none; b=bVF3cVUwoBk7/KE7aJ3x0WMMO6FyP41diA50zaIKXgHWd7b6HmvTw9GPxh+FfXTbvpOjkACJm0ExqWmqsn5QtgSV9w4JKdHTFbShG/2R2PGvoiSz6L1ycxGahasbx3DrhYHYf3J2nNvfPr2eXyXn0wKO36DPKuatCJHynjeyKQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791928499; c=relaxed/simple;
	bh=yhHiZFfjXYa8qYiiVzpdK9WnIr9d7/cIB1eQRmY9aL4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Els8daFi+t+7Ti5ta7jNj3YOfpb4Py6ACYJvfU0yJ9VUrHkwCGnz9WL33OtmgV8KrhZWX02HZY58ZoKFtdwESY/f+DrQ1HJw1fLzJrtv7qepDA/GI7edkVL4NT0uEkjKUv/AcOMvG3hz7YFmzJelSByxv+OGbtQraZ5x4Elapvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eoeS1Rs/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eoeS1Rs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380A91F000FF;
	Tue, 13 Oct 2026 21:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791928498;
	bh=yhHiZFfjXYa8qYiiVzpdK9WnIr9d7/cIB1eQRmY9aL4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eoeS1Rs/xp/wN2SMviU0LMDOdSu2FAoj+ufroZhzwPzwbUnqd38LZ7bCOgXUw8SBk
	 HUKqmMWZOnYOh5QPYl6/4U0HnL13R/N2gnjwI/0KZprAcKut4Dd+HWSORdLKyIn3tE
	 6qIX2iX6kNzun6nYmQfQ+zfKtgvwGWR1jHIOcRAeSjoeWvFrMMAkypig1f1LWTKHum
	 e+9a5B/NxnSGm/UganR6qZLUo1nZQQRJE/ZClNWXWgKmwO91dP94dGmxA5IuYVvBji
	 +n9Wf1sLenkvfUhue0cPhoyiesKDAe0R9LZFNQMk/VIhECCqaC8lqrMn2VF6dxHGmQ
	 KMNBNs6htyzXQ==
Message-ID: <sashiko-outbox-170551@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 37/39] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-37-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-37-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 21:54:57 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted =
to
> predicates which explicitly express what is actually being checked for
> rather than the nebulous concept of possessing 'special' VMA flags.
>=20
> In any case 'special' is not so special a term of art in mm - it includes
> VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
> other cases too.
>=20
> Therefore make things less special by eliminating these now unused flags.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D37

