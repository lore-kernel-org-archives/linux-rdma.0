Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F244219E9;
	Thu, 24 Sep 2026 07:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790233712; cv=none; b=FKj+XhSHo7368zq46BUShKWODxyhcZGvlU36zIz5m1MDG1GYOLdLUsxK2ykn8U1nBsChxC27PXUdJkkGyn/B816RafxA5oX8X8rZnY6HBILg93bM9Fjz7OWnfRTQEvYnN0/mrK+BJULM9tF6QbWhBqbGz8m9IE6Akws+ls3Kc2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790233712; c=relaxed/simple;
	bh=Pj8QZuhX7zL8FbRPhKbOman45+doOXsmiYx7vsHjCug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUWwLgJu6hh0SZgGSdcRZjVR0HAsEj0a7ASG1d13TsWCzw+PiSB9+E3wm5yNYN//Oc1TtZ9Ok//U2ohCIpVdne/qLqMJ3p0/cpG18NmvhraI0R4cGjK9QSgqQpqXGPpk/QEXKUUwG6k8Z9xP59lQeCmTb4Vf4MgO3QD8YzsZhsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FPIoXgev; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FPIoXgev"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790233699; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=12U977ysKNEl4YLfINNPXdfDolOJLcVH87xgT48w/JM=;
	b=FPIoXgev1Tbw8YuyCgA+u57JDZ//gFGaYA6L+uT4Ea6ETex2Nq/aDBpvavLkwAQumz9o/z9zU1n8IXCc0raOU0ZLQ9OTrq8ysMiNT2X+fuL2Bmn7QSWaLPwVjkBT/PiWECFN/Q1N5Vnvzk1SgckCTTKRtHBM1Bi1PA2rIRmYv68=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XBYyN9b_1790233698;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XBYyN9b_1790233698 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Sep 2026 15:08:18 +0800
Date: Thu, 24 Sep 2026 15:08:18 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
	tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
	stable@vger.kernel.org, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v5] net/smc: fix lgr/lnk lifetime vs diag reader race
Message-ID: <arTMYu7oIByxPm8y@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260923061716.1970059-1-mjambigi@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923061716.1970059-1-mjambigi@linux.ibm.com>

On 2026-09-23 08:17:16, Mahanta Jambigi wrote:
>The diag dump walks the socket hash table under a read_lock and dereferences
>conn->lgr and conn->lnk. Two terminal teardown paths drop those references via
>smc_conn_free() while the socket is still hashed:
>
>  - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free()
>  - smc_close_passive_work() -> smc_conn_free()
>
>This allows the diag reader to dereference a freed lgr or lnk.
>
>Fix it by unhashing the socket before smc_conn_free() is called at the two
>terminal teardown sites in smc_close.c.
>
>Additionally, smc_conn_abort() calls smc_conn_free() during early handshake
>aborts while the socket remains hashed in SMC_INIT state. The
>smc_listen_out_err() path leaves the socket hashed in SMC_CLOSED state after
>smc_conn_abort() returns. Guard the conn/lgr/lnk inspection blocks in
>__smc_diag_dump() by skipping them when the socket is in SMC_INIT or SMC_CLOSED
>state.
>
>Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
>Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R connections")
>Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>


Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Best regards,
Dust

