Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A811E1C860C;
	Sat, 22 Aug 2026 05:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787376829; cv=none; b=CqLEJvTVNj+mZVcJB+8aGl2lALYZProw1HwZHT0kevnWWeMmee3Xy808Tyk+sZjgIFkX6M+Dr1kcVtpb2+Lhfhyum+xz8MqeAz2Pn8b4oo6GrY52jbA2bLUvzvek7jMIGot+4Xom2U6uXYYscrrQTRZnx7cSZKVgTFHseqBRwF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787376829; c=relaxed/simple;
	bh=E4V/k8PtNH+IzDd6N+wP5yNIhNIjIe7E9W5u5zqhukA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m0d0uJw8mlSgVqgAglAHu0Nx9uLitGWczDY8HO7Dc/C0kw5JuYn4NkjO/WQ1e7rx6+j2neH0QojbsiByxEvFEa6hl79KZ2WqHJNLFbcxp6huszFZsqfdAj5Hfy1kG9a+ScZJkpoLWtkDGCnappgofBx1nPsO3JJwfTMF6CeusPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WwZBPOsc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WwZBPOsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A491F000E9;
	Sat, 22 Aug 2026 05:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787376828;
	bh=E4V/k8PtNH+IzDd6N+wP5yNIhNIjIe7E9W5u5zqhukA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WwZBPOscPIGXQN9IWPUsAVS1PMMije/Gtt/EB6SvDyB8nWopW0ZDSSOoUJg7Nk+bK
	 FYJtUaACWoW2vjImw+nZUbK0xBV7Dn9OVCN5GOMMPJNsD+y9XwvQaNZQGUbixtsFx1
	 mz0++j3G69ZAcbQNCK9Rh6k7HU8r/xk1r+Hd22oqdi3b6Ig7x92cSq0RhJY9z6FHvz
	 wzVrzYfEdfY4tkNrXpA58S0votKjxIyXH3hMTQsn0W9HHC58wwZC7j9RSO9QjBWC3e
	 uvMcAuoCpcqyieC0P4S/GXhxltgdDwSCvBLxDaMyL0HbY5fBpug87kFfjS5JPnOHnB
	 msHp7ZhupPKKw==
Message-ID: <511c157524504bfe5d53fd739538ccbd0ebba7d4.camel@kernel.org>
Subject: Re: [PATCH net-next v2 0/5] net/rds: own the fastpath locks across
 connection teardown
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
 edumazet@google.com, horms@kernel.org, jhubbard@nvidia.com,
 woni9911@gmail.com,  michal.kubiak@intel.com, leon@kernel.org
Date: Fri, 21 Aug 2026 22:33:46 -0700
In-Reply-To: <20260821170347.77cfaadd@kernel.org>
References: <20260816001510.73645-1-achender@kernel.org>
	 <20260820133832.5384be37@kernel.org>
	 <c3c9a3f2683a37474256b9f879f9ee896d62704c.camel@kernel.org>
	 <20260821170347.77cfaadd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-08-21 at 17:03 -0700, Jakub Kicinski wrote:
> On Thu, 20 Aug 2026 22:07:26 -0700 Allison Henderson wrote:
> > The other commentary nits from the review do have merit though. If you
> > like, I can send a v3 with those corrected, but I think the code itself
> > is ok. The patch 1 comment about cong.c is a pre-existing issue similar
> > to the lost-wakeup issue that patch 1 fixes. So I can send a follow-up
> > converting those waitqueue_active() calls to wq_has_sleeper().
> >=20
> > I hope that helps? Thank you for being accommodating with the branch
> > targeting.
>=20
> Thanks, yes! IIUC you don't mind sending a v3 so let's go with that
> option.

You're welcome, I've sent out an updated v3 and one extra patch for cong.c.

Thanks!
Allison
