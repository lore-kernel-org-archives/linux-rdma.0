Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DB61E1DFC;
	Tue, 27 Jan 2026 14:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769523619; cv=none; b=GwHdoRGjGuFHETEloLCdVb1aPlEbuS9309PXB5slS5HSBYfy/SB4HYbe9Dpo+zF0rb15oJ41P9wD0wCvMXepgvK7HqK9PQuc3XiTV+BC2AKF7PACTXidWzw5nDTyLqqI5WkjIk55iet2WM2P6sXrUs2X4zY7UnWLpYOdB6lKGUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769523619; c=relaxed/simple;
	bh=T8zQub03vXPnd5hqr0xNscuKwDcvEebFeLOJfzUCjS4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FSQcAgoxghXq5Lg3rkUJRUcpQgyNhjWQ3Mx0eLd2OxKJxY39gGoC6mIVKud7UIU7BciHTvRuv/cwUSCYqnsFkk/CxDaDBslAoTtElrHvuXsLDH8/6xrtGN4EU/fqkhL2VeN8ekOQNyi2YRej+sgtl2wM0s7Ojr0K5zAHB1ONTH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MS+pYW7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MS+pYW7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63296C19422;
	Tue, 27 Jan 2026 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769523618;
	bh=T8zQub03vXPnd5hqr0xNscuKwDcvEebFeLOJfzUCjS4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=MS+pYW7sk9hSTxua0tNxvvwQDfn/C21a7f67YsANXNMLV6ald76nwHDgiejQFaw0k
	 VcP8QaZZLv7o3VjFAioNEOyE4VuSfK30HaDO37Bg0oM1Lt4HjWuz0ZhY+JXIXzT9Ds
	 afezgOEExWjuG+/qM73sZGZe+V1ZKoHob0sfn4arh2luSpwEvP40qSmlX8IiRYvsWS
	 h8+u3VSRxzU9XFSR+YUZ+3JwbRSVm1+IWizUenqQwK0BA7r7TkLTXP3XF1vs7r0MeR
	 ruBASPLYrxmO7IFvWn0vtGJkDivAqUtiVT0eNQc1WlmkmcDZzH/A/0TdVWU3X4IaCl
	 DHamfIX5PJhMA==
From: Leon Romanovsky <leon@kernel.org>
To: kotaranov@microsoft.com, shirazsaleem@microsoft.com, 
 longli@microsoft.com, jgg@ziepe.ca, 
 Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260127082649.429018-1-kotaranov@linux.microsoft.com>
References: <20260127082649.429018-1-kotaranov@linux.microsoft.com>
Subject: Re: [PATCH rdma-next v2 1/1] RDMA/mana_ib: device memory support
Message-Id: <176952361602.919365.13871249642943514688.b4-ty@kernel.org>
Date: Tue, 27 Jan 2026 09:20:16 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Tue, 27 Jan 2026 00:26:49 -0800, Konstantin Taranov wrote:
> Basic implementation of DM allowing to create and register
> DM memory and use its memory keys for networking.
> 
> 

Applied, thanks!

[1/1] RDMA/mana_ib: device memory support
      https://git.kernel.org/rdma/rdma/c/a01745ccf7c410

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

