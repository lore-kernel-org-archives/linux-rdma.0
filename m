Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FA837FF53;
	Thu, 30 Jul 2026 03:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381775; cv=none; b=kQnGk8SJcT07vvEyQeg7WmrpwYjyrUUYXRh4ngjdb4J9jDYZ5PrAXr/i08lXRnWgQAHkoklnUzn5IFxrG1KitI61b5W5NJ9OZeo3RsPBhzDTAPostBGMvDR0Bon7BP1FxMXGals04OCZ0sOnnzQBBkiIzos6/aKkRWAdErZKzoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381775; c=relaxed/simple;
	bh=K5plh9K0eSnkpKGBWt1ew4DZit+enuqhh53f5B9/1G0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r7/irTs7ltQ5CWGHkVTGzHJOza1uvWKRJxXxmxIOLSCJS1SidQfppXHsS3ZaZjWv16jaHsW8Ilsm2ls7B6cSGwFaUh5ZLJY+5uhDDTTYnAVsWxSgF/2aeeU2QF4FkYh9DYw7ATSf4Cnfsb618m40BPRAoD0aq+AnmDCqyvLhGVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TySLqYn7; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TySLqYn7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785381767; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=d3izBdes5nlak2vE4b+zjTRjdmoLs+wGWEK+U3iWFsI=;
	b=TySLqYn7MhwixZu3iScWX64zH037l6fTyq/khSEen25M217/Qe2xuUXqNfzO7eFieTbq4FOH+9JyZib8PZs6Lj8/hf6rWtppMfjt4e40h+V1JLbhGt03Jzz0jICbmfeWRB4lD/hNmXqTWHtIvKKuKYntc1+fOITqzr8hwX3bdCM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X83p2di_1785381765;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X83p2di_1785381765 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Jul 2026 11:22:46 +0800
Date: Thu, 30 Jul 2026 11:22:45 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Wen Gu <guwen@linux.alibaba.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>, mjambigi@linux.ibm.com,
	wenjia@linux.ibm.com, wintera@linux.ibm.com,
	dust.li@linux.alibaba.com, tonylu@linux.alibaba.com,
	kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
	leonro@nvidia.com, pabeni@redhat.com, edumazet@google.com,
	sidraya@linux.ibm.com, jaka@linux.ibm.com,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next v4 3/3] net/smc: transition to RDMA core CQ
 pooling
Message-ID: <20260730032245.GA109346@j66a10360.sqa.eu95>
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
 <20260716113745.65234-4-alibuda@linux.alibaba.com>
 <349282a8-8c66-409b-99d2-970785bf42d1@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <349282a8-8c66-409b-99d2-970785bf42d1@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Jul 23, 2026 at 10:56:09AM +0800, Wen Gu wrote:
> 
> 
> On 2026/7/16 19:37, D. Wythe wrote:
> >  static void smc_copy_netdev_ifindex(struct smc_ib_device *smcibdev, int port)
> >@@ -952,7 +916,6 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
> >  	INIT_WORK(&smcibdev->port_event_work, smc_ib_port_event_work);
> >  	atomic_set(&smcibdev->lnk_cnt, 0);
> >  	init_waitqueue_head(&smcibdev->lnks_deleted);
> >-	mutex_init(&smcibdev->mutex);
> 
> Since smc_ib_setup_per_ibdev() and smc_ib_cleanup_per_ibdev() were removed,
> the .mutex field is now unused and can be dropped.
> 
> Thanks.


Good catch! The mutex is indeed unused now — will remove it in v5.

> 
> >  	mutex_lock(&smc_ib_devices.mutex);
> >  	list_add_tail(&smcibdev->list, &smc_ib_devices.list);
> >  	mutex_unlock(&smc_ib_devices.mutex);
> >@@ -1001,7 +964,6 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
> >  	pr_warn_ratelimited("smc: removing ib device %s\n",
> >  			    smcibdev->ibdev->name);
> >  	smc_smcr_terminate_all(smcibdev);
> >-	smc_ib_cleanup_per_ibdev(smcibdev);
> >  	ib_unregister_event_handler(&smcibdev->event_handler);
> >  	cancel_work_sync(&smcibdev->port_event_work);
> >  	kfree(smcibdev);
> 
