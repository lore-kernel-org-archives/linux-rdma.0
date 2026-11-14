Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794664655;
	b=H1oeZbpfV4P7GOrtpuk73yYWm4slIhU18n2w7CRDYbD0V1qLYYTKTpkQr4Suc/tgS8C1
	 9U8X8RCiy+fEZn6BkiBhPdDpsOPR+5X1/O0LQyPc9y82WPYBukyw9qnewr0LAj59W/51X
	 MjXoqS0SfNOTBLHDVm/NfnEi6/qMC5GcF+nBWiDyn8QyrUWnvUmN3ykkA1gvsAF+gaNQ/
	 7Od+ELLAaFPQ/b1UkHMy+sdR1uL7NN8Gma2Mvnp3VXs5amyvlY+aGR6UnUQgHE7UksQQw
	 CbxZYGsaOQUjAvK0hDOYlFcri6CMVijKpnK3i5m0Lwyp14EHy/bOSSvMwy2HPqRKrLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794664655;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GBG9nadfxLM37oSVYTr8sHdFX+MWrjDr+WcgPcdUHR4=;
	b=TB93kqL7wdIxhTKRsQi2jueY3rabpE2yobvcG29doM2g/LcvTeW0zRQE21Ya5N/Fo/Av
	 lD3QSty49UkBEvMJt930bogpZb0XAZ/HB0c7VSKIyf99ukgCZJRWkWVTBR72UGgkZau51
	 wRSZmjbWkRpf/fvmwu7Lpm8R8zVyeM/HDi9q25/vCoEoPO3Q4yqr+DdnEFBKvvDkbmmoa
	 dPna+bjJpV+bCNXLzlLhBShq4jPGd+YsvdWoCqFAthd4TM/aLBwkXjLhNAycDsDvP6kfB
	 9HNf5VL4Y9Cqac8ST7+CUEJz9Mn2KWyIcaOtZcFQSugql0UJGChwVCP9YN88jKBwHIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="YHGxtW/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC72606A334;
	Sat, 14 Nov 2026 13:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YHGxtW/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB991F000C4;
	Sat, 14 Nov 2026 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794664654;
	bh=GBG9nadfxLM37oSVYTr8sHdFX+MWrjDr+WcgPcdUHR4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YHGxtW/hLtBwV4nSAK7WIvP6n1I3uzth9VyWfN9qwwQ1irdX+FNKqL4O1T5gVUod+
	 FeJgnwWhto/ClaFsllKj7WcgRylQWiov6kosyUrh+xa23vANMzNmTHzYkwz8x1Xokl
	 ZBtVe+7E+zloXOKKhQ7aycpqSq81SJHoOGBW3uwWzJH40wBvk3n5xCyF4gv2M9UeVn
	 AqQacVnwKfS8ITPzpYtp9pR/l9Lgei7uIp1zuJfvf4MjXLY9Lk5yXOQRrokF8okw6O
	 rEAJ/c2PWhSjwV0jzjhjcJ+4yNxUQjD4554hyBhxzFpmW+64vMEZ7QZny8vKKArJxj
	 ZyEdDZ3x35Img==
Message-ID: <sashiko-outbox-214598@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 2/2] net/smc: do not reuse the DMB of a nocopy
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261113-b4-disp-19244662-v1-2-39b256b70ca7@proton.me>
References: <20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me>
 <20261113-b4-disp-19244662-v1-2-39b256b70ca7@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 13:57:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] net/smc: UAF of conn->rmb_desc when lgr is terminating in
  smc_conn_free()
--

commit 1d775feb06a42c02b472b41cc9bc4f7bca488d91
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: do not reuse the DMB of a nocopy device

This commit adds smcd_rmb_drop() and calls it from smc_buf_unuse() to
unregister and free the RMB DMB of a nocopy SMC-D device and clear
conn->rmb_desc instead of returning the buffer to the link group pool.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index a3164201c1420..88855d9f66173 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1243,6 +1243,22 @@ static void smcd_buf_detach(struct smc_connection =
*conn)
>  	kfree(buf_desc);
>  }
> =20
> +/* With DMB nocopy the peer writes into the RMB through its own
> + * attachment, which can outlive this connection: unregister the DMB
> + * instead of pooling it, so the next connection gets a new one.
> + */
> +static void smcd_rmb_drop(struct smc_connection *conn,
> +			  struct smc_link_group *lgr)
> +{
> +	struct smc_buf_desc *rmb_desc =3D conn->rmb_desc;
> +
> +	down_write(&lgr->rmbs_lock);
> +	smc_lgr_buf_list_del(lgr, true, rmb_desc);
> +	up_write(&lgr->rmbs_lock);
> +	WRITE_ONCE(conn->rmb_desc, NULL);
> +	smc_buf_free(lgr, true, rmb_desc);
> +}
> +
>  static void smc_buf_unuse(struct smc_connection *conn,
>  			  struct smc_link_group *lgr)
>  {
> @@ -1266,8 +1282,13 @@ static void smc_buf_unuse(struct smc_connection *c=
onn,
>  			smcr_buf_unuse(conn->rmb_desc, true, lgr);
>  		} else {
>  			bufsize +=3D sizeof(struct smcd_cdc_msg);
> -			memzero_explicit(conn->rmb_desc->cpu_addr, bufsize);
> -			WRITE_ONCE(conn->rmb_desc->used, 0);
> +			if (smc_ism_support_dmb_nocopy(lgr->smcd)) {
> +				smcd_rmb_drop(conn, lgr);
> +			} else {
> +				memzero_explicit(conn->rmb_desc->cpu_addr,
> +						 bufsize);
> +				WRITE_ONCE(conn->rmb_desc->used, 0);
> +			}
>  		}
>  		SMC_STAT_RMB_SIZE(smc, is_smcd, true, false, bufsize);
>  	}

[Severity: High]
Can conn->rmb_desc still be used after free if lgr is already terminating
when smc_conn_free() runs?

smcd_rmb_drop() is only called from smc_buf_unuse(), which smc_conn_free()
skips when lgr->list is empty or the connection was already unregistered:

net/smc/smc_core.c:smc_conn_free() {
	...
	if (!smc_conn_lgr_valid(conn))
		goto lgr_put;
	...
	if (!list_empty(&lgr->list))
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
	smc_lgr_unregister_conn(conn);
	...
}

If a handshake fails after smc_clc_wait_msg() calls
smc_lgr_terminate_sched() (which unlinks lgr->list), smc_conn_abort() ->
smc_conn_free() skips smc_buf_unuse(), so conn->rmb_desc is not cleared to
NULL before __smc_lgr_free() frees the buffer.  If connect() is then
retried on the same socket and fails in smc_buf_create() after
smc_conn_create() attaches to a new link group, smc_conn_free()
dereferences and double-frees the dangling conn->rmb_desc.

Skipping smcd_rmb_drop() on those paths also leaves the ended connection's
nocopy DMB registered in lgr->rmbs until every remaining socket in the
terminating link group is closed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-b4-disp-19=
244662-v1-0-39b256b70ca7@proton.me?part=3D2
