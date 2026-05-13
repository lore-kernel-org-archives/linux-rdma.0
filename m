Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2106D48BD42;
	Wed, 13 May 2026 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685232; cv=none; b=RQg7FsS4OcvwsJO+ZhIyrG48NdKLNdv9fyXoY1h+QLpaNioUR2XmUtvq5di40kGkkfBxz329DBtUpwSiQ0ydWQBwUhs52HsUDtB+I69VldI3ljt5Rg2xprDt5gayvuSm2ukIqkkjef1UPyO71bvI81uyoN6j53NHEacd8y7pFwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685232; c=relaxed/simple;
	bh=cFBDig4H2AxF+N3fcQtoH/Kl6q5RIYACbVTCJm7rLLU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=P9bWo9t2hzxWBUFVS4LBT3ilPbuLzdX60DUSNthh0QLeyjtw6Uh0p+mBvD+mCJQE8QE3Ei5ovqI6glt67N7BzMiPREmGhVWeOavbQ5rQu875+yIfda+t1NtLCUkJdLWtyLjYI4RiWCQ7cTn5xQ4QO0IX2OaPYTlv0cn184uAgwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5bn1t9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5bn1t9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5180CC19425;
	Wed, 13 May 2026 15:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778685231;
	bh=cFBDig4H2AxF+N3fcQtoH/Kl6q5RIYACbVTCJm7rLLU=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=H5bn1t9e7x+B6kyR1i7AQM4dTiHkqxn2PEe5PczTLd83l0F3hM4Ju2GgULoWYTiy5
	 niqJyVS26kvaulUS1jR36IQLK7ibvMJ8XF0ejgLjyFn3Ug2u5ndrXIvoG0UnvqACWQ
	 ltYm4UwTkt0FqUBo0ssNqwpa7//VFpyww/HtPCi1Bdld5BqyPz/1hhsaTENACPvbaR
	 O0nSKr0sOTfs4jmcFmAExodwLYJNAbxzq8R7P6lA6R+f4neskVoTFcuXL4BwmP+Lfs
	 5uKCZKqLP+qWpMjEDl+AXP6XIflJ0beTsIoF3HE4Q0jhCtS+0MzFOSADCUgfc4WDkR
	 zSF6ZewalTwOA==
From: Leon Romanovsky <leon@kernel.org>
To: siva.kallam@broadcom.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Rohit Chavan <roheetchavan@gmail.com>
In-Reply-To: <20260505085709.1755534-1-roheetchavan@gmail.com>
References: <20260505085709.1755534-1-roheetchavan@gmail.com>
Subject: Re: [PATCH] RDMA/bng_re: Remove unused variable rc
Message-Id: <177868522872.2315156.15272705238699997968.b4-ty@kernel.org>
Date: Wed, 13 May 2026 11:13:48 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 05 May 2026 14:27:08 +0530, Rohit Chavan wrote:
> The variable 'rc' is initialized to 0 and returned at the end of
> bng_re_process_qp_event(), but it is never modified in between.
> 
> Simplify the function by removing the redundant variable and returning 0
> directly. This cleans up the code and avoids potential compiler warnings
> about unused variables.
> 
> [...]

Applied, thanks!

[1/1] RDMA/bng_re: Remove unused variable rc
      https://git.kernel.org/rdma/rdma/c/4d575fcf8fdbae

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

