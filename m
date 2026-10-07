Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE2734B40F
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 18:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791398210; cv=none; b=em5FzSCaCGjrTBi1L9bTuDL9uHUKZY+ZChNvFB5lUb5VurrbNfR9dhZl3my7FWbjn66OI8grIMoEbjvgV+PRUeBZfVFHxGMuX+yIg3GVzFMTP2nxarI6BZVQLHj1Vfvc3EzVAvM/BXjnvBf9jLIover0b6HMQQyXVoxWk1j4jeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791398210; c=relaxed/simple;
	bh=JrLa3HexNJbbVKnunxiIgrli+e3/+0NTV8uujfvINgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H2EG50UYce4pgdCQVcCkJDfqVkl2z4soZw9SL7R3BAEcQ6NwEWgFF9n5MrWebfVesMy6T1I1eI680PAQTITi2tL5KeIPVg1aCXpd3E914F60wg6wwOL47fuyZ2bupaXH+KqjmWlOa9jEdKVuzDGo/PhN5sXxAJMvPWAVgTV2h50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T45ZHqlG; arc=none smtp.client-ip=95.215.58.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T45ZHqlG"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JrLa3HexNJbbVKnunxiIgrli+e3/+0NTV8uujfvINgw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791398204; v=1; x=1792003004;
 b=T45ZHqlGbp1VI7HCvHR3VBtFRdK+pj1I4SnuK2NHtgO9ecDDv6MJxWvyT8bRzGs0vClu9TIP
 vYruKJ6FSymNkpxCEaAbI26J2k3AagoXnjcHHjvvGZBLx33vFf9M2jM3bBTggIvAmtkB8arOdox
 Xu4/Z0XRV6+uH4EtubgM6x5I=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c47590e99ebdb691;
	Wed, 07 Oct 2026 18:36:44 +0000
X-Mizu-Trace-ID: c47590e99ebdb691
X-Migadu-Flow: FLOW_OUT
Message-ID: <92db8ba8-a77e-449b-b238-efcee90dad4e@linux.dev>
Date: Wed, 7 Oct 2026 11:36:41 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] RDMA/rxe: copy completer WQE to kernel buffer
 before processing
To: Tristan Madani <tristmd@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, stable@vger.kernel.org
References: <20260830191344.2026524-1-tristmd@gmail.com>
 <20261007163356.407937-1-tristmd@gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20261007163356.407937-1-tristmd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/7 9:33, Tristan Madani 写道:
> Hi Zhu Yanjun,
> 
> Gentle ping on this v2 series. The v2 addresses your review feedback
> from v1 — bulk memcpy() writebacks were replaced with targeted
> WRITE_ONCE() for individual fields and smp_store_release() for state
> transitions.

Please follow my advice to modify v2. I have sent my comments.
Follow Leon's advice, please send the latest patchset as a standalone 
patchset.

Yanjun Zhu

> 
> Would you have a chance to take another look?
> 
> Thanks,
> Tristan

