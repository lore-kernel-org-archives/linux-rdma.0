Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0B230F545;
	Sat,  7 Mar 2026 17:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772905099; cv=none; b=egnWsVSx4urLlklNGzvMUad5+Na65cUq69KZyAd0By/tPkIfeYt5eVIO1oBcDZ/I1BCEOpqE/sHBcMvdK434Ba/I25KuSRk8d6qYfZidlZ7PcA9Gqv+lxMGrytlMqtaD69mpX556LL/od0zc+kHaUni7DxguJ1siR4szrcnHZRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772905099; c=relaxed/simple;
	bh=t7qdO9corSfNTkZPrumwwSolizuoerkE8WBeCc0vSxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLYgkGP4CSByhhgLnBui7kHiSG+MI4Ahh+40OgexBDOd51HmYFIJ0d+a9GbfzJyFzGkQYE5FbWryjVgwAkaLZO2eFCwmcXeuDPJcR03Rte4UgE291hz4XvXFSQRo/RbvpEHZGwb/NhfxzysZXoBTAa+VGGyyKO75OcHc6dUyIPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRFxMARI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRFxMARI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B553C19422;
	Sat,  7 Mar 2026 17:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772905098;
	bh=t7qdO9corSfNTkZPrumwwSolizuoerkE8WBeCc0vSxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZRFxMARIJYSzQ4/pC47IjJE1JISAHrDyeTDYyXdZRpsxofeWOqeTSwsssyCPUU0Hr
	 OxgMQXI0n0ipLpC/IubZHWPh7Gmk+pxcsLyQNG/w58fj9h4CFAVQdNKn4PXYTz/Ymu
	 xECw/diZ4y/WoU9mEXlpFK2czG49Jyedma1XOuFjNxXFpNqHg4HSCQFnTCG9vQd4j7
	 BXyrs5UtMyWhkjaxo0vGfWAfjam0kJEv9zkybXe8+m7dz/zhpqpRMTdMtbn/1o94XL
	 lNZEhQVnJCZUNVEQD78/d7Ynita/mLfIlyEODnK2Ir5JVE4HcTjn8a6Dnsdkks1XmY
	 /9qEvcVDTwSMQ==
Date: Sat, 7 Mar 2026 19:38:14 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Simon Horman <horms@kernel.org>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH rdma-next 0/8] RDMA/mana_ib: Handle service reset for
 RDMA resources
Message-ID: <20260307173814.GN12611@unreal>
References: <20260307014723.556523-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260307014723.556523-1-longli@microsoft.com>

On Fri, Mar 06, 2026 at 05:47:14PM -0800, Long Li wrote:
> When the MANA hardware undergoes a service reset, the ETH auxiliary device
> (mana.eth) used by DPDK persists across the reset cycle — it is not removed
> and re-added like RC/UD/GSI QPs. This means userspace RDMA consumers such
> as DPDK have no way of knowing that firmware handles for their PD, CQ, WQ,
> QP and MR resources have become stale.

NAK to any of this.

In case of hardware reset, mana_ib AUX device needs to be destroyed and
recreated later.

The same is applicable for mana.eth as well.

Thanks
