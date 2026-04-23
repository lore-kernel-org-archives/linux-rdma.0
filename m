Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BC13E8684
	for <linux-rdma@vger.kernel.org>; Thu, 23 Apr 2026 12:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776945986; cv=none; b=j94r6lcFXyvQyctN6+asr327kWF9fno5RsEstlNv2q4Ky5LIOQvdJqGlhAfpBBI+TmhbZg7Owae2sNYGgTkNtfzzprCwxhuGsXu5EhrD62FOgNNn5KlANXR0/Csv/qYGQbMcQJ6RmmgUvo5GQPU4Uy6I4SsCu2uoPvXlPWg92MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776945986; c=relaxed/simple;
	bh=F9kqgcMOdYs7jwkWr7asOxMnf+uaxTM5gvypZPXR4h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQcOpDwHQ5Q8vCpUeN8X9MSb3aWYq1HlE/CbyP0DFtFMfmG49oEodCz0Gol+umn+qdwJVE6a+MfCYVhHIaESBGilkWlaKlqyW+XQ8JX2POa/YQzGzp+QRpad2kTVt0y7KlvPt3wvLRVGWYwELXOy2ER8U7jeMGmQ/8+UxZSC9NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iyqo87F0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iyqo87F0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2867C2BCAF;
	Thu, 23 Apr 2026 12:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776945986;
	bh=F9kqgcMOdYs7jwkWr7asOxMnf+uaxTM5gvypZPXR4h8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iyqo87F0R6pa3TY/Q8qoTUNWF12EJgxyXjPcEFTw6tCl4YS2tj0jd4ma0RTGYesdt
	 zTxvPoe+lltZHVt8gY0rvqktx5NVCD5pcKqP9C72v9tHyvGXduBWTbflK66FTW2TbE
	 Ynz3Hyb7BQ/++Bx0/hpevnia/52+YnzM5DQVLaKhzWWpqNESQDIbaxpBzD7Hrz6FFt
	 ZFK2FG+U6gMkcr2Brh8U3HcfqOpG0TPmLoBGsq58lNvwXyBfX/y76wJ/IUjZ0YCOai
	 Hcfg/SnvpieC70odFpC3hTsCA5dUmImGPiJVyPPcw+yU5qQmSm92X2aNIT912DLD7c
	 hrZMgDYnWEsHw==
Date: Thu, 23 Apr 2026 15:06:21 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yonatan Nachum <ynachum@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, mrgolin@amazon.com,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev,
	Firas Jahjah <firasj@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Add checksum support for admin
 responses
Message-ID: <20260423120621.GC172828@unreal>
References: <20260409074905.3126023-1-ynachum@amazon.com>
 <20260420065528.GA29767@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420065528.GA29767@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>

On Mon, Apr 20, 2026 at 06:55:28AM +0000, Yonatan Nachum wrote:
> On Thu, Apr 09, 2026 at 07:49:05AM +0000, Yonatan Nachum wrote:
> > EFA devices added support for CRC16 checksum on admin responses and to
> > expose it to the driver the API version increased to 0.2. Add a check
> > for support on device init and if supported validate the checksum on
> > each admin response the driver receives. If the checksum validation
> > failed, drop the CQE.
> > 
> > Add the CRC16 module to Kconfig to have the in-tree dependency.
> > 
> > Reviewed-by: Firas Jahjah <firasj@amazon.com>
> > Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> > Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
> > ---
> >  drivers/infiniband/hw/efa/Kconfig             |  3 +-
> >  .../infiniband/hw/efa/efa_admin_cmds_defs.h   |  3 --
> >  drivers/infiniband/hw/efa/efa_admin_defs.h    | 15 +++---
> >  drivers/infiniband/hw/efa/efa_com.c           | 50 ++++++++++++++++---
> >  drivers/infiniband/hw/efa/efa_com.h           |  4 +-
> >  5 files changed, 55 insertions(+), 20 deletions(-)

<...>

> > 
> 
> Kind reminder.

There is nothing to revisit. We are in the merge window, and we do not
accept new features during this period.

Thanks

> 
> Thanks
> 
