Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E60843BDB8;
	Tue, 13 Oct 2026 16:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791907575; cv=none; b=diiuogTkXT4xmtwr65hLJX50ANftsPMPTruaUxI8jYCQFs/D3MiTVc1mzSBEmQ6r3z6pxQS3x2gZiLY/DabU17ca31cyktMaxE5p2uxwAdQh+3p8MRle880jznbo+kXD0sg1F5vCEWxMiAm7rwEWsNq87KWidGBZl6IhwjkbBj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791907575; c=relaxed/simple;
	bh=LzOduDt/4mA7QukV85aRiXsSb4GHMwpwafEBs9xQnuE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=AndxdkxHrOqao9ASF3iZytJbUStezmmrswYm11bgiWqX5CCMYWS5S3vE58rigmlJy8oA73o4AoFgk/Zcn4DkHT/eLpQ05EUxk9A3HN0r9H1S7SDM4b+ttVxvWLVpKfAYSs9wqnHHCP9JrkT5+Ar0GqaP1kuYokTG4/zZre8/uPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqoDtv8A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqoDtv8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336D81F000FF;
	Tue, 13 Oct 2026 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791907573;
	bh=LzOduDt/4mA7QukV85aRiXsSb4GHMwpwafEBs9xQnuE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RqoDtv8APyvcS0a0RlPI03KPoE0ocmIBQVcc8udEkZ5mUC9HB/rf5+swlmUfAM63V
	 H/RHhseJ+qK0PU569ilE4hV6wr4E7Oucl7lUtp8CQSWbvd4w7QPsrpq8x0jXII+sGZ
	 21Sr73VZfobxmBeNHag5mRQ0WOkcjE+iFeExar2tiXSEJEx72Ttoitd52f40/jUyy0
	 W1UJcapGu8vubp5m/VgR/f7Y1INR6dvOEk7kUsk1sQWXBBy9jDtYCbSRL/+kCHKZJD
	 GnOy8bW14ickG5o88ZmwENENjxL6uzrpwKQU2f+yBxMEt05YMdwZnRmswt+lnbXWUr
	 i2Rfp71S3A2mg==
Message-ID: <sashiko-outbox-170087@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/39] mm/vma: tidy up map kernel pages enum values
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-6-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-6-1aa3c9b139f9@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 16:06:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
> MMAP.
>=20
> Also while we're here delete useless comments for mmap actions whose names
> clearly indicate what they are for.
>=20
> Also update the userland VMA tests to reflect this change.
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
epare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org?part=3D6

