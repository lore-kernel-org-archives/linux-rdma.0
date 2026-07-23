Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122061AAE28;
	Thu, 23 Jul 2026 02:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784775388; cv=none; b=RJcwVOCgMW8wYhWpkIXlbt/AvVymcY1CLn3kJ9ZbMIBu/JTl2QN0ogoQ7yHfNijr5+PRH7vmT1AWHQ8DJ1xR6CgWX6O7I752N7yjI9MFDkiwZ+HmrSqH8erSrAMHz6YbCkHDaUm2nLZojKfmrkh6eF1GmAyBXx1pzJfvfWGGeN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784775388; c=relaxed/simple;
	bh=H+nMxA2IWZJ3YibtWWtcgT+96V14vZObn9vk63g3c4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uCj82Fd3nBY9jFC5oeAyMx0PmLTeQkzTAvIgi7QMsFu4p5gDMRukZrZjdMQzCJFAyi8rLBXQvKc1Usz5Epvl8KNENPzaoWr1JWHZgvs6tSWY8XPMxc3x8ck8sZsVLakDqn9bvGRTKEIcpsyJDobHaoD6Kd2x9fwvsPBoz/ZsGqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aYVZlJJw; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aYVZlJJw"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784775382; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=o4x1d80nsakE/H/LZTVOJLfZCS96JV71yIDaMMwLnhc=;
	b=aYVZlJJw4gzd/xZA17MWte4WvjMiQgljCCtwbFhtfkp3fwXj052GZuAUXTqr3NScCUK4z9TtLPBfIDy3Br67e2bUKBshq0FOgzi7m0ThwwinxDl5dl7Ld1OVBx/NYqbDdmjcbAJYS+BJte0oW+Z8BQ84x9eKu0I2Q7bYqckRRAE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X7ep.zp_1784775369;
Received: from 30.221.147.55(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0X7ep.zp_1784775369 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Jul 2026 10:56:21 +0800
Message-ID: <349282a8-8c66-409b-99d2-970785bf42d1@linux.alibaba.com>
Date: Thu, 23 Jul 2026 10:56:09 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 3/3] net/smc: transition to RDMA core CQ
 pooling
To: "D. Wythe" <alibuda@linux.alibaba.com>, mjambigi@linux.ibm.com,
 wenjia@linux.ibm.com, wintera@linux.ibm.com, dust.li@linux.alibaba.com,
 tonylu@linux.alibaba.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@nvidia.com,
 pabeni@redhat.com, edumazet@google.com, sidraya@linux.ibm.com,
 jaka@linux.ibm.com, oliver.yang@linux.alibaba.com
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
 <20260716113745.65234-4-alibuda@linux.alibaba.com>
From: Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20260716113745.65234-4-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/7/16 19:37, D. Wythe wrote:
>   static void smc_copy_netdev_ifindex(struct smc_ib_device *smcibdev, int port)
> @@ -952,7 +916,6 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
>   	INIT_WORK(&smcibdev->port_event_work, smc_ib_port_event_work);
>   	atomic_set(&smcibdev->lnk_cnt, 0);
>   	init_waitqueue_head(&smcibdev->lnks_deleted);
> -	mutex_init(&smcibdev->mutex);

Since smc_ib_setup_per_ibdev() and smc_ib_cleanup_per_ibdev() were removed,
the .mutex field is now unused and can be dropped.

Thanks.

>   	mutex_lock(&smc_ib_devices.mutex);
>   	list_add_tail(&smcibdev->list, &smc_ib_devices.list);
>   	mutex_unlock(&smc_ib_devices.mutex);
> @@ -1001,7 +964,6 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
>   	pr_warn_ratelimited("smc: removing ib device %s\n",
>   			    smcibdev->ibdev->name);
>   	smc_smcr_terminate_all(smcibdev);
> -	smc_ib_cleanup_per_ibdev(smcibdev);
>   	ib_unregister_event_handler(&smcibdev->event_handler);
>   	cancel_work_sync(&smcibdev->port_event_work);
>   	kfree(smcibdev);

