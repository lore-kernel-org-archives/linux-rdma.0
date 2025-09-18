Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6E519E967
	for <linux-rdma@vger.kernel.org>; Thu, 18 Sep 2025 12:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758196965; cv=none; b=VPjeMHpQLUsTv+AYRQBcGSxjcXXKeWnznTDHdcyh8nfWv9TPHQNJYCJ/DNhFxDh1SQqs55+Hb0qUHWzDqxs2ziE1s+tqXh9GXU5YSkm754E/2m1a7D/EVbCVeTaUYtAhbJQ2ZjBODSWw8K8r9qJYVdnXAvpDqQsgenN6jUp0vSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758196965; c=relaxed/simple;
	bh=FiCKivX13hbul5rz9BgbaQvpkYB/2MR48I7KBGGkAA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZMHgriIGvtZTssbiv/tOKG66lxRHlUkWL0U1opATReU0RSQIwcdM/nFV7rLPXgTdNJA5cNS3pbS7XALwRtJtCDmvGkWjDrcwhvWCwvJmTmvWDdkaqa+cKQfT6vdLBgM2S2qqQoMheEpHHVmFmTjWKF9hnqx68zLSO66WBwubPcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mt3iz2Fh; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mt3iz2Fh"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6228de280a4so1410179a12.2
        for <linux-rdma@vger.kernel.org>; Thu, 18 Sep 2025 05:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758196962; x=1758801762; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EgTjWdNAeATC9fSYNBkpSg9g+rdFSYzomsQoCW/uKIA=;
        b=Mt3iz2FhrcdER4jGIwPuHpubkgHHVujgVTtXmTSSWprYrYC7ImQHA+PYyKtRfK4TLJ
         UhJDwkzRQQz/gfBwN4YDx5hGQoXB2EIs+Np6UoeQnfmsNZnFJmfF90Vc1RTttn3UMSKD
         EPUymhCTXWGY5z53PE0+/n+jMpIMlzuEnRQMTwOFon51fbGpJaje6eHduFJHSEHGPXOI
         6fcZueDFJVQjdQNnUHWkzLlcKaYLVpv3NDQA4K8ZFNE22HONH2b5G9kmqB0b/9cWk17A
         Zmv+Mo6kolNsIXk8yepJDvISDjjFvvjZVKW5orHGGVy8gsJzMNp8r0alNBj2Q4DPpnSS
         2flQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758196962; x=1758801762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EgTjWdNAeATC9fSYNBkpSg9g+rdFSYzomsQoCW/uKIA=;
        b=HUDSP7pY7+/WzGjuFOusGy30ndxNf0P2TI/lYYTE/HevJwxUJrUX+CPGxNBwV2B57l
         epjJb4lJh2NvUAzeTZk5dzQezM0t/t3FET+3F8u2qPxp095mBqVOPR9l4ZFd0e8HUayj
         d/bps6ehCUbMYZGAP8o60O+xr3u3q5+qkFYDGAWpA1bTX1OMWx1ndDZyeMd5cg3LmS4U
         cKPTRs32XV9ikXUjSaGdzZgEzBd7O1sXe0PLQA9W3mOYJhxkGI7n0IQf6ZkpKIXOSt/j
         KJz1a85eVm4zWhovph8xFD2+lS2ckXW+6Ok6xumcmYYNVHPIYkx1c3wtN7QzUqnnjtF3
         WXIg==
X-Forwarded-Encrypted: i=1; AJvYcCVWPhR1y5Iac/9Rt9gOJY1wwjAXi+HKhCf1JIAUndCZLyhT/3ZhowHzU3H5wtJniK8orn0LYRvhqtQh@vger.kernel.org
X-Gm-Message-State: AOJu0Yws+/i8gmtVI0q6OpfWZJBLdTrK8hGUsV45SYX+9Mlw4pYPW9pe
	L1dfUlGGZpTjoJqY1F4uf7UTLECuldamNlWCBzBcdmpZiVs7cncNf2jb8AFwT6C272eW7SwX+Rj
	tVv66kNJeh1iZ/3CP69QToYY1XWHjeDo=
X-Gm-Gg: ASbGncvUCEtnSGyaWqyR9GyBbQm/vGBgzoF7Uu1+Tf1ivDcr9I25HKtq35ytl6Ztdku
	EybJzygCsXZlZvsXvt+KAIbV3PJgcmySXdI5lO6TDUjWV0TlqG7Gk0AqIdr278jhzTJp3scb8o9
	jDtYuSTL8l2f3je2nLEBThbIVXvJNpG1L5diJqIvExBiQnvrf/vlTHpBO81MdAWMrgB7Vhmwfny
	10OtBaEggPkfQvFCW5q0kSV/g==
