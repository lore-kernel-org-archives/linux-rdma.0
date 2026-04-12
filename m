Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ABC1E1A17
	for <linux-rdma@vger.kernel.org>; Sun, 12 Apr 2026 14:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776003285; cv=none; b=h9s1GCq9YcZJ5KupfhgGJvc0h0qrU9rbgzUA+VzsZxbrEq7W236jweqhT9Q2h+PRHNIbIVREjlSAQK0HG6D512c4R+eRS5iL2nw8HHxoQYRc1OaxH3Do8ZGykB5ebRc8x0QMa3iiMv1/XMlecI5d867rjDC2XMh92B5p+3D2GFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776003285; c=relaxed/simple;
	bh=Xe13EkcrIIFL3m0G8drldzooM0xthoen4TETUIqWIlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KorWUlejjH7Gz4yxr/CH/PY3ol418Krp88QcdUw3sIPylzf1zjgfcd3/AEf8Ao8F4gukAo3a7MkY1tZx5niTU6Kvvd/d/+Mc6rW0pystSfS9XEllkTVbVcp94JGDhzVMgMMtwMufg7J65evKdHd//c8fLoq38HSbChjKpOIx0qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsH4CD7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsH4CD7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53E4C19424;
	Sun, 12 Apr 2026 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776003285;
	bh=Xe13EkcrIIFL3m0G8drldzooM0xthoen4TETUIqWIlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NsH4CD7wOXM9MhKdouVA2zUzSluH8llhxPoR+21cU0/1BDO43j7rlFeq+QPiC0dPd
	 OEMKBuJ8RAN3y0uyNsMn+/OmFY39gNd0/gTnwiQjeU5AVpNBVUCreDdPWhDJ8CatcN
	 ZaZUrKFVPJ+hGegxTl0EEWnlkp3mItur6jByUZaIgXkSTM5ioA9jvwAyZaM7SGTyTw
	 6khsUfOKFhOmHvU8BQ16vdhTSYDWUIEQwoDYLR5kwxuqjwGqMLXILzRSneGJWtaIfd
	 g83+3uCQDdsp1xAbsjkaQNLUrk5+lg7dzQLSdKUq54VU50CSrIGnAtBBmuo3RPJ9Y7
	 RT8npAS5HzwWw==
Date: Sun, 12 Apr 2026 17:14:39 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Petr Vorel <pvorel@suse.cz>
Cc: Andrea Cervesato <andrea.cervesato@suse.de>,
	Linux Test Project <ltp@lists.linux.it>,
	Eric Biggers <ebiggers3@gmail.com>,
	Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: Re: [LTP] [PATCH 2/2] device-drivers/rdma: Add ucma_uaf01 test
Message-ID: <20260412141439.GD21470@unreal>
References: <20260325-infiniband_rdma-v1-0-9c1bd3e69d29@suse.com>
 <20260325-infiniband_rdma-v1-2-9c1bd3e69d29@suse.com>
 <20260407132426.GC25645@pevik>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260407132426.GC25645@pevik>

On Tue, Apr 07, 2026 at 03:24:26PM +0200, Petr Vorel wrote:
> Hi Andrea,
> 
> it's been long time since this use-after-free was fixed, but IMHO still useful
> to have a test (it's also kind of smoke test for rdma_cm).
> Anyway, LGTM, but it'd be nice to reproduce the bug.
> 
> Reviewed-by: Petr Vorel <pvorel@suse.cz>
> 
> > Test for use-after-free in RDMA UCMA triggered by racing CREATE_ID,
> > BIND_IP, and LISTEN operations. Three threads concurrently issue
> > these commands to /dev/infiniband/rdma_cm and the test checks for
> > kernel taint (KASAN use-after-free detection).
> 
> > The bug was fixed by kernel commit 5fe23f262e05
> > ("ucma: fix a use-after-free in ucma_resolve_ip()").
> 
> > Signed-off-by: Andrea Cervesato <andrea.cervesato@suse.com>
> > ---
> >  runtest/kernel_misc                               |   1 +
> >  testcases/kernel/device-drivers/Makefile          |   1 +
> >  testcases/kernel/device-drivers/rdma/.gitignore   |   1 +
> >  testcases/kernel/device-drivers/rdma/Makefile     |   7 +
> >  testcases/kernel/device-drivers/rdma/ucma_uaf01.c | 208 ++++++++++++++++++++++
> >  5 files changed, 218 insertions(+)

<...>

> > +static struct tst_test test = {
> > +	.test_all = run,
> > +	.setup = setup,
> > +	.cleanup = cleanup,
> > +	.runtime = 300,
> > +	.needs_root = 1,
> > +	.taint_check = TST_TAINT_W | TST_TAINT_D,
> > +	.needs_kconfigs = (const char *[]) {
> > +		"CONFIG_INFINIBAND",
> > +		"CONFIG_INFINIBAND_USER_ACCESS",

I’m not familiar with the LTP tests, but I wanted to point out that these
config options are insufficient. You need an actual or virtual RDMA device
connected to rdma-cm for the tests to work correctly.

Thanks
