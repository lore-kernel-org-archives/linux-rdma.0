Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEC140861B
	for <linux-rdma@vger.kernel.org>; Wed,  8 Jul 2026 09:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502601; cv=none; b=b3Z0zA+zG6yJhQt5tITVitYoF76kLT6PZFhnZiUAg04c0cRqxFul+nJZ936yjbtMaGgbfJ4tvRxLZToQwwSrvy4m1UNuPvk+A2P963t/YzuKy3fIXeoelRQemtYXpj4Xacadh9xahxyWeDDMd8JEnFC4BkJSMiGOmSaMrcpVDmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502601; c=relaxed/simple;
	bh=KSGO88dgyUe1y4AYUyg7jQ+i0/b7FoOrCed8a0pzrPc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qxSLhexK0jCLsZn/HgyqOJsHXvxUBoLelbEU44Oz+cQrPYjjdRsqRd3ebJBsf8uI7suKY/1kcj+jT4IniIjMobgDcdX59xwUJZioZ7g3C4otfLwPHAy4A9yHs5NiqS3K4VOIDs4qVNMqyH9+rldsS7WoNmQCHZ8YCUEipfbti/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1ohVCYOD; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=lvRHYaZw; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1ohVCYOD";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="lvRHYaZw"
Date: Wed, 8 Jul 2026 11:23:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783502598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=g64nVw3djX+2rwvjxDO9+SIe5HIWvHXM9rmeU1r5lFM=;
	b=1ohVCYODY/DoiA6fMgRF5AjU+fp7lpT1r03rufIAPUo0RBxoYoI+sV8oCUXIi0HbuH9WcP
	W5xER+abrUCs4A4cd1JXrAGOAJwfw6rQyK3TwGDiiFVfQIogJFhqgdoeeAwXi5v3ITZP+y
	1OTbW+gMt15FXQ0+iivCi9BWew/Rq0Lb62NSfc4OVEw0oSJE8a6QQaopwndtTZ4OdEkn3d
	xnl4M6XlbwqLRX2sG/4sGzQP6CJCofXc1VSN8OkAzel8iFz8+C1a4SDTYHu+DY8LHo6YFq
	PLQoIk1edJEAy+LG2SFxfLC1b8eyzJQVNu5rbPoLUXJ0eqAnmSpIAng1Y3VwXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783502598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=g64nVw3djX+2rwvjxDO9+SIe5HIWvHXM9rmeU1r5lFM=;
	b=lvRHYaZwMxKkYIq/RzJiZkwDcN1nkFyExYWkERTPTThwv7u4LdT0Zp2OSIJ0ClkU16CyZK
	YILlXygg2wZ+YrCQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [Q] RCU usage in infiniband
Message-ID: <20260708092316.Qb39F_B0@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

I've been randomly starting at infiniband code and noticed it uses
call_rcu() with a callback from its module. 

| drivers/infiniband/hw/mlx5/devx.c:         call_rcu(&event_sub->rcu, devx_free_subscription);
| drivers/infiniband/ulp/ipoib/ipoib_main.c: call_rcu(&neigh->rcu, ipoib_neigh_reclaim);

I don't see synchronize_rcu() and rcu_barrier() there so I've been
asking myself what ensures that the callback completes before module is
gone (via rmmod)? I would expect a rcu_barrier() in
ipoib_cleanup_module() for instance.

Is the unload path so "late" that the callbacks run before the module is
unmapped or is there something between the APIs that ensures this?

Sebastian
