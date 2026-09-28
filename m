Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EB34D17B9
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790603772; cv=none; b=SxufM36m3MZoH0yiBsVXatdj/aexzVAcZg1msFtVY/mwEzQnrsrKJsI4upElouhA+IGPzfyDd5xLwycniIhWCOP5I5c0BSEgF5EypErAvhbpERbVtP6+5BKM8VM405Iuv++DFn5WlM7XECasPD6fzM97tCrPhPSQT2ISSJla7Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790603772; c=relaxed/simple;
	bh=QjZkkPdl41YGXoFYa2yNKjbOR2SHcrDWC1IcRrLMu9U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ixILW/WQvDGGgT0/QkgQ9j01AHYM+rN6hLFkBkdLODELQGcRm6j5ZWovox7lFvUQQDJZ9iN0Z0EzBWtpJkTNsdGqwDHr/hX+QjfJsjEgdWtlUnGMOB8v07LGFD9zkMuEo+459woN1X1flpuI0Q5gqhv40OzDNJOFpMKHa6XzIBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+HOIot7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+HOIot7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD0E1F000FF;
	Mon, 28 Sep 2026 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790603770;
	bh=QjZkkPdl41YGXoFYa2yNKjbOR2SHcrDWC1IcRrLMu9U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m+HOIot7KuomRJSvh8Mw7K40gx4pMEran5Ydvpwypxi/giVtKl2+UEWGJXL0/qz3m
	 d/HYZRuINX1BXoJ9rBDqBwPjmXM7Rr+QdOO52B6bnGf28YCAbH5eUDl26xASXDLQra
	 ony/y9ii62emsHu3//jm/XfDWIrvblhwmdRLsAhGhUpbqjJEC1+aTPM3/lnPlafD67
	 GGxlTikqWiAE7KEypBAalrhrNAhUuSl6CftzvZINoh5Fd5leAsBO+erkUEOUvodMQE
	 8ofxA4eFIJXXfvkwU+Z088BGtXRoc8+kg/IdhGi3IDXQFkyKx9Gzr9ONMEBe+C9WFg
	 bd0yBJryqzfig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hongyan Xu" <getshell@seu.edu.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928134148.977-1-getshell@seu.edu.cn>
References: <20260928134148.977-1-getshell@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 13:56:10 +0000
Message-Id: <20260928135610.BDD0E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The SDMA state reference and completion cover the software cleanup
> tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
> flush_worker. Queued instances can therefore access an SDMA engine after
> per_sdma is released.
>=20
> After the state machine has stopped, cancel err_halt_worker first
> because it can publish the hardware cleanup tasklet. Then kill that
> tasklet and drain the remaining flush work.
>=20
> Fixes: 7724105686e7 ("IB/hfi1: add driver files")
> Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928134148.977-=
1-getshell@seu.edu.cn?part=3D1

