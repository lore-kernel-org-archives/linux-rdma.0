Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3DF1A38F9;
	Tue,  3 Feb 2026 00:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770078590; cv=none; b=RJHS/gZQ85O7gfOWSZ0OHYMpguCr9FsWwt8Mk6mkBhE1o+gkFiL2BMSUpZK64BwyCctKoisagZge/lbm2Tx/XYFoyVNc936+sc9m8eCdtwurG7s2/4rI2eGLLTtTN7j2xxe7iHDi6zGB3taLMIgFbbJu5By/+tcB52E2Ww/zNxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770078590; c=relaxed/simple;
	bh=AmMWg3mXovZLfeM6pqZsDaAg1W83YZpeViaLqURVGr4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vu8Gw3WKbCZvZauikSJNFLZmBl/1I/1drA86HWSgdYutIHc5q8Rd+Icyn3/rIX12pZ0X2aUrO/kVqS0QUiiZaqO3xJc7wp/nt0JLZNsxQG4zQo93bWCdhQLoe5NV5DqTgtPvZJOgg2uvR/gtnfMhBFZkhEVtbs4RIABGL5SA8bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Re7Zd6y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Re7Zd6y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3B8C116C6;
	Tue,  3 Feb 2026 00:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770078589;
	bh=AmMWg3mXovZLfeM6pqZsDaAg1W83YZpeViaLqURVGr4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Re7Zd6y/QkOxgDYos6A6apfJvUjn1kBLbZFIhCP4YoKTuvcsgumdE06PRUEbQW1pY
	 bkYQiiSXDRgaMaHWW+6GohQjBAFAIH9KCwFJzT/ls1yQjN1A0NJDqHlzFcg88Xa9BV
	 YoG3unpmVyaue+/SBNo9UqXi7m0CyC1Gc19tMrPg8C4N0lgJ1Z52DpKOTsChQU4Z9s
	 PL/QF4uZ4/CFcsA0h9kilx4vBftuPE2IXLUDOyNXxXE/5IYVa4sT2GV1wapqhewVSM
	 gFhE/LO0lTRjse1Zivt8Bbewkozx6wA4/NPlukLAPuz473j3KylHG4R1GYG8b0xlX8
	 ArxEyvILBHWVQ==
Date: Mon, 2 Feb 2026 16:29:48 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Cosmin Ratiu <cratiu@nvidia.com>
Cc: "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "davem@davemloft.net" <davem@davemloft.net>, Tariq Toukan
 <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
 "pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
 <edumazet@google.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 Saeed Mahameed <saeedm@nvidia.com>, "leon@kernel.org" <leon@kernel.org>,
 "horms@kernel.org" <horms@kernel.org>
Subject: Re: [PATCH net V2 2/4] net/mlx5: Fix deadlock between devlink lock
 and esw->wq
Message-ID: <20260202162948.4e743216@kernel.org>
In-Reply-To: <75a38217239d4df76f53cd6c355c5179ffb97546.camel@nvidia.com>
References: <1769503961-124173-1-git-send-email-tariqt@nvidia.com>
	<1769503961-124173-3-git-send-email-tariqt@nvidia.com>
	<20260128205622.12e1f026@kernel.org>
	<d52714243592921c08175aa742f32ae56e4f6651.camel@nvidia.com>
	<20260129154024.3915c3bf@kernel.org>
	<75a38217239d4df76f53cd6c355c5179ffb97546.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Feb 2026 14:48:28 +0000 Cosmin Ratiu wrote:
> > And having a refount on (I presume) struct mlx5_esw_functions
> > so that work can hold a ref is not an option?
> > Are you planning to revisit this in -next?  
> 
> Currently, mlx5_eswitch_disable_locked (with the devlink lock held)
> waits for esw_vfs_changed_event_handler to finish.
> The event handler needs to acquire the same lock and load/unload all
> VFs, which touches the entire esw.
> I don't currently see how to use reference counting on the esw to avoid
> waiting for the handler.

struct my_thing_with_work {
	work;
	refcount;
	dead;
};

work() {
	lock()
	if (my_thing->dead)
		goto out;
	/* .. add code here .. */
out:
	unlock()
	my_thing_put(my_thing)
}

some_op() {
	// assuming lock() held
	if (!work_queued(my_thing->work)) {
		refcount_inc(my_thing->refcount);
		queue_work(my_thing->work)
	}
}

shutdown_op() {
	// assuming lock() held
	if (cancel_work())
		my_thing_put(my_thing)

	my_thing->dead = true;
	my_thing_put(my_thing)
}
