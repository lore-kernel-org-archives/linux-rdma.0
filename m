Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D788D49DBBA;
	Thu,  8 Oct 2026 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791463525; cv=none; b=n5ssodkCQn96rz/hs1pa7cPKuZfdY1C+aWLILLvOIaJHxgqBFGGbQ/L/VKaLRWCOhQwKG6goMBVJYvQT1mQCdLYgERp5JRxs6QGo2Ys8Z9SDPh5+ftsroIn9J3JwBejQ8cQZT47+WHU1xwYV8D+7vYBJdqGY8ZIdnXciIVzQoic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791463525; c=relaxed/simple;
	bh=B2xwRmjaoQVg9wr0dMd5X+QH7+pRHtbhVjKfgTCyW5E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m92Dth6Niy9GMZourPx5erWCgnBuRKV26728rkBFmc613IPPnf4JqtUEFiX2J00s4g2xQeslV1/tI1wssclvhOtFEzddhhbZfSO+yQ+aw1/Bx3XQlK0dhXYz4thpYuN/zgOILE0lk+a1JO+d6ZFh1+BJ4LgYr+yQr3oa7qDuRh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=cpXwrTN4; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="cpXwrTN4"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50507b984;
	Thu, 8 Oct 2026 20:45:17 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH net] net/mlx4: shut down catas recovery timer during teardown
Date: Thu,  8 Oct 2026 20:45:00 +0800
Message-Id: <20261008124500.954229-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <bcc09996-e71c-43af-b3f2-0d072f6d402a@nvidia.com>
References: <20261004121259.1245171-1-runyu.xiao@seu.edu.cn> <bcc09996-e71c-43af-b3f2-0d072f6d402a@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa11b8bed7503a1kunme36ce5dd40edcd
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQ09LVhhCSxhCGh1IThpOTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUJCSU
	5LVUpLS1VKQktCWQY+
DKIM-Signature: a=rsa-sha256;
	b=cpXwrTN4AECBeNgPdmkbJBq7kM2og9ySgTU+CMqsFy8hsa3a3Cxz4eVuPJAYdAS7klVZtFDhziJ5QwvKZJauPyyrUu1VjOBmiS1xjgbXYfEDSdQ3ufd9Uy5uiNZg1K1+qMk/YXI7LXmKyIuQCkrSOiKAPt7abF5c7Onz+BnSDUY=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=B2xwRmjaoQVg9wr0dMd5X+QH7+pRHtbhVjKfgTCyW5E=;
	h=date:mime-version:subject:message-id:from;

Hi,

> This is fixing a patch from 2007.
>
> Did you hit this issue in reality, or just claimed by an AI tool?
>
> We need to have a very good justification to touch this old piece of
> code now, especially in stable.

I did not reproduce this issue on mlx4 hardware. It came from an AI-assisted
static audit, and I accepted the finding without establishing a failing
execution.

After rechecking the timer core, the interleaving in the commit message is
not sufficient: timer_delete_sync() waits for a running callback and retries
deletion, so poll_catas()'s own mod_timer() should be removed before
timer_delete_sync() returns. I have not established a separate concurrent
rearm path through mlx4_start_catas_poll() during this teardown, or observed
the callback accessing the mapping after it is unmapped.

I therefore cannot justify the reported bug or its Fixes: and Cc:
stable@vger.kernel.org tags. I will withdraw this patch.

Sorry for the noise.

Thanks,
Runyu
