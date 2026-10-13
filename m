Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2161349CF0;
	Tue, 13 Oct 2026 22:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929143; cv=none; b=E+iTJGZWqUY9auBEQSLiVYdGh0F7dq5YlpoKzWoQTa9Mof5ND3C1BcbgjvVS4OMGmI01CrpiJymuK+NjIyFRCUzLqVFd09BxmhomN0T4mVNgOqxXq2CtHgoxBIRtrkATUq12WY/3bODN5nDaUx6MfcsW5HfwJEClo0tQ8N0Dqlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929143; c=relaxed/simple;
	bh=c7Gip3vKfecZa8bmhM+oThxGTsLgpcB0MI8dJan+45A=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eyHj6sohmrSeTEgdb0pwhS/R4ReJMfMuIMn+JqJL1zTedIH4xMW7ssG8u5VgphfJar39zpAe5uTU0mr9S3pMzwn3n9ARb16jb/PnTUtUApdvBY8PgEOc7kYJ7V0zaOM48jOjgALbUGlZSHV1D6/YMyaSSmPzkHJ8OlPPOU3YG3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PyzeVsii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PyzeVsii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1EE1F000FF;
	Tue, 13 Oct 2026 22:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791929142;
	bh=c7Gip3vKfecZa8bmhM+oThxGTsLgpcB0MI8dJan+45A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PyzeVsiix0P6Jr6/ooPLK9qF/tIdE64m1XRoNiUMCw6BmoOUcl5hYKntOT93Ap27w
	 3Vts3yC7v8YU/05M3qvbJz8OtOipH4TL48FVuixGd/+e1rwLxJfLtFF9LgSeJh4Kfz
	 RzdPa1WjaFlluDCZRpZ+1ZCxApWCCoqY/GrHiv3/vWPP8LdBcXvGq8rOMk8U8p0gpl
	 k3WAiIuVJC2OP5DV4CGrrqwhOUZe6L4HZZ7QxhlFx+V1ERDMxyLAO9tIagO2i0VHxu
	 6BuRUGpDC4AWgRoUOZpkwKD34opANJz4Jkw+NxSi//Ork1TpKMtflCjTYUlpMHfPvp
	 DhL96jrop/1OQ==
Message-ID: <sashiko-outbox-170553@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 38/39] fuse: dax: do not set VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-38-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-38-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 22:05:41 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
> prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
> relies on it to direct core mm paths.
>=20
> The fuse DAX implementation, added later, copied the old pattern and still
> sets it.
>=20
> Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
> ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
> insert ordinary refcounted pages and so do not require VM_MIXEDMAP.
>=20
> Setting it only serves to mark the mapping as not mm-managed, making fuse
> DAX the sole DAX implementation whose mappings are unmergeable, cannot be
> mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
> MADV_DODUMP.
>=20
> It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX o=
ut
> of its check for mappings not managed by core mm explicitly.
>=20
> There is no reason for fuse DAX to keep on using this flag so drop it.
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D38

