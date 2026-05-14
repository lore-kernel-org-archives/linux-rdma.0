Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBCE34A76A
	for <linux-rdma@vger.kernel.org>; Thu, 14 May 2026 06:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778741272; cv=none; b=gyPp9KONr0PNxDYEbquhPuh79v9xcit96y2/hJX01cXhZgBSmiRphSOwRkGzwTEsahGt4HwtXbicE6s9qyD5ktGLUt/fBvJNW4BtWOq5BShCS6J6xSAttBDd0DhyqCVMCo6j3nCmTjHE4jq60xwSLTc0hxGYaT/ksZC2fKrGN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778741272; c=relaxed/simple;
	bh=Co+0IOPP+le/nJzxckVEEYymnBjnjLLVQ6EgAdRDDMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHE3EodnTUlOAK3+D6M0ZXeTT/XGtmzHeY1cccZTjvYdrfXBg25u6kMvQF9qjJuCeZQy/dFtw3bLHjZZMHI0Z4i9scib+orvNAnMDLmZiiFL1yUmQ81U6vmkNibnH9oesIoEnOWd/Pi9fPLjg+Vhh7pKGdgvQG4/RAG1qYlvFJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSfgGCtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSfgGCtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C404C2BCB7;
	Thu, 14 May 2026 06:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778741271;
	bh=Co+0IOPP+le/nJzxckVEEYymnBjnjLLVQ6EgAdRDDMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RSfgGCtEa5KYNcSSWIyUsIUjZmHuPjQU5lTW/qQ9cxA+ZUnGlAtlJGeVgKG06vOQ7
	 L0JJ6gwhpxkULZHyfDb24uqN2Lj6mTluzHTfV2QEkxaBTONlqTOTC19sHJBXMeET1+
	 D2zlsitU+wbhi/LQIqhWnH26OO7qvGY5cW8HF/gGv6RGtMHuyZayC1k++lhqtLaNE1
	 tVJXiUfNhfP/iS/JkNJEFs64gYidB2qcQ8e/QP+wGvFckeoQmUsbG8t4QX0sOfJUFx
	 KvNeQ+4SSG3DfqoDOgBsCvGWYl1vU+WyIdlft0DXyGvRzv02sc2x4N9EyoO1XvGzSe
	 CvHN0jLj8llfw==
Date: Thu, 14 May 2026 09:47:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chenguang Zhao <zhaochenguang@kylinos.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Sean Hefty <shefty@nvidia.com>,
	=?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH] IB/cm: unregister client groups when port registration
 fails in cm_add_one
Message-ID: <20260514064746.GL15586@unreal>
References: <20260511103204.1757106-1-zhaochenguang@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511103204.1757106-1-zhaochenguang@kylinos.cn>

On Mon, May 11, 2026 at 06:32:04PM +0800, Chenguang Zhao wrote:
> If ib_port_register_client_groups() fails, jumping to error1 skips
> ib_port_unregister_client_groups() for the current port because the
> cleanup loop only runs for strictly smaller port indices after --i.
> So jump to error2 to unregister the currently failed port.

Why? There is no need to call ib_port_unregister_client_groups() for the
current port. A failure in ib_port_register_client_groups() does not create
any sysfs groups that would require cleanup.

Thanks

> 
> Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
> ---
>  drivers/infiniband/core/cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 6ab9a0aee1ec..bcd347c78376 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -4378,7 +4378,7 @@ static int cm_add_one(struct ib_device *ib_device)
>  		ret = ib_port_register_client_groups(ib_device, i,
>  						     cm_counter_groups);
>  		if (ret)
> -			goto error1;
> +			goto error2;
>  
>  		port->mad_agent = ib_register_mad_agent(ib_device, i,
>  							IB_QPT_GSI,
> -- 
> 2.25.1
> 
> 
