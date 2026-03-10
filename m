Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38483A6411;
	Tue, 10 Mar 2026 15:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157761; cv=none; b=RtvEvrpVfyozyMeYcw44TJsMTDq9UWhmBbrFWnujv+8rgAopcJ2LHQTciofxZoNul6wxYfRA7gZwrDnnrlDE8nu29VIVXicVeqMUiRPq6+ozmCaiMLxAVkJbEl843G2P2LUJbi7YPCncET0hWGEDqeuz3B6/HsBjllcjUgiJdk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157761; c=relaxed/simple;
	bh=KpJKRBQg3Dc5Ku4deL5sBp8ICuA3q23sgjP19sfNdC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=opqgyO46Xes/q29biyyV/NBl/RJs/bmUuSZ2ns53KjDynJbhyEUFWjY23ZcUiFWmJt2wQEK9Pe2a+MJ5efVrrmsjEahEFNYdZJyMZbKuaR6yMU3drs9EbrG6Y93UUvfvS1Fydr8c29Y0Lz/CT5mUptZhMlYJ5sWu7vSjMRUg7U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVsKbeEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVsKbeEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268C9C19425;
	Tue, 10 Mar 2026 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773157760;
	bh=KpJKRBQg3Dc5Ku4deL5sBp8ICuA3q23sgjP19sfNdC8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=eVsKbeEw9C+lwaa8c0Mei4FMK7mN1JcTAevGwzcxX7KLlIte5w3dusqa/6ZE9k2LJ
	 NdZeLWu0Mv5E1vGyFkWYoxci0l6wJ/eg2d1DxitOORxUo8LezSw2jlPpnE/RIg4RcB
	 w1Ud5e4YZ3SfUnPZBI0UHvJKEpPDW676M+j1LANY4j0UuHi2+mW08T1pbSdWkTeDZ3
	 EL7+cBNY/112cyJddFZv4XBUlIUoE8UWh3OTLSzpLd43IQ7dZCW2UYi4bryPDbX4bK
	 r28uCYGT2ITvNt/LXgxfQI29ArIaRcdTTtnd4TOFMvDsuGeRGXdUmvek5RXCBFgsqu
	 czzYedMVwBfTg==
Message-ID: <f09106d7-b455-47a4-ab8b-651a7c27a596@kernel.org>
Date: Tue, 10 Mar 2026 09:49:19 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] RDMA/rxe: Add testcase for net namespace rxe
Content-Language: en-US
To: Zhu Yanjun <yanjun.zhu@linux.dev>, jgg@ziepe.ca, leon@kernel.org,
 zyjzyj2000@gmail.com, shuah@kernel.org, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260310020519.101415-1-yanjun.zhu@linux.dev>
 <20260310020519.101415-5-yanjun.zhu@linux.dev>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20260310020519.101415-5-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/9/26 8:05 PM, Zhu Yanjun wrote:
> Add 4 testcases for rxe with net namespace.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
>  MAINTAINERS                                   |  1 +
>  tools/testing/selftests/Makefile              |  1 +
>  tools/testing/selftests/rdma/Makefile         |  7 ++
>  tools/testing/selftests/rdma/config           |  3 +
>  tools/testing/selftests/rdma/rxe_ipv6.sh      | 63 ++++++++++++++
>  .../selftests/rdma/rxe_rping_between_netns.sh | 85 +++++++++++++++++++
>  .../selftests/rdma/rxe_socket_with_netns.sh   | 76 +++++++++++++++++
>  .../rdma/rxe_test_NETDEV_UNREGISTER.sh        | 63 ++++++++++++++
>  8 files changed, 299 insertions(+)
>  create mode 100644 tools/testing/selftests/rdma/Makefile
>  create mode 100644 tools/testing/selftests/rdma/config
>  create mode 100755 tools/testing/selftests/rdma/rxe_ipv6.sh
>  create mode 100755 tools/testing/selftests/rdma/rxe_rping_between_netns.sh
>  create mode 100755 tools/testing/selftests/rdma/rxe_socket_with_netns.sh
>  create mode 100755 tools/testing/selftests/rdma/rxe_test_NETDEV_UNREGISTER.sh
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

