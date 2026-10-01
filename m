Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CADF4F1;
	Thu,  1 Oct 2026 12:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790857958; cv=none; b=J4tqdpPVS1Dam8UVWZQ9KYFvh8KP8lSERv01SmbQQe2aDndaz5l4/gJSK5dqTxLtkJeM73Mho97Mn3c2jeSBKR1pxwVDLZudVpR3s5UrX/0WKdynMoLnDqipi5nEbj5qPubPtTm0y3fRrkwZWi+Rj4qWNdNLx5keHjmDdBxKieQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790857958; c=relaxed/simple;
	bh=2H4dvXkTG/n9Dwckqpz0LSWCVGx6OTNG+gcPZ/vZtdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjanR6M/xKmoROoO+z9Nt2XoyUDqIctNe6FsLeqWqeoq8ylOQgR0VnMPfXeOUG2MEoGSO7pLzYjNe52dFFd6OqkNTC1ubkfnu6QjJHtkBxBls+V1SWuOq/l+itdrB9IFx6BHrzZBzHO0jZRBZxgtk1JWw//wIwgJAsqGygNIp/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJRNaAys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJRNaAys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3111F000FF;
	Thu,  1 Oct 2026 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790857957;
	bh=aSRFVEAHHA5CxlLUYy1xI8LnPQYIia1n92iZY1FjCdA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cJRNaAys7HCF16wrcJsDzgb5OfEerqYnJMq/9001J7jmhy0pudVSm59sn2zFghYJg
	 2uOGCM+i+1xKAs4rn/60T/7+Ufx7DrBrpomwm+WYX2x1PvaorDzBhbk6J9HieHDTsZ
	 R9jsPAkhmtkYeT5HDeXSYlEQPfi6RY9aqffe6NLfI6ZpI8oi1aUU54bfgJgcBtjYxP
	 wrk4m+1cJ5iQO+QbBZwCwy9f3Pb+VYp7MQaAY+YcdrTZAxk5ndA/9fPVifiO5VDYuP
	 ISOkXk4PcKGxnYNnnYu2tzZNDD/3EDpu0OLHPLYCBYSJwp1X8NGdCWLheGyRhEQA+g
	 lOeV6dmLI0qQg==
Date: Thu, 1 Oct 2026 13:32:33 +0100
From: Simon Horman <horms@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, kuba@kernel.org
Subject: Re: [PATCH net-next v4 2/2] net/rds: log the port a listener
 actually bound
Message-ID: <20261001123233.GC13925@horms.kernel.org>
References: <20260927063058.170273-1-achender@kernel.org>
 <20260927063058.170273-3-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927063058.170273-3-achender@kernel.org>

On Sat, Sep 26, 2026 at 11:30:58PM -0700, Allison Henderson wrote:
> rds_rdma_listen_init_common() reports every listener as being on
> RDS_PORT, but only the IPv4 caller binds that port; the IPv6 listener
> is bound to RDS_CM_PORT, as rds_rdma_listen_init() explains, and its
> debug line has claimed 18634 instead of 16385 since it was added.
> 
> Print the port from the address the helper just bound.
> 
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Reviewed-by: Simon Horman <horms@kernel.org>

