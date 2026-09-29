Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1C43D79EF;
	Tue, 29 Sep 2026 18:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790706155; cv=none; b=DQmARyeu3nfKJarhh5qAGDSwQXCkmsmXM2nVPxtwtwPKNCaI8vAbxCJfyo6SwDNTM+62sI7Xez4dcFyIZ3siMhtyEmFycs7Tuw7ZqhyD9U1HnZcYAAAvF/BQCdvX+k6mStRTq/sqy73UuofSGd/2kTRv5AmRypq1X/C2JVDLiIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790706155; c=relaxed/simple;
	bh=+MX2a7fH8twwYB3OWUVLyf1B2H7pEipYbfgJ3PIDve8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mfSTs+Xh0YbSrGqBtsqnsnlOR0ThqalKK4dM1FNl4j3duYi5Qk8K++QKt26SKxuMK0Ubl1y+ACEbVlCQCadCqUiaKgAYzAlR4lU91Lzi/XB0E/x5aPUGLnmPPWoifHOJwfXCA/yb9bDHSUtrCGcrkrrDkQ9860Hx7/o9WkDIE6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oC7md4Re; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oC7md4Re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564FD1F000FF;
	Tue, 29 Sep 2026 18:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790706153;
	bh=oXtCVwnbwCQRkCSsXzRTmBC9jkrm9EOvEagF+DsRd6I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=oC7md4ReDf7i2kxy2RjbZFgISJ9tNJKvnKUo95OWq6KWR2hPQFHkD1ODO/l2/U0td
	 G0R/0Fbv1cTodjBOKFyuvdFzyQ70aISAZJQX1ZTtFR14IWdVfUwrxxzV4WyqEE58PY
	 OOQRCNh/Hcz8/2ZONQq3BoGbZQpf/WS6E7BPBLeIHoS2KlwdEME3YcdgSQFC4gB3dK
	 jVYNPDP/GnOTfRYN+81VComk4uShLFZY3VTvDdvjF+jLTE9TWBMj5zkRVB616PKDnE
	 Kc/pACmJZj9AJWjEiC/i+Kc2HyXnLGhOxJpxsmGsXX3Ck1m235ziipJWgM7Qwro3FT
	 tKiIRZkbSgntA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Yili Zhang <zhangyili01@baidu.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260923131239.6521-1-zhangyili01@baidu.com>
References: <20260923131239.6521-1-zhangyili01@baidu.com>
Subject: Re: [PATCH v3] RDMA/nldev: Fix NULL deref in dumps of objects
 abandoned by DRIVER_FAILURE
Message-Id: <179070615109.3969314.1905636503207032165.b4-ty@kernel.org>
Date: Tue, 29 Sep 2026 14:22:31 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 23 Sep 2026 21:12:39 +0800, Yili Zhang wrote:
> fill_res_cq_entry() dereferences
> cq->uobject->uevent.uobject.context->res.id unconditionally for user
> resources.
> 
> This is normally safe by ordering: destroy_hw() removes the resource
> from the restrack before uverbs_destroy_uobject() clears ->context,
> and the XA_ZERO_ENTRY marker set by rdma_restrack_begin_del() hides
> the entry from concurrent netlink dumps.
> 
> [...]

Applied, thanks!

[1/1] RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FAILURE
      https://git.kernel.org/rdma/rdma/c/9f4c322be27bf6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

