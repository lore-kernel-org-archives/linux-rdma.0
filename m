Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4123DDB00;
	Tue, 13 Oct 2026 12:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893094; cv=none; b=ELmP6PW8Ivt0tiqkN3yFK72f/DB0S4bjpME3HPyhWPY6Qwk6YFRI6aRhN6+w5/QsvT1GOot7D5zzKIEzUTyV0cnWv5xlPx2eo5ouGVwS04hNw709sypUkoxecvl9+nW9ZMREOzMhVqpfMJ5zMRm/1VrMF0BbJDX+1Ojy0Exq2BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893094; c=relaxed/simple;
	bh=cO+fSJ0EIFyvTMEQTmUZIyuJVVUTh0TgRx989RdcJs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bwutjab75778LtWp2ECRh2H5SiLBrZhHtMCo+Ki2ukdHWNyIPSBUkgp6L7CDepZf3a4CVBqMO8x99I+pdMJW3HOpxTON/ZjpKSXmrwH8s/sdLbk/3jxfm4v5pTC49WEfa6gn0rjFWjlUfJnia0f5fWzrxB3A7ogQxjbiDNW0E48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=If05iqav; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="If05iqav"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791893089; bh=cO+fSJ0EIFyvTMEQTmUZIyuJVVUTh0TgRx989RdcJs0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=If05iqavEq7nfao+oBOzc1o5NBIr4GPq8c9Ox64YePM8/21THdAzZ/lkAmMGDsWMg
	 9C5aNkqRyNZvaS93DsYs+CA7ihfx11vjy8kHCEXJUNTYUrv9NVwL6KpVZRdnHXEexN
	 ySpKF8U0pyBx8sLpQn7rOTboPpE2W96wtxiAbtkv74zwNVWBdvFGH4HIZrY48hgE9f
	 wZ/yBv8CguV4Ic96YtU59rf8u/qppYm8oCAmyM3PTX1vhfxXpUdT1v2obxTK4E4mAZ
	 DEPMbzs6C6SkMeWoZxpHRDCYjX0c5xN5i+2duTBnIO7r8IBSt3Drblk+ApD4NnoBvf
	 2lOe04dqwp0Ag==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 9F96F44C2B54;
	Tue, 13 Oct 2026 14:04:48 +0200 (CEST)
Message-ID: <25a7141a-7c98-4678-8f17-374e920aad6b@corp.free.fr>
Date: Tue, 13 Oct 2026 14:04:48 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 0/2] net/mlx5: HWS, fix reformat release and meter
 offset
To: Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261007143830.1733583-1-acassen@corp.free.fr>
 <d19cbf9f-a5af-4fe5-9c20-eac1365afb92@redhat.com>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <d19cbf9f-a5af-4fe5-9c20-eac1365afb92@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 12:39, Paolo Abeni wrote:
> On 10/7/26 16:38, Alexandre Cassen wrote:
> The actual impact is not clear to me

Both bugs only affect HW steering mode (opt-in). I found them on a 
ConnectX-7 while offloading multiple tc rules, each with its own encap 
and meter.

Patch 1 is a leak. In an add/del loop of an L2 to L3 tunnel encap, every 
iteration after the first leaks a bulk of 64K entries. That is about 2 
MB of host memory and 4 MB of device memory.

Patch 2 is more serious. Every tc police action past the second one runs 
on the meter of another action, so its traffic gets the wrong rate... 
(my use-case is mobile network where counters accuracy is truly important)

The fixes are tiny so I would prefer net. But net-next is fine with me 
if you still prefer it. For our production systems we will run this 
patchset.

Yevgeny, Moshe, you know better than I do how widely HW steering is 
used. Feel free to amend.

-- Alexandre
