Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F873655D9;
	Tue,  9 Jun 2026 16:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781021064; cv=none; b=tD8rSHOwoFaKq7COLDbWxnQskbw+0ghMnJD5nJ7jZT/OxQqDPz+XNn+qqVfzBS8iaKHstxM2Fjat8OpIGH71+sZxG1Gg/dFMrm3+Y6XuDQC4lB7Ym2WU/My9gEBENhyRwdHBI2ys270obESjIYlbP5u+CYVzJxNIOmmJ1s6w+3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781021064; c=relaxed/simple;
	bh=Htzjj+iBxZJDahLFAtt5wUwFAw1m+LlXlt/Fld8Ch1s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BLXLYxR9coYdyiho8WjAowcF6pBL62vtG5554rSYJsC+XUJJK3NVGcZYNQDXRBnJSzkShpxrn0Oy3xYPZfYXzF+TQENMROwvvvxzSYcx8WFc8MmNseKlDxbf05fSalHwOz3eNVufsEi+anh2onyZVWWFTcC5NnMrCfo6tRPCCDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nx7jxR2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nx7jxR2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C221F00893;
	Tue,  9 Jun 2026 16:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781021063;
	bh=t2wgkGNVfpS9fL7oWSyTipxzTFvk2mjVXvIgDz41TnE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Nx7jxR2IcaFDLN6VVikQBBdq4Q7JN6orMYlKhnIE3twN4qQmONXvaLb1rQKoGNtSy
	 ej8B8kqjtFPXJcUhAm/iGM3T1mxaA2qqafPyhH4QHHv0mLnK32shnTTD78002b781/
	 NccF8NiH1L4C+Hmjpd7P+lUBrLfZZV+yRuHOHoVTnBVYYf8FH/LhvnabGsSMUnezHJ
	 IHlJ4n8GNSiVdAmDnzc2KJDpADb9ITOKpOyj0isUeLrl85TLhbkqpq1TGfRztddrl9
	 rEamIZeC/LR6u9HAQzUoqgDO227C8TGk+62GTSC5Ob4VTzBKzBbhOw512FGcC2/4Mp
	 6vndQb6g++Oig==
Message-ID: <c68c873bf021ca2f64b582e337694c5a01871acd.camel@kernel.org>
Subject: Re: [PATCH net] rds: mark snapshot pages dirty in
 rds_info_getsockopt()
From: Allison Henderson <achender@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Andy Grover
 <andy.grover@oracle.com>,  netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Date: Tue, 09 Jun 2026 09:04:21 -0700
In-Reply-To: <aifP4O6jAMEKLJM-@gmail.com>
References: <20260608-rds_fix-v1-1-006c88543408@debian.org>
	 <7f310d00c39da9edf0019c130d346ce30107fd29.camel@kernel.org>
	 <aifP4O6jAMEKLJM-@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-06-09 at 01:35 -0700, Breno Leitao wrote:
> On Tue, Jun 09, 2026 at 01:02:00AM -0700, Allison Henderson wrote:
> > On Mon, 2026-06-08 at 02:32 -0700, Breno Leitao wrote:
> > > rds_info_getsockopt() pins the destination user pages with FOLL_WRITE=
 and
> > > the RDS_INFO_* producers memcpy the snapshot into them through
> > > kmap_atomic(). Because that copy goes through the kernel direct map, =
the
> > > dirty bit on the user PTE is never set, so unpin_user_pages() release=
s the
> > > pages without marking them dirty. A file-backed destination page can =
then
> > > be reclaimed without writeback, silently discarding the copied data.
> > >=20
> > > Use unpin_user_pages_dirty_lock() with make_dirty=3Dtrue so the modif=
ied
> > > pages are marked dirty before they are unpinned.
> > >=20
> > > Fixes: a8c879a7ee98 ("RDS: Info and stats")
> > > Signed-off-by: Breno Leitao <leitao@debian.org>
> >=20
> > Hi Breno,
> >=20
> > Thanks for adding the Fixes tag. One thing though: now that this is
> > standalone, it collides with "[PATCH net-next v3 2/2] rds: convert to
> > getsockopt_iter" since both rewrite the same unpin in the out: block of
> > rds_info_getsockopt(). =20
> >=20
> > Easiest on everyone is to just keep it folded into the net-next series =
as
> > a three-patch set, rather than splitting the fix out to net.
>=20
> I got from the maintainers that they want to continue to split the fixes
> into net and non fixes (features) into net-next.
>=20
> 	"So just prepare for net with Fixes tags and we'll route the
> 	patches accordingly." -- Jakub
>=20
> https://lore.kernel.org/all/20260527155942.45c43c8d@kernel.org/
>=20
> Thanks for the review,
> --breno

I see, ok it's fine to apply my rvb then.

Thanks for working on this,
Allison