X-Google-Smtp-Source: AGHT+IHVUHlJO0cZgTPunPW6G9LaF1ZC7D7lVNzN/pIDhFPtMoiQK2KtWpG1ihhSrZ97nhPYnTFCrTiO8H0A4ekfmfU=
X-Received: by 2002:a05:6402:42c1:b0:61e:c750:1ef2 with SMTP id
 4fb4d7f45d1cf-62f84663933mr5552717a12.36.1758196961719; Thu, 18 Sep 2025
 05:02:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917100657.1535424-1-hanguidong02@gmail.com>
 <a321729d-f8a1-4901-ae9d-f08339b5093b@linux.dev> <20250918095844.GD10800@unreal>
In-Reply-To: <20250918095844.GD10800@unreal>
From: Gui-Dong Han <hanguidong02@gmail.com>
Date: Thu, 18 Sep 2025 20:02:04 +0800
X-Gm-Features: AS18NWAqH4wrp_0SoYiOdKts9735PQQ1gEGdnexnZflBldPFcYETCYiYeXsaa6k
Message-ID: <CAOPYjvZ-kn98bq0C_ng1e4hrC2LKh5jdo-fm1BB9M2ULbhp10A@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rxe: Fix race in do_task() when draining
To: Leon Romanovsky <leon@kernel.org>
Cc: "yanjun.zhu" <yanjun.zhu@linux.dev>, zyjzyj2000@gmail.com, jgg@ziepe.ca, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, stable@vger.kernel.org, 
	"rpearsonhpe@gmail.com" <rpearsonhpe@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 5:58=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Wed, Sep 17, 2025 at 12:30:56PM -0700, yanjun.zhu wrote:
> > On 9/17/25 3:06 AM, Gui-Dong Han wrote:
> > > When do_task() exhausts its RXE_MAX_ITERATIONS budget, it uncondition=
ally
> >
> > From the source code, it will check ret value, then set it to
> > TASK_STATE_IDLE, not unconditionally.
> >
> > > sets the task state to TASK_STATE_IDLE to reschedule. This overwrites
> > > the TASK_STATE_DRAINING state that may have been concurrently set by
> > > rxe_cleanup_task() or rxe_disable_task().
> >
> > From the source code, there is a spin lock to protect the state. It wil=
l not
> > make race condition.
> >
> > >
> > > This race condition breaks the cleanup and disable logic, which expec=
ts
> > > the task to stop processing new work. The cleanup code may proceed wh=
ile
> > > do_task() reschedules itself, leading to a potential use-after-free.
> > >
> >
> > Can you post the call trace when this problem occurred?
> >
> > Hi, Jason && Leon
> >
> > Please comment on this problem.
>
> The idea to recheck task->state looks correct to me, otherwise we overwri=
te it unconditionally.
> However I would write this patch slightly different (without cont =3D 1):
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw=
/rxe/rxe_task.c
> index 6f8f353e95838..2ff5d7cc0a933 100644
> --- a/drivers/infiniband/sw/rxe/rxe_task.c
> +++ b/drivers/infiniband/sw/rxe/rxe_task.c
> @@ -132,8 +132,10 @@ static void do_task(struct rxe_task *task)
>                  * yield the cpu and reschedule the task
>                  */
>                 if (!ret) {
> -                       task->state =3D TASK_STATE_IDLE;
> -                       resched =3D 1;
> +                       if (task->state !=3D TASK_STATE_DRAINING) {
> +                               task->state =3D TASK_STATE_IDLE;
> +                               resched =3D 1;
> +                       }
>                         goto exit;
>                 }
>
> @@ -151,7 +153,6 @@ static void do_task(struct rxe_task *task)
>                         break;
>
>                 case TASK_STATE_DRAINING:
> -                       task->state =3D TASK_STATE_DRAINED;
>                         break;
>
>                 default:
> (END)

Hi Leon,

Thanks for your review and for confirming the need for a fix.

Regarding your suggested patch, I believe removing the transition to
TASK_STATE_DRAINED would cause an issue. As seen in the code and comments
for rxe_cleanup_task() and is_done(), the cleanup process waits for the
final TASK_STATE_DRAINED state. If the task remains stuck in DRAINING,
the cleanup loop will never terminate.

My use of cont =3D 1 was intended as a minimal change. Since this
regression was introduced during the migration from tasklets, restoring
the pre-migration logic seemed like a reasonable approach. An alternative
could be to set the state to TASK_STATE_DRAINED directly inside the
if (!ret) block, and I am open to discussing the best fix.

Regards,
Han
