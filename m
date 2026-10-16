Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E66D26C3BD;
	Fri, 16 Oct 2026 23:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792192078; cv=none; b=DR+d+3QXraI+xBH4urttTrLxX2yq+7uhX6LC0RnhDi0BHSyMLKehyMBHLIn9tLsb95PF3uzWnhZP5c+sJoeWYQOd7tkMQbbSdPvp/8026ywqpdpU+PYMSfzjDekVhj6SGLbbZ0psmNF3qKYMTVIliZNrgcV++x7I5YwaHY149P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792192078; c=relaxed/simple;
	bh=xR2Q/X8rCTuHM8wN6Ix2JCy3WqRzpwjZWl2Y/GAxApo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mmRKJ/vnK9oKRDzypUx5kREVeiix2kXQQnQ2zxeaP92CW1EoN3RrZRS97QUHuuH3KRfyh2yBda2qhUa9Fdy0AtXQPkB0zDOZsb42OxJgi4nJzNDj3u5tKXFeCYcxg5Bmka5VhKcf7rG9LjHO50bMszSxRiWn7iUNOy7nOYwC6dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJDw0PQq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJDw0PQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5F71F000C4;
	Fri, 16 Oct 2026 23:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792192076;
	bh=HkNMLoVatVZ0ME6yiHdcRT6jjH1ChBzW0KS1ujUMMRY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=OJDw0PQqaDOqEoIwpu+wxNRWhAFqDabhmAcVxbE/wG8O6MK1+1cFfVKBvrd0SW2Sh
	 9XVdnhFxEebcGDkuKMP2ZTGVtMxfU3+a3yCkZ12z/EdSHIIudknxgbnSoJ92dxz90g
	 buvEItDaPxnrxqWIfuQnX0atNZJdzMnqceYGa8/ZToy9C7gQ46sYT1Ly0Bzv+JIZk6
	 EiMcNpfmckA/WOAHLSPDEbOoBEWeRNVTjRGcOd8UKwVkRT3ARkhYvh3dD651QpvcWf
	 EZMCID+pHVes0Ak4Sg7VJeeR5WhHNJNqOuRgiR3Sitg/ZF6lgNFHsIzmxV7mQmY6Dc
	 Xssz0/5zJCT4A==
Message-ID: <d149a5b9f088994e5e98db7223b82040a302c0e9.camel@kernel.org>
Subject: Re: [PATCH net-next v9 00/13] net/rds: make connection lifetime
 reference-counted
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, horms@kernel.org
Date: Fri, 16 Oct 2026 16:07:55 -0700
In-Reply-To: <20261016160503.1f1b807d@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
	 <20261016160503.1f1b807d@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-10-16 at 16:05 -0700, Jakub Kicinski wrote:
> On Wed,  7 Oct 2026 20:13:20 -0700 Allison Henderson wrote:
> > This is v9 of the connection-lifetime set (v1 at [1], v2 at [2],
> > v3 at [3], v4 at [6], v5 at [7], v6 at [8], v7 at [9], v8 at [10]),
> > following
> > "net/rds: own the fastpath locks across connection teardown"
>=20
> Patch 12 fails to apply now, sorry about the extra long processing
> delay.
No worries, I've been tied up with a lot of extra work myself. =C2=A0
I'll come back and rebase tonight or tomorrow.  Thanks!=20

Allison
