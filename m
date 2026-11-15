Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794734127;
	b=XPm2bby7Kfwoz9LSGb3by0cu8F85tSoTjXePa5gObumcrGzbPV/gHnyv9ead2CjJ2F08
	 DwSkV+Bzhn45x7J9ia8IPl8Hl14gnTIELid7ebo0mgbmfDNkURlY19Aw66X5za0rHMTfq
	 yOJyHkBs2atzbgGttCyRZ+i3bei4PQd/1wjnznw4osMpxUsN50israbvP2Ub76r2H2q6l
	 sGf+sHT0TCp/aU+BR5YekXw241rJ45+3YWxS3XrudoFgd6RVnmgu+A9eyDplUNDJcMZjY
	 8BMob4kwBwss0yHsvBovT40ngXG+DXi4c3BDILoJLz0TnLluzWm28/Uruyn9VG2r7WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794734127;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=5biTwganlbstyJybL78+tl6I7DrpousHi8Dt7rvXJuk=;
	b=ERh51APb7nWcLnZQN00G92rmpr0lMwK8seFNsfLq16kpGf8aFJyXgZe1z3hmaX/C+ttg
	 Q7If7mgCrWMInAqJkDqRPPjXusRCi3ZPOIP0w3O+Tee1qfiXU3/JaQIwu+Kb+F9CkVU4q
	 C7mRH5bdhs8lu+GvtzDdb1zWb/F/p83TkfGfAWZXO1Fgk7GGTjtLVrcpT/gy7wfvCAhOp
	 evcApbiL36wplX/AyEmimefVwxqtAsjy5z8q4NE/BRKt7S6uImETxhMJTawvM7J0xj7ED
	 LT2CqmJWhVJTFGZDVmZHlBcCcuMHaS8Hu7SjzOgZL9VdejZV0atAZTgot9o6/BphWlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=hyFzxpdu;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AF0606A31A;
	Sun, 15 Nov 2026 09:15:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4AF0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=hyFzxpdu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794734125; bh=JS9ETpJE8r0qzCNQTlwZSK4sKCDJAI4wEW50Q/BackQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hyFzxpdupagXyFnDRyMknaikVvhRatSXKBOR6SSM8m/qiRHjk62G88e2x+x6AAHIH
	 jcmFGmROSrapIQPtYVC2sbtma2v7TlG3R/lb1WfVct6PUt6kfAxBRZk8f3hvib8+hi
	 /80CWkwUQoJN16Mar1y57t4fLF11jTABcK4R7FixMzBzA3tp/JhGfhFihiuql/ILqT
	 p2kxNlMR4Ajm39axUAzp7xI57otjj2F2IsSm1B8weH90854zzZI+LTqPNKj6e4QgDT
	 RmLSXTRWGlY0WknWKOJELvmWIIVIpXj/yK4lYhIViBulrcIUP62ZzJqAxhY9YdkATc
	 paHjSKcEvka9w==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 70B2644C03E2;
	Sun, 15 Nov 2026 10:15:23 +0100 (CET)
Message-ID: <ce9ba19e-14d7-44c3-bda4-83cf5f90a6fb@corp.free.fr>
Date: Sun, 15 Nov 2026 10:15:22 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 06/10] net/sched: cls_flower: add enc_key_id mask
To: netdev-bot+sashiko@kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, bharat@chelsio.com, donald.hunter@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 dsahern@kernel.org, idosch@nvidia.com, shuah@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 oss-drivers@corigine.com
References: <20261109131039.959438-7-acassen@corp.free.fr>
 <179442432794.2199510.1364864921481333835@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179442432794.2199510.1364864921481333835@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/26 20:12, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Medium]
> The commit message says truncating the mask to a 24 bit VNI is correct
> when the key fits the VNI. The earlier patches in the series only check
> the key. Doesn't that miss a mask with no bits set in the low 24 bits?


On cxgb4 it does. The truncated mask clears encap_vld and drops the 
tunnel match. v2 of patch 2 refuses such a mask.

mlx5 and nfp keep the tunnel match. Their VNI mask becomes zero and the 
rule matches every VNI of its tunnel. The software filter does the same, 
because a VNI has no bit above 23.


> Should i40e_parse_cls_flower() and iavf_parse_cls_flower() reject an
> enc_key_id match with -EOPNOTSUPP, at least until firmware support for the
> tenant ID exists? That would stop the offload from appearing to succeed
> while ignoring the key. It would probably fit best as a separate fix.

Agreed. It predates the series, as the commit message says, and belongs 
in a separate fix for the Intel drivers.

