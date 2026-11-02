Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793643873;
	b=miSHPkPrFAicFJZ/0zzrCnqK8alUB1C3lZpbh3yvEzIlGuOO9PUvg8VML2RKVqP8dOZi
	 UEO2nR4Sxt8Lf3aDqw3t0godxkcj5bGNy/di4LHbl8V/JJ0D2IKLGoa5ZLExtvtGvfHOc
	 q1dN//WnIP5tiReZ8HV6jhKbXwlPnyfk8TYAEyj0js2ktQNgIdXPfqek5VYJ97Uz1GkKG
	 P+8InHdFur4StNoKBlXZ3oquQojdW7+gZNGerNOwW+hLH6GjJLqZ/1nTFX0mHfGn5WlFE
	 /Vj9pkTt5Jp1nM8nXql3mlBF77W3jP51FRc+dXEcYkhpQaqxk7LIV//VPQzaW79eXRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793643873;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=zQOgtK1Q5lTQF+oypvJ7p+u9t+1NRbd2bvqvbKtTwZE=;
	b=wXQoN7MIWOJxZFiSOVjiMRm2eYNPuYDQBS01WJRbDz91pmIgiD0DG78Ze7K2MiHHPx9G
	 fS6zk/vR23vCrHngPsSxV/VcXpxFKjZLc8oVN/0j2P7Q8I8fOMaCCJi02EzN0VjGSmLux
	 XPmWoSvIGi17gcrFAPyOPFnL+wfGTrPjoZh20ecV6D32q4hawG3RckB37IqHAGhgYoSOn
	 9pFzUlg3Pot+k0iiDmprv5ABkK8cvnWcDAQdTC3gt17bUHZP342On9SzZHJ6Nkdj56tma
	 9S+M0IYagCxXa6Zx1DxhPIS8r3JvN5yqfx7/EuaoHlS96RDLT+z/iACzNnxZAzINNhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FcR8HmKy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85C2606A335;
	Mon,  2 Nov 2026 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FcR8HmKy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9E71F00A17;
	Mon,  2 Nov 2026 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793643872;
	bh=zQOgtK1Q5lTQF+oypvJ7p+u9t+1NRbd2bvqvbKtTwZE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=FcR8HmKyW5M9r2g8b+TyIka8JtcnwI6Ta5We5GcbLoVeEjHI9K09qtC4RUyeKXIGe
	 gnex4ESxaxMsK98oVrjJMmNtO2VuITBQ3fRq0MwBW681FylmJ5SiRCjV665kUfDMYf
	 rHE+O//SQ4SqFYJXRjUkMloVC2fvYfmUekkzbF3AEubHIVsGl/HzA/w+ehUJd8htdS
	 V4jEPc3emYrbWZXdWN87BPXW3A0aaB6nsk7LQG0pd8Shb8YgDz3H5B0eUxVse1IlOl
	 U6oNPq990Uy1nLNRj8olUK5gwY3LQW8/LqXaesEJbiWTreG4REZ0qADhW0u6FktkHO
	 gqPnLaZDnBbSA==
Subject: Re: [PATCH net v8 2/4] net/smc: bound the receive length to the RMB
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: sidraya@linux.ibm.com, kuba@kernel.org, mjambigi@linux.ibm.com,
 pabeni@redhat.com, alibuda@linux.alibaba.com, davem@davemloft.net,
 dust.li@linux.alibaba.com, edumazet@kernel.org,
 guangguan.wang@linux.alibaba.com, ubraun@linux.ibm.com, raspl@linux.ibm.com,
 linux-s390@vger.kernel.org, guwen@linux.alibaba.com,
 linux-kernel@vger.kernel.org, hidayath@linux.ibm.com, horms@kernel.org,
 wenjia@linux.ibm.com, tonylu@linux.alibaba.com, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org
Date: Mon, 02 Nov 2026 18:24:30 +0000
Message-ID: <179364387064.3131.5492897013975868107@kernel.org>
In-Reply-To: <20261029-b4-disp-33001ace-v8-2-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-2-f9bb96e17827@proton.me>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 (2) · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch says that reordering splice_pending in
  smc_rx_pipe_buf_release() means 'no reader counts them twice', which…
