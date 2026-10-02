Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A5A3F4DEE;
	Fri,  2 Oct 2026 19:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790969824; cv=none; b=oIbzoBdgcg3a8PmSmICPv2sLdkKrNh0j3t2YrQyoKO5yGaWdyKxZ0cx7V43c4bsa+wzBkwvIFOAI4ZZZiIjDgovzV4MtYSIQH8Ocs7/AW4EVApN5mvVq5Z+nz89CpgjegQ9Xs1fq8gy73+z/7xsw5va+LG6Woengfr4CNWz+foQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790969824; c=relaxed/simple;
	bh=DAKI7BHuuq3bXWjjNhdB2Dyd9wRb/iHwYCrTVD9HS5M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J40YYCU1Pjy7oe9oyx0l8rRsnerHq+Mete3KEh4sUYsUuAsvwk937oxx2u4JcOk5UjFEVhuLbNYBLZhNF9s0slZR5N50YhWtnMEki2mbOL8fVW/wvKow3OGm5ETOnefeFVoYspizB4IwL/87+lCk0nZdjAAClOmLNfH4b59n2aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKgekKtU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKgekKtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D078B1F00893;
	Fri,  2 Oct 2026 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790969821;
	bh=q+c3gF5ij9EgHarX8BeJn+sMUo0v2+fKvqpGTz+Pz7A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QKgekKtU+PGT/iK96g7o8q1wsC+ixT8dNYNZiCDj7AEc9dc6Bb9X5LR/dGrRmZzBa
	 MTgi0k7fwmDpz69sKXiA+q55W390aITIzH0WHjjcLp/+bVgcR5VePrD+YvsWqgWgfw
	 cuHHNnmVBcKJpYrbQpPUgMpVPqdDkIVKTZQXIqnsanVy+yGb5hvhoudLuSC8jIOLPf
	 2DSzQavevUxOErxyddg2JCVdRcgMZW9WQ7gJhhbJzhjZCMNeYmhfSfcGkaKEa34+Hm
	 p0KVpAlWvPg1Ma4LeByinNqzBPF7dVXLrqjKgXGT2WTXKdX58O/OZ1uBm40pcFx9mt
	 eYiNLFrjBqn5w==
Date: Fri, 2 Oct 2026 12:37:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net-next v7 00/12] net/rds: make connection lifetime
 reference-counted
Message-ID: <20261002123700.48b9540a@kernel.org>
In-Reply-To: <20260927061448.167862-1-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 26 Sep 2026 23:14:36 -0700 Allison Henderson wrote:
> This is v7 of the connection-lifetime set (v1 at [1], v2 at [2],
> v3 at [3], v4 at [6], v5 at [7], v6 at [8]), following
> "net/rds: own the fastpath locks across connection teardown", which is
> in net-next.  It is targeted at net-next: although the series fixes
> real use-after-frees (one syzbot report and one report from Chengfeng
> Ye below), it does so by reworking connection lifetime rather than
> patching the individual crash sites, and that rework is too invasive
> for net.

More changes coming / planned or is this good enough?
