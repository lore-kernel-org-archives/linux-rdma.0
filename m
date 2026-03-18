Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC4234676D;
	Wed, 18 Mar 2026 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773857605; cv=none; b=Ycpb5MPzdrqUTq/luuw87CKcQn9QLUe0Dn7ITQIiIRYBeJRNR78lhlP1VgW2/NX1ujZIcSxNc7pPFZejeum8W4I8sW/m1/QaGo1hWD3fUELvj/bdm4hTc6bk8E/pRTljxjCuOYKY12XjR2ztYgZXeVuFWH0D9roYHtKEMWqTJXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773857605; c=relaxed/simple;
	bh=XHgYIwhFIbPpDkjJOT8MLyAiDU8FGpSWii4Xa0iuyjg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ScTUDFzpvQ4KKCYPtwCHGboxnt7bfZO9ThqQnoetg2el016FRIHxBN5VD6b1LKTFEQIRTFaS7KuJGF9gKXvsz+MVDeoK2Njoo+ZjmyftMLJHDAK3SuDcH1hk5Y9p1z2sJWA9IPEJmBrqriJrXukT4deqK+uLCzhrqoJSULaDqmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qnp6rRiR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qnp6rRiR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBB6C19421;
	Wed, 18 Mar 2026 18:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773857605;
	bh=XHgYIwhFIbPpDkjJOT8MLyAiDU8FGpSWii4Xa0iuyjg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Qnp6rRiRP1zwNooxC7sQ4dSdZVs99uZg/+NTBA+1FpyVl7vCEOusyyWZU7dIQHq0w
	 zZ1sgCHQt+mOd2bpZigRuqIACivXIJiOMmQrdVmeIJ4bz+aOkcqBI/1G+o9M7N6wHS
	 mfLtkOm/g9Mhj2v57ZJrvDctH2uK8hiHYAz1gO38J4Hd/lqzoQ99GcfHPUGapcg9A6
	 mEWT+s2H9ORneO9usatY7aGh6Jelbm48S3xZY7n8Nv2XYHwzhUKw0HzlQDyA7IQPxa
	 334cKr8SX8/Jvg6RoU1ZojKCvoiDkQYVMOvyhJ2jVvJ8xxJ3gJzUTt7IuLruTCBQDN
	 XAb9kmqg3nKVA==
From: Leon Romanovsky <leon@kernel.org>
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 Marco Crivellari <marco.crivellari@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Michal Hocko <mhocko@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
In-Reply-To: <20260318152748.837388-1-marco.crivellari@suse.com>
References: <20260318152748.837388-1-marco.crivellari@suse.com>
Subject: Re: [PATCH v2] RDMA/rxe: Replace use of system_unbound_wq with
 rxe_wq
Message-Id: <177385760172.774155.8831510625996711948.b4-ty@kernel.org>
Date: Wed, 18 Mar 2026 14:13:21 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 18 Mar 2026 16:27:48 +0100, Marco Crivellari wrote:
> This patch continues the effort to refactor workqueue APIs, which has begun
> with the changes introducing new workqueues and a new alloc_workqueue flag:
> 
>    commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
>    commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> 
> The point of the refactoring is to eventually alter the default behavior of
> workqueues to become unbound by default so that their workload placement is
> optimized by the scheduler.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Replace use of system_unbound_wq with rxe_wq
      https://git.kernel.org/rdma/rdma/c/2102cbaf8db4ef

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

