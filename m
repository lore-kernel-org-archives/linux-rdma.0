Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D893D5656;
	Wed,  9 Sep 2026 07:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937775; cv=none; b=mVGyQqcetz4l4bcA24iWSOGPolF7XxB2lrlxAsEEd0omc8EHUvpe50aPMXQJjrLOBdfQX3oB7G38/8Vz9QKBfd1F3jPp9Wo59AxjT48bO4zpJoCupTbCWXqhDs9hDEzhapq19F6GIGIjKGWZV79cbWGNGTZJ1F+qce1GiQJFB7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937775; c=relaxed/simple;
	bh=1FAIQnZhZLFZV/kJb7P8mASwsdd4Z8mss2/nHoa+KR0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c2XeP2nMHz1pmLsDP8pEYKz+YS7KCWswzxnRMHVdhczlQVAApxecpzTuPWHpfnj2kgCDvcgFx/p7e/ugNNuBfU0BmMPzV4sEU+Xb9Ap0TWXPze4tZpPayH0Ag6zjx3NSh9kVSenV1uDxfJE7ChwwuMKa9WQ4hqmmWf+22KIIMGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqZcA2zc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqZcA2zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D011F00A3A;
	Wed,  9 Sep 2026 07:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788937773;
	bh=07RL5PmXNvtCfGUStJ5pEHV1wfyEpGPOcdrgmnwqvqQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dqZcA2zcPrzpT4MGF+wy9U90QV4SzDzwQbpPlgCkQkbHMU6g4WLGrTe0R3zRArkpc
	 qd5Ru50M9+AaZs9l4w4kHrGHaVqEd/4w2os7TbO+5hTHS1SpOcLPDOylGfuwHgUHhM
	 P4WgCA+ll+bnSSpoTq5d830ZcDQlZFpEo06aLSaaIU6WhX0TEfi5Ru7aDFnVglF+M7
	 VUcvj+yimtv4lFoBxgMfV9BcvxL9NxcaicDCWpptT6iEj+j4ruAGLDDOR0TTNt1YNE
	 vWoPAUeYzfNT+cWhExflaf8h0trCwWz7fV6kjufvUc9uDgoZ9iOD6p8Zi3YFCGB/kO
	 vfpUgZhfsgG2Q==
Message-ID: <4fda023c1e7152aee2d5f977f5045dcddcd08d8d.camel@kernel.org>
Subject: Re: [PATCH net] rds: ib: use rds_conn_drop() on protocol version
 mismatch
From: Allison Henderson <achender@kernel.org>
To: henrymei <ljp1205831794@gmail.com>, netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	santosh.shilimkar@oracle.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, Aohan Mei
	 <henrymei@tencent.com>, TencentOS Corvus AI <corvus@tencent.com>, 
	stable@vger.kernel.org
Date: Wed, 09 Sep 2026 00:09:32 -0700
In-Reply-To: <20260908123356.1163970-1-henrymei@tencent.com>
References: <20260908123356.1163970-1-henrymei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-08 at 20:33 +0800, henrymei wrote:
> From: Aohan Mei <henrymei@tencent.com>
>=20
> rds_ib_cm_connect_complete() runs from the RDMA-CM event handler with
> conn->c_cm_lock held.  When the peer negotiates a protocol version
> older than RDS_PROTOCOL_COMPAT_VERSION, the handler calls
> rds_conn_destroy(), which is only safe in the rmmod path: it
> synchronously tears the connection down and flush_work()es the
> shutdown work cp_down_w.
>=20
> That shutdown work (rds_conn_shutdown()) needs cp_cm_lock, which is
> the very lock the event handler still holds, so the flush never
> completes: the two workers wait on each other and the RDS connection
> workqueues stall for good.
>=20
> All other RDMA-CM failure paths (REJECTED, CONNECT_ERROR,
> DISCONNECTED) use rds_conn_drop(), which marks the connection
> RDS_CONN_ERROR and schedules the shutdown work asynchronously.  Use
> it here as well.
>=20
> Fixes: cdc306a5c9cd ("rds: make v3.1 as compat version")

Hi Aohan,

Thanks for the catch, this looks correct to me.  Just one nit on the
fixes tag.  I think we want: f147dd9ecabf ("RDS/IB: Disallow connections
less than RDS 3.1").  That looks like the commit that added the
rds_conn_destroy() call to the version check.  Other than that, I think
this patch looks good.  With the Fixes tag corrected, you can add my rvb:

Reviewed-by: Allison Henderson <achender@kernel.org>

Thanks!
Allison

> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Cc: stable@vger.kernel.org
> Assisted-by: CodeBuddy:Kimi-K3
> Signed-off-by: Aohan Mei <henrymei@tencent.com>
> ---
>  net/rds/ib_cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index d46146887ba4..2909da8363f3 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -115,7 +115,7 @@ void rds_ib_cm_connect_complete(struct rds_connection=
 *conn, struct rdma_cm_even
>  				  &conn->c_laddr, &conn->c_faddr,
>  				  RDS_PROTOCOL_MAJOR(conn->c_version),
>  				  RDS_PROTOCOL_MINOR(conn->c_version));
> -			rds_conn_destroy(conn);
> +			rds_conn_drop(conn);
>  			return;
>  		}
>  	}

