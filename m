Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAFF3C5552
	for <linux-rdma@vger.kernel.org>; Wed, 15 Jul 2026 08:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104880; cv=none; b=hkMfRQviaEszUsgXEee1Q5hNbLpuHq4td68wXDhr6a6jQ8+e5IFjY66sYPBoqiJOK8Vt8/0IP5hO3pgXYqQCmRZ0PV/5aL5ch6r2Y+NUL1c9lOhvdZRNKHSllxC/PYbU3C3f0EDsbVlkeS+bB2ZO0BjkiQEDQgcF4FQVhwbOdjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104880; c=relaxed/simple;
	bh=bXWMJeYmrJODv3J7rIizJrNDtUZSpvz3X9Zm77KmJ8g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=D56+aUYLCAeUD2TRnrfzor0yQWaPNNQkQfW/tLMo+t0XYYtLHIsZKg30+vDeaQ2lILBqHEPYJ2BzSmT4rTT5mnCmSxbsC15S1UX3uiXW81Cnt2DrUAF69G2x3s+sj9VNtFJ+g2EpdaY/kY92fnF44ixGD8cdFJAumkGLwFJkuT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L9qf4T7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L9qf4T7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B31F1F000E9;
	Wed, 15 Jul 2026 08:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784104879;
	bh=mhCB/KJ8K9U9YhBgeMLzinfriaKvhtG6dkelQd1c42E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=L9qf4T7N504tUup2EMrgOywKCo9oYHuACypMQKQgLqtlfwMAZ89jbI8YgeMKheQhU
	 Os6P1SgIFZLcSsxnkeGijkN9B/EywZKUX7RvT1peQIHCvqmiNTEk0WwJfPposmeYCn
	 jNGxMDwVhxAJBQUZr/B3XSBdp91Tf+qfIrfVJeVRdA8GLxSsPW4IvJ1MCxNaHpbUpP
	 yi8AMF0KolD5ita34vGQGIsObe/xVpnc17tKM7+Xn1IMyqsmTHrNLsfj5W6JPWo2rk
	 BDgfMLKchFFDpmBbHTZsWXOxPjBo7tIQiYsHbaGcY9MmQA5/aMXBtDmX5uaD6S+O3I
	 t1RFWRPgZ6h9g==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, weimin xiong <15927021679@163.com>
Cc: xiongweimin <xiongweimin@kylinos.cn>, Jason Gunthorpe <jgg@ziepe.ca>
In-Reply-To: <20260713010439.331054-1-15927021679@163.com>
References: <20260713010439.331054-1-15927021679@163.com>
Subject: Re: [PATCH] RDMA/rxe: Reject unimplemented implicit ODP cleanly
Message-Id: <178410487635.139394.18279326664819014472.b4-ty@kernel.org>
Date: Wed, 15 Jul 2026 04:41:16 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 13 Jul 2026 09:04:39 +0800, weimin xiong wrote:
> rxe advertises ODP but not IB_ODP_SUPPORT_IMPLICIT. The reg_user_mr path
> still contained a dead branch that checked the implicit capability and
> could never succeed.
> 
> Return -EOPNOTSUPP for the implicit ODP address range up front so the
> intent is obvious and the unreachable code is gone.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Reject unimplemented implicit ODP cleanly
      https://git.kernel.org/rdma/rdma/c/9eab9eb2225912

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

