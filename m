Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964C747AF69;
	Tue, 13 Oct 2026 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791905672; cv=none; b=f4IxuDR5MzWdgD5B6i2qCutUTYNCeocLzesVjhjQ3xh7BbcU+3iM7WRcLzQgy3C+gRqWhKUpHoFUdtJ2eGFubvwSY8G6bOWylicf2HygxvjmHM5ZRDL60gCtd10MNXzyY80QP4YTo/p07007F35S9Rr08osZOIxoG5xkv1wlbSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791905672; c=relaxed/simple;
	bh=S30RohOVYzrMBuZfvhMPezMqELdMMuQOqYxosGtFHq0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=k/rznjhqEW5ENF2rJIhWRUlhU5ETH7kdHNfgUXAC4ONd7Mr5SjtQy+CaBZ0GauaoLhkz6idANYA7Z12lp7d6/XiBeueuDzuobKoYtznxCcgIjqOWOws8ISZ5REAaOSYT1tAOdkVLIvQCuIYT8fPXnerxAk8JGeQ2F4j9eEDDYmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UKw2XfzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UKw2XfzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53DF1F000FF;
	Tue, 13 Oct 2026 15:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791905671;
	bh=S30RohOVYzrMBuZfvhMPezMqELdMMuQOqYxosGtFHq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UKw2XfzSFfN/YYb1OHDUVLqVbdY8Z9y6aBHds5/vSsICHNKDCc0UoOrLAggeW0/1Y
	 LdoQ7TuoeBZh4Hy7DynypR4t/7+ISHjamju/ECH7TFiJgxBdvp+i9FLP16l2VYlm7o
	 IjykinOcRVquQ3fwIf1aqdolpprvTufdQokwPF4bysi5tKiVBK26EnXX1SpqJ+4UFv
	 88q8J62HjD9XH61MeO3Z8U6RguGOyv5oySWy9TAhVbwwicSzfNirUCdhuI6f4CnRM+
	 urRbHvORM1NLBb46yNMkimNCNTAayqO+D50zOUDd2/pn4mcSnaVuWrHuiRoCwj9l76
	 HlmxKAR0Lflfw==
Message-ID: <sashiko-outbox-170018@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 01/39] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-1-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-1-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 15:34:30 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
>=20
> Drivers are permitted to change the owning file of a mapping. If they do
> so, they are required to take a reference on that file.
>=20
> The mmap() operation which ultimately invokes __mmap_region() is guarante=
ed
> to drop the refcount for the original file the mapping was made under, but
> this is not true for the replaced file.
>=20
> This has been addressed so far by tracking map->file_doesnt_need_get, whi=
ch
> is rather poorly named and unfortunately fails to correctly track whether
> or not an additional put were needed in a number of cases.
>=20
> Make life easier by removing this flag, and instead drop the reference for
> [ ... ]
> currently (no driver that does this is mergeable for one), so this does n=
ot
> need to be a fix.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-mmap-pr=
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D1

