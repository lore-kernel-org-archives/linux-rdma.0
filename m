Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77D41DED4C;
	Mon, 23 Mar 2026 08:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774253335; cv=none; b=h9tSYC1AiUJOcCOZ9QW6AxKYVvd7Lgfjbrz8nLF78yPPHGPASeZNhQXjxloU8rr2zUieFLZTmHQCTY1kt1Ct7laGHjn9oKIutIQ3rm+Z4A57y90FSc6x8eWsfONMvPylAyRi7fUErbyvuyKFr0Pgz6EkyY9Y6AEv/lxV6Uy9H8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774253335; c=relaxed/simple;
	bh=duHbJjCiv3keEx2pL+5FokNVI6n7igApHRCi0RJex9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CWF8Tyy/eWFbBOtMGH7dnrISa3bn4ezE3XBRrO1sb8UnLKjl4vt36+Qjik2GhwPkQXH3ZrRUfK+NtM7Mw00h4f+bDKV/KzGK5eHunxRPq+jezfGmA6jBdHwjULHQ3lk0u2uhpY6sOKGN1wwLpZXCG7hMGSePoQICxaGNBk977iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s7b4fqp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s7b4fqp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D649DC4CEF7;
	Mon, 23 Mar 2026 08:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774253334;
	bh=duHbJjCiv3keEx2pL+5FokNVI6n7igApHRCi0RJex9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s7b4fqp+kVUyMnMNOVp/ykyk3H23B5oRl0MU4J9jfYVuUs62QB5ciVDikFv8ercyK
	 28zQOfjB91V9E6DfceJJF19ak6dzLDV77Cs6D0vL/k2Twn2rhof9zNW1bWPGGDbcBh
	 Xr7DPx+Xz+Dil1/g0jItSUuFeXc3a1Igx98DnWgzYRA9zJdnM/X9BjJzrGEx/R3GRr
	 qNpwzsBZAT8gsC0wGxO+05YeAfXo0a/G2inn1FceN+wDy76LDqAOHYkBSDMUNxbmcO
	 oTz7AxjNSLlbgFq0UjOSGU0vWo2N4h2j5MmdhCUhqEZtBalUnmn0SioCwaPmzewUV6
	 yMGjD0tu5NK4g==
Date: Mon, 23 Mar 2026 10:08:48 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Nathan Chancellor <nathan@kernel.org>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Doug Ledford <dledford@redhat.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Ingo Molnar <mingo@kernel.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 2/3] RDMA/hfi1, rdmavt: open-code rvt_set_ibdev_name()
Message-ID: <20260323080848.GF814676@unreal>
References: <20260320151511.3420818-1-arnd@kernel.org>
 <20260320151511.3420818-2-arnd@kernel.org>
 <6b56c476-86fd-4d43-8dee-c7f89d346941@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b56c476-86fd-4d43-8dee-c7f89d346941@app.fastmail.com>

On Fri, Mar 20, 2026 at 04:53:04PM +0100, Arnd Bergmann wrote:
> On Fri, Mar 20, 2026, at 16:12, Arnd Bergmann wrote:
> 
> > +	 */
> > +	ibdev = &dd->verbs_dev.rdi.ibdev;
> > +	dev_set_name(&ibdev->dev, "%s_%d", class_name(), dd->unit);
> > +	strscpy(&ibdev->name, dev_name(&ibdev->dev), IB_DEVICE_NAME_MAX);
> > +
> 
> I messed this up during a rebase, that should have been 
> 
>        strscpy(ibdev->name, dev_name(&ibdev->dev), IB_DEVICE_NAME_MAX);
> 
> (without the extra &). I'll wait for comments before resending.

The hfi1 driver is scheduled for removal. Dennis has already posted the
hfi2 driver, which serves as its replacement.

Thanks

> 
>        Arnd
> 
