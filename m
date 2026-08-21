Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1DF3939A5;
	Fri, 21 Aug 2026 23:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787356420; cv=none; b=WWGHUVUwWcpkE2zZj+U4W0+Vm+FAjwuLLaKRxsnZTGb1XmEKeF6iWw9sRHk80oAL3OEGzEhgQ7iItHJEUTYb3I4t6zeBDTe3UCTVBpgPYOtZM7HrnALH5j0ccseAyn/41MvENH5ybQi5gAesnb/tXxEyl0c/GfAAQPi5Ksu55w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787356420; c=relaxed/simple;
	bh=hwwk9t3rEficLuf6tMUozQMN/lzLuXQmUkx6xZRwk7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iP0rd8+bh0cSAhnKU9RBHKJzlnpdGasiWy+WgEVMNanJqWP3OF+gvQlK9MQz08SOuUZZuGNu+Sit25l6XLvQydpTILDfEXZiEUvVIAbameCJKHmB1pxLAd2MKpo5sxEV/bV73y0DuPljjC1msccsw/qqLnnYBBbLzwtjVPJ0cRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIOyvhMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIOyvhMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B54C1F000E9;
	Fri, 21 Aug 2026 23:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787356418;
	bh=z6AE8pCjlSYv6GEenKHXAdh3yhQOesnnHByTacX9u0g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KIOyvhMqPdV2gMfoV0Ae2iLeg0i59zrohj4ZxjxF8p7X+EAABB1Bb+ognys6dZ2Et
	 9b/4sH+JO4fXHCciaZfH+qyn7lwrj9kTdAMpac0GGQlRibxqtJVwG06XcIwwDPgs/O
	 TvNEuuIpOs/P2wWfYBWjIJ68oTm9rD2+c9L0Gop0qiZxkwsyyKbAoUP36jEc69mPav
	 HxWMEZAS1/px13JepTLWaNetkZTeszuSb+ReydV3DnOaTeGvpw8h9DBlQt4SrwJqE2
	 AqLZergt26lgJKT8zIfzhr+iSalck9vdDTAsRY7QZqs1g9t3ZI0bTKPGQpjfSgcFga
	 a4YLAEljp5phA==
Date: Fri, 21 Aug 2026 16:53:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Chuyf26 <Chuyf26@linux.alibaba.com>
Cc: pabeni@redhat.com, alibuda@linux.alibaba.com, dust.li@linux.ibm.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3] net/smc: release the internal TCP sock on
 IPPROTO_SMC socket creation failure
Message-ID: <20260821165338.21c8d11d@kernel.org>
In-Reply-To: <178729790329.223882.15209084993558811810@linux.alibaba.com>
References: <20260813060456.b48HqF9m6NTfFXvq_PL9w_Ih493OogqAqxfAHAfU74A@z>
	<20260820111229.153086-1-pabeni@redhat.com>
	<178729790329.223882.15209084993558811810@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Aug 2026 15:38:23 +0800 Chuyf26 wrote:
> Signed-off-by: Chuyf26 <Chuyf26@linux.alibaba.com>

We need something more official-name like for the author
and the sign off. The numbers do not look right/

It'd also be great if you paid attention to the automated
emails you're receiving telling to not post new patches
in reply to the old ones
-- 
pw-bot: cr
