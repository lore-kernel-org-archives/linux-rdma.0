Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1635D3845DC;
	Tue,  1 Sep 2026 23:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788304815; cv=none; b=k07xr//wP2eLRiKrrWg5q6STJeHGNsuNtAgIErK0y/YUwcTWN4h/1GdjVZLkagVKX2BAXG0sylaTrKgjkeXTgX3H4bXCSMZ5tFM2APp+Sg9mC1NpM1pv3SzOthBGyTztKgrym5jX7qBtUs+33PuQohQjB7dnVJbpDx8qkHaJmkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788304815; c=relaxed/simple;
	bh=1ZTLqh/CEL/oQco0CSscxMobUaxOmcQZMh5FFzy6QR8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EVaKcQt4Ob+27PSlcrTUe7TeCQsGRNAau7hJUJ5IjujMMyhzKfF6KIMKzPY3XvjVrLglXwYaezOK3TdXOYRPflGenTgwDIIm3w4KwFw1OM1GQvsYC7Q/yQTppQ7edOxFTilyaRCCwnCsmOrXhdOegApy8+x4M2Twi5iGNpJ1fRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2EY6tWO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2EY6tWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339391F000E9;
	Tue,  1 Sep 2026 23:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788304813;
	bh=1ZTLqh/CEL/oQco0CSscxMobUaxOmcQZMh5FFzy6QR8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=j2EY6tWO452AphVxxCj4hyI3ZBCUVYA8kdb+RxLcYgsX5Xa2nNEEZKc3Qb5KVcki1
	 kV2GLPX5Usx225Naha7IdGIKJ9bQvIYinOmq99O+63CsS4HOcNE1giDY/XHcxs0dME
	 +z2zV0wCf4S/TN4E648Xk9eu5wmuqYYnbgyE79u1u9oaED3+Ps4EpyOvpG3AQPMUii
	 ZpVhmlg6obKHNfCzWSucwnpUemqjTtEN87DF72LUnM92qWAIHAJ9QYWdRxG7Jkw5P2
	 l/ouZH0nVOUcncsAw3E93njoqR/NTD7cNL/0mOeft3UpraxBAclkELHW3mlmBTC6pk
	 CH+0h+C/QNzSQ==
Date: Tue, 1 Sep 2026 16:20:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: hexlabsecurity@proton.me, Sidraya Jayagond <sidraya@linux.ibm.com>, "D.
 Wythe" <alibuda@linux.alibaba.com>, "David S. Miller"
 <davem@davemloft.net>, Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang
 <wenjia@linux.ibm.com>, Eric Dumazet <edumazet@google.com>, Tony Lu
 <tonylu@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Paolo
 Abeni <pabeni@redhat.com>, linux-s390@vger.kernel.org,
 linux-rdma@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Raspl
 <raspl@linux.ibm.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net v5 0/3] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Message-ID: <20260901162012.602cc62e@kernel.org>
In-Reply-To: <db896915-5858-4fc3-a56c-77b626980284@linux.ibm.com>
References: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me>
	<db896915-5858-4fc3-a56c-77b626980284@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 1 Sep 2026 12:10:35 +0530 Mahanta Jambigi wrote:
> I noticed that this series has *not* yet been merged into the net tree.
> Is there anything still pending or any outstanding concerns that need to
> be addressed before it can be merged?

FWIW it needs to be reposted to be considered for merging since it's
over a month old at this point.
