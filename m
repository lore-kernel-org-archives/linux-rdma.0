Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAF5383C92;
	Thu,  6 Aug 2026 23:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786057707; cv=none; b=f7wf9/DLiolPQkeEZGcUkMx6yw3lrWbpx+Q+Y0w1pxQMxy4/QWa3EhocH4MfFnNn2JgpP4C4Zn2fU1CTbJYnoiRi1cZmkvp6IFECVNORfcfysDLFK0fNkfXAoTt1gqA5CGqn2MUScgDn9Qv7DnBfUiDTQv+e8812opgxv4NkGss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786057707; c=relaxed/simple;
	bh=nGTQuXML9DD+gKEaIpveNv54d1QuhzlmDTO3qBgwcm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CH2EVpVHckzywD8zni5pNGLwAtKZJO9N19Z6DI1OFRB1nZVWbIy5MIxAEo/ztapDxJf8HMN6EBzqbd79z85hrAHpZpycdRbKTKg4hmM9v6w6o/8MwIgWWyaHEpMhlGD3CbKQm/ZpRVN82AUBCVPRGZyGZ7UP8VOh0+RPh9X8wtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BoTm2QPA; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BoTm2QPA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786057700; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=nGTQuXML9DD+gKEaIpveNv54d1QuhzlmDTO3qBgwcm0=;
	b=BoTm2QPA6oC9cCTlMiPflce3F1jV/KVmxHTRQvBiwABlP1l5UUN3Esgkq1q7tiEdU07WcKCsLDlHhsqxNoHYgFPZg3th3i0Qs+OKedohZ70LHvKskEP5iTEDexTgM9qzdgMQQXpaI94R6POdlHwUwJiT7n3tEB+2/yD6CibeSq4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X8UzUSY_1786057699;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X8UzUSY_1786057699 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 07 Aug 2026 07:08:20 +0800
Date: Fri, 7 Aug 2026 07:08:18 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Hidayath Khan <hidayath@linux.ibm.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	wintera@linux.ibm.com, alibuda@linux.alibaba.com,
	sidraya@linux.ibm.com, wenjia@linux.ibm.com
Cc: mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, horms@kernel.org, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com, pasic@linux.ibm.com,
	gbayer@linux.ibm.com, andrew+netdev@lunn.ch, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] dibs: fix double free of dmb_clientid_arr
Message-ID: <anUT4hWIYQOT51ux@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260806120447.596164-1-hidayath@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806120447.596164-1-hidayath@linux.ibm.com>

On 2026-08-06 14:04:47, Hidayath Khan wrote:
>dibs_dev_add() frees dibs->dmb_clientid_arr on both of its failure
>paths, but does not clear the pointer. dibs_lo_dev_probe() then frees
>the same pointer again in its err_reg path, so a failing device_add()
>or sysfs_create_group() results in a double free.
>
>Drop the kfree() from dibs_lo_dev_probe().
>
>Fixes: cc21191b584c ("dibs: Move data path to dibs layer")
>Cc: stable@vger.kernel.org
>Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
>Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust


