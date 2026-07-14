Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21326145B3F;
	Tue, 14 Jul 2026 08:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784016316; cv=none; b=liisoo5PEsFDLtgoRbQ06ewCYIlpe9yBgYiQbrURzcuCiUAKbWfFgCJ3ybYfmOcYvOMhBUWzeAOMVwj0+a0yf+6n+VkC61QtSEH54nnNYp0c1J+LPD5qKT8Atv3A/uxG15Qd8mTWeYQzEH4KBb550/9bQpBIqEIFPOYnjHnAs9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784016316; c=relaxed/simple;
	bh=TiLVHWKy4mlkeS41lVKDXWkDRcTjPNnk1QZCzNu8HGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rhX4W4UOW2EzU/rDryAPeZ1l6QgUPBjj5rw7TCVEAdtZBK/5N01+zLdqBRbTgTptjX39gF2MkbkWwfYOn8zCW6kL1rC9hpoc9Bd7GruJujPvUV+sJVy/EJTGhMauulWzJMdMBuUEt5kjTQvzEmRU2RJVICd0N6eVJvhIg7pMR1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JAu2Ukq7; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JAu2Ukq7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784016307; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=XcY9oAzuAkEa1Ucn4QLvsDCT9v6MfjC/iYTifozKeGQ=;
	b=JAu2Ukq7luEl7zWZrpMjgntfqDBfZyrZWmAEHpV28RQ24dgSH+f/nTcJ4m2ZdOz7QK5MIIcVrGkdOChWFfR4V2uUQrq8v7rTGMPR20Fz+YJAoHn5N5E3QCnxnkYLRffRIP08j/C290j3CzJQWcEUD7nc2Y+PZ5v96dy5lAob590=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X73dCz._1784016306;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X73dCz._1784016306 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 16:05:06 +0800
Date: Tue, 14 Jul 2026 16:05:06 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>, mjambigi@linux.ibm.com,
	wenjia@linux.ibm.com, wintera@linux.ibm.com,
	tonylu@linux.alibaba.com, guwen@linux.alibaba.com
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
	pabeni@redhat.com, edumazet@google.com, sidraya@linux.ibm.com,
	jaka@linux.ibm.com
Subject: Re: [PATCH net-next v3 1/3] net/smc: clear the correct v2 slot and
 buffer in smc_wr_tx_put_slot()
Message-ID: <alXtstsR477AuKPD@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260710033356.16460-1-alibuda@linux.alibaba.com>
 <20260710033356.16460-2-alibuda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710033356.16460-2-alibuda@linux.alibaba.com>

On 2026-07-10 11:33:54, D. Wythe wrote:
>smc_wr_tx_put_slot() tries to reset the v2 pending slot and buffer with
>memset(&link->wr_tx_v2_pend, 0, sizeof(link->wr_tx_v2_pend)) and the
>equivalent for wr_tx_buf_v2. Both are pointers, so this zeroes the 8-byte
>pointer variable instead of the structure it points to. The pending slot
>and buffer are therefore never actually cleared, and the pointers get
>overwritten with NULL.
>
>Pass the pointers directly and use sizeof(*pointer) so the intended
>structures are cleared.
>
>Fixes: 8799e310fb3f ("net/smc: add v2 support to the work request layer")
>Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust


>---
> net/smc/smc_wr.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
>index 59c92b46945c..6b5add922993 100644
>--- a/net/smc/smc_wr.c
>+++ b/net/smc/smc_wr.c
>@@ -288,10 +288,10 @@ int smc_wr_tx_put_slot(struct smc_link *link,
> 	} else if (link->lgr->smc_version == SMC_V2 &&
> 		   pend->idx == link->wr_tx_cnt) {
> 		/* Large v2 buffer */
>-		memset(&link->wr_tx_v2_pend, 0,
>-		       sizeof(link->wr_tx_v2_pend));
>-		memset(&link->lgr->wr_tx_buf_v2, 0,
>-		       sizeof(link->lgr->wr_tx_buf_v2));
>+		memset(link->wr_tx_v2_pend, 0,
>+		       sizeof(*link->wr_tx_v2_pend));
>+		memset(link->lgr->wr_tx_buf_v2, 0,
>+		       sizeof(*link->lgr->wr_tx_buf_v2));
> 		return 1;
> 	}
> 
>-- 
>2.45.0