- [Low] The new conn->rmb_len field exists so it can be read without the
  socket lock: the patch's comment in smc_rx_data_available() says the…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is a
  reachable local DoS.
- [High] This problem wasn't introduced by this patch, but it is a real
  accounting bug.

--

net/smc: bound the receive length to the RMB

This commit clamps smc_rx_data_available() to what fits in the RMB behind
the spliced and peeked bytes, never returning a negative count. poll(),
SIOCINQ and the deferred accept now use this helper too. It also caches the
RMB length in conn->rmb_len for unlocked waiters, and moves the
splice_pending decrement in smc_rx_pipe_buf_release() ahead of the consumer
cursor update.

> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index d10244af5bd29..d492c77161283 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c

[ ... ]

> @@ -2939,7 +2939,7 @@ __poll_t smc_poll(struct file *file, struct socket *sock,
>  						mask |= EPOLLOUT | EPOLLWRNORM;
>  				}
>  			}
> -			if (atomic_read(&smc->conn.bytes_to_rcv))
> +			if (smc_rx_data_available(&smc->conn, 0))
>  				mask |= EPOLLIN | EPOLLRDNORM;

[Severity: High]
This isn't a bug introduced by this patch, but can smc_rx_recvmsg() loop
forever while splice_pending is non-zero?

When data is available and an earlier splice() is still pending, the top of
the loop jumps straight to copy:

		if (smc_rx_recvmsg_data_available(smc, peeked_bytes))
			goto copy;

That skips the !timeo, signal_pending() and sk_err checks. At copy, msg &&
splbytes is true:

		if (!readable || (msg && splbytes)) {
			if (splbytes)
				func = smc_rx_data_available_and_no_splice_pend;
			else
				func = smc_rx_data_available;
			smc_rx_wait(smc, &timeo, peeked_bytes, func);
			continue;
		}

smc_rx_data_available_and_no_splice_pend() stays false until the pipe
buffers are released. The return value of smc_rx_wait() is ignored.

With MSG_DONTWAIT, recv() never returns -EAGAIN; each pass sleeps about a
jiffy and loops again. With a signal pending, including SIGKILL,
wait_woken() returns at once and the task busy-loops. The only ways out are
splice_pending draining or conn->killed. If the same process holds the pipe,
the pipe buffers would never be released.

smc_poll() now reports EPOLLIN from smc_rx_data_available(conn, 0). That
helper uses splice_pending only to cap the length, but recvmsg() refuses to
copy anything while splice_pending is non-zero. While a splice is pending,
does the commit message's claim that these paths "all see the same length"
hold?

>  			if (sk->sk_shutdown & RCV_SHUTDOWN)
>  				mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;

