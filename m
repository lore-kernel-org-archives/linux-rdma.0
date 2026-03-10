Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7E43B19A9;
	Tue, 10 Mar 2026 15:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157681; cv=none; b=OOQsIO/1lSQp74L4QiBr6qlKDOVK7wZUvqy0K+JMOvs4526YHNMghzojzP93SIJNOwQ3aJILQz/JS+59MBqv6NVEWr66zlYeJe+CoQS8XvASn9F0KU2+klgEUmb5I8jonGJMSUmflKxg+xY5C7y5EpweWAfapfwSeFzL/tet05g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157681; c=relaxed/simple;
	bh=6ibFQ3/qoAq3dRoL9b2ENcfsj5lcqNDMlsUM9Py6KdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Wi7o1OnrOqxsWcbmbIgM5PjO4i3+vKQk7yBQxJ/3e7rArwo9r/pEEEhmaOwnppRIXJIN4dUcolJRDhwUNeSnwNTb5ThVDPseBQkzwln/QUiHaoPv2zDijVGvtcm65MahYqBFss8cGVB/enG3FxVO1UrNtS6Fd0xp/a8mwMLXm7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjTyAhvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjTyAhvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E19C2BC86;
	Tue, 10 Mar 2026 15:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773157680;
	bh=6ibFQ3/qoAq3dRoL9b2ENcfsj5lcqNDMlsUM9Py6KdM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=HjTyAhvWxNnv91QqYDFV+ZvfTbGENGyHWmiAYL33wW8wffdoeqMXyBSwGuQQm0acR
	 4NxQggz+fjbW7FtMsiDMoEIx1gP+y7ELEqU6iF6B1kxmFlkjfShH4tc0ELZ6OJhsxJ
	 KQxUpSC/F24vcR30gvN83GpZt+j6GnKEm1PokVfhUV8bOYusSyWhYkcLeQjD3Ynm4s
	 NYGosigzmfK5TDjxyr01CiCohrHkt0f4JynYr7lkYX2XGX1R1ghO6rQ53NSDzS6qmp
	 YGFM5lZbA0+qCI4RQs7SEv3SW4mNwld3Xn28RXPJZUh53M0+iXZv6C392RASDAzBTt
	 88rFdDRBcLMVQ==
Message-ID: <7bb0928f-1fbe-4c21-8918-99b0cfede0b4@kernel.org>
Date: Tue, 10 Mar 2026 09:47:59 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] RDMA/nldev: Add dellink function pointer
Content-Language: en-US
To: Zhu Yanjun <yanjun.zhu@linux.dev>, jgg@ziepe.ca, leon@kernel.org,
 zyjzyj2000@gmail.com, shuah@kernel.org, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260310020519.101415-1-yanjun.zhu@linux.dev>
 <20260310020519.101415-2-yanjun.zhu@linux.dev>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20260310020519.101415-2-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/9/26 8:05 PM, Zhu Yanjun wrote:
> The newlink function pointer is added. And the sock listening on port 4791
> is added in the newlink function. So the dellink function is needed to
> remove the sock.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
>  drivers/infiniband/core/nldev.c | 6 ++++++
>  include/rdma/rdma_netlink.h     | 2 ++
>  2 files changed, 8 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


