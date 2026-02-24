Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B863437756A
	for <linux-rdma@vger.kernel.org>; Tue, 24 Feb 2026 10:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771929592; cv=none; b=bB/iLeIfLL2Hv5jFk2lGb5lSetOrXwMu8hvSWeU0krgayp/1dk38s2+nN64zlQgCfWnitkFYNgx5zeu71iegOHib57JVcNNAg5+rL+6wFuCQXRvLhAahYGa0Bp9KlDtapQqcNttXpXzwrR2E3H/+bcmXl9hRUQLnPHHTO2JHWYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771929592; c=relaxed/simple;
	bh=/yfUHQoVY2Fe1mKTUdqh6jMmVub9OgF9osnrMM3qfgc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bCqKngS1VYOTV5WGUjQ6gDMi4Il1dKfByeGORlco0AdOSCOrSWAmrgmgOglhrBQIP3hVm/B2GLiFy2ZdGAVAB1nkH/iBLM94RHt9RgqgrBeKM46HYdA9Himzj4nJT5DqVWPlmyNhk8wzGHUOmzhc+0R3P5svN4HiSR0LfjkouKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TdrcTSK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TdrcTSK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E383FC116D0;
	Tue, 24 Feb 2026 10:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771929592;
	bh=/yfUHQoVY2Fe1mKTUdqh6jMmVub9OgF9osnrMM3qfgc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=TdrcTSK8c0/tSqpti+8ct6IVMhEur8KrIPpOkocAKtD9sWMqzSBs0sqFhUriW+R9I
	 fBfQFINlLl7XqjNPbNCbg22mtidBRdi2kUwcTt0ytWAvL/blMkftJUxtrOKzYs5uUo
	 o6ZixURrWTXFVXE3fxZCF2/qbKBRuInT8+bc2hvGmrDmcWmq0Aedv1Q9aeP25mQ+Yj
	 eUPgJwF/G3uV/S/GNQyeOmsIIc+7hS/VMVQIcHJbh43BWZrpPmwR4QwxYUuSXkO5ZZ
	 4gqB9sTnPud78EqqdITqMS2sg7pxW1D+XfJ04s7+lCz8GRgvjW/lTH+V/cRe4Qggqe
	 1a1EvineVkPxQ==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
In-Reply-To: <20260224003134.3174856-1-rdunlap@infradead.org>
References: <20260224003134.3174856-1-rdunlap@infradead.org>
Subject: Re: [PATCH] RDMA/iwcm: fix some kernel-doc issues in iw_cm.h
Message-Id: <177192958857.751672.11282729912946535002.b4-ty@kernel.org>
Date: Tue, 24 Feb 2026 05:39:48 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Mon, 23 Feb 2026 16:31:34 -0800, Randy Dunlap wrote:
> Use the "typedef" keyword as needed.
> Correct 2 function parameter names.
> 
> Warning: include/rdma/iw_cm.h:42 function parameter 'iw_cm_handler' not
>  described in 'int'
> Warning: include/rdma/iw_cm.h:42 expecting prototype for iw_cm_handler().
>  Prototype was for int() instead
> Warning: include/rdma/iw_cm.h:53 function parameter 'iw_event_handler' not
>  described in 'int'
> Warning: include/rdma/iw_cm.h:53 expecting prototype for
>  iw_event_handler(). Prototype was for int() instead
> Warning: include/rdma/iw_cm.h:104 function parameter 'cm_handler' not
>  described in 'iw_create_cm_id'
> Warning: include/rdma/iw_cm.h:158 function parameter 'private_data' not
>  described in 'iw_cm_reject'
> 
> [...]

Applied, thanks!

[1/1] RDMA/iwcm: fix some kernel-doc issues in iw_cm.h
      https://git.kernel.org/rdma/rdma/c/16dc2d72de577d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

