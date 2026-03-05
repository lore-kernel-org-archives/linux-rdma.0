Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75B3223DD6;
	Thu,  5 Mar 2026 01:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772675712; cv=none; b=EwbNU9z/gdhEP6ZCZKjPju5vFwPAA3W8WpGH9uwH0GTevlA09vIcGCNMDuE3avcu7nFqUvxlvdO5LDiLF2byLVbZQGrICzK/VT0AcXqSdyFhRDTOVFnfDoZCdrP4tyhtfEQD0Lm+sNvaJkiElkSiHJ9p9tir9nCOeu6Q1TOLVqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772675712; c=relaxed/simple;
	bh=ZQUBrWfctnJtFHe4bVSgO8ce0YU8Uwi9bPqt+uZ8vn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=teEN7w1/t4z/Czp4ZDmDZoTdIgI66Si/VK7zNVJIYxtAUv/blh/NdEP1muW9bYTYBEW8UcpGpduwvf1xGK4EaX6c3L3EER8AQX+WnFIYJjSebGcws5763MDqXKbLVKVGTKwiLll9Jap209FZCcttfAfGZVf79PS8gGtpo2h8uK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LlS2jUvD; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LlS2jUvD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772675700; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=OHgAACH+q2DjfP6Ed0v+M5e+hsII+F/WPSAfjtq0GhM=;
	b=LlS2jUvDcEGsaUd6m/erbPP1xpyHz08q97lR8kILz8ApzET3vsB/IfuNC/H6rIUZgWF0TShZw1iRnetJqb5GeztdG4sH6aQKHlMjlqOAnxODIhwkOxufygRaiEfL/4hT6uvpSJKSMiactT8zdQ+wlIA4MYtCIm/Ueq45bFRQprQ=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0X-GievI_1772675699 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Mar 2026 09:54:59 +0800
Date: Thu, 5 Mar 2026 09:54:59 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Jakub Kicinski <kuba@kernel.org>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	netdev@vger.kernel.org, oliver.yang@linux.alibaba.com,
	pasic@linux.ibm.com
Subject: Re: [PATCH net-next v2] net/smc: transition to RDMA core CQ pooling
Message-ID: <20260305015459.GA55554@j66a10360.sqa.eu95>
References: <20260302063737.4393-1-alibuda@linux.alibaba.com>
 <20260303170908.64a5070f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303170908.64a5070f@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Mar 03, 2026 at 05:09:08PM -0800, Jakub Kicinski wrote:
> On Mon,  2 Mar 2026 14:37:37 +0800 D. Wythe wrote:
> > The current SMC-R implementation relies on global per-device CQs
> > and manual polling within tasklets, which introduces severe
> > scalability bottlenecks due to global lock contention and tasklet
> > scheduling overhead, resulting in poor performance as concurrency
> > increases.
> 
> does not apply, please rebase & repost

Will rebase and send v3 to fix it. Thanks.

> -- 
> pw-bot: cr