[ ... ]

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 6021322253e93..fe6e4a2f7935a 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -2505,6 +2505,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
>  
>  	if (is_rmb) {
>  		conn->rmb_desc = buf_desc;
> +		conn->rmb_len = buf_desc->len;

[Severity: Low]
The new comment in smc_rx_data_available() says conn->rmb_len is read
without the socket lock:

	 * INT_MIN, avail - peeked wraps. This also runs unlocked, possibly
	 * after rmb_desc was freed, hence rmb_len.
	 */
	avail = min(avail, conn->rmb_len - atomic_read(&conn->splice_pending));

Should this store and that load use WRITE_ONCE() and READ_ONCE()?

For example, during a non-blocking connect,
smc_connect_work()->__smc_connect()->smc_buf_create()->__smc_buf_create()
writes rmb_len under lock_sock(). At the same time, smc_poll() on the
SMC_INIT socket reads it without the lock. The first unlocked evaluation of
the condition in sk_wait_event() has the same pattern.

KCSAN would report this as a data race. There is no functional effect today,
since bytes_to_rcv is 0 at that point.

>  		conn->rmbe_size_comp = bufsize_comp;
>  		smc->sk.sk_rcvbuf = bufsize * 2;
>  		atomic_set(&conn->bytes_to_rcv, 0);

> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 197fddc6271f0..85654d9f321b0 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -118,15 +118,20 @@ static void smc_rx_pipe_buf_release(struct pipe_inode_info *pipe,
>  	struct smc_connection *conn = &priv->smc->conn;
>  	struct smc_sock *smc = priv->smc;
>  	struct sock *sk = &smc->sk;
> +	bool drained;
>  
>  	lock_sock(sk);
>  	if (conn->freed) {
>  		release_sock(sk);
>  		goto out;
>  	}
> +	/* drop the released bytes from splice_pending before cons moves
> +	 * past them, so no reader counts them twice
> +	 */
> +	drained = atomic_sub_and_test(priv->len, &conn->splice_pending);

[Severity: High]
The commit message says this reorder means "no reader counts them twice".
Is there still a path where spliced bytes are counted twice?

In smc_rx_recvmsg(), a copy that wraps past the end of the RMB is done in two
chunks. If the first chunk succeeds and the second fails, the error path
jumps over the bytes_to_rcv and consumer cursor update:

				if (rc < 0) {
					if (!read_done)
						read_done = -EFAULT;
					goto out;
				}

read_done already includes the first chunk. For splice, smc_rx_splice() has
already added that chunk to splice_pending:

	bytes = splice_to_pipe(pipe, &spd);
	if (bytes > 0)
		atomic_add(bytes, &smc->conn.splice_pending);

Those bytes are then counted in both bytes_to_rcv and splice_pending. The
second chunk can fail with -EAGAIN from splice_to_pipe() when the pipe has
only one free slot. It can also fail with -ENOMEM or -EPIPE.

On the next splice(), the start offset is cons + splice_pending, which skips
the first chunk. The readable count still includes it:

	avail = min(avail, conn->rmb_len - atomic_read(&conn->splice_pending));

Would that splice() return stale ring contents from beyond the producer
cursor?

When those pipe buffers are released, cons would move past prod, and
smc_tx_consumer_update() would send that cursor to the peer. bytes_to_rcv
would also stay inflated for good.

In the recvmsg path, a fault in memcpy_to_msg() on the second chunk returns
the first chunk to userspace without consuming it. Would the next recv()
deliver those bytes again?

The new clamp keeps the read inside the RMB, so this corrupts the stream
rather than memory. But it looks like the same double count that the commit
message says is fixed.

>  	smc_rx_update_cons(smc, priv->len);
>  	release_sock(sk);
> -	if (atomic_sub_and_test(priv->len, &conn->splice_pending))
> +	if (drained)
>  		smc_rx_wake_up(sk);
>  out:
>  	kfree(priv);
> @@ -506,7 +511,7 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
>  			/* increased in recv tasklet smc_cdc_msg_rcv() */
>  			smp_mb__before_atomic();
>  			atomic_sub(copylen, &conn->bytes_to_rcv);

[Severity: High]
This is a pre-existing issue, but is a short successful splice counted here
as if the whole chunk went through?

For SMC-R with a virtually contiguous RMB, smc_rx_splice() works out the
number of pipe entries from the page offset:

	nr_pages = !lgr->is_smcd && smc->conn.rmb_desc->is_vm ?
		   PAGE_ALIGN(len + offset) / PAGE_SIZE : 1;

do_splice_read() limits len by the free slot count but ignores the source
page offset:

	p_space = pipe->max_usage - pipe_buf_usage(pipe);
	len = min_t(size_t, len, p_space << PAGE_SHIFT);

Take an empty 16 slot pipe, len = 65536 and an unaligned offset o.
smc_rx_splice() builds 17 entries and splice_to_pipe() returns 65536 - o.
smc_rx_splice() adds that short count to splice_pending.

smc_rx_recvmsg() only checks rc < 0, and then counts the full chunk:

			read_remaining -= chunk_len;
			read_done += chunk_len;

It also subtracts the full copylen from bytes_to_rcv here.

Would splice() then report o more bytes than reached the pipe, and leave
bytes_to_rcv o bytes below the real unread amount?

The pipe release only moves cons forward by what was actually queued, so the
deficit would add up. That could lose trailing data at EOF, or stall the
connection once the deficit gets close to the RMB size.

> -			/* guarantee 0 <= bytes_to_rcv <= rmb_desc->len */
> +			/* can be out of range, see smc_rx_data_available() */
>  			smp_mb__after_atomic();
>  			if (msg && smc_rx_update_consumer(smc, cons, copylen))
>  				goto out;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261029-b4-disp-33001ace-v8-0-f9bb96e17827%40proton.me
