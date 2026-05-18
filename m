Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD515330D22;
	Mon, 18 May 2026 11:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779104516; cv=none; b=AQ+nRG7nh1qSme3yRs421V+3bsd+dNSr5q79Hm04XxbudEiYoFcgarfppwhTrZB9fKKWZJQr/yv1YzxMu6Nl9TxrT7v9T65JJzS/FyElMJbTD32FAuE16kAy3aWPvNUsB5QGM1gzlcdu5gJYFompU36Q3wS63e2eJ/CMACMalO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779104516; c=relaxed/simple;
	bh=wBhNwTvlTojY3itreFV+jxL0OCDjiZxEJH56Soyf/CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdHmcoOzM71miMQwCMRtUrmLKe9Ej/YZIBbGCfw26EYE9XLe6v44/dg/rmDs5GnJJwnxcg9M+hZMlh7fmsdlQIgEbV5/e3lUkbvFy6bMB4xoWqIoXjBgVJexFkat8yks/C9v5dalr8lKkblphIngeONdtsHkKIrUjQ1m6Bho3e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcCJ2w7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcCJ2w7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E355C2BCB7;
	Mon, 18 May 2026 11:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779104516;
	bh=wBhNwTvlTojY3itreFV+jxL0OCDjiZxEJH56Soyf/CY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YcCJ2w7ih+AOztmKIF8K0dcWqxeRdG2SfLsSpKaMTjNrE5iBg8Dw5Sp75IwXlBKq/
	 2rG/PlbMSCqYoczsvVDGqCIIS1a5+vF/SbuJF/lYq8NeKhoN926CURJrCO87RTVKSh
	 ts89cN4JY662AkgU/oiDPfysUIy+O2dwRNys3VEtUFR7Y6UaIt7WD/bvnF79FiL9Mt
	 /nUjifgBHOIpck8abhVH8N3wqkpsgDNbJtZCNgX77MgcULq0P3JK0sp80MspBGGsgb
	 dO4MoTOFDta99s1Coznb1hJQwaJ0z28Q3wXAES9umvAY4QuRatWXPXmVesMsKPMX5R
	 GfJr1dwZFOlVQ==
Date: Mon, 18 May 2026 14:41:51 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Dust Li <dust.li@linux.alibaba.com>
Cc: Xiang Mei <xmei5@asu.edu>, alibuda@linux.alibaba.com,
	netdev@vger.kernel.org, wenjia@linux.ibm.com, sidraya@linux.ibm.com,
	tonylu@linux.alibaba.com, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, bestswngs@gmail.com
Subject: Re: [PATCH net] net/smc: avoid NULL deref of conn->lnk in
 smc_msg_event tracepoint
Message-ID: <20260518114151.GP33515@unreal>
References: <20260510222640.1230720-1-xmei5@asu.edu>
 <20260517084513.GA33515@unreal>
 <agnZ_G9_9jZFS2An@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agnZ_G9_9jZFS2An@linux.alibaba.com>

On Sun, May 17, 2026 at 11:08:44PM +0800, Dust Li wrote:
> On 2026-05-17 11:45:13, Leon Romanovsky wrote:
> >On Sun, May 10, 2026 at 03:26:40PM -0700, Xiang Mei wrote:
> >> The smc_msg_event tracepoint class, shared by smc_tx_sendmsg and
> >> smc_rx_recvmsg, unconditionally dereferences smc->conn.lnk:
> >> 
> >> 	__string(name, smc->conn.lnk->ibname)
> >
> >My comment is not directly related to this patch, but it was triggered
> >while reviewing it. The ibname should not be cached, as users can rename
> >it through rdmatool or udev.
> >
> >For example, this function is racy:
> >   552 static int smc_nl_handle_smcr_dev(struct smc_ib_device *smcibdev,
> >   553                                   struct sk_buff *skb,
> >   554                                   struct netlink_callback *cb)
> >   555 {
> >   ...
> >   582         snprintf(smc_ibname, sizeof(smc_ibname), "%s", smcibdev->ibdev->name);
> >
> >Thanks
> 
> Hi, Leon
> 
> OK, I'll submit a patch removing all the ibvdev->name in SMC.

Thanks

> 
> Best regards,
> Dust
> 
