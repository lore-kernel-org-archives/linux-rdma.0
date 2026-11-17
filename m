Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=12.32.117.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924562;
	b=C0KSiZq/fMcGV0VlJSC2CHTi/jSuxyjKX7y1kQ8zbnW7vIzzCbUHXeeQRNbLLg2zu/A6
	 7G2cj2r1nm6Heyw1sI/TyuJdsidr3VkM6bXxoj3HAAuxO2sMtxu/cMYJ9vsOvMU77R9B0
	 4yFHTEEVfxt3edGvxXUst8GLfpEk6iHyLcS/JcwERff3DDRUo4NI4AROdXQKLxVXf2htt
	 sFa/2EynRIeYlpmhRbJCGQPFHU5AZeWabvSjA0DIud9Q7G3Dzyf4qWqNNQv0jMFNJGFdT
	 lXbFV5kiORskamziaWjmFWSGy9kCeuM3bjUBr3g+FikqiAsEYPAbvWv8kty/ttS1nhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924562;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IS5A69DN3etoBCzAim4M2YEDkR7TO4KkrjqVc99lAhQ=;
	b=HrrNI7oLKOXTtM5UMkSipNVeygS0n4Rlh4KI6GYLx+R9BpGoLABVmTI6xNm8K2Z6TtyB
	 urghJUQ7J5vdnkG8pp/exDV4I4pchnZkcSS9U4yQKysVEt3GwPnS2SJLkyTCi3x8Vx20x
	 PplkRBjX1beTEO2YRDcY+Ekh2g2JHX4if0Rj56WjHe/PYLBbHT/5/sV9cWeLJi5tBX+Tk
	 nLIUr4HyKFB60qP46Rv3SxSde402I3aMJxHUip7Ewrv0J6W64Z6IzlyQdM848BoF85OgT
	 3YNU3qiahLDgl8aOIiWHXMy4vKcmUb9frLADzmRfuDjvkDNkrp63kY1g/1QQ2Kq54bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chelsio.com;
	spf=pass smtp.mailfrom=chelsio.com;
	arc=none smtp.remote-ip=12.32.117.8
Received: from stargate.chelsio.com (unknown [12.32.117.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C2B606A323;
	Tue, 17 Nov 2026 14:09:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37C2B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chelsio.com
Received: from localhost ([10.193.191.19])
	by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 6AHE5ZYp013372;
	Tue, 17 Nov 2026 06:05:36 -0800
Date: Tue, 17 Nov 2026 19:35:02 +0530
From: Potnuri Bharat Teja <bharat@chelsio.com>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Donald Hunter <donald.hunter@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next v2 02/10] cxgb4: flower: refuse a tunnel key
 wider than the VNI
Message-ID: <avxfDps1eq4i4Zj8@chelsio.com>
References: <20261117092915.255194-1-acassen@corp.free.fr>
 <20261117092915.255194-3-acassen@corp.free.fr>
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
In-Reply-To: <20261117092915.255194-3-acassen@corp.free.fr>

On Tuesday, November 11/17/26, 2026 at 14:59:05 +0530, Alexandre Cassen wrote:
> cxgb4 holds a 24 bit VNI and truncates the key and the mask of enc_key_id.
> An exact key above bit 23 already selects the wrong VNI. Flower is about
> to accept partial masks. A mask that only covers bits above 23 would then
> clear the VNI mask and encap_vld. The rule would match any traffic its
> other keys allow. Refuse a key that no VNI can match and a mask that
> leaves no VNI bit.
> 
> Found by an AI code review agent while auditing the users of enc_key_id.
> Confirmed by code inspection. The wrong match was not triggered. Build
> tested only.
> 
> Fixes: 98f3697f8d41 ("cxgb4: add tc flower match support for tunnel VNI")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>  .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> index 3307e5042681..467f055e318c 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> @@ -316,6 +316,21 @@ static int cxgb4_validate_flow_match(struct netlink_ext_ack *extack,
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID)) {
> +		struct flow_match_enc_keyid match;
> +		u32 key, mask;
> +
> +		flow_rule_match_enc_keyid(rule, &match);
> +		key = be32_to_cpu(match.key->keyid);
> +		mask = be32_to_cpu(match.mask->keyid);
> +		if (key >> ENCAP_VNI_BITWIDTH ||
> +		    !(mask & GENMASK(ENCAP_VNI_BITWIDTH - 1, 0))) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Tunnel key does not fit the 24 bit VNI");
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +

Thanks for the change. the 24-bit vni bitfield silently truncated wider keys and masks.

Reviewed-by: Potnuri Bharat Teja <bharat@chelsio.com>
>  	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
>  		struct flow_match_basic match;
>  
> -- 
> 2.43.0
> 
> 
