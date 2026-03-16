Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C7234C83D;
	Mon, 16 Mar 2026 20:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773692454; cv=none; b=s/SEgeRqfwjQ95FBO4pXGdKNytV04KZhYZ1sFg7HUPTMUjOQpH8wxDqIWwHoOO7TzfUyJCbVBr/mh+VRJuGVbImUMW/M/NA0Lp1StRB4g1WRwhImoxc5rpr92RbimEF8koH66eGSkOCBP5rfoCP9PNqN0QesgwDP0t/gAGOaUIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773692454; c=relaxed/simple;
	bh=X3qdF+QcSoqBbZL+mfmbGq9QVmSWgeNNE6cfst+rcio=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dNn24iWu2Wg6tqp6JNqR0g7zd8CbleC+Bylyhy2gsMrgWbeqF3UkUyvN6sRMse/0mlBN+uojr50B+UoGmFwqmA6uGntqpZ8AbtA0YUXK0y+1+dWo9RU5gAEZIreEQJrBNNRuuEagATI3++ebB9zmrG8BsHjdn7yZEjo2jm+X2O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/RwHIg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/RwHIg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265D7C19421;
	Mon, 16 Mar 2026 20:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773692454;
	bh=X3qdF+QcSoqBbZL+mfmbGq9QVmSWgeNNE6cfst+rcio=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=O/RwHIg2G4i65VqgAlIysUYPV/oofaQFEsOEupMHCaZW1h1CuK4Apg0HwiaaTTaRB
	 bqj0yuBDU6Ecmnk8bo2MqMl4vLf58MgHIEADZsr1YlqE2IyJOd7adfY3AAhhM9uN80
	 y0fHsyw2AefOBq9f4k6DRS0ne9R7eRRpHaXbDDBRzAxyEfSMFwn/39M48wgwaXaaJz
	 cS2aMEvL0kS+9xPVpvZS/wqS1Gsi2aeUcK3mhag7/llrp6FL0kscgpqLGgB8AiGLcD
	 o1+WYVTbDtXUQ6zAIquYmDGjLXD99/elPRm82PSddsRRom4kKA9iEBlt8/eouJlgtG
	 gR8qzmL/IrNcQ==
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-rdma@vger.kernel.org, Ethan Tidmore <ethantidmore06@gmail.com>
Cc: Gal Pressman <gal.pressman@linux.dev>, 
 Yossi Leybovich <sleybo@amazon.com>, Daniel Kranzdorf <dkkranzd@amazon.com>, 
 Yonatan Nachum <ynachum@amazon.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20260314045730.1143862-1-ethantidmore06@gmail.com>
References: <20260314045730.1143862-1-ethantidmore06@gmail.com>
Subject: Re: [PATCH] RDMA/efa: Fix possible deadlock
Message-Id: <177369245162.225830.12389860834345738153.b4-ty@kernel.org>
Date: Mon, 16 Mar 2026 16:20:51 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 13 Mar 2026 23:57:30 -0500, Ethan Tidmore wrote:
> In the error path for efa_com_alloc_comp_ctx() the lock assigned to
> &aq->avail_cmds is not released.
> 
> Add release for &aq->avail_cmds in efa_com_alloc_comp_ctx() error path.

Applied, thanks!

[1/1] RDMA/efa: Fix possible deadlock
      https://git.kernel.org/rdma/rdma/c/5c241838c6bba6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

