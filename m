Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1974831A92;
	Fri,  8 Dec 2023 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uN0LFax9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A797C433C8;
	Fri,  8 Dec 2023 15:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702050639;
	bh=8TvvcdH6y68CeejUuXRNHc2JUCHSpN9wLs4oh8xA/vM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=uN0LFax9ioS0a0f35lJP4tbhwaiXRwQ6k4SFz3TUfUDWmp3X/07k+1J5AXTKjYrqZ
	 Zu9iUDDnkhvEiIJD8LoTW1wb5L9jojPxIIECuDiHhvHCGtyIUS6hiknqaDz+z9GOWE
	 9ZhJz4tMkhDtyY64xRwdmJWa+mGQ4548fvZ5UBJfU2d059DbkvkUaKHkQXNAEM+aeN
	 dd7I/haQAxyds6ujweuWSDeQd0oMHtySOkfuoI29tFqE9B/OE0DaClUGTrjD697C87
	 d5jMlWzNmy1ouRnjr+RTdAsbC8iEOTW7sms+brb/J5cvDneN1q49WoZP1eZ+GomLoC
	 naq/eCk5Qoqhg==
Message-ID: <7e370f63-f256-45f3-89c9-7774877afaba@kernel.org>
Date: Fri, 8 Dec 2023 08:50:38 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v6 3/7] RDMA/rxe: Register IP mcast address
Content-Language: en-US
To: Bob Pearson <rpearsonhpe@gmail.com>, jgg@nvidia.com,
 yanjun.zhu@linux.dev, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 rain.1986.08.12@gmail.com
References: <20231207192907.10113-1-rpearsonhpe@gmail.com>
 <20231207192907.10113-4-rpearsonhpe@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20231207192907.10113-4-rpearsonhpe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/7/23 12:29 PM, Bob Pearson wrote:
> diff --git a/drivers/infiniband/sw/rxe/rxe_mcast.c b/drivers/infiniband/sw/rxe/rxe_mcast.c
> index 86cc2e18a7fd..5236761892dd 100644
> --- a/drivers/infiniband/sw/rxe/rxe_mcast.c
> +++ b/drivers/infiniband/sw/rxe/rxe_mcast.c
> @@ -19,38 +19,116 @@
>   * mcast packets in the rxe receive path.
>   */
>  
> +#include <linux/igmp.h>
> +
>  #include "rxe.h"
>  
> -/**
> - * rxe_mcast_add - add multicast address to rxe device
> - * @rxe: rxe device object
> - * @mgid: multicast address as a gid
> - *
> - * Returns 0 on success else an error
> - */
> -static int rxe_mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
> +static int rxe_mcast_add6(struct rxe_dev *rxe, union ib_gid *mgid)
>  {
> +	struct in6_addr *addr6 = (struct in6_addr *)mgid;
> +	struct sock *sk = recv_sockets.sk6->sk;
>  	unsigned char ll_addr[ETH_ALEN];
> +	int err;
> +
> +	lock_sock(sk);
> +	rtnl_lock();

reverse the order. rtnl is always taken first, then socket lock.

Actually, I think it would be better to avoid burying this logic in the
rxe driver. Can you try using the setsockopt API? I think it is now
usable within the kernel again after the refactoring for io_uring.




