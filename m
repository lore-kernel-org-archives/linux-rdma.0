Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795493778;
	b=ddJbAKN8hGHuXJYQTaPw+G41OJHb/WUvuVJ2k8k5QwbdihjfM8+JJStzL2owpgQy69Dg
	 gY1l+68dVGIyR184bvKBX2k9sHIhn+/1cB67KFfKBbH/i+QNh86Tr2g6Gi96L/9jSACTn
	 Ww6jbzNHX+G3OyHmiGxfglpIgw8/FRbyQirz97TsK7ZPRio2OYa18WoxTHIjygAjfzgwk
	 Ucf7Hc/PVMWuZ2aMXMQ+ZO3aHxqqZ1/zViOUSeP5nP9keP83sQA/WvMnXHJbANjtOAXvo
	 tXho7852Rq99KLfzklnlvSG4NC2TJQjOiYfnoNEeyEluft/4tPh8lQ1KvC7tVfzpgSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795493778;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=lzo3DG5jQeTIv4tq9t9/JrbENZSwl8CcGGmhioRYcrU=;
	b=eYRcCdCMweZclPyMDxcBbY11j//87vlEG5l4s1ZlpG5wP62DW6LpAVgs1UMXNSSWHLXQ
	 Vb7AZE/OcCLczyBcqTF8FutNsC9q3hgmnXcYr+EXIhZ6Ng5AG5e3K/92pimI0zuMtbZQo
	 LP/oLKfo+hVJCJuv+3Y99q0e6RIamkza4H2s7zt6G87hs5IATwdjcRo+elXqF00qxexA3
	 buInI/sQv1uK8u1r9o2uCSDOBxXyfyNFXj2zI/Wgg/F6C6FGrD8gi8I5Vx3LINMZIl3Zo
	 BOu+5cWloeSewfTiGdVF0wGmL9a+CimJKGMLCfKISVz8ro+Y2qjjprDQx4EORuLZkZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hCG1Iuvl;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31CB606A31E;
	Tue, 24 Nov 2026 04:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A31CB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hCG1Iuvl
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795493765; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=lzo3DG5jQeTIv4tq9t9/JrbENZSwl8CcGGmhioRYcrU=;
	b=hCG1IuvlAO6dqN5GWiermX8FEFidFsScHIwp8f+axgVckTMACxeofD4a7IcGSSEU5iCFgekwB4CZE8iPuuMFOBw7+dlQ+s62Kw7x+W8IiJ1FcH/Gh0Kt7mVpK5PaQ2+sssz/Hr451NihhicLgZiT89HHDWxw2BE/Q5jMOTvV1hA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XFNAltz_1795493764;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XFNAltz_1795493764 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Nov 2026 12:16:04 +0800
Date: Tue, 24 Nov 2026 12:16:03 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Qican Ma <goonsomeway@gmail.com>, alibuda@linux.alibaba.com,
	sidraya@linux.ibm.com, mjambigi@linux.ibm.com
Cc: tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/smc: validate peer CDC cursors against buffer
 bounds and window
Message-ID: <awUPgw3EGv7ATYRS@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <CA+OT+ON4Lt9mLvWPK8rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+OT+ON4Lt9mLvWPK8rUaHKZ01_p0fGCiCsWHwXWzT1sGaTtLA@mail.gmail.com>

On 2026-11-23 19:21:01, Qican Ma wrote:
>smc_cdc_cursor_to_host() only checks cursor monotonicity and
>smcd_cdc_msg_to_host() copies peer cursors without any validation. Neither
>verifies that prod.count < conn->rmb_desc->len or
>cons.count < conn->peer_rmbe_size, nor that the resulting cursor deltas
>stay within available buffer capacity. A malformed or malicious peer CDC
>message can therefore:
>
>1. Drive conn->urg_curs.count past conn->rmb_desc->len in
>   smc_cdc_handle_urg_data_arrival(), causing an out-of-bounds read from
>   conn->rmb_desc->cpu_addr exposed via recvmsg(MSG_OOB).
>2. Inflate conn->bytes_to_rcv past conn->rmb_desc->len (either via an
>   out-of-range prod.count or repeated wrap increments), causing the
>   second chunk iteration in smc_rx_recvmsg() to copy past the end of
>   rcvbuf_base.
>3. On SMC-D dmb_nocopy links, inflate conn->sndbuf_space past
>   conn->sndbuf_desc->len, causing the second chunk iteration in
>   smc_tx_sendmsg() to write past the end of sndbuf_base.
>
>Decode incoming CDC messages into a temporary smc_host_cdc_msg and verify
>both cursor offsets and their deltas against rmb_desc->len,
>peer_rmbe_size, and (for dmb_nocopy) sndbuf_desc->len before committing
>the update to conn->local_rx_ctrl.

Have you checked this patch ?
https://lore.kernel.org/netdev/20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me

Best regards,
Dust

>
>Found with an LLM-assisted code review tool and verified by inspection on
>v7.4-rc4 (b6a9fa34ce4). Build-tested only; not runtime-tested due to lack
>of an SMC-R/SMC-D setup.

You can test using SMC-R & rxe + veth

Best regards,
Dust

