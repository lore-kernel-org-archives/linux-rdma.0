Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E172543231D;
	Wed,  2 Sep 2026 13:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355389; cv=none; b=CDi6PGzcoU8UEGnrYGpjWprJnSkIS18JpOurvHjZPv1JyIyw1hV/L4+wndhtqBWGksfpb8iGfqisi90fTCKv/VTgnaVLIYzTwsCKkhqIZIZEVK36aOkuykYiCvTZPN9sI+akoxrs1KxJtsDtbSP/Zx7qgStEUKbUk/5kYKOC3Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355389; c=relaxed/simple;
	bh=2CM/KH+tavjtIAroEulUiItNXRiGDNC8/zDwFxHlwu0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pPk2IfjQFJeFGGaE/RGmM/a+b2hRfupz9nuc5pseug0XDxbzGkAxThNIhF5wBr2mPa+85RjQLe0LG6vxmy0NKeVNtg/KWdDd4NOkg3gLXaAvXF96Xb9IG6sKOKEvMjACFN8+i2QOPXj0+NUUYwFVNnArZ+W9xJaAqkzxRxCokAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+16GVEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+16GVEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22A81F000E9;
	Wed,  2 Sep 2026 13:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355386;
	bh=bxUlkYfK8xT+1kwgb0O2d01WK749SdTYmGt4vPC5cCk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=b+16GVEI4iWJSYMNC8o4DyU41M+k3ugG6Firq0VcAh6k+XrcoFolFRkZJsUbUAQfU
	 RD0oITT5J3vevvyNtcB+038B9+Co5hpGf56aVcUWDE2Xohe+PehRMHgx5BhRt9rLsc
	 PJ8l/OEdAyjv4c8wxnzG+kzkfpI9x+8yF49RSEVVfX1iIA8Wbf7uLRYt+xL+GbMf5g
	 1C7NXztYmE5w4CKi3o8RY17s03F7xfiBaKZpuxZSu1ik9/7KiAJYfpk+l5b9Lq4Ab3
	 n261X6XDCRvbSa+Nx49TLxs6wVyGWrj5Y3zEU3o2/AW4+pXjUMd+8lnz0T8EvAZpg5
	 Qn5SMEl4ZOSuA==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Linkai Gong <gonglinkai@kylinos.cn>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260821090908.1310605-1-gonglinkai@kylinos.cn>
References: <20260821090908.1310605-1-gonglinkai@kylinos.cn>
Subject: Re: [PATCH] RDMA/bnxt_re: check create_singlethread_workqueue() in
 DCB setup
Message-Id: <178835538351.2486487.3724592189174179663.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 09:23:03 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 21 Aug 2026 17:09:08 +0800, Linkai Gong wrote:
> bnxt_re_init_dcb_wq() ignores a failed allocation. The async DCB
> handler later calls queue_work() on the NULL pointer.

Applied, thanks!

[1/1] RDMA/bnxt_re: check create_singlethread_workqueue() in DCB setup
      https://git.kernel.org/rdma/rdma/c/6c368f7baaea63

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

