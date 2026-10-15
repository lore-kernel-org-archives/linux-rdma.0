Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA110490BEE;
	Thu, 15 Oct 2026 20:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097235; cv=none; b=Ehi/r5QZkdp48/44fvzwFlFtD4jKSYB7Pr6XsWajtu/RsQHnyR2/H+7GA9UhNG7vOH8sozmgEx6utiqGl7cm48oKOLSwGLRoyaW3OjvpTNgBOJkA/lz7t1yPbVXblK0DsnAi6q9dMU1WLPoPpLqD5JHXfESo2zLFrCzEu0LR9pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097235; c=relaxed/simple;
	bh=SOwvzms1rsGyiQI3eqHkAt6zPoztVZfMbwjbrBUJ4tg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zdbw99QE6yp7KIe82NYHJ4dEubKQz68G4YsemBWk2pzGu3mBXcJb+71y6YuoNTBmzFHZgyaPAj2U+1KnwEgSVm44XcZc+Aj6AMJX7bqwTh17QZxEoK4Mcn3JHZp/L2XnHISq6Kwm8ic535caiLfehDKRUQavH+uNFm6HYWTJESo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8E+y0/H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8E+y0/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684DE1F000C4;
	Thu, 15 Oct 2026 20:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792097232;
	bh=/XdwB6j74nD/HIOa2tCFYC4UuA7YLzDfGeq9MCVTZPY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=P8E+y0/HTRtjYtf5t02C0srTVymbz0FlJNy6DiBBQHcv8WwLjjliyDS+eWbI/x2UD
	 4ozxN3iWvHfB9PB5X+FfeYBr0nBhYA7QxvKa0eQhZRybkPGT2JWpAgfUTZrzpZ2QpQ
	 6mwrdO1LB3CE+WkKayaJTvBoQJxGbBZNz9Y8dIWB5wJHSkNdjWQxTdP5GLuEiuSiZX
	 DqxvrmcRUGEmH8NyFHgDzCjjYV6ot9mRGyq+YUnJEcLqdPA18XVmgDDY+4d0zDrIxp
	 Xl5P1mA9qROZILfb29EOK71ijopMUP7x3/g+ySW3vbc1iBvuzgDYdMI4iwrSnacReX
	 Oi3e9b/FIcxmQ==
Subject: Re: [PATCH net] net/smc: don't spin in smc_rx_recvmsg() while a pipe
 holds spliced data
From: netdev-bot+sashiko@kernel.org
To: hexlabsecurity@proton.me
Cc: sidraya@linux.ibm.com, pabeni@redhat.com, davem@davemloft.net,
 mjambigi@linux.ibm.com, dust.li@linux.alibaba.com, edumazet@kernel.org,
 alibuda@linux.alibaba.com, kuba@kernel.org, guwen@linux.alibaba.com,
 linux-rdma@vger.kernel.org, raspl@linux.ibm.com, hidayath@linux.ibm.com,
 wenjia@linux.ibm.com, tonylu@linux.alibaba.com, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ubraun@linux.ibm.com,
 horms@kernel.org
Date: Thu, 15 Oct 2026 20:47:10 +0000
Message-ID: <179209723095.434549.11206499945190748009@kernel.org>
In-Reply-To: <20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c@proton.me>
References: <20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c@proton.me>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (2) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] smc_rx_wait_splice() sleeps until
  !atomic_read(&conn->splice_pending).
- [Low] The new smc_rx_wait_splice() (net/smc/smc_rx.c:294-303) sleeps on
  sk_sleep(sk) via add_wait_queue()/sk_wait_event() but never sets or…

Pre-existing issues:
- [Medium] After this patch, a non-blocking recv() whose readable data
  sits behind bytes still held in a pipe returns -EAGAIN.
- [Medium] smc_rx_pipe_buf_release() advances the consumer cursor
  (smc_rx_update_cons) under lock_sock, but decrements…

--

net/smc: don't spin in smc_rx_recvmsg() while a pipe holds spliced data

This patch changes smc_rx_recvmsg() so that, while spliced bytes are still
held in a pipe, recvmsg() checks the timeout and pending signals before it
waits. The wait moves to a new helper, smc_rx_wait_splice(), which ends when
splice_pending drops to zero or the connection is killed, and no longer ends
on RCV_SHUTDOWN. A zero-length read now returns 0 right away.

> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 197fddc6271f0..6f409bda4c37a 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -286,6 +286,22 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo, size_t peeked,
>  	return rc;
>  }
>  
> +/* Wait until the pipe releases the spliced data. Unlike smc_rx_wait(),
> + * this does not end on shutdown or a socket error: the data to read is
> + * already in the RMB. smc_conn_kill() wakes the socket, and the caller
> + * checks conn->killed.
> + */
> +static void smc_rx_wait_splice(struct smc_sock *smc, long *timeo)
> +{
> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
> +	struct smc_connection *conn = &smc->conn;
> +	struct sock *sk = &smc->sk;
> +
> +	add_wait_queue(sk_sleep(sk), &wait);

[Severity: Low]
smc_rx_wait() sets SOCKWQ_ASYNC_WAITDATA around the same kind of sleep:

	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
	add_wait_queue(sk_sleep(sk), &wait);
	...
	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);

Should smc_rx_wait_splice() do the same?

The wake callback smc_rx_wake_up() calls
sk_wake_async_rcu(sk, SOCK_WAKE_WAITD, POLL_IN). For SOCK_WAKE_WAITD,
sock_wake_async() sends SIGIO only when SOCKWQ_ASYNC_WAITDATA is clear.

Before this patch, a recvmsg() blocked behind spliced data waited in
smc_rx_wait(..., smc_rx_data_available_and_no_splice_pend), which set the
bit.

