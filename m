Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A842FE056
	for <linux-rdma@vger.kernel.org>; Tue,  1 Sep 2026 13:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271077; cv=none; b=aLc9zoS8o5e+mIrhvqlIad2khD8YWQZiEW9GkMJzZHV0xPW48H1iaVDjaaYPXoia8s19amPHxt+K/+bNqel4dYNQEsOXLXs+B/n3fogQDVj0+c7iiaUGmpQLSjcjXRh3Z7YYXnHATtV0gortJ8te+xRTG25y+klHjwcq1bO7moo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271077; c=relaxed/simple;
	bh=RQSRoUB1WbyaCDu1Fdsj6DEFHsdQU3Khke0Xf4OnrZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMveLl7M5fLOh+gbwe+5KS/iLFcqJAdeteSW0iT8EF8NrwHdlMFmHtP3+eQNMa5K71TgTPpoiReofGixugJmU4n+Kw9xYn+3dJW+KBctsmSsgCbroz1w9musvMlmvz+P3Ygym5g3oAJF5Oo4LxcibVzGo7fYhXIqUng34xVivlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/xnwomH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/xnwomH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E781A1F000E9;
	Tue,  1 Sep 2026 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271076;
	bh=Ea22HpDGc1QKHhmKfBofX/thbtGew8AiTYPi5CysFyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D/xnwomHqEvo+3BAy5BQ+wvBeRl/RNz//NEYHAoaEEuFpqCCyDLLrg6WvnUjGCoTs
	 Vr6WOjkTJqo4nwrzTE8b7V5hr3DS62rnHC+ZvGrM6DwPxZ560UDqjedRVaWpDhnkIT
	 mzpQiyAMeKpqAcfEXHqZa/t3AluZ7IN+yFUCmi+/IVBgYpRb8DTsoh2w4MfLtNB97h
	 bdRu/90oekS8OyzivCKL2x3KG/n++qoO8kG6wlpANpion6MCtalO367+awwCEOxzbs
	 gPErT6xaPrO32Can6h0qKrX+wEmApmGBFllOi6XJpWGMcBi5rKBwVzM6mxZU7Eqa0t
	 aYpTMcjolOYRw==
Date: Tue, 1 Sep 2026 16:57:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yonatan Nachum <ynachum@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, mrgolin@amazon.com,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev
Subject: Re: [PATCH for-next v3 0/3] RDMA/efa: Add support for 128B admin v2
 SQ entry
Message-ID: <20260901135753.GN24140@unreal>
References: <20260812121718.2904349-1-ynachum@amazon.com>
 <20260901135638.GM24140@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901135638.GM24140@unreal>

On Tue, Sep 01, 2026 at 04:56:38PM +0300, Leon Romanovsky wrote:
> On Wed, Aug 12, 2026 at 12:17:15PM +0000, Yonatan Nachum wrote:
> > Changelog:
> > v3:
> >  * Ensure proper alignment of stack admin buffer to prevent unaligned memory
> >    accesses.
> > v2: https://lore.kernel.org/all/20260731075007.3878376-1-ynachum@amazon.com/
> >  * Rebase on for-next branch instead of wip/leon-for-next.
> > v1: https://lore.kernel.org/all/20260726123854.638687-1-ynachum@amazon.com/
> > 
> > -------------------------------------------------------------------------
> > Add support for the new 128-byte admin v2 SQ entry format. The v2 entry
> > extends the v1 header with checksum and payload version fields, and
> > carries a larger inline payload.
> > 
> > The series first decouples admin command payloads from admin headers,
> > then generalizes the SQ ring to use a configurable entry size, and
> > finally adds the v2 entry format selection based on device API version.
> > 
> > Yonatan Nachum (3):
> >   RDMA/efa: Decouple admin command payload from admin header
> >   RDMA/efa: Generalize the admin SQ
> >   RDMA/efa: Add support for 128B admin v2 SQ entry
> > 
> >  .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 116 +++--------
> >  drivers/infiniband/hw/efa/efa_admin_defs.h    |  33 ++-
> >  drivers/infiniband/hw/efa/efa_com.c           | 194 +++++++++++-------
> >  drivers/infiniband/hw/efa/efa_com.h           |  16 +-
> >  drivers/infiniband/hw/efa/efa_com_cmd.c       | 170 +++++----------
> >  5 files changed, 240 insertions(+), 289 deletions(-)
> 
> I tried to apply the series, but it resulted in a large number of merge
> conflicts. Please rebase and resend it.

Disregard this email, the series were applied by Jason.

> 
> Thanks
> 
> > 
> > -- 
> > 2.50.1
> > 
> 
