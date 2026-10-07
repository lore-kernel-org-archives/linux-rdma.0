Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1373A3502A7
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388022; cv=none; b=b9gT+Lu3tlr9TVvvQb/qqEusFU5xKapsTEd1FWMuohCvnhll6z7Y3GOytr7G6OHUyQvhxHbhN6GIb8IWBXCOIJ+2lo2JXZdvgQqXJwUYGGd4h+A5hjLuoqJ16jBaabhaF3YVuZE4m11DA38usggOvhBN+ggUaiRIRTK/fjlBTrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388022; c=relaxed/simple;
	bh=mvlyt6WLPf4CkU97cC10yHU+EKUyXwC8vY5bIJHtdRo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=adJ2MDndln2RBK8EG99QCoCO9LJvMYF+Sd3HDkKi29JSKctBlHzU1g9spjFUuOcZHz9wcn2TVvryb5d3sVjxYsT4fxhatFfMuzcffS/5Ba54rjW+Ri78LSVFBq8QxBA907Mj8rq6eeYmdAgUoe2FBs4iEBILq/F+GvRp7ae6aGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FXbbTJdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FXbbTJdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF4C1F000FF;
	Wed,  7 Oct 2026 15:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791388016;
	bh=Smrpj5Jy3HDoa3AgTceAMUmunCRCqLsR6XQ5lzBSPAk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FXbbTJdqeaWdps0jIMssV+3ur9iLbLQjlM9uvs0SJG1z1bhyPz+roG0hKSh7fdS/Z
	 zALpUUNwFrOvcdLxwJaOMbsDFzb8eYBUEBMxUU8w94sPj15+QlyFm3kn2mVwCv/dPI
	 FCgJXmr+uQ082ecfNXBpm6SzvaJqgzxyqtbFniezXZfFOHZ5oM7adK2SAFHraGW1HH
	 pyHkfo0pVtt3Vja9isgwyJ0Judp0anxUfAK8HFWeMt3egH/FAAf/g3InMd3O7s44v0
	 Y5DBzoJ7EQ+LN5mz1N3XJgzHL4kK/QPE/rOI0EsAQGbYqxeZRotIwf2wiWICjgbpBK
	 wdkmF+zCLdETw==
Message-ID: <sashiko-outbox-163159@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 01/10] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-2-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:46:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] rdma: brittle ALIGN() macro usage with struct size
--

commit 5c377dbd75ff20b57d34b69b57ca784c487e1850
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Allocate and map fast-registration MRs

Implement alloc_mr and map_mr_sg for memory-registration MRs.

> diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw=
/mana/mana_ib.h
> index 9173ca64d2e1e..3098ad2c6a05c 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h
[ ... ]
> +struct mana_fmr_mst_entry {
> +	u32 reserved1;
> +	u32 reserved2		: 8;
> +	u32 page_size		: 5;
> +	u32 reserved3		: 3;
> +	u32 access_right	: 8;
> +	u32 addr_type		: 2;
> +	u32 reserved4		: 6;
> +	u32 reserved5[2];
> +	u64 start_va;
> +	u64 length;
> +	u32 reserved6[8];
> +}; /* HW DATA */
> +
> +static inline u32 mana_ib_fmr_header_offset(u32 num_ptes)
> +{
> +	/* the header is located after the PTEs and aligned to mst entry */
> +	return ALIGN(sizeof(u64) * num_ptes, sizeof(struct mana_fmr_mst_entry));
                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^

[Severity: Low]
Is it safe to use ALIGN() with a structure size in mana_ib_fmr_header_offse=
t?

The ALIGN(x, a) macro strictly requires the alignment argument 'a' to be a
power of two in order to perform its bitwise masking logic correctly.

While sizeof(struct mana_fmr_mst_entry) currently evaluates to exactly 64 b=
ytes
and works properly, using a structure's total size for alignment bounds is
brittle. If a developer later modifies the hardware structure in a way that=
 its
size is no longer a power of two, the ALIGN() macro will compile without er=
ror
but produce silently corrupted mathematical results at runtime.

Could a constant macro defining the expected power-of-two alignment boundar=
y be
used here instead?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D1
