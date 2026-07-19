Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6E73563EB;
	Sun, 19 Jul 2026 09:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784453207; cv=none; b=rWxbem6+Xj4F1R1i0Fcs0dXb/eWTt26AQ92Xtyf1xdkfAOZsYajIFs/9NzMppLkQRI1Ex92KymzfYOCYrTxalqijLJHKfro6c0/Iu9UJ8NCQa3WM1HV6BOLckDvSVEVR2xu1riA1wq7Aa1tFfWtf8akdlcUs8BtF7b3sTbC5UuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784453207; c=relaxed/simple;
	bh=sMW3QJus+b44frmJOKMargkP+aScshjZ4nX32X50DuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qog6bP/DONDQvjKdFFomF1MoZ+9x/fVIA4DlvO/N7g0wnZr5fTVndLhoWCR53gfSRAS/QhkqLJ1gJdy7+zXakdgIi8x5AT1cdzuDQkOn4KAQALAOxvBlQNg0WXdqDy+VlN1pBX6VEMvmSO64NTgqA5RUsipevzP6Oa3IFTnlouU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wwv1YzjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wwv1YzjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E8A1F000E9;
	Sun, 19 Jul 2026 09:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784453205;
	bh=Z6CVcW2Mj6rNVFJ3aanBTM5gmTtw0teGttT7Uf5GtjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wwv1YzjZiw86S3+VeFJxGS1AG7ETfAT+S5mrIo78WxO6tjkAo9sOnqODO7Ladbxye
	 6jspizWM6Fu00Vu/zTQqD7UlV4ZNLPmfYGA3GgtNtJB8sgI/AHX9nDr5O09swxerC9
	 0+5bnT9KsJ8z8uRcSJOU/8nZnqLzq1JXdIPflFkDLuSkYFl5cDm6cM/eD3dd6eQbNA
	 LUWL4NoJaVFICnXklFnkhUrfiTfm+WGBcKfTkfG1bF7ztbMzMgxgmci3wH00tlEQfC
	 CwyrXFVWRRFOYtN+yq0BSzw0LvA7ercbyQKOPRr2SUnjwkw+HGSGa7TmHu0glHD7qV
	 fevkQtnadM7pg==
Date: Sun, 19 Jul 2026 12:26:38 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Gioh Kim <gi-oh.kim@cloud.ionos.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix double free on path sysfs failure
Message-ID: <20260719092638.GC110966@unreal>
References: <20260714142838.1723076-1-lgs201920130244@gmail.com>
 <20260715081720.GD21348@unreal>
 <CANUHTR-wDnrAYQuFvM+PEyZL6SyovFRb-FqVyiBV=1CKUvDG1Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUHTR-wDnrAYQuFvM+PEyZL6SyovFRb-FqVyiBV=1CKUvDG1Q@mail.gmail.com>

On Sat, Jul 18, 2026 at 02:55:02PM +0800, Guangshuo Li wrote:
> Hi Leon,
> 
> Thanks for reviewing.
> 
> On Wed, 15 Jul 2026 at 16:17, Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Jul 14, 2026 at 10:28:38PM +0800, Guangshuo Li wrote:
> > > alloc_path() allocates clt_path before rtrs_clt_create_path_files()
> > > initializes its embedded kobject.
> > >
> > > If path sysfs creation fails, rtrs_clt_create_path_files() calls
> > > kobject_put(). The final reference invokes rtrs_clt_path_release(),
> > > which calls free_path() and frees clt_path for the first time.
> > >
> > > After the helper returns, both rtrs_clt_open() and
> > > rtrs_clt_create_path_from_sysfs() continue to access clt_path and call
> > > free_path() again, resulting in a use-after-free and double free.
> > >
> > > Let the sysfs helper undo the sysfs and stats setup while retaining the
> > > path kobject reference. After removing the path and closing its
> > > connections, release that reference with kobject_put() so
> > > rtrs_clt_path_release() remains the sole owner of the final free.
> > >
> > > This issue was found by a static analysis tool I am developing.
> > >
> > > Fixes: 7ecd7e290bee ("RDMA/rtrs-clt: Fix memory leak of not-freed sess->stats and stats->pcpu_stats")
> > > Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> > > ---
> > >  drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c | 20 +++++++++++++++-----
> > >  drivers/infiniband/ulp/rtrs/rtrs-clt.c       | 12 +++++++++---
> > >  2 files changed, 24 insertions(+), 8 deletions(-)
> >
> >
> > We have already discussed this multiple times. What is still
> > missing?
> > https://lore.kernel.org/linux-rdma/20260428105515.362051-1-lgs201920130244@gmail.com/
> > https://lore.kernel.org/linux-rdma/20260511130804.773204-1-lgs201920130244@gmail.com/
> > https://lore.kernel.org/linux-rdma/20260514113834.865530-1-lgs201920130244@gmail.com/
> >
> > Thanks
> 
> The previous discussions addressed the server-side path,
> rtrs_srv_create_path_files(), involving struct rtrs_srv_path.
> 
> This patch addresses a different client-side failure path in
> rtrs_clt_create_path_files(), involving struct rtrs_clt_path. Here,
> the helper may release clt_path through kobject_put(), while its
> callers continue to access and free the same object, resulting in a UAF
> and double free.
> 
> Although both issues involve kobject lifetime handling, the affected
> object and call path are different.
> 
> Sorry that I did not make this distinction clear enough in the commit
> message.

You likely need to apply the same fix as in the srv patch.

Thanks

> 
> Thanks,
> Guangshuo
