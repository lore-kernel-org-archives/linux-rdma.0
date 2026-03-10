Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED543859D5;
	Tue, 10 Mar 2026 18:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165862; cv=none; b=g/i+gJS1W76IFX7B2CLL2cNUqQs8Cm6zHCUlhtUdaUuaUHvFItj0mJIxQ1SnD6Xxq9RnNlZQzjz299Ia+20bnChceBVYyjVlwosJ6JVAmJocsaXXO7rW7vNPuB1WgZDeJXA3E25WXPNMyKWk5/CYe0cM/wdHpbg1qrYglecwVyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165862; c=relaxed/simple;
	bh=MU22B51NjTl8uvI31sGl2YxgbTtKlLhz6viNLznZVxE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pQjO2ciVMWgilGvVsQEjy2v8SMNUF+AOlmHUizmZFh58MLz3UwtoMwE+eiwaYIvCM/fRBtbEonzQWJSvFdLvcUqGeq0xhRy8DDA2ccae7lIqin6XX5FwIQK+ZmzrpVLHyzGptl1QPz68lj47cAH7DozTZSHFP7gUWmVe6ZjLngE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XHoBms+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XHoBms+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2EFC19423;
	Tue, 10 Mar 2026 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773165862;
	bh=MU22B51NjTl8uvI31sGl2YxgbTtKlLhz6viNLznZVxE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=XHoBms+0N0cNCuirdPkRhFK9kl8arnNHaYU1JLVXuVuqD8rdo2aeKnXeRxSvk6w9L
	 Hxw/5at4gbPb6iOJwFR451CiLLvw95/wBnJ28sVTxhQEFoN28WufIKdgan90GNVJ82
	 JLL0LzMvmixwvjLvDXkd8SPcSbUqp1bAFefMQrWA0MXEHNduZcD0LOvgJPon7Ptgfq
	 ciB47IGHlrb+9vnWyFEOaruqE0me+OITLhfPd7K474zQg9AptuZcDiDP661SWDYpgP
	 oJwYg46bQADdgWdk1IWBsqRNaG3yUK8fywM5fquutO8z60sdlTSC/OxAUaXPcg0ipV
	 u7ngw5i4VHjJw==
From: Leon Romanovsky <leon@kernel.org>
To: linux-rdma@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 linux-hardening@vger.kernel.org, gustavoars@kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <20260309215017.4753-1-rosenp@gmail.com>
References: <20260309215017.4753-1-rosenp@gmail.com>
Subject: Re: [PATCHv2] IB/hfi1: kzalloc to kzalloc_flex
Message-Id: <177316585982.1721111.1793505374480694836.b4-ty@kernel.org>
Date: Tue, 10 Mar 2026 14:04:19 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 09 Mar 2026 14:50:17 -0700, Rosen Penev wrote:
> Combine kzalloc and kcalloc with a flexible array member. Avoids having
> to free separately.

Applied, thanks!

[1/1] IB/hfi1: kzalloc to kzalloc_flex
      https://git.kernel.org/rdma/rdma/c/120ad1fd591402

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

