Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA732D7814;
	Tue, 21 Jul 2026 12:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784638191; cv=none; b=XqCfd7PIsqzBP4YE/FC0zpJQfHsBXrgzQgW13CYvrNeVVQyBv+ylmD0aQnpVl6ca6msU39JE/lefGyxSBqP+02e+3aszpxgHtF4+yW6q5ash0RIpJ1xwULDOoj4a5iPbIWMFHLJ+3AFtKJqa6Qtl40mdIUpcaFTkEcywrWAJQ20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784638191; c=relaxed/simple;
	bh=SM2l94hiPKVtpXZbgVwuP12xB6LLyvWSd3UUMw1POls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LPCbTn7vhbihCcOYwVegHrmbt9sQpvl0313EapUfQMBfjxAy/3+Au4GDdQUWUTguE749589bJp766ZQYNVazo+IenrCbMbuOeiep63a+SmkOXfOPbiCIBBQhp6Gwr5vfqAC0OdnDBYRPj6+uDyQ0xjzxUU6h7s+5pyiS1W1+P6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okewHL+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okewHL+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73771F000E9;
	Tue, 21 Jul 2026 12:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784638189;
	bh=8dGgGRBOnBqV+dsZYwekjiT3b3Pykl1Pm0cR51M/NkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=okewHL+lQSDnUkDIe2rF+y7YkwCHCcmd/szsIxxFs4ibtQ5SYQ/CphtjH7/Nff+3R
	 z6HEDUzWCTWvNhZVR1boGfBEkyeJB4cIviKoY2Dptu6FZ0F+0/xBRRc2ka+2WyJGgI
	 h6Ls9njrym2Hpv8cPoRX1sFqfAZzaMH+S04RVEdWI0YBIuQ27+DvqPibezQHVC+jDz
	 rQirZKMhVPZgkqmuf4U7jWUz7e4fTtp3rq/5GzXthgmKOECeq3Szp6/7PkOMTEmOuP
	 VWjlwKV/ctX4ywshg4yznc+UnhpK6aKXyHfRg0l9DVPuUZl35SaxCDTupORSoHpTml
	 0sRUjgpLTRGsA==
Date: Tue, 21 Jul 2026 15:49:44 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Mykola Marzhan <mykola@meshstor.io>, Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/6] block,md,nvme: correct handling of unsupported
 P2PDMA transfers
Message-ID: <20260721124944.GL110966@unreal>
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260720124304.GE110966@unreal>
 <al5IJb-L0FpztnYz@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al5IJb-L0FpztnYz@kbusch-mbp>

On Mon, Jul 20, 2026 at 10:09:09AM -0600, Keith Busch wrote:
> On Mon, Jul 20, 2026 at 03:43:04PM +0300, Leon Romanovsky wrote:
> > It would be great if developers supervised their AI tools and kept
> > commit messages and cover letters concise and readable.
> > 
> > Everything above can be reduced to a simple sentence: "MD treats an
> > unsupported P2P operation as success rather than failure; update the
> > code accordingly."
> 
> Thank you for TL;DR summary! The verbosity from these things is a bit
> annoying.

Yeah, too verbose and conveys almost no useful information.

Lately, I've started ignoring such submissions to prioritize commits
from people who put real effort into explaining what they are doing.

Thanks
