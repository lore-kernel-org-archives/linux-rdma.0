Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAE12D0602;
	Thu, 30 Jul 2026 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785431946; cv=none; b=mlAxaUqWJg7URrFMmYvLM92avCkFVwi0Dw13ZFpwEtg/ko8Rrp7zDMO57tcrgS1M3cjwzym2Pxte4K0v0M58cDL29SJ21kLbXWDinS70w1O0YAkat9RB/Mv0+Hlde6ebjZjlaeF0MtFHC24qwLpTQRfnfdeUhN1QD3e0q3o5GlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785431946; c=relaxed/simple;
	bh=neQz36Gu0ofyMWD17vfJYRvyyr/Ggr+5GId4RbIsZK4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oK+ZxVM6xXdKD2QuUJ/dYe9iOY1n3sgJVpj/KQDRr8MSRBKt5PoYeVk5+iZfBagrdePUH0KIov9cMYtUFRbD/HBHujC3YdJvPl8zah1zHYI5oGSEbiRFW/ZTsabmLdm9wqeyBStjsIBlBj32SJA6EV/d1AS5Ow5IGhjlB6EX8pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9aMGxbp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9aMGxbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915481F000E9;
	Thu, 30 Jul 2026 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785431945;
	bh=KrXms9/rXOAC06izuiNE+4c2tWkvjh8QP+bSVZkdQk8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=c9aMGxbpecvKqtW6HLcRhWO/6GiqdL4mB+1K2dwcPjRmxi6r3SDDdElW1S5Yz4lJl
	 vSFj4H1z8AG8/m25dCzvnB8zusBdvPrjto0PsIoXIcgHNt7So/+VvilRrE6BWTFDr2
	 txqX08PqqnudxN3xFvi0o5izGsXGFdGcsoB8ccOuV74i5s3XIj9A481gpb99WgLrEU
	 gT/91snSODE6ZehcQbsgQJHEWJ44LOeA3r0Zx8r8c5RyJqeofxzNnypTACaK+j7UvH
	 NaoHKW0WiFvPHk0D2tM0rITI/UK7vsaiv6mO1ywVlsiNkRH2m4ODxwwC5HOn/PqYCw
	 xyFRRUCougtLg==
Message-ID: <9a131b7a83c72122699ec5d41010b9ba5db08b34.camel@kernel.org>
Subject: Re: [PATCH net-next v2] rds: synchronize info callbacks with module
 unload
From: Allison Henderson <achender@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>, Chengfeng Ye <nicoyip.dev@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman
 <horms@kernel.org>, Santosh Shilimkar <santosh.shilimkar@oracle.com>,
 Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Dan Carpenter
 <error27@gmail.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date: Thu, 30 Jul 2026 10:19:03 -0700
In-Reply-To: <c4fb41a2-4859-4f91-b65b-b1ca036185ed@redhat.com>
References: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
	 <20260727174826.135662-1-nicoyip.dev@gmail.com>
	 <c4fb41a2-4859-4f91-b65b-b1ca036185ed@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-07-30 at 11:55 +0200, Paolo Abeni wrote:
> On 7/27/26 7:48 PM, Chengfeng Ye wrote:
> > rds_info_getsockopt() reads a callback from rds_info_funcs and invokes =
it
> > without protecting the callback's lifetime.  Transport modules register
> > functions stored in this array.  For example, rds_tcp.ko registers
> > rds_tcp_tc_info() for RDS_INFO_TCP_SOCKETS.
> >=20
> > This permits the following interleaving:
> >=20
> >   CPU0                             CPU1
> >   rds_info_getsockopt()
> >     func =3D rds_tcp_tc_info
> >                                    rmmod rds_tcp
> >                                      rds_tcp_exit()
> >                                        rds_info_deregister_func()
> >                                          rds_info_funcs[offset] =3D NUL=
L
> >                                      free rds_tcp module text
> >     func()
> >=20
> > The reader can therefore branch to an address in unloaded module text.
> >=20
> > Protect callback invocation with SRCU.  Enter the SRCU read-side critic=
al
> > section before loading the callback and leave it only after the callbac=
k
> > returns.  Clear the callback with release semantics and call
> > synchronize_srcu() before deregistration returns, preventing module unl=
oad
> > from freeing its text while an old reader is still executing it.  SRCU =
is
> > required because callbacks such as RDS_INFO_COUNTERS can sleep.
> >=20
> > Keep the callback array unannotated and use acquire and release operati=
ons
> > for publication so sparse does not have to apply __rcu through the
> > function-pointer typedef.  Replace the two callback-slot BUG_ON() check=
s
> > with WARN_ON_ONCE() and return without changing the slot on mismatch.
> >=20
> > Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
> > Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.d=
ev@gmail.com/
> > Suggested-by: Allison Henderson <achender@kernel.org>
> > Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> @Alison: I understand you prefer this on net-next, and I'm fine with
> such target, but the current guidance for net-next patches is no fixes
> tag unless the buggy code is on net-next only.
>=20
> I'm going to strip the fixes tag while applying this one.
>=20
> Thanks,
>=20
> Paolo
>=20
I see, sure that would be fine.  Thank you!

Allison
