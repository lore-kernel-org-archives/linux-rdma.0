Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B740283FEF;
	Fri, 13 Feb 2026 21:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771017450; cv=none; b=ndjW0EuOd1D4tssE7wYW1RZMJAYdZcm3oKxNk3eu6fYXHrzJwQtE5eRkwV3hfx8af2BX8nvSwusbw4Qd0vexLOk53tpUyn48SPtzXTI1BubudzwyYAsq54i83sW4DjtvHHcKDVTPbesHl+jRT9yMntjVi4PCALp1ZN1YiLKrEr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771017450; c=relaxed/simple;
	bh=QlcL27O3ioRBHOEWaDhkbLRq0wlbMnBXzrVrXePjFiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ObK6gQSrlmHjhlEEQJQM/VCODPmESuQLr1WNSDUQe2ZcDx1estBQNme7Tgh8q5IsoblCZG4WswlhlPu71MwG7ggsQqXn5WhjOnsi5EUcwh2t7FhodvkaOhZnKRQInjCi0X6VI77AotXrAfjo3+urDnrPP+fz8nbcNi8aqcTSHQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQnuiL0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQnuiL0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB89EC116C6;
	Fri, 13 Feb 2026 21:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771017449;
	bh=QlcL27O3ioRBHOEWaDhkbLRq0wlbMnBXzrVrXePjFiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eQnuiL0apbzq6AO3OTVemwUrkBPCI9zxRbfHVedPQJCyRANA+597jQ8ueRkQjiuHy
	 x3HNoi4yMrHhKTiddrjJlN+wCENPaA8Drxb6PcKhZ+1JVMsTRtSvsYbCQi6+nBB8fw
	 0W4PY8wtj+FqA5zZNuCPxHWxHM6puvJEfy6GEd0jSC9iUXl4VS1PmUpQDGCEyyRf5Y
	 gjmELhV5oT3dYRfsIG6+RmwoiVp+zmd5XONvxrHH3ZjRMPMxpCQGhxJuMRZgdrXR6s
	 z8KR9lLetW+BwBJxwhL5pgW2XTKOq599sGjRR07qrtl3Ju+gIveG+nRwLQGU3LY0t6
	 1ROp00tFhgSkg==
Date: Fri, 13 Feb 2026 23:17:24 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Allen Hubbe <allen.hubbe@amd.com>,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Christian Benvenuti <benve@cisco.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH rdma-next 28/50] RDMA/siw: Split user and kernel CQ
 creation paths
Message-ID: <20260213211724.GA691383@unreal>
References: <20260213-refactor-umem-v1-0-f3be85847922@nvidia.com>
 <20260213-refactor-umem-v1-28-f3be85847922@nvidia.com>
 <054452b7-7e08-4f8c-8010-e1b69c4b3997@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <054452b7-7e08-4f8c-8010-e1b69c4b3997@linux.dev>

On Fri, Feb 13, 2026 at 05:56:32PM +0100, Bernard Metzler wrote:
> On 13.02.2026 11:58, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Separate the CQ creation logic into distinct kernel and user flows.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   drivers/infiniband/sw/siw/siw_main.c  |   1 +
> >   drivers/infiniband/sw/siw/siw_verbs.c | 111 +++++++++++++++++++++++-----------
> >   drivers/infiniband/sw/siw/siw_verbs.h |   2 +
> >   3 files changed, 80 insertions(+), 34 deletions(-)

<...>

> > +int siw_create_cq(struct ib_cq *base_cq, const struct ib_cq_init_attr *attr,
> > +		  struct uverbs_attr_bundle *attrs)
> > +{
> > +	struct siw_device *sdev = to_siw_dev(base_cq->device);
> > +	struct siw_cq *cq = to_siw_cq(base_cq);
> > +	int rv, size = attr->cqe;
> > +
> > +	if (attr->flags)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (atomic_inc_return(&sdev->num_cq) > SIW_MAX_CQ) {
> > +		siw_dbg(base_cq->device, "too many CQ's\n");
> > +		rv = -ENOMEM;
> > +		goto err_out;
> > +	}
> > +	if (size < 1 || size > sdev->attrs.max_cqe) {
> 
> isn't there now also a check for zero sized CQ in
> __ib_alloc_cq(), which obsoletes that < 1 check?

Thanks, this line needs to be changed to be if "(attr.cqe > sdev->attrs.max_cqe)"

> 
> Everything looks right otherwise.
> 
> Thanks,
> Bernard.

Thanks
