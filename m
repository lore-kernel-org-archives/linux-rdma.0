Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7F742086D;
	Tue,  7 Jul 2026 03:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783396594; cv=none; b=dNNuNzVOzrCnvhAxlHfuSIeoKYKtE6VgLPs53ItU4gKzW4YLg6f/NfMciRlpRpkpfW2fYut2B6zH3JAiHX3TuI8sdqjaDuBmZSUMtw25LhkcDfW3Kg7eK4OLcBQmfofqDYIpG6j6t3k3zyTM0qzSzBFPT9HVhsVDSFEEBkmHyYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783396594; c=relaxed/simple;
	bh=AH0x5XaXy0vIg0qhq+qAwESJKMn/Df6ORcuGRPEcxNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JMjylz9Ovnk9Xpql1fhyuk9qpaeC8vAdJlk6vkk7BRrGC45rR7MbM6hycq6C3UdQl1bmdMnU/p66t4c83i4HJwnGnuflRFigvmsiw3k8k5GtdPHL6saa2CRs5/UyR3oEkwVUebUM2MjNxDIRxQ1jJdU8HsJjxD37NavhQkycFVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LlakIQbN; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LlakIQbN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783396581; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=M4RVq49saWLjC2cfzHwMtl8WbBTa/nnpaGr8HOsnPv4=;
	b=LlakIQbNJhf2JQWChhZ0wz876tCXtu0xCIvHcz8tG2i8d5USKunPD8FXAMy0LuW8opJJ3bPjDHsGRRiLqeByteLJY7bO4BKjhjFL+ovP8ug6UbojUMy83l/0tkkqeO4wPUcoqbZJYYDrPN1zamZm9HQIk622W5rxaq5wFdc30t4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X6bdqfX_1783396580;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X6bdqfX_1783396580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jul 2026 11:56:21 +0800
Date: Tue, 7 Jul 2026 11:56:20 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: "D. Wythe" <alibuda@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, Simon Horman <horms@kernel.org>,
	Ursula Braun <ubraun@linux.vnet.ibm.com>,
	Hans Wippel <hwippel@linux.ibm.com>, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net/smc: ignore peer-supplied rmbe_idx and dmbe_idx
Message-ID: <akx45Ewt3iuhzCRI@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260702171137.1099051-2-dust.li@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702171137.1099051-2-dust.li@linux.alibaba.com>

On 2026-07-03 01:11:38, Dust Li wrote:
>Linux always uses exactly one RMBE per RMB (index 1 for SMC-R) and
>one DMBE per DMB (index 0 for SMC-D), so conn->tx_off is always zero.
>Hardcode these fixed values instead of deriving tx_off from the
>peer-supplied rmbe_idx / dmbe_idx in the CLC Accept/Confirm message.
>
>Fixes: e6727f39004b ("smc: send data (through RDMA)")
>Fixes: 413498440e30 ("net/smc: add SMC-D support in af_smc")
>Cc: stable@vger.kernel.org
>Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
>Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
>---
> net/smc/af_smc.c | 16 ++++++++++++----
> 1 file changed, 12 insertions(+), 4 deletions(-)
>
>diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>index b5db69073e20..3706e8ac49e0 100644
>--- a/net/smc/af_smc.c
>+++ b/net/smc/af_smc.c
>@@ -729,11 +729,15 @@ static void smcr_conn_save_peer_info(struct smc_sock *smc,
> {
> 	int bufsize = smc_uncompress_bufsize(clc->r0.rmbe_size);
> 
>-	smc->conn.peer_rmbe_idx = clc->r0.rmbe_idx;
>+	/* Linux uses exactly one RMBE per RMB (always index 1); ignore the
>+	 * peer-supplied rmbe_idx to prevent a malicious peer from setting an
>+	 * out-of-bounds tx_off.
>+	 */
>+	smc->conn.peer_rmbe_idx = 1;
> 	smc->conn.local_tx_ctrl.token = ntohl(clc->r0.rmbe_alert_token);
> 	smc->conn.peer_rmbe_size = bufsize;
> 	atomic_set(&smc->conn.peer_rmbe_space, smc->conn.peer_rmbe_size);
>-	smc->conn.tx_off = bufsize * (smc->conn.peer_rmbe_idx - 1);
>+	smc->conn.tx_off = 0;

Althrough we only have 1 RMBE/DMBE per RMB/DMB, but this does break SMC
protocol.

I will send another patch, checking the bound in dibs_loopback.c, please
ignore this one.

Thanks sashiko for pointing this out!

Best regards,
Dust
