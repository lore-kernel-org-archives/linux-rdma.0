Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C80320A14;
	Tue, 24 Mar 2026 07:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774338325; cv=none; b=ODn2XtaMEWNZW4kIzpZZXSIX7b5H+2M0S2/+62ubbGaHH4ArWA9AyQjYqmV3hcHmoKCA/8jUc6D6iYkstU+j3ucZuaOIyVCF+eV7gamQa+LtiJG6QLDu0q+Iv9azZk60j/TM+QUt1tiAsbn0yXAujC7cJTU8hpmAw9+nPZfcBjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774338325; c=relaxed/simple;
	bh=w7aSu3hEUiDumjA3EwakxvKSJQA92CEO6cfhnLNuU2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+Tc8Pf4/hkrJTbBsPGpB1rz6JEkuoaCR3olJWLxs4yHmodvQ+TZtfeI7RNCIJEx+GAuxexdPJKDzVPa+OU8IICNoGOlSCV3JzIgiK+XJHgdzegS4ZvzbvAofuE2VMQ6+y7qfmWqwlJdeCSF6Sc36V5i7V3l83uZIvhpZeBNgas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KROC2JMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KROC2JMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2A7C19424;
	Tue, 24 Mar 2026 07:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774338324;
	bh=w7aSu3hEUiDumjA3EwakxvKSJQA92CEO6cfhnLNuU2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KROC2JMpwnNJNnNv9ctBUFh+0mbCJT08QnNlnxUKcUSX7tO1lWfoAxilm0BVDj01P
	 qGoTmMuoh7nYVkmDLJiYMQjRCi8ADg54A7q6C8vfvT+2OiZ5Uo16UPWwQ0QW10QGpd
	 KEHaPZfVMgF1UsSCVEoJZn+IxrGp00gZp1WyCloSFN9SOv4bMQV96utkh149J+cseI
	 xvAvMKg4IqdXy8XwuPokj12Nkg3bjsEDmj2Ipkb19wVPZ2pqntVBJ64V2c2ojplltP
	 jWXlNJay7PWJohU3fuENgeYBWRywZvsKgesjOubPwKJWBQBROK2TvYw33UuTj+8QFL
	 xKErDv9LyjPgA==
Date: Tue, 24 Mar 2026 09:45:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: krzysztof.czurylo@intel.com, tatyana.e.nikolova@intel.com, jgg@ziepe.ca,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/irdma: validate AEQ QP and CQ indices
Message-ID: <20260324074518.GK814676@unreal>
References: <20260324014459.93348-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324014459.93348-1-pengpeng@iscas.ac.cn>

On Tue, Mar 24, 2026 at 09:44:59AM +0800, Pengpeng Hou wrote:
> irdma_process_aeq() trusts the QP/CQ identifier decoded from the
> hardware AEQE and uses it to index rf->qp_table[] and rf->cq_table[]
> without first checking that the identifier fits the allocated table.

HW should be programmed to provide valid index.

Thanks

> 
> Reject AEQ entries whose QP or CQ ids fall outside rf->max_qp or
> rf->max_cq before touching the tables. This keeps malformed or stale
> hardware event records from walking past the end of the driver-owned
> resource arrays.
> ---
>  drivers/infiniband/hw/irdma/hw.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
> index f4ae530f56db..32d7ac7d3885 100644
> --- a/drivers/infiniband/hw/irdma/hw.c
> +++ b/drivers/infiniband/hw/irdma/hw.c
> @@ -313,6 +313,13 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
>  			  info->iwarp_state, info->ae_src);
>  
>  		if (info->qp) {
> +			if (unlikely(info->qp_cq_id >= rf->max_qp)) {
> +				ibdev_warn_ratelimited(&iwdev->ibdev,
> +						       "AEQ reported invalid QP id %u\n",
> +						       info->qp_cq_id);
> +				continue;
> +			}
> +
>  			spin_lock_irqsave(&rf->qptable_lock, flags);
>  			iwqp = rf->qp_table[info->qp_cq_id];
>  			if (!iwqp) {
> @@ -413,6 +420,13 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
>  				  "Processing an iWARP related AE for CQ misc = 0x%04X\n",
>  				  info->ae_id);
>  
> +			if (unlikely(info->qp_cq_id >= rf->max_cq)) {
> +				ibdev_warn_ratelimited(&iwdev->ibdev,
> +						       "AEQ reported invalid CQ id %u\n",
> +						       info->qp_cq_id);
> +				continue;
> +			}
> +
>  			spin_lock_irqsave(&rf->cqtable_lock, flags);
>  			iwcq = rf->cq_table[info->qp_cq_id];
>  			if (!iwcq) {
> -- 
> 2.50.1 (Apple Git-155)
> 
> 
