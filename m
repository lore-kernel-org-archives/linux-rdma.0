Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794811667;
	b=lryrLHQ/4VLXLQGlSDkDAChYDoh4qwofaZWdM81XqzjcvRkswLxldJI2X/TPwuBMkz6a
	 i3Z+92zLzvcbbIIa8tqxS2nFXdxSUDdMcox/vyTPBXfdIWthPzSI1xBz4APN+KxbexhAR
	 Uagl5ud8Ho5AAYRf2ekCBKSryncH6fP+WgXhXICBWFMVFjdg/as3qZpw8XRzMPlm219bF
	 1wGPaNioen63hYWMJXVXUTeUDyus64jd+Zlxv06wpZ+GagqANRwFyxl5fvHgZtZu4IkaU
	 rw9MUyz3vXw3y/v1+Tm1vdJGCjDmGCg+1znAQyfgRTxum/WWzpYSsO/3tw57K9RqTsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794811667;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=HvhOTGquWWqSov5pWXvbVX0ZD7JwTIftmYtwAtViYDg=;
	b=A6wC2MoLRQ3pbiZtQU7pIyLOXnDM8KpkK/HLjrlRsiC+gaDeU0ofx8Eq97sHMtgWIndf
	 L7SYRlHXTRyuG7qysYbuXFJfy/pczkMI4LNjw18SWwlKzsLJcxVWpkFRpOI8FihmE9ejV
	 4/sTrF/AcvjeSiK/TQltqAJhZLuKE7KTD2F+9ZZYRNLNZPcmXOnEq6t1IGhdAr9SQOQ6a
	 thEs2IhkG5lTfQVDLyMsmojFFMxCXMzX45WAPTyefalKdq34tpM/+zT0kuEuhPy2CikoI
	 yRVUyUUzbMQaLruUpOq6plJ4u0TEKVtAl6n6gMwO7WTpNTQowOGTykrZeAbizg1Qncg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="YA3/xBe4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41398606A336;
	Mon, 16 Nov 2026 06:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YA3/xBe4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422551F000C9;
	Mon, 16 Nov 2026 06:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811666;
	bh=HvhOTGquWWqSov5pWXvbVX0ZD7JwTIftmYtwAtViYDg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YA3/xBe4Lj9/kfUygUC3XXgFgC9Fp8RySOpvpRRPiavvanCMy4QNyPcZ+FrI4ZzA9
	 aQaCgI5tnP3MJa0mKqY53TyHeFwcWx8J71UaCST0fNn22im6xaB2pqkddMeEMUIuow
	 XJ2XvnFf5D8y28ltSyRmU28zQM/f0aOPTkITGirBzvjdJIBLoWQCIGLLH3KnoUh4K6
	 uITV2JWsvWH2kcMxIq+XyDOzJrfrW0jvm+PmuwmZiNeoJQrlG7HylLrfgXN5OKrZFd
	 15RO+2SqoFhTI0Bwy7+u8S7dYmVaNxusiDZKa7i8M6HWGDhig70nvESGRoxTCZHxWa
	 2oAvOAV6WequA==
Message-ID: <cee2fea9e09d50d33a9786260edbb295179fc1e9.camel@kernel.org>
Subject: Re: [PATCH] RDMA/cma: add rdma_destroy_id_wq() and use it from RDS
From: Allison Henderson <achender@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Aibing Chen
	 <chenaibing@cmss.chinamobile.com>
Cc: leon@kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org,  pabeni@redhat.com, horms@kernel.org,
 linux-rdma@vger.kernel.org,  netdev@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,  hdanton@sina.com,
 hackerowskiy@gmail.com, 
 syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com
Date: Sun, 15 Nov 2026 23:47:45 -0700
In-Reply-To: <20261115001851.GH2532299@ziepe.ca>
References: <20261114150541.1908-1-chenaibing@cmss.chinamobile.com>
	 <20261115001851.GH2532299@ziepe.ca>
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

On Sat, 2026-11-14 at 20:18 -0400, Jason Gunthorpe wrote:
> On Sat, Nov 14, 2026 at 11:05:41PM +0800, Aibing Chen wrote:
> > syzbot reported a possible circular locking dependency between
> > rds_trans_sem and the RDMA CM handler mutex:
> >=20
> >   CPU0 (bind path)                    CPU1 (CM callback path)
> >   ----                                ----
> >   down_read(&rds_trans_sem)           mutex_lock(&handler_mutex)
> >   rds_ib_laddr_check()                cma_ib_req_handler()
> >     rdma_destroy_id()                   rds_ib_cm_handle_connect()
> >       mutex_lock(&handler_mutex)          rds_conn_create()
> >                                             rds_trans_get_preferred()
> >                                               down_read(&rds_trans_sem)
> >=20
> > rds_ib_laddr_check_cm() destroys the CM id from inside
> > rds_trans_get_preferred()'s read-side critical section, while CM
> > callbacks create RDS connections (taking the same read lock) from
> > under handler_mutex.
> >=20
> > Break the cycle by destroying the CM id asynchronously: add
> > rdma_destroy_id_wq(), which queues the destruction on cma_wq, and
> > switch rds_ib_laddr_check_cm() to it.  The destroy work is embedded
> > in struct rdma_id_private, which keeps the id alive until the work
> > runs; rds does not touch cm_id after the destroy call.
>=20
> This doesn't seem like it should be the core codes problem? Why can't
> rds do the workqueue?
>=20
> Jason

Hi Aibing,

Aibing, thanks for chasing this down.  I think Jason is right, this
should probably be in the rds side.  This solution doesnt quite cover
all the locking issues though.  rds_conn_create calls
rds_trans_get_preferred() which falls through to rds_ib_laddr_check_cm()
when not local.  And then we get a rdma_destroy_id while the listen id's
handler_mutex is still held.

I think a better way to do this might be to create a new work item and
then deffer the rdma_destroy_id to be completed later by a worker.  The
work item would just hold the cm_id queued on rds_wq, and then the handler
just calls rdma_destroy_id() and frees itself.  alloc the new work item at
the top of rds_ib_laddr_check_cm and then queue the new work item in place =
of
the rdma_destroy_id.  You'll also need to add another flush_workqueue(rds_w=
q)
after rds_trans_unregister() in rds_ib_exit().

Other nits:  this patch should have a fixes tag, and target the net tree
like this: "[PATCH net v2] net/rds ...".  And I think the fixes tag is:
ec16227e1414 ("RDS/IB: Infiniband transport").  Drop the tested-by until it
is tested by syzbot and/or Eduard, and be sure to update your change log
below the dashed line.

Thanks for working on this!
Allion