Now take an O_ASYNC socket whose F_SETOWN owner is the reader. Each new
peer data arrival during this wait sends SIGIO. The next loop pass sees
splbytes != 0 and signal_pending(current), and returns -EINTR or
-ERESTARTSYS. A reader that used to keep sleeping is now interrupted.

> +	sk_wait_event(sk, timeo, !atomic_read(&conn->splice_pending), &wait);

[Severity: Medium]
Can this wait miss the final wakeup on weakly ordered architectures?

The only waker for this condition is smc_rx_pipe_buf_release(). It
decrements splice_pending and wakes only after release_sock():

net/smc/smc_rx.c:smc_rx_pipe_buf_release() {
    ...
	smc_rx_update_cons(smc, priv->len);
	release_sock(sk);
	if (atomic_sub_and_test(priv->len, &conn->splice_pending))
		smc_rx_wake_up(sk);
    ...
}

smc_rx_wake_up() goes through skwq_has_sleeper(), which does smp_mb() and
then waitqueue_active(). The wq_has_sleeper() comment says this barrier has
to pair with one on the waiting side.

On the reader side, two steps sit between the list store in add_wait_queue()
and the relaxed atomic_read(&conn->splice_pending) in sk_wait_event():

- spin_unlock_irqrestore() on the wait queue lock
- spin_lock_bh()/spin_unlock_bh() on sk_lock.slock inside release_sock()

Neither is a full barrier. Under LKMM, an unlock and a lock on different
locks don't order an earlier store before a later load. That leaves a
store-buffering pattern:

reader                                releaser
add_wait_queue()
  (store not yet visible)
                                      atomic_sub_and_test() -> 0
                                      smp_mb()
                                      waitqueue_active() -> false
atomic_read(&conn->splice_pending)
  -> stale N
wait_woken() sleeps

Before this patch, the RCV_SHUTDOWN, peer close and abort states spun here,
so they could not lose a wakeup. They now sleep in smc_rx_wait_splice() and
depend on this single wakeup.

Once the peer has shut down or closed, no more CDC traffic wakes
sk_sleep(). A blocking recvmsg() without SO_RCVTIMEO could then sleep until
a signal arrives, even though the data is already in the RMB. On x86 and
s390 the lock acquire is a full barrier, so this would only show up on
architectures like powerpc.

The notes below the --- line already say "Under LKMM, today's order allows a
lost wake even with the condition". The old smc_rx_wait() has the same gap,
but this patch newly relies on it for the shutdown and abort states.

Would an smp_mb() between add_wait_queue() and the condition read close
this? Moving the splice_pending decrement and the wakeup under lock_sock()
in smc_rx_pipe_buf_release() looks like another option.

> +	remove_wait_queue(sk_sleep(sk), &wait);
> +}
> +
>  static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
>  			   int flags)
>  {
> @@ -443,7 +459,24 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
>  		/* could be just 1 byte, even after waiting on data above */
>  		readable = smc_rx_data_available(conn, peeked_bytes);
>  		splbytes = atomic_read(&conn->splice_pending);

[Severity: Medium]
This is a pre-existing issue that this patch didn't introduce: can the
splice path read a stale splbytes here?

smc_rx_pipe_buf_release() moves the consumer cursor under lock_sock(), but
it decrements splice_pending only after release_sock() (see the snippet
above).

The releasing pipe's mutex doesn't serialize a concurrent smc_splice_read()
into a different pipe. In that window, the second splice can take
lock_sock(), reach copy:, and read splbytes == N here. It then adds N to a
cons that has already moved by N:

	smc_curs_copy(&cons, &conn->local_tx_ctrl.cons, conn);
	...
	if (splbytes)
		smc_curs_add(conn->rmb_desc->len, &cons, splbytes);

That skips N bytes of valid stream data. It also splices N bytes from past
the producer cursor into the second pipe.

smcr_buf_unuse() and smc_buf_unuse() zero the RMBs. So this corrupts only
the connection's own stream and doesn't expose another connection's data.
The accesses stay inside the RMB.

The notes below the --- line say a separate series moves the splice_pending
decrement under lock_sock(). That looks like it would also close this
window for the msg == NULL path.

> -		if (!readable || (msg && splbytes)) {
> +		if (msg && splbytes) {
> +			/* a pipe still holds bytes ahead of these, and the
> +			 * jumps to copy skip the timeout and signal checks;
> +			 * a zero-length read returns 0 at once
> +			 */
> +			if (!read_remaining)
> +				break;
> +			if (!timeo || signal_pending(current)) {
> +				if (!read_done)
> +					read_done = timeo ?
> +						    sock_intr_errno(timeo) :
> +						    -EAGAIN;

[Severity: Medium]
This is a pre-existing issue rather than one added by this patch, but
smc_poll() still disagrees with this -EAGAIN:

net/smc/af_smc.c:smc_poll() {
    ...
			if (atomic_read(&smc->conn.bytes_to_rcv))
				mask |= EPOLLIN | EPOLLRDNORM;
			if (sk->sk_shutdown & RCV_SHUTDOWN)
				mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
    ...
}

bytes_to_rcv doesn't count spliced bytes, because smc_rx_recvmsg()
subtracts copylen for them too. Suppose a pipe holds N bytes and the peer
has sent M more behind them. Then bytes_to_rcv == M.

poll(), select() and level-triggered epoll keep reporting EPOLLIN. Meanwhile
every recv(MSG_DONTWAIT), and every recv() on an O_NONBLOCK socket, returns
-EAGAIN from this branch. An event-loop reader would busy-loop in userspace
until the pipe is drained.

Before this patch the same non-blocking recv() spun inside the kernel, so
CPU use is no worse than before. The commit message doesn't mention that
this case remains, though. Should smc_poll() also look at
conn->splice_pending?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c%40proton.me
