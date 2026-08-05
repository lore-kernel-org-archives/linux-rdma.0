Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF471A23A6;
	Wed,  5 Aug 2026 13:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785938301; cv=none; b=cYitjWkxuoUfJUcKXjdcOh89XV/EjxJ63xrmwXM3n5lwpsVyHeJHZ3jmVlgoEOVnq4TTpQv7aYVR0aU/QHVzWI32isFt/kxbdhEThloMpRUZquWAAC5QSJiLgBo2qqgpwtEQuK6rH6+o1NQVdI91LvgLgXeW4A3VwnrIilrHsW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785938301; c=relaxed/simple;
	bh=2f0N4NThyFsHOSu7yAvZvw8TfTzXH2mnDZfdUWwt1X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2oYE0vwl8SUszxIUxYn7/BsoXFNAmNbNaqkaqfUUs2nqr5LamXAINiz7GHYd6YqG5CK9OayCYmtqYDkbrVLPFAxuLwMy2MS8mO4INzHUjBxdpDMV9FQDYb7m+xZdhrE8IFD5I+ixlylSq9CDRDsFj4wa63yClqXQQG3TjDy4ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=BRq05zj7; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="BRq05zj7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v684Hd3ge3JQAfZIPpMO9SA/yEYHCz655qZuiyy7FbQ=; b=BRq05zj7juD4nChMEME6XTDtcR
	+6fbUxOskGN3s4vIj8rY9IKRJ9IG6s/ELpIjEoKsdS9wrsBnHjNd9sshMWVLpPXyXKDPUd/NsPQYH
	VfzXQDETeSHrZJDbrnkocYT203w9A05+yjNyFBcPO9JU1xrzYF/0ZVInMNunU5aO9+N+xiXKPJ5F6
	JBhqaI3cqRVqrpjDLUbUakOfrhtL0axdm0tZ6Evn6i3Rknkpieezs2DZdy3wVzxyvWZBS8mQkJOge
	yLfZ4p2HVpldiTsz86mMrF36GoEY5CAHHJKXpQ3jZylmFxI/NuR9IMw6mPqR8sC4a58VT1WXXeWqE
	HNcbv/YQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wrc8C-00Dxtz-1A;
	Wed, 05 Aug 2026 13:58:04 +0000
Date: Wed, 5 Aug 2026 06:57:58 -0700
From: Breno Leitao <leitao@debian.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, 
	sidraya@linux.ibm.com, wenjia@linux.ibm.com, kuba@kernel.org, davem@davemloft.net, 
	edumazet@google.com, pabeni@redhat.com, horms@kernel.org, mjambigi@linux.ibm.com, 
	tonylu@linux.alibaba.com, guwen@linux.alibaba.com, guangguan.wang@linux.alibaba.com, 
	kees@kernel.org, gustavoars@kernel.org, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v5 1/3] net/smc: fix use-after-free of the LLC qentry
 in smc_llc_srv_add_link()
Message-ID: <anNA7V8wqhI6OEqf@gmail.com>
References: <20260801094208.1937951-1-yhlee@isslab.korea.ac.kr>
 <20260801094208.1937951-2-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801094208.1937951-2-yhlee@isslab.korea.ac.kr>
X-Debian-User: leitao

On Sat, Aug 01, 2026 at 06:42:06PM +0900, Yehyeong Lee wrote:
> @@ -1512,6 +1513,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
>  	rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t);
>  	if (rc)
>  		goto out_err;
> +	kfree(qentry);
>  	kfree(ini);

Instead of these two kfree, can you just 'goto out' ? out: seems to do
the free nows, and rc is 0 above.

Also, is send_req_add_link_resp always false in smc_llc_srv_add_link() ?

