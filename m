Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3131A3CCA05;
	Thu, 19 Mar 2026 23:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773964532; cv=none; b=feZhPolKVb7i01FlIk83PaK3giT+/e9TqiupPWsLuMytuaCRe2UIRv3cwm1hL4Qeay+O0t/dF1CLS28ZFengPdC7EvEGPmmrfsBIb7UXIoHVSUkZenVp3Yxv8+EfXrjBsX9uHgh3P8zAL68RHLtjUolq0Fsh+VMGlTCEuL+ZBwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773964532; c=relaxed/simple;
	bh=aWhhuGA/F8QBOdpone2Nhm7d1uBpbl7/3jMAOi2iDW0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cZkIyLcauaTNr9luc6VMwbVRewqXArvnRn7oSYYCAgwSW4sBdWl61KTF5TPi7i3fRXo8BcVF++1uuDIe4E9gmyz8rakCwMSUbx5RFdwK6mPDJdzDgAsNIxESZjTRUC+PSVgUg9WtMqQYGipZ0FN9YZCEg4sCZCUUpqB/f3u/Nkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hm7QUfJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hm7QUfJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120F1C19424;
	Thu, 19 Mar 2026 23:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773964531;
	bh=aWhhuGA/F8QBOdpone2Nhm7d1uBpbl7/3jMAOi2iDW0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hm7QUfJ8ABixwpDY+SFVmnUT2J0sfb5Kztb6nUAXyxjqeFQxJqkY8xVuJ3neT5+vv
	 lU2Qr4QYrlbpeOY7VmT3dCisoMU3fS40T0rkaxLMB3sIfRGyHbPy0/XGsXm+2x6K4U
	 yZG3t14fPt2qmDVG6v5OM8htWhmQdCBNUjEDvzsuY9H3XaRMa0K9F/Whc711vPGBef
	 SkuX13kufmpVJ3V1U6lL2MU7v9lEfKlkdMBbU9UoL9rOgrVsz6W85yCAH00Fi2z6HD
	 tLVEnt16zds3Z4RcDj1iGsUq3hH++eAxyDhYQC4Pe6tLpxlmUtOQb80OTxQWMK7Ikm
	 1NRNY5DZ0N7eA==
Date: Thu, 19 Mar 2026 16:55:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 pabeni@redhat.com, edumazet@google.com, rds-devel@oss.oracle.com,
 horms@kernel.org, linux-rdma@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH net-next v2 1/2] selftests: rds: add
 tools/testing/selftests/net/rds/config
Message-ID: <20260319165530.0472ab6f@kernel.org>
In-Reply-To: <20260319165435.4468160f@kernel.org>
References: <20260319004618.2577324-1-achender@kernel.org>
	<20260319004618.2577324-2-achender@kernel.org>
	<20260319165435.4468160f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Mar 2026 16:54:35 -0700 Jakub Kicinski wrote:
> Contents of both these files need to be sorted according to the whims
> of these scripts:
> selftests: rds: add config file and config.sh -c option 

paste fail, I meant this:
https://github.com/linux-netdev/nipa/tree/main/tests/patch/check_selftest
