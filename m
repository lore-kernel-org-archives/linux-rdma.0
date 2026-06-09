Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48DB3DA7E4;
	Tue,  9 Jun 2026 08:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780994132; cv=none; b=I3ikqX+KZZOc1ZP3Ha1Rbkl3vZbUpOW0TmiSV/UuNvbE7n+X6QMb5RhnSVbxdrDivOc8Rsr7a1ioBpcor7MYd0IJva/bfchqMUfnl7LhqRBvVzTYxS/WasRLUstvDkQMvJJnXWkRJCoIdEtH/IACooKbNYI6IKojecUNkP2p8bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780994132; c=relaxed/simple;
	bh=agHnnU9pxUfbwrePYbJNMunKdBqGz368Z9XAbZsask4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnvrM4E+dLgHeoooi2F4gAN2FHzNJgqdCeuzf4nsQ67Yi0nCe5DRPQpEibSilD7Z/zrNDYNWJ7rsIW5ms6EnADJ4uzcCYYCXKCEIVKhJ3AW1vNoS6mD7CY1oZ1OKfpzNI30AOgBCkixbc9fm4uvcqOHjUtdLgfijvJiiAOrGYx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=GuEOd586; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="GuEOd586"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HVShz77o7wtiDPwSoSBqcYOrnx+LuabrEFbxqB2rCyk=; b=GuEOd586MOgUxpL7ndJ6NJ8ZHY
	0NDprxVRKDpAUayWzwHf1UHgVNm9lEW2IGNgGrkQvqqNK5jaoLFspoYwjMeqgrzhPTtoWUm5qrgHP
	s0GAiCS9NE8f/XKmHDnp06xf6n8+dpVi+o9qXjzEjWj3OxNrRIRGBiUp5Wt6zPYtd1hjj2xwuVlLq
	DU1ho0nOc9EJffBglfk650iolPOBUslopjNWnXHd9/xqD0k9cb1a6IO3RZ84JuN+o/Zm4oKLKyXzY
	BbYOhDhJ15Yc3Ql8DKr/qDyzcUICHWYa7V8KOiml9nJ+Vtu/oUgIgzns5jcNOvS8rc5bwKeX4H3RP
	X2kYT0nQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWrvZ-008H75-1G;
	Tue, 09 Jun 2026 08:35:17 +0000
Date: Tue, 9 Jun 2026 01:35:11 -0700
From: Breno Leitao <leitao@debian.org>
To: Allison Henderson <achender@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Andy Grover <andy.grover@oracle.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net] rds: mark snapshot pages dirty in
 rds_info_getsockopt()
Message-ID: <aifP4O6jAMEKLJM-@gmail.com>
References: <20260608-rds_fix-v1-1-006c88543408@debian.org>
 <7f310d00c39da9edf0019c130d346ce30107fd29.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f310d00c39da9edf0019c130d346ce30107fd29.camel@kernel.org>
X-Debian-User: leitao

On Tue, Jun 09, 2026 at 01:02:00AM -0700, Allison Henderson wrote:
> On Mon, 2026-06-08 at 02:32 -0700, Breno Leitao wrote:
> > rds_info_getsockopt() pins the destination user pages with FOLL_WRITE and
> > the RDS_INFO_* producers memcpy the snapshot into them through
> > kmap_atomic(). Because that copy goes through the kernel direct map, the
> > dirty bit on the user PTE is never set, so unpin_user_pages() releases the
> > pages without marking them dirty. A file-backed destination page can then
> > be reclaimed without writeback, silently discarding the copied data.
> > 
> > Use unpin_user_pages_dirty_lock() with make_dirty=true so the modified
> > pages are marked dirty before they are unpinned.
> > 
> > Fixes: a8c879a7ee98 ("RDS: Info and stats")
> > Signed-off-by: Breno Leitao <leitao@debian.org>
>
> Hi Breno,
> 
> Thanks for adding the Fixes tag. One thing though: now that this is
> standalone, it collides with "[PATCH net-next v3 2/2] rds: convert to
> getsockopt_iter" since both rewrite the same unpin in the out: block of
> rds_info_getsockopt().  
> 
> Easiest on everyone is to just keep it folded into the net-next series as
> a three-patch set, rather than splitting the fix out to net.

I got from the maintainers that they want to continue to split the fixes
into net and non fixes (features) into net-next.

	"So just prepare for net with Fixes tags and we'll route the
	patches accordingly." -- Jakub

https://lore.kernel.org/all/20260527155942.45c43c8d@kernel.org/

Thanks for the review,
--breno
