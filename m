Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E3F29BDBB;
	Sat, 17 Oct 2026 00:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792196720; cv=none; b=kYbtxQ90qIxCtYLjV8A6x9Z+sOuVjxAxLzFxQ4N5Fiw4XPdCdkjrkTVZ2sIl0nffCGemqwUp9f0xhof9cz3vrDzq7ly4lY7fKdkVD/NtF9gZbclztPlhYD36jI8Ax+rVVkNuOrKEhPY4bSlIyKWPCpzFLhmKzFwI82uF09lIxrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792196720; c=relaxed/simple;
	bh=X0xUC7IcQaElOFj2cS1wE2dixERmdc38wrS7CC00i+w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Nl4f/377u2MpFNmhLUpLeIRJruRkNH8WdGgqGvxtD4ALy3w2I+4BOYXWZdP1/4V0t5CMac8j8uLOltZNsZ03pnfW2Gbv9TKiBg9henuMXb9wwTHiFcNRfVXljO51kOe+TIf7HUyby0L4Q7P+0jeTXRFn9M6U7NL5iPMf3Mdu5YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+kTzFfA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+kTzFfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1271F000C5;
	Sat, 17 Oct 2026 00:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792196718;
	bh=VbX8Pc4dh/DxuookKffggUMjVK+IdZelOtr214MiSAc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=W+kTzFfAd2jIWjXWnVp26guFYJfZ+0QTT8NRtowfB6c3gKpwTkpfzmYBXO/crbypN
	 PrLUKV3olffpS3yBMGJ+lSeeEFWJEAy6miuYYlvparxIA4/U7o4gqHOD4GbaqwP5EF
	 rHznpzqS/DcbWOc11caBRWUZxwUW+CJZXf47uvkW9uPB9+a0jsFK3BR55Dkp3+qIiS
	 PFB7eaSOoNXF4xil0TtrmiVhu270GsHx1+S8xD2wWH+CNZ/z+EZpo7tuxLTnoCDdPQ
	 rXyMTtQf5gHcsOJOqCn1F7NUFn+Mr4ny5Xim5O0vUUBHoz6B9aBOmuoAmZlrmqNAyX
	 I/KzjlYALYWHQ==
Message-ID: <141aa388b13663b611520bdaa32376b67f886984.camel@kernel.org>
Subject: Re: [PATCH net-next v9 00/13] net/rds: make connection lifetime
 reference-counted
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, horms@kernel.org
Date: Fri, 16 Oct 2026 17:25:17 -0700
In-Reply-To: <20261016161504.1085ed5d@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
	 <20261016160503.1f1b807d@kernel.org>
	 <d149a5b9f088994e5e98db7223b82040a302c0e9.camel@kernel.org>
	 <20261016161504.1085ed5d@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-10-16 at 16:15 -0700, Jakub Kicinski wrote:
> On Fri, 16 Oct 2026 16:07:55 -0700 Allison Henderson wrote:
> > On Fri, 2026-10-16 at 16:05 -0700, Jakub Kicinski wrote:
> > > On Wed,  7 Oct 2026 20:13:20 -0700 Allison Henderson wrote: =20
> > > > This is v9 of the connection-lifetime set (v1 at [1], v2 at [2],
> > > > v3 at [3], v4 at [6], v5 at [7], v6 at [8], v7 at [9], v8 at [10]),
> > > > following
> > > > "net/rds: own the fastpath locks across connection teardown" =20
> > >=20
> > > Patch 12 fails to apply now, sorry about the extra long processing
> > > delay. =20
> > No worries, I've been tied up with a lot of extra work myself. =C2=A0
> > I'll come back and rebase tonight or tomorrow.  Thanks!=20
>=20
> I also dropped the small series for net.
> Is the Medium severity concern there not worth worrying about?
> If so - I'd apply that to net-next, LMK if you _really_ want
> that in net.
I'll circle back and address the medium review complaint here too.
I think net-next is fine for it, nothing here has been seen in the
field, so I'll tag v5 for net-next.

Thanks!
Allison
