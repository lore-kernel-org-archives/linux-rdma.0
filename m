Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A31137F006;
	Tue, 29 Sep 2026 18:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790707547; cv=none; b=UraDzPMFTRgWf5KW0AvdFxzEjb8fpLTnCiETqohT8C8ZBLMDDuELf8te8vxkTMAh9wKQWAuFyXvWhM6EWWm/At7jxvBPHQoweqvYVMhn2dcxJ6iYvGaF5EFUW0N947e6suxDqWP5qLW0HDuqMZ5/9b+ZQCENooFd4N9PqXG0Ox8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790707547; c=relaxed/simple;
	bh=LKMPUiUQbaG7cOnJgjRyRkPTA0EcqGVJ5W+21o6UC5c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f5lLa5Hcy6jagTFxaJSJdCiXd0aytvRKomgx+9apBDT0YpNuSYpguj8MC0LKVZ/RJ6sOBCgFm1KQ19QieX837adIoslBg4yVf9oQddEZOxX5/bIbcLGM7LKGpIB9EOlQ7Z26EAzBkXWIhfvyftzv2G+F3vZfXPSHwbpV+TiqJoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQFE/Zgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQFE/Zgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858E21F00893;
	Tue, 29 Sep 2026 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790707546;
	bh=l2pxtBc3cuHU1GiMtGKOPq9GuEl/aAoOnypp20Wc5Sk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=IQFE/ZgxJHdtLxjObg/kTivZeXbyNHdvJ2ohWeszaavcBsDFUzjl8RBVB78BEi32J
	 45pjWFiV3GLG5YYKbm8v3tz4kfBvWe/1JmscWt4IfL/sRkYD+Acg90ThQwbRqO7rMJ
	 DgxAZJJMk6U8bqzha+ZHGbgM5+O/rD9OLN7QZ/EOIvryYV+AE7H40qn7aAc9a7XSTt
	 n4iPik7PvLHFYZY+/u1+ZBUYaARTyAdZuvGJZwIAvFpUCYBt0l0T4kCoH6paZsmD7R
	 z1hcAwY7E3KFkrY9hiwnCJdP1bcVYKpiJqWjp7aknyzEbDuIf+fHjBlOm/faJAqt1X
	 cf8+RHOd4VPQg==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: allen.hubbe@amd.com, nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260925093638.3032149-1-abhijit.gangurde@amd.com>
References: <20260925093638.3032149-1-abhijit.gangurde@amd.com>
Subject: Re: [PATCH 1/2] RDMA/ionic: Fix XArray initialization to use
 XArray flags
Message-Id: <179070754326.3974961.446550706671419287.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 14:45:43 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 25 Sep 2026 15:06:37 +0530, Abhijit Gangurde wrote:
> xa_init_flags() takes XArray flags (XA_FLAGS_*), not gfp flags, even
> though the parameter is typed gfp_t. Passing GFP_ATOMIC leaves both
> lock-type bits clear, so xa_lock_type() resolves to XA_LOCK_NORMAL for
> qp_tbl and cq_tbl.
> 
> Both tables are used with the IRQ-safe accessors: xa_store_irq() with
> GFP_KERNEL from process context, and xa_lock_irqsave() from the event
> queue path. When a store needs to grow the tree, __xas_nomem() drops
> the lock using the recorded lock type before allocating:
> 
> [...]

Applied, thanks!

[1/2] RDMA/ionic: Fix XArray initialization to use XArray flags
      https://git.kernel.org/rdma/rdma/c/2eca9c14e66a1f
[2/2] RDMA/ionic: Fix double removal of CMB mmap entries in create QP error path
      https://git.kernel.org/rdma/rdma/c/485effd117d031

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

