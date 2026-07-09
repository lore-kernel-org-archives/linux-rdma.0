Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B93A3FE650;
	Thu,  9 Jul 2026 09:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783588023; cv=none; b=LALOw33kIscqenomJ4/rMekB7ucomO21S5mq4UhsOkY+cUEmKw2BShMNsVeLq+FzcUQL2RKoL/5ac86CyDc0KVrWWzH54+7eVK00d6BG7EyXPlqqPZl+yPaDrgDgfhmwAIHN2edPJRj/S97P0u6va1UlPoHcarpLA19VgnK4q98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783588023; c=relaxed/simple;
	bh=z9gR4RJsNzffr/vVvx0UgKTJQmCW5wSGTUORrslbYyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ArWsID07ziZnO/MNoggOxthZD/ZY2DabaUmspKfejh0E8cLuvYMDMQdKxX4kgLb+ET72KeyYCtz/ZgtaWV2PunhOw8aGEsJgyAqx3eAjatOvmoKlVzqDHDhb6kjQanHIX3QC8b98XrDOE1GvqgfgipWP2RIB01ig/mwk6yRTxWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RC4/PBz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RC4/PBz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6261F000E9;
	Thu,  9 Jul 2026 09:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783588017;
	bh=S7zCCobLmQHdomwmvPxBcx9vY9o+6XVxT/i9YM/J9es=;
	h=From:To:Cc:Subject:Date;
	b=RC4/PBz+LSsvoH+V/vjJcT+33pQcREEP3YTaC7f319KOUzX4qIKFc83eNUdaaPU6K
	 WsoS0azaV+lcymdPMnNwF7KfimekIHVYuBfO2sdt8IefabLAGgFWR11/ocVEx3BVk2
	 VoJNZGsANgbg5/JoG38pP19wLrH8wJf3eT3zPI9NjTueLM66F4lKSx0gWlrsaOvUqM
	 Dne1b0/2/mo+X4jQOfrbcku1rX2zb3Ca9Srchh80t4pJM9I8voIGXCZx+iGLjup9uW
	 n+FXX8SJjaNrCyS6QC/OYHCgpbhT3CJYEmBXyYuo733P/mWvrRNRu6AKyBKUMS/TlC
	 4XpRQ6BglH1hg==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH rdma-rc 0/3] RDMA: Prevent RCU callbacks from outliving modules
Date: Thu,  9 Jul 2026 12:06:46 +0300
Message-ID: <20260709-unload-rcu-v1-0-fccd27211e5a@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260709-unload-rcu-67c6de79b589
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

ib_core, mlx5_ib, and ib_ipoib use call_rcu() with callbacks implemented by
their modules. Stopping callback producers does not drain callbacks already
queued. If module unload completes first, RCU can later invoke code that has
been unloaded. synchronize_rcu() and SRCU waits do not wait for queued
callbacks.

IPoIB reclamation completions are signaled from inside the callbacks, so
they can wake teardown before a callback returns. Initialization unwind
also needs protection because registration can attach existing devices and
undo their setup on failure.

Wait for queued callbacks after all producers have stopped.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-rdma/20260708092316.Qb39F_B0@linutronix.de/
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (3):
      RDMA/core: Wait for RCU callbacks before unloading ib_core
      RDMA/mlx5: Drain RCU callbacks during module teardown
      RDMA/ipoib: Drain RCU callbacks during module teardown

 drivers/infiniband/core/device.c          | 1 +
 drivers/infiniband/hw/mlx5/main.c         | 2 ++
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 ++
 3 files changed, 5 insertions(+)
---
base-commit: 5f9576c6734abca88a02db72c466e09d2eddf160
change-id: 20260709-unload-rcu-67c6de79b589

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

