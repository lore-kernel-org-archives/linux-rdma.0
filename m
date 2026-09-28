Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2742847A884;
	Mon, 28 Sep 2026 09:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589458; cv=none; b=oa+euxkTP08CB9Y0FsfW5wzTmJk797SfB868lF+WUlMn2J9UIcMBS8RdFczsQOgn0zII/cOPKOlDXpX1G68565o3SyQWVzeElvWdVGht7gAzyeMXYb6Ura5LGl/sk3qlVZGqwEZc46wiM4QKZiuk1/Pful/DLqm/IgupWjPPmXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589458; c=relaxed/simple;
	bh=28QXE5eRbecjMOrfo9K8OHTMgEsYVlyQEhzcYtmFdJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkJG+qZZDISTW6Q+2gq0A0ZjXvlXFF8J89Ph+HgrDFkXqziYv2uEaYmU/6ytWJna5iMGGTCAskRndJZZCWN/V/UGCs8BuWJjp5kHLWZN/jQqUpbn2LasBSVD4kPScG3kT9Wesy2UkLoCqkOYJ6pr+bkMosEHwR4sXFrygDoVyz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AcoJIf7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AcoJIf7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716C91F00893;
	Mon, 28 Sep 2026 09:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790589456;
	bh=7L5GmVZDyFL/gZtQ52Ve5myc7vLizYko5g7v5Vt9CFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AcoJIf7OlqGIrIDsz2q0aPRN64OZ+Jre+ccTLAq6QN5UI4kCpfL5ul6tChtZ1tinV
	 VdYx9goDPci6CmtgkKoPMdYk1dMu6OM3o0bIXKKsn4BWwSnUG9QR9k1aG6KepwsDwt
	 yc5C117LcpiJ8E1rxMvId9fKGRai5CgHjZCGwyZqWlV9KSEt3zy3ool3ns2z8x0yMb
	 gPZc+RCsnJEa1cYp8H+luv6P/xKqF57dkhjlE6lt/Owx+LVOQF5HIzkyPbmU0Qd6bV
	 SUVpfCwtjwydIgnBKAxhIk+ex3Hr+LpPm2VDlFjGPJO5BklfiAzMFQqt8Oi3csprrA
	 XjSGT2jYautBQ==
Date: Mon, 28 Sep 2026 10:57:33 +0100
From: Simon Horman <horms@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev-bot+sashiko@kernel.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	kuba@kernel.org
Subject: Re: [PATCH net-next v3] net/rds: restrict the rdma_cm ids to IB
 devices
Message-ID: <20260928095733.GN13925@horms.kernel.org>
References: <20260922084837.390414-1-achender@kernel.org>
 <179033694505.2160803.10055619633105856141@kernel.org>
 <20260927111140.GG13925@horms.kernel.org>
 <5ee7e43c998eaaa75d630b077a77aef3721298c9.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ee7e43c998eaaa75d630b077a77aef3721298c9.camel@kernel.org>

On Sun, Sep 27, 2026 at 09:38:47PM -0700, Allison Henderson wrote:
> On Sun, 2026-09-27 at 12:11 +0100, Simon Horman wrote:
> > On Fri, Sep 25, 2026 at 11:49:05AM +0000, netdev-bot+sashiko@kernel.org wrote:

...

> > In all, this patch looks good to me.
> > 
> > Reviewed-by: Simon Horman <horms@kernel.org>
> > 
> Thank you!  I'll carry your rvb on patch 1 of v4 unless you'd
> rather look at it again.

Thanks feel free to cary the rvb.
