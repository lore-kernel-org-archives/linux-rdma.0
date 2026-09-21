Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39C332B99F;
	Mon, 21 Sep 2026 08:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978731; cv=none; b=uNLGLDSV9nXNg6U6ns3NvGvhkl4yPIJvhk4i9VxjuZeN6+GpK1PKDYJvclWlzsOJqXje0ToZEU/wBy8FDAK+71QgfxnzLn3jUQ+ASOXNH3q881cP5XAnl/DDqal53ywV3/T0S040JCU3USP8v7YK6zTe3ksF1chWFWn3t5OCa0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978731; c=relaxed/simple;
	bh=RXTEADUxNX25XHvmq+nNeN9InOurCYmqz8LkG2CvSuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hAEirfJayAH7z/A1CqOLzpWYx+/tEnMdDzwyeqZLP0twruuaeQbNezTLAWpz+2CByObu4gGXEOrs4V0hGd60vbIUQKJHimuKbdpg0hTG/83L9Gkg672PA7Bz8qx+dab1Afls5yYAWkPejJMcya1r1V4F14230l3Ii8B4frN+0H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sbJ2exZT; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sbJ2exZT"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789978718; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=RXTEADUxNX25XHvmq+nNeN9InOurCYmqz8LkG2CvSuI=;
	b=sbJ2exZTXy8w9D5U89S9YZ6tyhAF1tLMF2xDG78R0EYMigR21OibuhoMr1WIjVS1kmRJPBxU7rn+9qmVsShcgXGw11DV14sQmHkVNXQxRSRwH+8mXvjXQe7KvKDJLIKgI3h8MTDVd+k/5MPxa6DVt0W2TWv2HoPqxGLqMJglovY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XBKlPHT_1789978717;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XBKlPHT_1789978717 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 21 Sep 2026 16:18:37 +0800
Date: Mon, 21 Sep 2026 16:18:36 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Wentao Liang <vulab@iscas.ac.cn>, alibuda@linux.alibaba.com
Cc: davem@davemloft.net, edumazet@google.com, guwen@linux.alibaba.com,
	horms@kernel.org, kgraul@linux.ibm.com, kuba@kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, mjambigi@linux.ibm.com,
	netdev@vger.kernel.org, pabeni@redhat.com, sidraya@linux.ibm.com,
	tonylu@linux.alibaba.com, wenjia@linux.ibm.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] net/smc: Fix socket use-after-free in smc_shutdown()
Message-ID: <arDoXGUu5ve2oew4@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260917163956.2162779-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917163956.2162779-1-vulab@iscas.ac.cn>

On 2026-09-17 16:39:56, Wentao Liang wrote:
>In the fallback path, smc_shutdown() drops the passive closing
>reference on the socket with sock_put() and then still uses the socket
>by calling release_sock() at the out label. If that reference is the
>last one, for example because the passive closing reference was
>already consumed by an abort of the active link group, the socket is
>freed while it is still in use.
>
>Move the sock_put() after release_sock() so the socket is only dropped
>once it is no longer used.
>
>Fixes: 1a74e9932374 ("net/smc: Fix sock leak when release after smc_shutdown()")
>Cc: stable@vger.kernel.org
>Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Hi Wentao,

I think the patch makes sense. But have you reproduced the bug successfully?
I didn't find a path to trigger this bug. If you can give more details
on how this would happen, that would be better.

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust

