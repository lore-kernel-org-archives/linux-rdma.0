Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A604A92ED;
	Wed, 14 Oct 2026 20:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010725; cv=none; b=b5yC1lna+JvGGvNd0w8TZOlXYnR7gjUwMyOHTilkJWTyFK4gegrrPhTjtRSRclH1PgOojsnBf5Qhnwhtnbi8hibazUU494miPz6iKR0bREz0fiyYpOt8jtu9cA9bBo2jV0YCdKKvzP53LLCAu8kAdpI6SZrYWknlWczaJ1KmWJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010725; c=relaxed/simple;
	bh=A76tajMKEIZ8jP2ixJmGzySfE60J/IeJeEz1zQ6suQI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QU2sOocUjAhXrRJ0UKrBLf0zLT3X0N6tQR3vQdBQjpoypqzHPf5KWk/s379VcKkYMuyJV/Loq7rJ/3wqnY/jmPnpfDO7+5gpfInZdwfunuv5Hry4kvlgLw7l3JOg0Fdn/LePsS9+VXzRa3zzEynJyFXSxqnh5z+Z8vr8fpOH9x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8Imvv8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8Imvv8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4792B1F000C4;
	Wed, 14 Oct 2026 20:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792010723;
	bh=pMjmc8w7w4yIKqIm/dVuUuWGDGFZky6zwsdTVEZZc5c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q8Imvv8LIPStTckez0rM5emNXfw9h3TzVK7/hWCyiJ3v4FwCllysIp5kut1QbKzvK
	 MGkRHqMYZQN7qfFVyeV3qcIiaut6bf8MB/GFtj79UsUDtEgui8nDTUh3jIlDHdfYyJ
	 a/46VAapS3cj0JXebxv/S3Y2lgcuZrc3yhS9LlKTBN5NX34LriRmci+BGz2lf9d9Wb
	 DdZfR/zz1lrDFChO4AsMSb5+lY/6c0Tb0r3mVZiLmZosdlkT6LViDVlmnPxLTPV0Fl
	 IuzFmi0FFxlRy+DKV9D748wkirQiwhHXjHEpZ2GQrk3jFMN1wjAYoikx34Uj3jMxDB
	 J9SGRZxdS2HEA==
Message-ID: <sashiko-outbox-171898@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: don't spin in smc_rx_recvmsg() while a
 pipe holds spliced data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c@proton.me>
References: <20261013-b4-disp-193a2a59-v1-1-ed88ac10a41c@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 20:45:22 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] smc: missing SOCKWQ_ASYNC_WAITDATA flag causes spurious SIGIO an=
d -EINTR
--

commit ffdc9d46059a93d975c6fd059f43bc43b71fe12f
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: don't spin in smc_rx_recvmsg() while a pipe holds spliced data

This commit introduces smc_rx_wait_splice() to allow recvmsg() to sleep
instead of spinning on the CPU while bytes spliced off the RMB are still in
a pipe. It checks for timeouts and signals before waiting, ending the wait
when the pipe releases the data or the connection is killed.

> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 197fddc6271f0..6f409bda4c37a 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
[ ... ]
> @@ -286,6 +286,22 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo, s=
ize_t peeked,
>  	return rc;
>  }
> =20
> +/* Wait until the pipe releases the spliced data. Unlike smc_rx_wait(),
> + * this does not end on shutdown or a socket error: the data to read is
> + * already in the RMB. smc_conn_kill() wakes the socket, and the caller
> + * checks conn->killed.
> + */
> +static void smc_rx_wait_splice(struct smc_sock *smc, long *timeo)
> +{
> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
> +	struct smc_connection *conn =3D &smc->conn;
> +	struct sock *sk =3D &smc->sk;
> +
> +	add_wait_queue(sk_sleep(sk), &wait);
> +	sk_wait_event(sk, timeo, !atomic_read(&conn->splice_pending), &wait);

[Severity: Medium]
Does smc_rx_wait_splice() need to set and clear the SOCKWQ_ASYNC_WAITDATA b=
it
around sk_wait_event()?

If FASYNC is enabled on an SMC socket, smc_rx_wake_up() will send a SIGIO
signal to the process unless the SOCKWQ_ASYNC_WAITDATA bit is set.

Since smc_rx_wait_splice() puts the socket to sleep without setting this bi=
t,
a spurious SIGIO could be delivered if the peer sends more data or the pipe
drains while the process is sleeping here.

This could interrupt wait_woken(), causing smc_rx_recvmsg() to prematurely
abort the wait and return -EINTR (or a short read) instead of waiting for
the pipe to drain. While applications generally handle -EINTR by retrying,
this breaks the expected blocking semantics.

For comparison, smc_rx_wait() uses this pattern:

int smc_rx_wait(...) {
    ...
    sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
    add_wait_queue(sk_sleep(sk), &wait);
    rc =3D sk_wait_event(...);
    remove_wait_queue(sk_sleep(sk), &wait);
    sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
    ...
}

> +	remove_wait_queue(sk_sleep(sk), &wait);
> +}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-disp-19=
3a2a59-v1-1-ed88ac10a41c@proton.me?part=3D1
