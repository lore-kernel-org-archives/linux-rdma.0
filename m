Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC6619D8A8;
	Sun, 14 Jun 2026 00:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781397108; cv=none; b=kMDoKLmMlgFABR1vneW7csTwooW2VDhLfrq8/Ui8MKxOS0WC53729frXayOkPyg+3jr0uTs8KmDNF7yAdQyIREMinXv4hxACxsM4gF3Z6KO2kZbPJWhpey+ue427oY8ly9OafKkfsAet2wy0xGFgX6JNPIfiONW1IGhm2xX1N7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781397108; c=relaxed/simple;
	bh=Mrg+AevGtQ73XotzAA0Pea0ZqD504RAf1CYBXl38EvI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VRDLYng+DonhVuunpeulPDNQTRKZRxVoOYsuC8450pVVXf+KuN6dah3s5xqbLKvP9FTnXt/9kFHdNnYhB1HjApnlM3crfCj2vYEMWnJiFw9NXFYe24lSYK+Bq5Q0wW/dL8SpTnBIhWcnE2ZysurhsbvhxM6ARIlyjyhkT5DJW64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCYNj1/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCYNj1/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E684F1F000E9;
	Sun, 14 Jun 2026 00:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781397107;
	bh=2wHXfUnP3DR/Ofo56/WhY+6mUp7zb0Z18EcHmP1HxsQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aCYNj1/ShW2ysSzpshf4vixH4c6ltWfCpaxKGOpsn2G/FFrgmQ8tJYxcclSpIFlE9
	 T9iwEEh9aB0aDw6YYI9mVsYKn0cqPhdjsLStFhU8sMJ7XIdSrVP6Ah2I36XGJeV/LT
	 g5mR1NRlV3VDJnmUys9H/GTOMrwndXMQn5ig1Y6dEf2i4cn4+K0BXQi9Sn3dG0UeMS
	 qpIRvIqJUSHHvMHpytiWlboePOTwM/3V51uGSersRCwpa1SkCsQu4HhJ5db8FLAON1
	 5yhunz/EeasrWLv4ijFPPdcyambSpBbzFzR3I6SYSmg/RRRwd5rz0dxHq9V5FAekMO
	 PnvOoL5DyzJhg==
Date: Sat, 13 Jun 2026 17:31:46 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li
 <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>,
 Wenjia Zhang <wenjia@linux.ibm.com>, Mahanta Jambigi
 <mjambigi@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu
 <guwen@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/smc: bound sndbuf_space on the SMC-D DMB-merge
 receive path
Message-ID: <20260613173146.3b4ca37d@kernel.org>
In-Reply-To: <20260610090928.192177-1-hexlabsecurity@proton.me>
References: <20260610090928.192177-1-hexlabsecurity@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Jun 2026 09:09:36 +0000 Bryam Vargas wrote:
>  			/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
> +			if (atomic_read(&conn->sndbuf_space) >
> +			    conn->sndbuf_desc->len)
> +				atomic_set(&conn->sndbuf_space,
> +					   conn->sndbuf_desc->len);

similar comments here as on the previous patch
-- 
pw-bot: cr
