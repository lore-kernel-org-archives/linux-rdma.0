Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793868901;
	b=FhP0yLEp251+gx4yTUOtJdE4BGgDTHpKA9XYzNivIy8m7kf5IJp8vKlN4Cb5eklUylGy
	 djTNv+cJLDU3Z7xzf9SRr3s/puX98ji4i2Wh0asmTLJeSYESCFpc4vQuAflRGE4R+sUeh
	 gvlpoGEZTzCPIjYWwyIQWHRqQLZkpPT/EzqVt+Ax3aY51AOFR2c/k1ryAcwromgbPbCUJ
	 FMVe6yal9JVzzKBArm2SN2SmK2WtZt3Z2M9uT4UyCkXSZo+nLfc0HRmfekTRtAZv19kWK
	 HncZroXQBGnWDlsM2qkf+1tu4/hQv5HS6lVrr+rsgidVs9AP9hZI+02w3X9DpzMlxow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793868901;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Date:From:To:
	 Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=tLitCl0VEuwGphljrXsGB+0zDpgukEGa28T33owqfkw=;
	b=FnpauW+LIB8s0MfqeEr/kgsWhMS6+9Ez1yOsFXw350LQ/g8+ovxnR1HTwmiRr2b3x2Xc
	 9sOGub7THqeqMHVdnvphPHltvmVQZJWjrlozLm/1YaClib+m8oU/07zU6werTcbhi5OLd
	 IhvnGxwT/9wruYzWztim2ynVlfxcf32UrRYsa75W4dnhRzerm/pbOBzhd5MfGHQz7/u3o
	 2CZv7WjD3bdhQcWTIcbU7tAfhE/37FpGJ9ueXbx5Am2rP6aIfDCBVWErADXTn6014+Zf+
	 1NoLIeeIUzZIRhXQ/R+a8HhtLMvZPr2Tv8t7LLUsGyrRXilJbLehAfWqvWZRlsm5W/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584EC606A32C;
	Thu,  5 Nov 2026 08:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 584EC606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793868889; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=tLitCl0VEuwGphljrXsGB+0zDpgukEGa28T33owqfkw=;
	b=rhTDPCjRrM3oFa6imoMwt9ywyUXlQpncO5M1hNrLspTO6M0AmcB47wOCzMakNu44FLfE244xLhdGfbA9+sXUi23sRoLkyNWfvtCBimbXLeB4scQn/SRFYC+KWupaDcTDVxKvkhnS4/q9JtbF37oAM7axilUDkqkExsi8x0Scu08=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XE86VIg_1793868888;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XE86VIg_1793868888 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 16:54:48 +0800
Date: Thu, 5 Nov 2026 16:54:47 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Wentao Liang <vulab@iscas.ac.cn>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] net/smc: deregister the MR when SG mapping fails
Message-ID: <auxEVwAk8Zu4j3w9@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20261104022812.1484233-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261104022812.1484233-1-vulab@iscas.ac.cn>

On 2026-11-04 02:28:12, Wentao Liang wrote:
>When smc_ib_map_mr_sg() maps fewer entries than the SG table holds,
>smc_ib_get_memory_region() returns -EINVAL with the memory region
>still allocated and its pointer left in buf_slot->mr[link_idx].
>The caller only undoes the DMA mapping and frees the SG table, and
>because buf_desc->is_map_ib[] is set only after this function
>succeeds, smcr_buf_unmap_link() later skips the buffer.  Both the
>MR and the pd->usecnt reference taken by ib_alloc_mr() are lost.
>
>The stale pointer is also harmful: a retry takes the "already done"
>shortcut and treats a memory region that was never mapped as valid.
>
>Deregister the memory region and clear the slot before returning.
>
>Fixes: 897e1c245773 ("net/smc: use separate memory regions for RMBs")
>Cc: stable@vger.kernel.org
>Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
>Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

For the patch itself,

Reviewed-by: Dust Li <dust.li@linux.alibaba.com>


But checkpatch.pl failed with the following errors:

WARNING: Non-standard signature: Assisted-by:
#66:
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex

ERROR: Unrecognized email address: 'DeepSeek-V4.1-Flash and OpenAI
Codex'
#66:
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex

total: 1 errors, 1 warnings, 0 checks, 12 lines checked

Best regards,
Dust

