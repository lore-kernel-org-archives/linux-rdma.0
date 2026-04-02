Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34D2EEC0;
	Thu,  2 Apr 2026 00:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775088363; cv=none; b=AVNu1Vf7seHIZZI2GeCh+cNwR5A7l6sYQ71nx9kAhHr8+o8WmR8wi1zdI3MI5LpeVLO5UETNH7pwSemcblt9OG0uOHW4Dhvztay42z/zrvNktg4sZbtGxB3LsKrDKIsDhJDMFSZ8mC10y7ubiHAXyniXT+g1vUMbXrQP8geFAtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775088363; c=relaxed/simple;
	bh=Hm5EWWDTjwUIWrWPKJ2kbP9Plm8b5q0Yv3+qJpfp7hA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PUvtRRwwzYSU0a2JN0EjFtqWRol66x/NpQfeCm4bJPSM+1fKSQCJ3Hy9GNP5tqCD3DQgMW9L5fO0SU3OYukCssikT9To6UBwWbh0PSZ0acDY0E/8VLf0IHIlgU2u3cVOvsBuqPpHtXYYZahr9dGGQJhSwtBTcXtMi/8COzbOZkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=itPdhWOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="itPdhWOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9977C4CEF7;
	Thu,  2 Apr 2026 00:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775088362;
	bh=Hm5EWWDTjwUIWrWPKJ2kbP9Plm8b5q0Yv3+qJpfp7hA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=itPdhWOpo1cn9X0A/A2aieNHKjY4stV3UqvNAMRhKd1/W7AMd84aTZElRZ4F/gLlf
	 eHzl4m+LJE/xK8OuZ18wPfk2DYqKFsU68ORA8dIZQw8GVBeyHTY8hZHCgp3DsU8Nrc
	 eYuKnzPd6Px0Gty2HFpF/Cf49soq+Bth09yZ/Bl8pPfA9/QFuTfmtdGQonjt9tEURx
	 +J1iOEdS86krPChiFzT70r97vdCpDbc7UyLUD1jZ2dcAQ1czzGfrqd2z6Pznxf64Wg
	 mo7qB0RLGr/544k1G5zpRTzZbG1iZ5dooy6Hhub5PmHbQp6hW8DNbV11K+KjQrMMLB
	 8+0MI0VGE78Pw==
Date: Wed, 1 Apr 2026 17:06:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
 <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
 <pabeni@redhat.com>, <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
 <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] net: ionic: Add PHC state page for user space
 access
Message-ID: <20260401170600.312a23d1@kernel.org>
In-Reply-To: <20260401102501.3395305-3-abhijit.gangurde@amd.com>
References: <20260401102501.3395305-1-abhijit.gangurde@amd.com>
	<20260401102501.3395305-3-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 1 Apr 2026 15:54:59 +0530 Abhijit Gangurde wrote:
> diff --git a/include/uapi/rdma/ionic-abi.h b/include/uapi/rdma/ionic-abi.h
> index 7b589d3e9728..97f695510380 100644
> --- a/include/uapi/rdma/ionic-abi.h
> +++ b/include/uapi/rdma/ionic-abi.h
> @@ -112,4 +112,15 @@ struct ionic_srq_resp {
>  	__aligned_u64 rq_cmb_offset;
>  };
>  
> +struct ionic_phc_state {
> +	__u32 seq;
> +	__u32 rsvd;
> +	__aligned_u64 mask;
> +	__aligned_u64 tick;
> +	__aligned_u64 nsec;
> +	__aligned_u64 frac;
> +	__u32 mult;
> +	__u32 shift;
> +};

You're just exposing kernel timecounter internals.
Why is this ionic uAPI and not something reusable by other drivers?
