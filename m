Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794732484;
	b=MC9vsDtKng6s4PWGe2W1GHMP/Ym1nFMv9D17wM5EpE4sbjW/7pC475ZMAQNB1kBmis+p
	 OJMbj4ceSj/oqLL6pS+fEjVxD8DwVwkNlC+ePKe0IzvxMyivqDnA1Gv8BG/wT30yEHeAR
	 Xwr3t8khXnu09aQXS/+7Ky3k+0YQW9lWe/+mYaPIA6/Nqx/rG/ycWpgJjH2uXVzz05EiZ
	 tuH6fxVJDupYTbimFk7sbghZ7tWavhUiFs/95AJcmATeepl3J+hKfryrpbr4oHFScpu8T
	 dQZ96GnHuEo5cf11OAsFP9lkYRBM75J5JewyHURdXKWpH7pAY1llCCaKqlfUbzt4rHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794732484;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=uPPg0EzF0XkV3FTMCRiVAvj2KrnUFtGRJ3oRND3vRZM=;
	b=JOGkSSfRdrWLgYMPVu+PbwFa819we/aVTE5bwkh3/UmIkt8AY+4lexzgOv030lpjBIwr
	 1ll/8AdO4q2n+9PruHm/FmkWWi3GghgO+To/BXFGsQaUOGwgEXVEDNiU+Lhk04GVlK8z4
	 r/MDvt1tHL4EQ3lmHE5QgbO0OJeDHu7l5pDluQjnEhj8JP42LmlINTc50Gg9/1M0J3ute
	 KlKC34hpBExyatQBSvxOk6uEw5Zx4DdPSTHZqjMH1tPxYWI9fTMVcyQAdKeLEo8maX36W
	 3OZ0LDh62kp7HzmuyVE0wV0RwHbakD7QA7QXNAaLQgpgItt9KV2/a/2D/lv7v5qTgOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b="hGMo/JPZ";
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD277606A327;
	Sun, 15 Nov 2026 08:48:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD277606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=hGMo/JPZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794732474; bh=5uvVqzK9P8/E9voTDvHAYhseKqu/N7Z++XtENzAy8bU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hGMo/JPZdze1z9fdRrRQZlUK+MI+GtaZzrBmpYzilOo88fi2nMw3VWkS0dfWsM2yO
	 GhPpv7EwlHuzVdlwmWl2s1dyApHzgR/qpEP2v2320Uobbiibp3Q+rUfWyFqepcgGsZ
	 LU6xxj4Mj2Z015MxYgwF/CiyXA8aqholFHvkzKRztYcrn8hcga6nhU8R3LSl226RdI
	 5hwdeU2FF9v+TIV8c8Dvea/2M7NAl1PCyTT404YipVKxdgX8uT/0fjKojXIyBlIxtg
	 DZmLyGufJ7QqQDv4nTa4zej3Mz7GuV/Hz116Oo6XMAe66bB73zIqTtqY+rJ9xe19wu
	 b1hJq0mhsH2+g==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 0584944C0202;
	Sun, 15 Nov 2026 09:47:52 +0100 (CET)
Message-ID: <8c5a16d1-5307-450f-9f83-911c871321c5@corp.free.fr>
Date: Sun, 15 Nov 2026 09:47:52 +0100
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
Subject: Re: [PATCH net-next 02/10] cxgb4: flower: refuse a tunnel key wider
 than the VNI
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
References: <20261109131039.959438-3-acassen@corp.free.fr>
 <179442431962.2199510.14986379471426017@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179442431962.2199510.14986379471426017@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/26 20:11, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Low]
> The commit message says the truncation can already be hit today. Should
> this carry a Fixes: tag, and possibly go through net?

v2 adds the tag, with matching ones on the nfp and mlx5 patches. The 
series stays on net-next. The bug needs a key that no VNI can carry, the 
rest of the series depends on these checks.


> [Severity: Medium]
> Does this check cover the case the commit message describes? It only
> looks at match.key->keyid. The hazard named in the changelog is a mask
> that only covers bits above 23.

No. v2 also refuses a mask that leaves no VNI bit.


> [Severity: Medium]
> This is a pre-existing issue and was not introduced by this patch. It
> causes the same symptom the commit message names ("The rule would match
> any traffic its other keys allow"), but it depends on the firmware
> configuration.
> 
> validate_filter() in cxgb4_filter.c checks encap_vld only against fconf
> VNIC_ID_F and the chip version:
> 
> 	    unsupported(fconf, VNIC_ID_F, fs->val.encap_vld,
> 			fs->mask.encap_vld) ||
>      ...
> 	if (fs->val.encap_vld &&
> 	    CHELSIO_CHIP_VERSION(adapter->params.chip) < CHELSIO_T6)
> 		return -EOPNOTSUPP;
> 
> It never checks that iconf (TP_INGRESS_CONFIG) has USE_ENC_IDX_F set.
> 
> In __cxgb4_set_filter(), the VNI is programmed only in the USE_ENC_IDX_F
> branch:
> 
> 	iconf = adapter->params.tp.ingress_config;
> 	if (iconf & VNIC_F) {
> 		f->fs.val.ovlan = (fs->val.pf << 13) | fs->val.vf;
> 		f->fs.mask.ovlan = (fs->mask.pf << 13) | fs->mask.vf;
> 		f->fs.val.ovlan_vld = fs->val.pfvf_vld;
> 		f->fs.mask.ovlan_vld = fs->mask.pfvf_vld;
> 	} else if (iconf & USE_ENC_IDX_F) {
> 		if (f->fs.val.encap_vld) {
> 			...
> 			ret = t4_alloc_encap_mac_filt(adapter, pi->viid,
> 			...
> 
> If iconf has VNIC_F, ovlan_vld is overwritten with pfvf_vld, which is 0
> for a flower rule. If iconf has neither bit, nothing is programmed.
> 
> set_filter_wr() has no VNI field, so tunnel information reaches hardware
> only through ovlan/ovlan_vld. In both cases the FW_FILTER_WR is sent
> without any VNI constraint.
> 
> On a T6 with such a firmware config, could a rule like "flower skip_sw
> enc_key_id 5 action drop" be reported as offloaded with a VNI match, but
> drop all ingress traffic on the port that matches its other keys?
> 
> Flower doesn't reach the hash filter path for these rules, since
> is_filter_exact_match() returns false when fs->mask.encap_vld is set.
> 
> One possible fix would be for validate_filter() to reject encap_vld
> unless (iconf & USE_ENC_IDX_F).


This predates the series. I can't test cxgb4 or its firmware 
configurations, I leave it to the cxgb4 maintainers.

pw-bot: cr

