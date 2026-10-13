Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91263C3449;
	Tue, 13 Oct 2026 16:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791907447; cv=none; b=uq2RYNmJwZLoCzMSPrkLRevIZK0BaX29NAIsvjc0G0CwSZtZzrAWIv1l90C3qmRqbT7nt9zDgkxLkvUMh8lDZr9iixZzkIMTizG0wBP2bhkRZpE4TC25Z3twYjQYbMZnvMvxyXiga4BOvjZNw7mGD/OseJwGXq4mOPTXKbx1NMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791907447; c=relaxed/simple;
	bh=f1i9xRg3/bd+P0byFOICVNuoUt5bDsFzfY8gVGm2sfk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=h03kf3J+yFfnviIMOLV2yEh1c1hcsFZE4oynyASs+nMyHmYhSDkzwcTjk551VXAsV1ssJuBG4EHLhVpN+Zwuu1T+PDWWsy2VapuepxE9t24DsZFybO3bVykRjTjYK6LuSSNdUJJHalF2tr6tRoGY6NZvoXPOAzg1iBULg0N6fTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1pkqWbB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1pkqWbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FF41F000FF;
	Tue, 13 Oct 2026 16:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791907446;
	bh=f1i9xRg3/bd+P0byFOICVNuoUt5bDsFzfY8gVGm2sfk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q1pkqWbBWGnzTZ26mXxwakCNrbKZgHkT6QjftJnCra9Rlp0OnN+Ql5vghPYZ64Gbx
	 2XLugfuZgCNufDuA/FdwoMZoxWjGrjKIkk1ymWw9IopPD+VoveKYR0NvNTgKuiyCvu
	 b3PDQM2ZZzvcIzQNgLPOxa21xKZsjALWZqMfqzTi3uLWv/0JSKlLNNe811HMhR4fxF
	 siF0qFUlAqMKE4xuRAT2Veo2P29abgxaKQ7vdE2B+4yfVQPXybWLDAuoO1bqTrtGe1
	 fSzdao36163bBldfWQHPypWmwyEPesqDa7mGnntMoBzKQU5HJaYAnQpF02PQXjasl4
	 4H6JCeYjSllpQ==
Message-ID: <sashiko-outbox-170085@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/39] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-5-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-5-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 16:04:05 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> There's no reason to export the symbols for these functions which are only
> called from internal mm logic, additionally there's no reason for them to
> be declared in mm.h.
>=20
> This patch therefore removes the exports and moves the declarations to
> mm/internal.h.
>=20
> No functional change intended.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D5

