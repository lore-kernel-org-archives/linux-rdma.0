Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D690B3FFFA9
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576123; cv=none; b=t7VySh/MTv7IdjSF4643Ym9OnxwNOdF+OykPbSqKhRbuyyv0JAdoA9FAsNnOcZGqHUVKwA5atencMPbT8wiOyDPdECxjl+X4IMTtLIDOSwxCGYQmVBAKPJBFyPLE+SnemHBOS8jogHIDncawmc2170GBhxVKYbqLTKTiqSD/KII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576123; c=relaxed/simple;
	bh=w0qH7ypYKjBF9So5/UFuxEgSY1p8kGoUU2Cx6jGCWWY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZUV4yQtHoND8/nWofMaVTys+h78CGwGr7qY4Re2ZsgiSHpzHmt3CFyPAmV2tIiWxoE/RaukDoifYHS08bk/roXUKsgKXpLyCXlKSCTiX99TnNEBydQUGf8GysdT5WeR/cSo858tMBEKhIO/fhCpIo9K+MoR0suZP5d7knEV7Qao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uy7PUtFz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uy7PUtFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F541F0089B;
	Mon, 28 Sep 2026 06:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576103;
	bh=DDhI3cu+DZ9gtyLfhqoWGB/vmmXQJ56wVdQPQowMS9A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uy7PUtFz4ssaQlpDCwdQrHgph5yM88wgtMuJUFWWoiE5Wwl6yJNjWcPzI7gb9vMWR
	 07TZwoN2JAXWwoHo20Zw23KFKvd+lPRLr2u4lSQOgNKAHFZID6qeK/uVRo9k9wJ1on
	 /d/SkxCgs9FB0aZBRG2s6Z1CyBy6a6jjfl8SSni6EQONJCarWTGvPAmuBJKOw/M2bD
	 /qAfMus4auLklhBsKseBEgMuvfgokWYWphf85MoKop9Xil+QlwwrTOohNYBbnCD8GU
	 oUOQ8KTv2RipnpWrayFbeLqzqhKXDUo2lNjlMpbY2tftoD9DkLRhOQlNPsKEc7dl3W
	 3No96An5j2Nvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 05/12] net/rds: split connection destroy
 into quiesce and kref-governed free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-6-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:02 +0000
Message-Id: <20260928061503.67F541F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: rds: permanent connection leak via orphaned probe message on =
concurrent teardown
--

commit 85ee160094b05c4fe02ec81d1c727379b584a32f
Author: Sharath Srinivasan <sharath.srinivasan@oracle.com>

net/rds: split connection destroy into quiesce and kref-governed free

This commit introduces a refcounting framework for RDS connections, splitti=
ng
the teardown process into synchronous quiescing and deferred freeing trigge=
red
when the last reference is dropped.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index cbc49426ba085..638e9f3140e28 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
[ ... ]
> @@ -567,16 +581,55 @@ static void rds_conn_path_destroy(struct rds_conn_p=
ath *cp)
>  	cp->cp_conn->c_trans->conn_free(cp->cp_transport_data);
>  }
> =20
> +/* Free a connection.  This runs from rds_conn_put() when the last
> + * reference is dropped, after rds_conn_destroy() has quiesced the
> + * connection and dropped the initial reference.
> + */
> +static void rds_conn_destroy_fini(struct kref *kref)
> +{
> +	struct rds_connection *conn =3D container_of(kref, struct rds_connectio=
n,
> +						   c_refcount);
> +	int npaths =3D (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> +	unsigned long flags;
> +	int i;
> +
> +	for (i =3D 0; i < npaths; i++)
> +		rds_conn_path_free(&conn->c_path[i]);
> +
> +	kfree(conn->c_path);

[Severity: High]
Does this code leak the connection and its associated memory if a probe mes=
sage
is queued concurrently during teardown?

If a concurrent sendmsg() is preempted after checking rds_destroy_pending(),
and rds_conn_destroy() completes rds_conn_path_quiesce() which purges
cp_send_queue, the resumed sendmsg() can call rds_send_ping() ->
rds_send_probe().

In rds_send_probe(), the message is added to cp_send_queue and a connection
reference is taken:

net/rds/send.c:rds_send_probe() {
    ...
    spin_lock_irqsave(&cp->cp_lock, flags);
    list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
    ...
    rds_conn_get(cp->cp_conn);
    ...
    if (!rds_destroy_pending(cp->cp_conn))
        queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 1);
    ...
}

Because rds_destroy_pending() is now true, the worker isn't queued. Since t=
he
probe message lacks an associated socket (rm->m_rs =3D=3D NULL), closing the
socket won't purge the message via rds_send_drop_to().

Because rds_conn_destroy_fini() does not traverse or drain cp_send_queue, it
seems the connection reference taken by rds_send_probe() will never be drop=
ped.
This could lead to a permanent leak of the connection and stall module unlo=
ads
in rds_conn_wait_conns_freed().

> +	kmem_cache_free(rds_conn_slab, conn);
> +
> +	spin_lock_irqsave(&rds_conn_lock, flags);
> +	rds_conn_count--;
> +	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D5
