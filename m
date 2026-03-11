Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003B62F5487
	for <linux-rdma@vger.kernel.org>; Wed, 11 Mar 2026 22:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773266972; cv=none; b=lb5sUhkcq6qXouy+vtz/23kEO77DohfTaZ2GQ8EYfC3VeTQ2BFo1aX+8nQssLQ0VFgjcFMqsrYuE6+hbyoty2juPiyndJZJA52DSnEfiHBwJGPgvjGl4WvZcBRaf3R9QwtN+qB2gsxSSwCYzA5+oMsGPk7aXnEgREow6Mtfnu6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773266972; c=relaxed/simple;
	bh=vHEiGVqwtPyudmbk1UW3EcHDyuZtvOX8ZvY257epeOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lFlzQlzxW1LnpEVrHPsuCFd5+5eFwYgG8+x9ed65Wre2AszPUwEx7aigmbrdWgUdjqslOkVVCHqQNDF2hARtrc8q3CPJYMmPHmm4RmVNZYAqaeNSKwWmT4NX3Kbzm/bmcPoQit21Dup3ja9F2ZN8tkVdDyoQCkVAmltfhlg8y3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qrBpIQwL; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qrBpIQwL"
Message-ID: <db3d0678-43bf-4131-bb3c-f6bb9d54218f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773266968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eT0tL5gn/Ht7DTCQhzwUw2fk0bV4JBnWHSBr2Khv9Oo=;
	b=qrBpIQwL0qVrj91VptZ7w4RNFDQXPUUqirFOiEQXMGdxd0tZZlGHOd5Ky93GzIMAOlFJKF
	NaxQWAtXbdd7dQWV42Wppo0S8DB05+Gg7VUfJU1Gxj7/LJvEL0fWRxGvuQ+GaC0j2aa/kw
	pcZsxJn56lpRNchIVt+of3lOh67dtqs=
Date: Wed, 11 Mar 2026 15:09:24 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 1/4] RDMA/nldev: Add dellink function pointer
To: Leon Romanovsky <leon@kernel.org>, Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: jgg@ziepe.ca, zyjzyj2000@gmail.com, shuah@kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
 dsahern@kernel.org
References: <20260310020519.101415-1-yanjun.zhu@linux.dev>
 <20260310020519.101415-2-yanjun.zhu@linux.dev>
 <20260310190140.GL12611@unreal>
 <5700c718-d10e-4b23-adfc-c14ee1930b18@linux.dev>
 <20260311085434.GW12611@unreal>
 <6a8b0983-a198-470a-8125-b0133ccb7032@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <6a8b0983-a198-470a-8125-b0133ccb7032@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 3/11/26 3:01 PM, Yanjun.Zhu wrote:
>
> On 3/11/26 1:54 AM, Leon Romanovsky wrote:
>> On Tue, Mar 10, 2026 at 06:58:00PM -0700, Yanjun.Zhu wrote:
>>> On 3/10/26 12:01 PM, Leon Romanovsky wrote:
>>>> It is an RXE‑specific description, but you are adding code to the 
>>>> general
>>>> nldev path. Please clarify that this behavior applies only to RXE, and
>>>> include examples showing when and how it is invoked. In particular, 
>>>> explain
>>>> how the socket is cleaned up if delink is not called.
>>> Hi, Leon
>>>
>>> You are correct that this logic should be driver-specific. I will 
>>> add an
>>> explicit check for RDMA_DRIVER_RXE in the nldev path to ensure this 
>>> behavior
>>> is strictly scoped to RXE and does not impact other drivers (like 
>>> iWARP).
>> No, you don't need this driver_id check, because iWARP doesn't have 
>> link_ops->dellink,
>> but you should document the rationale and how it is triggered for RXE.
>>
>> Thanks
>
> Hi, Leaon

Sorry. The name should be Leon. My bad.

Zhu Yanjun

>
> Got it. The commit log explains how the netdev_notifier mechanism is 
> used to clean up the related resources.
>
> In the source code, additional comments have been added to explain how 
> the dellink operation for rxe is triggered. For iWARP, this change 
> should not make any difference because iWARP does not implement the 
> dellink function.
>
> The commit is shown below. Please take a look and share your comments. 
> If you agree, I will send out the latest commits out very soon.
>
> From c05038dcdf69c5985837736a8926ba76d9f3e8e4 Mon Sep 17 00:00:00 2001
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> Date: Fri, 23 Sep 2022 16:52:45 +0000
> Subject: [PATCH 1/1] RDMA/nldev: Add dellink function pointer
>
> The newlink function pointer was previously added to support
> dynamic RDMA link creation. In the RXE driver, this path creates
> a transport socket listening on port 4791. Consequently, a dellink
> function pointer is required to ensure these sockets are properly
> closed when a user administratively removes a link via rdma link
> delete <dev>.
>
> Furthermore, RXE does not rely solely on this nldev path for resource
> management. It also monitors the underlying net_device state via a
> registered netdev_notifier. The rxe_net_event callback serves as a
> fallback mechanism to ensure that transport sockets are forcibly closed
> and all resources are released even if dellink is not explicitly called
> (e.g., if the parent NIC interface is removed or the driver is forcefully
> unloaded).
>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
>  drivers/infiniband/core/nldev.c | 12 ++++++++++++
>  include/rdma/rdma_netlink.h     |  2 ++
>  2 files changed, 14 insertions(+)
>
> diff --git a/drivers/infiniband/core/nldev.c 
> b/drivers/infiniband/core/nldev.c
> index 2220a2dfab24..34f5faf80d9c 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -1824,6 +1824,18 @@ static int nldev_dellink(struct sk_buff *skb, 
> struct nlmsghdr *nlh,
>          return -EINVAL;
>      }
>
> +    /*
> +     * This path is triggered by the 'rdma link delete' 
> administrative command.
> +     * For Soft-RoCE (RXE), we ensure that transport sockets are 
> closed here.
> +     * Note: iWARP driver does not implement .dellink, so this logic is
> +     * implicitly scoped to driver supporting dynamic link deletion 
> like RXE.
> +     */
> +    if (device->link_ops && device->link_ops->dellink) {
> +        err = device->link_ops->dellink(device);
> +        if (err)
> +            return err;
> +    }
> +
>      ib_unregister_device_and_put(device);
>      return 0;
>  }
> diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
> index 326deaf56d5d..2fd1358ea57d 100644
> --- a/include/rdma/rdma_netlink.h
> +++ b/include/rdma/rdma_netlink.h
> @@ -5,6 +5,7 @@
>
>  #include <linux/netlink.h>
>  #include <uapi/rdma/rdma_netlink.h>
> +#include <rdma/ib_verbs.h>
>
>  struct ib_device;
>
> @@ -126,6 +127,7 @@ struct rdma_link_ops {
>      struct list_head list;
>      const char *type;
>      int (*newlink)(const char *ibdev_name, struct net_device *ndev);
> +    int (*dellink)(struct ib_device *dev);
>  };
>
>  void rdma_link_register(struct rdma_link_ops *ops);
