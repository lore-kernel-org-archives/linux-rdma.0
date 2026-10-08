Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B13346A10;
	Thu,  8 Oct 2026 09:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791450061; cv=none; b=hLk7Qwzs3aUPJVcXWW8RXQFZLttmGsi8JLLXGzdMhYnkxmUe3ffJtUGZLtwxgE6+t9+QHiOLtap7pgG41ZOohsi02uQh1kJK/t4snjJOO24nbnBt5o/+qdsNu4IBGKtzAXtmaX1v8zHLGPm0g2BLq6GK1h7NVqqKWYt9Jq6ZYX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791450061; c=relaxed/simple;
	bh=fiPOko5axzbNPMZSyd6kcaiqWm1IJ9m4U3k0VA9KM20=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LBem4OckTPq5XTPe5jQO817mFuvDrymJ87fS33POIrKgLzXFrnWTTyvQGz6VTsPFz02DLFELzpLD6YgL8hKBoMUMdiOiBE4L73frAY1W7BcdjLPWM8ouEomRElHj8UvTTh0d9EiCxrf3iZETbnd7IVN4tZZZ9KNxVUr5782nN1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnSlmtbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnSlmtbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694E11F000FF;
	Thu,  8 Oct 2026 09:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791450059;
	bh=UOQhqHxp1lW0rnZ9bAdlsSSTL82PaKJldrRlul/WI8U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GnSlmtbiVgQaPCZV/kIP9Y8VeAiqURvH5ocBE6R6D79gOGAXgDhWu+syi0VH8Nskj
	 KvtBvdw4pNzyd49CyXqA+LNBGf/MYvLH4dFWPPeW+gv7QMBmvQhxJNXdLk8gSSVQ3Y
	 YzZZVNgWaI6F0uZbW8MzlYb1eAMBexPFJ50o4qPXRFdiiTk18MV+wn1v8QYtyUSs7d
	 RZwBogRVOQJT1EoC3keGueAZRi2B0Ud4OUrh5dsytg9OIHg6vzFH7cPrAf14nNZcbD
	 ah0pF70H0KvXPWAOJGdERdNrttjrcJ/XhSwSrAOZ25ccip9fnY2cLAg9ikoodshyFx
	 Pqnpkp4SV5W7w==
Message-ID: <sashiko-outbox-163874@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3] net/smc: protect clcsock lifetime in smc_getname
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261008084444.787449-1-nicoyip.dev@gmail.com>
References: <20261008084444.787449-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 09:00:59 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> smc_getname() dereferences smc->clcsock without holding
> clcsock_release_lock. Link-group termination can release the CLC socket
> through smc_close_active_abort() while the SMC socket is still open,
> for example after shutdown(SHUT_WR).
>=20
> A getsockname() caller can load smc->clcsock, then the termination worker
> can clear the pointer and call sock_release() before the caller accesses
> clcsock->ops or invokes getname(). This causes a use-after-free; if the
> worker clears the pointer before the load, it causes a NULL dereference.
> The syscall's file reference keeps the SMC socket alive but does not
> prevent asynchronous release of its CLC socket.
>=20
> KASAN reported the following with test-only timing instrumentation:
>=20
>   BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
> [ ... ]
>=20
> Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
> Cc: stable@vger.kernel.org
> Assisted-by: GPT-6.1-Sol
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008084444.7874=
49-1-nicoyip.dev@gmail.com?part=3D1

