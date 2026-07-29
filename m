Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FBA2C2360;
	Wed, 29 Jul 2026 03:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297527; cv=none; b=OYRhJKbusZq7vCCmhfeUTXmUsBepn6JLHWQkfDwK2xJGLMXkD3SkbA9HNgTzCJPPNfHRct+py5Fj2bJJnB1qX3+37syxwaZgY1ztSgvwbcZ/FJbpQ4OvFinUvusr+GLBFLKN0Tcs/UvzYTSEcDLOT+4KYeGXAkvoot+XPV/afM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297527; c=relaxed/simple;
	bh=ujwc+OPhF2yEkrTBSYTWy3UnAhazMeMxXb4E93z7aic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRNO456lq+SI3wPqbvrtDNsR0XN1uRYbGQskL3lq5s5Lz6Bc5h3Cwi8Rb/ebaRdOu3vIPLrZO6lE0xFFFZLEF1IZcoEmG46KZGjylLDK6H+/hvengxpzRUYugQ449BRg2AxhzM7/Aa3MhWDUr6B212Pa5/bV3Hj0ictumngxbew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JHPDBZ6o; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JHPDBZ6o"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785297520; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=ujwc+OPhF2yEkrTBSYTWy3UnAhazMeMxXb4E93z7aic=;
	b=JHPDBZ6o6wwszK0ieyU2A1ZBpctJs9El6tnvIAbXwLKSrCmdmU/AfwvDZXkbj4mh34T114/Do+vG+e9P1iVsdIAFHDznVTFg/HHl+gbPiEQuYzpvylS+B/DhMOvfl24Ha/zDm4iw7StkSbx71OSUyEapFZMGn+bWIHqwBb5fMKg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X80trhv_1785297518;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0X80trhv_1785297518 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Jul 2026 11:58:39 +0800
Date: Wed, 29 Jul 2026 11:58:38 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: hexlabsecurity@proton.me, Tony Lu <tonylu@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: Hans Wippel <hwippel@linux.ibm.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	Wenjia Zhang <wenjia@linux.ibm.com>, linux-rdma@vger.kernel.org,
	Ursula Braun <ubraun@linux.ibm.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net v4] net/smc: order the CDC receive path against
 buffer publication
Message-ID: <aml6bmRRgDVznjIs@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260728-b4-disp-52ee4e7d-v4-1-0dda94b0f397@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-b4-disp-52ee4e7d-v4-1-0dda94b0f397@proton.me>

On 2026-07-28 11:52:53, Bryam Vargas via B4 Relay wrote:
>From: Bryam Vargas <hexlabsecurity@proton.me>
>
>The SMC CDC receive handlers dereference conn->rmb_desc, and on the
>SMC-D DMB-nocopy path conn->sndbuf_desc, but both are published after the
>connection is already reachable to a peer: rmb_desc once the connection
>is in the link group's token tree, the nocopy ghost sndbuf_desc later
>still, in smcd_buf_attach() after the ISM receive tasklet is armed. A CDC
>in that window hits a handler with the buffer unset -- a NULL dereference
>and host DoS -- or, on a weakly ordered CPU, non-NULL but not yet
>initialised. Both are also published before the receive state
>(bytes_to_rcv, sndbuf_space), so an early CDC's accounting can be
>overwritten by setup.
>
>Initialise the receive state first and publish both buffers last with
>smp_store_release(), consuming them with smp_load_acquire() and bailing
>while unset, as the handlers already do for a killed connection. Gate the
>whole sndbuf consumer trigger on the send buffer, not just the nocopy
>accounting: smc_tx_prepared_sends() and smc_tx_pending() dereference it
>too. Conforming peers are unaffected.
>
>Fixes: 69cb7dc0218b ("net/smc: add common buffer size in send and receive buffer descriptors")
>Closes: https://sashiko.dev/#/patchset/20260714-b4-disp-835288a6-v2-1-581555ef2145@proton.me?part=1
>Cc: stable@vger.kernel.org
>Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Hi Bryam,

Thanks for finding this corner case !

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust

