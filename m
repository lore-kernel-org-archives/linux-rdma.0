Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806223806B3;
	Sun,  8 Mar 2026 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772991863; cv=none; b=ShnfnVhiOCJeoDQBjiveQKDsGAXEgFKdfvgfTQWCKsdk8Tj969rmxIydk5HFzWmKs1Efit5UWhuYzbU0OyrNPKLlR4VXwF3QDihZnSV0AynvnPU62gD/sn6MIYLCWokiINTKyvhnZDcQkd97gO+NHuN3xUxTPX52dJUwchO2/qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772991863; c=relaxed/simple;
	bh=p39jlz7t3oGzMBzB1TxNHtTNmwPEla7Ee7ICbxRw4w4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=I0ff65Fnjt6PTw0zg9uXt72kuc6PikF5xGI5iEozU7acqMGFBClzgODrXX3/HnHp5AjD0MyVmimsTwm/crqYClCDEUAAPqzlsqeqrzv7SvphZiXggWWYiPiZqxkWqgwJqYpw9e/iapZkUf+Af3douEpRpUL7x3yf51tbId3G3cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbZ1rrG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbZ1rrG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AD6C116C6;
	Sun,  8 Mar 2026 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772991863;
	bh=p39jlz7t3oGzMBzB1TxNHtTNmwPEla7Ee7ICbxRw4w4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=YbZ1rrG9LVcM0RNToqDVwv2hfIXTe/ZK37vBE+NXqUSijitRPuRaRkntixBhxefgg
	 9ib4NE8/ys2aC8+RTrYORDjF2XWBmBpBbtVlatkNQbZT3NuKPv4/71o1zPiQduxP3X
	 zTNmo2j5mM45/JCJkCOXUCSz9lUuoZV8lpRQVFKrWJpcTx19SQxJdqvBHTZFUczAOT
	 dzyYhhOjhyaYIC2KS/W+efRq7EVmt0V2QUxQmlNxvznruVt3DQvrWHvQMA31g8MSAF
	 O6YlFrYopLCaW+HV6qUs0Tn8fQrn2q9dB+fiCkzhE3JPHIkUdJBP8dGFFRYTEJ989S
	 Ubt8tYYWItixA==
Message-ID: <99e6f2c5-b039-4d47-8674-7d89a83fa849@kernel.org>
Date: Sun, 8 Mar 2026 11:44:22 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] RDMA/rxe: Add net namespace support for IPv4/IPv6
 sockets
To: Zhu Yanjun <yanjun.zhu@linux.dev>, jgg@ziepe.ca, leon@kernel.org,
 zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260308074711.24114-1-yanjun.zhu@linux.dev>
 <20260308074711.24114-3-yanjun.zhu@linux.dev>
Content-Language: en-US
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20260308074711.24114-3-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/8/26 12:47 AM, Zhu Yanjun wrote:
> +/*
> + * Called for every existing and added network namespaces
> + */
> +static int __net_init rxe_ns_init(struct net *net)
> +{
> +	/*
> +	 * create (if not present) and access data item in network namespace
> +	 * (net) using the id (net_id)
> +	 */
> +	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
> +
> +	rcu_assign_pointer(ns_sk->rxe_sk4, NULL); /* initialize sock 4 socket */
> +	rcu_assign_pointer(ns_sk->rxe_sk6, NULL); /* initialize sock 6 socket */
> +	synchronize_rcu();

As I stated in the last review, this is init is not needded. drop it.

See the net/core/net_namespace.c:

static int ops_init(const struct pernet_operations *ops, struct net *net)
{
        struct net_generic *ng;
        int err = -ENOMEM;
        void *data = NULL;

        if (ops->id) {
                data = kzalloc(ops->size, GFP_KERNEL);
                if (!data)
                        goto out;

                err = net_assign_generic(net, *ops->id, data);
                if (err)
                        goto cleanup;
        }

from there the request is to add a comment about deferred socket created
to explain why _init and _exit are assymetrical.

> +
> +	return 0;
> +}
> +
> +static void __net_exit rxe_ns_exit(struct net *net)
> +{
> +	/*
> +	 * called when the network namespace is removed
> +	 */
> +	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
> +	struct sock *rxe_sk4 = NULL;
> +	struct sock *rxe_sk6 = NULL;

again, init is not needed. They are set below before use.

I am beginning to think you dropped my review comments from the last
round ....

> +
> +	rcu_read_lock();
> +	rxe_sk4 = rcu_dereference(ns_sk->rxe_sk4);
> +	rxe_sk6 = rcu_dereference(ns_sk->rxe_sk6);
> +	rcu_read_unlock();
> +
> +	/* close socket */
> +	if (rxe_sk4 && rxe_sk4->sk_socket) {
> +		udp_tunnel_sock_release(rxe_sk4->sk_socket);
> +		rcu_assign_pointer(ns_sk->rxe_sk4, NULL);
> +		synchronize_rcu();

yea, I commented on this too.

I am not wasting any more time on this version. Either address my
comments from v1 or explain why you should not in that email.

