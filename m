Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792975075;
	b=b/3IVKLoMUcy2G3QLOue+d0gIsDUCtI3rPzaXDte7Zoi/YPtIc3Dd+iO1IvrfAgwnVQN
	 8uFreIHMe78yRBhm3b++TSTnbF4pjh5451BmPFEj2hhKt0foeijpj8gEm9wQ8hLBD4ETj
	 liC2jyJLWjO5TMrCWcjtfTmxOj1Uiju27izniiSxPab3VmK2SdGyOBdpqeu39Tscn94of
	 zapNKlJwHVkb5J9ebRNY41Am7/UHYf1aaLyb0bd5TyVzEgjn0uBwMY+xKovOHth4Wpz2K
	 eZhsC9SFkVPzQXIvXHnOvsadOi+v09PulAZLzkch9ZeE7cVr1vGcNGycyrxLDuXrDtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792975075;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=3OpWhHDiC0q0IeZapx7WAsAnnypbwyXltg3+JfcCVTY=;
	b=qyEak75youwFw1vCx4YKhU1AICtfR8wIKV/S/uMGNv+wRkm144xwAIARv19BsVQmROOI
	 tmutKqQqdUsqxTEhtJpZp2PU4JIgzsLIlgVMOzzcIs9cgEwskgLfII1cEUEj1rVYs0Cpa
	 nXZn1xpjczTm0k1rSjlQ2K0OzHyIn+mcZ4MjpGoAqZoxeH0QpgwDKDWv9JFF88rfw5Wj/
	 srnNi8gAs7LXCLpS17iG1Z7fHdIFEF3U24UramC1wpruXzm1Eq6oGReB1w5xlH/t8D/6h
	 x0LLUJQuiR7HbQm3zhn7RyBlQflUEcVg3llMzeIq8KPc1uWG+aZZrBxLfc6Hgeu6B8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mniVaYXS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365BF606A31A;
	Mon, 26 Oct 2026 00:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mniVaYXS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A1E1F01825;
	Mon, 26 Oct 2026 00:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792975074;
	bh=3OpWhHDiC0q0IeZapx7WAsAnnypbwyXltg3+JfcCVTY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mniVaYXSw+J4T6DIlCx0v+dCBHkQHE+jD8iQly4/+6u8gr05I/QdIA65+slb44n6O
	 9WZ6CpkQOI+m5tX82JuJiWn+M4LhreXySfmykgGN3xgIsZow5JZWw7IhpiAcxioTpP
	 3Ux/uuztLXPUrcz96IghTPYv86/O8MXXtuEUL1zHyaouaqGMWbicGydS9NzhsGyLb5
	 I5TAkyc2pN4kVXYWXkPIXm0LuxtiUL1TNzHNuq5gEuxL2sdAAK9CDSmLfPUsoUZVrI
	 4fwdVjMQ6earOBEL2T0vD6DYyPoB5E+INh71qMUz9DCu4TOtzt7iWHAQe0z/8HsNxP
	 XtGh0M3kfE4Zg==
Message-ID: <dc5e58c172ad4b4bab4b8e0a385c608245618a65.camel@kernel.org>
Subject: Re: [PATCH] net/rds: hold IB device reference through deferred
 cleanup
From: Allison Henderson <achender@kernel.org>
To: Eduard Zateev <hackerowskiy@gmail.com>
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com,  horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org,  rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, 
 syzbot+221e213bf17f17e0d6cd@syzkaller.appspotmail.com
Date: Sun, 25 Oct 2026 17:37:53 -0700
In-Reply-To: <20261023100206.126692-1-hackerowskiy@gmail.com>
References: <20261023100206.126692-1-hackerowskiy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-10-23 at 12:02 +0200, Eduard Zateev wrote:
> RDS device teardown queues rds_ib_dev_free() on rds_wq. Hold a
> reference to the underlying IB device until deferred cleanup releases
> its resources. This prevents device removal from freeing it while the
> work is running.

Hi Eduard,

Thanks for the patch.  Some comments below:

