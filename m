Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B892847A875;
	Thu,  3 Sep 2026 10:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788430746; cv=none; b=TLYJzKfWKKysZmzA12KQ2E2O3ov7CkSKEAmMX5RKVheQ5mKQok4sJUCh2NPG+jv2Z1TEvdLdO/S+DMMsHH418AwY0fpX+3YTUvu/Ijl2EfEh4AHpwC1IHgXglRuCdnhF6bnQhTUlT3fiLwi6LCDgOa79aqmeiykUsL21myjWV2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788430746; c=relaxed/simple;
	bh=PJJJcRnPBiyJEmkwDDDVsEBkM3HIQ1hVJ7lT121F1/k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Lh+O7E0DObwNCSednZA+ocQoIe5gYGZcJ6dodRDzrbNRG0y4eWRLS0VSLKOeCufqEU5nvYDxmhdLJAnd9QJqgejk0Ea4ppcGdh87RKIVdU8RxqZm88UllXOwo0Hqp8ADHK4XDbX7TkZEm/Mn2j5/8Lqnra6eSgP2Sn5/jEdE63Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ETwFvUjG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ETwFvUjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82381F000E9;
	Thu,  3 Sep 2026 10:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788430740;
	bh=C78FwDoy7yweKASNdvaZaOqOFm2h0eiCgyTMlPnnyJc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ETwFvUjGbmIUQRe2NAEJHuZy9dyRRdc3FnfVrWL7Jmh9CCPGP1yaIREa06R2tckIf
	 zgChVB5xhCa4vDHRlEQeULlzjCFwZ/LCVikPp61/BkcahgJFTkGH+pW1VjMDhu8tMZ
	 aIJmjnwf+xAHZ9+7uaHqLlrOi5rubJQ84tPXlM8z3/wbmLd8s1Rma+QFbUbUpETJ7i
	 wSvIMoFCfc37odcxUVUUj++BtZPNRf/ISu7FySeH6JSKMhOyYMqg0YOPtHinS/Nevq
	 LWg9xUFAEZdjslml9ytda5rmms1NK62MbYofgTBmv0UagSH8CQFT0HO97rPJP3KUOP
	 2weYr0voa0Mpg==
From: Leon Romanovsky <leon@kernel.org>
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
 Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Quanye Yang <quanyeyang@proton.me>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com
In-Reply-To: <20260830-rdma-rtrs-clt-cq-pool-leak-v1-1-b169434fd3df@proton.me>
References: <20260830-rdma-rtrs-clt-cq-pool-leak-v1-1-b169434fd3df@proton.me>
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix CQ pool leak when connect is
 interrupted
Message-Id: <178843073744.2697265.15020337719165388984.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 06:18:57 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 30 Aug 2026 15:09:55 +0800, Quanye Yang wrote:
> The client borrows shared CQ credits in the ADDR_RESOLVED handler via
> ib_cq_pool_get(), before the peer is connected. create_cm() can return
> -ERESTARTSYS from wait_event_interruptible_timeout() without destroying
> the CM ID. The init_conns() and stop-and-destroy paths then call
> destroy_con_cq_qp() while cq is still NULL (no PUT) and only afterwards
> rdma_destroy_id().
> 
> [...]

Applied, thanks!

[1/1] RDMA/rtrs-clt: Fix CQ pool leak when connect is interrupted
      https://git.kernel.org/rdma/rdma/c/2ae16aaa78b5ed

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

