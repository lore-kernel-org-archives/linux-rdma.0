Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0755A4534AE;
	Fri, 16 Oct 2026 23:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792192506; cv=none; b=ZGbXEO+7wOnN+w8vJ1V7iAxMSHSjkKuxV26mGaAhTw1v2fV86O85PbT64RfT2umicJQ8ZjOmVv5/PlM1XrQ9dDGHYF3ON3KKDcO5y/AD0yw69VvMPFsH3MfxB1Gj5EclBnPpIeB9JVK8HKgwK5hYazvR6ZJqb3hxFiov27XfE+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792192506; c=relaxed/simple;
	bh=z0jTt/qpJ5LHHzEc+/gxqHCYJjqXkIQvM8/yWCAearE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKZpPzulkJbDer6QwZulZ1KbARaKS5Cts+SA7MRqKf2osNQnL7XD226rb30gOVmEmlK8TuiJwR4YbCmggDxjGHV17EzQM++hdLy/sIV29Skz3PuNe6eRwVsPdlv5gXDv+MH40S9LS4hfncgbs/sh5Sk4yZ3brYCYFAprnvug8uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NTT3Zqfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NTT3Zqfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCCB1F000C4;
	Fri, 16 Oct 2026 23:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792192504;
	bh=3PYRtgMdOpfgR8IOc/kOR0s+40t1qQwyRO2AFpMHf7A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NTT3Zqfb7dc/5FfGKJbzJbkGSBYsqAFasiSW+s3zwDBl0xG7W2pdixIsYgY8o7X5c
	 xaLstpmm6PNAsCDinphxrnjDq5ZkPZZVVWM+XTvRUhWU0RrVhDinxRg7AuishOaY3R
	 USPJUvrlpgvctdleXaW5KqdCDCfsTgdvj595Zg8HDj8hZ29L4rSP7QPCuxX5UW6FCB
	 q8JnDOffSSb6yzG5Mj0N61/TtPJ0Y3SyTg3wB6ukavuzUeWoSd4Dk/yYYv9L3Md7kB
	 7KegaJ5+THO5LutC35Z6eBLQXae9tg+qoYPH9ycRPnx1B1K8NZJSSESd9Njg1UPop7
	 UZnt8s4AtVX+g==
Date: Fri, 16 Oct 2026 16:15:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net-next v9 00/13] net/rds: make connection lifetime
 reference-counted
Message-ID: <20261016161504.1085ed5d@kernel.org>
In-Reply-To: <d149a5b9f088994e5e98db7223b82040a302c0e9.camel@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
	<20261016160503.1f1b807d@kernel.org>
	<d149a5b9f088994e5e98db7223b82040a302c0e9.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Oct 2026 16:07:55 -0700 Allison Henderson wrote:
> On Fri, 2026-10-16 at 16:05 -0700, Jakub Kicinski wrote:
> > On Wed,  7 Oct 2026 20:13:20 -0700 Allison Henderson wrote: =20
> > > This is v9 of the connection-lifetime set (v1 at [1], v2 at [2],
> > > v3 at [3], v4 at [6], v5 at [7], v6 at [8], v7 at [9], v8 at [10]),
> > > following
> > > "net/rds: own the fastpath locks across connection teardown" =20
> >=20
> > Patch 12 fails to apply now, sorry about the extra long processing
> > delay. =20
> No worries, I've been tied up with a lot of extra work myself. =C2=A0
> I'll come back and rebase tonight or tomorrow.  Thanks!=20

I also dropped the small series for net.
Is the Medium severity concern there not worth worrying about?
If so - I'd apply that to net-next, LMK if you _really_ want
that in net.
