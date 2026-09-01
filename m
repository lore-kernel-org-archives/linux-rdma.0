Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DF33EEACB;
	Tue,  1 Sep 2026 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271452; cv=none; b=ue5mOaUH/G/8MqHAoqwMWz7acjCYAoFJ696WYoZ1ECoYnZV3bvhkEgr1wv/2ZYa9Pl+5g6SPZ79zmzRzzmRMuyRUkrOeCgRCMgW1CquwdQt54Nh/gm35pdl2aP5o/0CCI3xMX+Sks8XwSdXlwxPDxLhHAtDtMbx2Q2CbvsfLjYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271452; c=relaxed/simple;
	bh=Xfv2jt4cOB8bmx9v7TXqvrTMEmyMl+0EWxhvEqFVwBk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kXP6I7ThXggMM2XdPqy250vq6a7afuFaymvQmyzf80I0VdTBUddddubonUC0Mm8CcOrMKp9GOOTfkAnvknOuTLMp1/8s0TQqJZXFK3kU0ZF4NSnoK5WxSEjRp6R2LuFCW5Z1ne9oYuKdXBXmfvqER4yoK73KH7JEX+Jxg+5O7+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ds0Xkq+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ds0Xkq+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FC71F000E9;
	Tue,  1 Sep 2026 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271450;
	bh=FHZybySiaPe14dbMDMUulMa6M5fWVpsEsQ/tKYxAVJc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ds0Xkq+iDyAQ8C7jxQx8gVXYNunKJg6MbnhXtCfOZ/379srL6K0LXUWFor1r43s/Z
	 1Z7dzVLbj8wkKeGwM9vWlnKiXRswoSr4PE7GBXhxHL056oznRRU+2gs8m0yKbdzolS
	 vgtpZzBUHYvl+3ZFy27xa0i2tsBJWZPec0kpLhUQjFfh20oI85RNlRPC3GQEbW/h9s
	 q17oo5pEjUZ0hLNXKpumfqiCH98dgSRfq+9CaTMK68YvkU+IjIlDF4p7KJ2XmLBnES
	 L1PVOEFuq913Vz+Xg/0F6S0BDIACI60Kq3fWyId3T2l+PlllhypSAzsNu/H3Xj/Mzo
	 nBeV1RXapTOTw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Junxian Huang <huangjunxian6@hisilicon.com>, 
 Chengchang Tang <tangchengchang@huawei.com>, 
 Edward Srouji <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <20260811-fix-mmap-lockdep-v1-1-1151b41063b4@nvidia.com>
References: <20260811-fix-mmap-lockdep-v1-1-1151b41063b4@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/uverbs: Fix
 mmap_lock/disassociation_lock circular dependency
Message-Id: <178827144803.1380198.18045973124694867362.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 10:04:08 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 11 Aug 2026 19:19:16 +0300, Edward Srouji wrote:
> Commit 51976c6cd786 ("RDMA/core: Provide rdma_user_mmap_disassociate()
> to disassociate mmap pages") introduced disassociation_lock to protect
> new mmap registrations against uverbs_user_mmap_disassociate(), but
> created an ABBA deadlock:
> 
>   Thread A (mmap / fork):
>     mmap_lock -> disassociation_lock
> 
> [...]

Applied, thanks!

[1/1] RDMA/uverbs: Fix mmap_lock/disassociation_lock circular dependency
      https://git.kernel.org/rdma/rdma/c/a44a3f175eaee7

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

