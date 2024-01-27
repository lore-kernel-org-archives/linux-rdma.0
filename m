Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C3F79CD;
	Sat, 27 Jan 2024 01:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706318901; cv=none; b=aknrSkxTRrfcqv2bneiZrjSyZLVrEMkhCuj09rR2IBTeXJYStccQG/lkamLjNdUc2MHvn142VMZx4GYU9zx8IpJRr+mmh+WSTt2lsH5e9tzKTTziGDWz1Y7QblWvGb3foiYuRHYJCqOTrXM3JSZMi1jVpElCcKIBFixkUi/Z/Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706318901; c=relaxed/simple;
	bh=xfOkGCrUUYiorc9miYCmzuEaIH+fJKBI12AbPGRHlK8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q5u7gLD/Dv5ddyLdslNfFvK1AemnJy0bIkobNIeaYwHWQyN3Ebbz5J5KoJ04cYC8k/82K+tKawiv1Xzum1lw5mYuhAloyKNsT8j/6Xt9f3JU+AMM50SR9DfXaL7ijIyETm1L2G5g7e19w6OGLP+cxDfAKubEDPctKOI865hqOkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7D4mO0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7D4mO0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874D7C433F1;
	Sat, 27 Jan 2024 01:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706318900;
	bh=xfOkGCrUUYiorc9miYCmzuEaIH+fJKBI12AbPGRHlK8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=o7D4mO0wI4uA9XKdw0iv0g9dSa+bUTl5DxPYvJQzgym9lftVT7Q0fX7RkEuWVkcuG
	 4gmDQmxSefVlIFIuhWrsSA/gOA2ENnjLaGY/N8ttcnVIbxrTbKh7jlOS01Gm1ANiOB
	 8UjO9qKbDfO5JOiS8sPtr8onAn87PeNyRWeMshj0DZc6xAnqjgBQsh41Lb9VD1ajis
	 Z8hZOZibxw6o/+zj4a8yFi3vW/IP6lCIpdm0evo66j1Vg+L43kMFWY1rW8rqDjC3VX
	 1ED03HaLdoZWhwV0yyThUCB9723OO/aBMakPm6UQLBkwvB2hsoZ86iYqZ5ncI+7PQ/
	 nfIdR4rivuT1w==
Date: Fri, 26 Jan 2024 17:28:19 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: allison.henderson@oracle.com
Cc: netdev@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-rdma@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 davem@davemloft.net, santosh.shilimkar@oracle.com
Subject: Re: [PATCH UPSTREAM 1/1] rds: Fix possible deadlock in
 rds_message_put
Message-ID: <20240126172819.4cc13dd4@kernel.org>
In-Reply-To: <20240126172652.241017-1-allison.henderson@oracle.com>
References: <20240126172652.241017-1-allison.henderson@oracle.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Jan 2024 10:26:52 -0700 allison.henderson@oracle.com wrote:
> +	if (to_drop) {
> +		rds_inc_put(to_drop);
> +
>  	rdsdebug("inc %p rs %p still %d dropped %d\n", inc, rs, ret, drop);
>  	return ret;
>  }

This does not build..
-- 
pw-bot: cr
