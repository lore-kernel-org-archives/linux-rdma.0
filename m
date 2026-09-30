Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05C03B1016
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792211; cv=none; b=GlqSXyfQURaktyTnUjN6GY6E8H0Jbt0yUk3UQzR/RJEnW9e406phI6On/KtH3a8HtZ6QH624AirwDrQYWnZgOl6mqhOffy5dKVTFZz84j6aygegNJ3AEdOVhZ1knO+i7Pqk1hdHR8ZwfAqkCn1dnZ8QyFUP2q8WookcFSXWNiqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792211; c=relaxed/simple;
	bh=+wghNkjjXN56QZW331LCvIribbRObHKpdGu4/f258BQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mxYbTL5DcWXYa7rHULWEhDyW4AMpnqMPhi2o0juTnpkSGUFyH5ln5GJBmWDnOWGoO09V8ttj8h75fePBh2tEfNUdMkiUNdEWDGh3WDhCwlk5AOLu+VjAU2PIEwCap9Y9KlW1DPP6lf3NZ/POleRjkHnfkYz5Ycs1IvCaT2SJEwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsA3owSH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsA3owSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B7B1F000FF;
	Wed, 30 Sep 2026 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790792210;
	bh=+wghNkjjXN56QZW331LCvIribbRObHKpdGu4/f258BQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MsA3owSHbnncK2kWWbKhQiOFJq89kPrDLCmdBObdt0kHYoygD9jdTOfJU+WE4/m1Z
	 TwJcoH4fh2A+3xKkQcOFZTLX8LjOU9yWkMkKV7pgbuSg3jnaf7R0r1nD2s3oCEv6n6
	 9bT+qpfNPI08dQqIvCgr3AVSNLsq1ONPT8ExSutHmZIasGg67cPu+HsaFGYjRwvgJR
	 rmqolkZ17BaqQdvS1mSIl6J0EQl9WSuZcx73UEvpZg2up7cLGLBRVCHVL5lU7ueofh
	 WyTunMHuWQZ2d6rdQEuU6v6G4MHLgOurAY3JOMvZufhdlycqZUac+4JUW8QDkDRgwR
	 P8uVwmLiEO4QQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: bound the WQE opcode before indexing
 rxe_wr_opcode_info[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930180221.2497908-1-ays511.kr@gmail.com>
References: <20260930180221.2497908-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 18:16:49 +0000
Message-Id: <20260930181650.69B7B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with
> a caller-supplied opcode and no bounds check. For a user QP the WQE
> comes from an mmap'd SQ ring, so wqe->wr.opcode is an
> attacker-controlled __u32 read back by the requester
> (req_next_wqe() -> rxe_requester()); rxe_post_send() takes the
> qp->is_user branch and never runs validate_send_wr(), whose only
> opcode check is itself !wr_opcode_mask() (it indexes before it
> checks). rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR,
> so an out-of-range opcode reads out of bounds and the result is used
> as a mask and dereferenced; observed as a KASAN global-out-of-bounds
> "Read of size 4" and a wild-pointer oops.
>=20
> Return a zero mask for an out-of-range opcode, matching how
> validate_send_wr() already treats a zero mask (an invalid WR), so no
> path indexes the array out of bounds.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930180221.2497=
908-1-ays511.kr@gmail.com?part=3D1