>=20
> Reported-by: syzbot+221e213bf17f17e0d6cd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D221e213bf17f17e0d6cd
The report referenced here doesnt actually point to RDS, it's a warning in =
rxe_pool_cleanup.
Do you have a trace or a syz test result showing that the leftover rxe obje=
ct is the RDS PD
or MR and that this patch resolves the warning? Otherwise, I think the clos=
es tag should be
removed.

> Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>
> ---
>  net/rds/ib.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 786f39169bc..597872e4fe9 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -115,6 +115,7 @@ static void rds_ib_dev_free(struct work_struct *work)
> =20
>  	kfree(rds_ibdev->vector_load);
> =20
> +	ib_device_put(rds_ibdev->dev);
>  	kfree(rds_ibdev);
>  }
> =20
> @@ -142,6 +143,12 @@ static int rds_ib_add_one(struct ib_device *device)
>  				 ibdev_to_node(device));
>  	if (!rds_ibdev)
>  		return -ENOMEM;
> +	/* Keep the device registered until the deferred cleanup completes. */
> +	if (!ib_device_try_get(device)) {


The commit message doesn't quite describe what this does. Holding the refer=
ence doesn't stop
the device from being freed while the work runs. It makes ib_unregister_dev=
ice() block in
disable_device() until the refcount reaches zero, which now only happens wh=
en rds_ib_dev_free()
calls ib_device_put(). For connections that wait is short, since rdma_cm te=
ars them down during
the same removal, but connections are not the only things that hold the rds=
_ib_device.

A registered MR keeps the reference it takes in rds_ib_get_mr() until rds_i=
b_free_mr() drops
it. That only happens once everything using the MR has let go. Including th=
e socket (when it
frees the MR or closes), and every queued message that uses it (when the pe=
er acks it or the
socket closes).=C2=A0 Those messages also survive connection drops (rds_sen=
d_path_reset() requeues
them), and with the=C2=A0 device gone the connection can't come back up ove=
r it to get them acked.=C2=A0

So with this patch,=C2=A0whoever is unregistering the device (rdma link del=
ete, driver unload, PCI
hot-unplug) blocks=C2=A0in disable_device() until the process that owns the=
 socket lets go, which
it may never do. It=C2=A0 also turns any leaked rds_ib_device reference int=
o a permanent unregister
hang. I have a fix=C2=A0for one such leak, a connection left attached at mo=
dule unload, in the
connection-lifetime=C2=A0series I've been iterating on, but it hasn't lande=
d yet.

Unfortunately this is not a simple fix, even after kref lands.=C2=A0To wait=
 for the free safely,
remove_one first needs a way to make the device's MRs be released, so that =
the wait is
guaranteed to finish.  The uek tree approach is a socket accounting feature=
:

https://github.com/oracle/linux-uek/commit/ba92066dbf13e573a292252ea07e686b=
5104f091
https://github.com/oracle/linux-uek/commit/dc4c8c665368bca276db02ba7071d2d3=
fd653a10
https://github.com/oracle/linux-uek/commit/fcd394a1095625a39c44aa709bd976c6=
b9b98373

You're certainly welcome to look at it, but it is a bigger rework of the re=
moval path than
this patch, and I'd rather not take a partial fix that turns the warning in=
to a hang.

Thank you for looking at this though!

Allison

> +		kfree(rds_ibdev);
> +		return -ENODEV;
> +	}
> +	rds_ibdev->dev =3D device;
> =20
>  	spin_lock_init(&rds_ibdev->spinlock);
>  	refcount_set(&rds_ibdev->refcount, 1);
> @@ -180,7 +187,6 @@ static int rds_ib_add_one(struct ib_device *device)
>  		goto put_dev;
>  	}
> =20
> -	rds_ibdev->dev =3D device;
>  	rds_ibdev->pd =3D ib_alloc_pd(device, 0);
>  	if (IS_ERR(rds_ibdev->pd)) {
>  		ret =3D PTR_ERR(rds_ibdev->pd);

