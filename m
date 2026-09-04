Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D985D3F12E1;
	Fri,  4 Sep 2026 15:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788537178; cv=none; b=Yz3Xu1r5IISq6uQNCKTZpIZTEEn9lIB0/lP7x0staLxA0AqO3k3nHFu9uXZ0aVJLg4dxfOUP6+JNolRmYn0YF9R33kaUkmq7OXKXk6kaqXDRRuq56dCA324Ap53VFsUAuWMw1XSyOEn1+5KIzmQGFMiNA6RTa/hLUrDF93sgwgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788537178; c=relaxed/simple;
	bh=6aXEIh0nVLqf6nBIQBd3bsGcWjI4db2mAJ4V7gvbLkM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOyma1ksiDszklEO/UGBl6y+Dsg9XPLNT/9SRNN8HWgY3fpRWHqlEJjLU8IK6uGsu5VXFxr7Zn76GtLtSMArU+9+93gZ9zfnJUdXBIHXW1P7sdNFKlSyHqUbzsBx64U69HZbPZEX1lxuzJIAz27IeeRw5WOJZ3EIdlAwP+6dBKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lu4UmkNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lu4UmkNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39391F00A3D;
	Fri,  4 Sep 2026 15:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788537177;
	bh=u2oLYs1FtIYJEdaun7KIOHg8ykrkHldobLNztByHgCQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Lu4UmkNr8zxKIPgpUbQKQ7K3zrtr6/7DXEOe2ABgUaPpPo/DZqVnsxpytb4jW36+g
	 3WjUoM3z7qLQIYfx5PXSBwVzmYlvyfRs57j2jzRCD+XpdHi1NByy8yqgOCo3EJ842U
	 6elGqW1fbUFf9ednNV7WRDAI8UFsMbh565D9qozp5YwZgEQcSw8w66/AdaORpFQViK
	 JS0njOWHLoFlygyEJCgBv/39SJ3ixtwE6ApcuvcyVarscPlH82Z+yARxmVA0HEa/wc
	 MibU4eKNO7JfK2WZ99L8IwhLPNO22U7NZNHLMx+EdJ5BDgLKmt1QiBoTCgPbS+mR9a
	 RKQXRDe83UHFw==
Date: Fri, 4 Sep 2026 08:52:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc: leonro@nvidia.com, jgg@nvidia.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, andrew+netdev@lunn.ch,
 horms@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, Sachin Holla <sachin.holla@broadcom.com>, Vikas
 Gupta <vikas.gupta@broadcom.com>, Dharmender Garg
 <dharmender.garg@broadcom.com>
Subject: Re: [PATCH 03/15] bnge: reserve TX/completion rings for the RoCE
 MPC channel
Message-ID: <20260904085256.11d6098c@kernel.org>
In-Reply-To: <20260904104328.763768-4-siva.kallam@broadcom.com>
References: <20260904104328.763768-1-siva.kallam@broadcom.com>
	<20260904104328.763768-4-siva.kallam@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  4 Sep 2026 03:43:11 -0700 Siva Reddy Kallam wrote:
> @@ -293,11 +309,12 @@ int bnge_reserve_rings(struct bnge_dev *bd)
>  		hwr.nq = bnge_nqs_demand(bd);
>  	}
>  
> -	hwr.tx = bd->tx_nr_rings;
> +	tx_demand = bnge_tx_rings_demand(bd);
> +	hwr.tx = tx_demand;
>  	hwr.rx = bd->rx_nr_rings;
>  	if (bd->flags & BNGE_EN_SHARED_CHNL)
>  		sh = true;
> -	hwr.cmpl = hwr.rx + hwr.tx;
> +	hwr.cmpl = bnge_cprs_demand(bd);

This if nothing else has a solid chance of conflicting with netdev.
Please put the first 3 patches in a pull request so that both netdev
and RDMA can pull that. Once it's pulled post the remaining 13 to RDMA.
