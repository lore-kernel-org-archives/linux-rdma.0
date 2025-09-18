Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C5D27B324;
	Thu, 18 Sep 2025 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758197459; cv=none; b=qRUSFgNQ1xnBob2p7CsFC5iRRGN0Q7DCVqDcqGhQbSn3D0FLa6HpR/ZA8ys1Doj8E85S4rtM3vVeiUMIj32HZRrkBJMsPLy7/PQeoqDlYdUbYtl7DoP1vWraLpeCzxY3ItAStraob6CPzzNqMD6SbNcr+ogunAv2Kcs0bKH/Qeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758197459; c=relaxed/simple;
	bh=aKMdJ/XzAe2M7ZNo6zb/1KpDyxkbF1l2T/ETWlh3AvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6ERTAlZssN/quC0AJfuEIX25viqbFjORVa9glnpO0Ww2SvM0zubjoTgFO+H7EpFeCfE/vs6IX8GtgMXieyI9S903C0mR2DbkMxWASTtxB1jAhV7A2i8p338g2rFTDDW82xFAeKMQZb/oUFoAk1R/tlxHwJA810nkZgaotdHwPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tey5P/LH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tey5P/LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A5CC4CEE7;
	Thu, 18 Sep 2025 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758197459;
	bh=aKMdJ/XzAe2M7ZNo6zb/1KpDyxkbF1l2T/ETWlh3AvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tey5P/LHvbcCy/xqYxyfx27wIRktwE4MOwppjO1wY0s8hlks9jpHlbRhb/KZbTdGQ
	 HT3KqYdGHjdrz+OA8aWDmUV3C2r/kmaySBEowby9fPgW65YZPX45894oppm1jR7MkU
	 LqdrFfEGA9cpJUoNNiigBov32sInwqlfLEIfnt0S151E28IiA9UJtQFAkeQ1dEuAA+
	 QoPMI6yGylWEPVj+Zq/ft1BMd+Y6fk+gXzmY6bfXaNRXnNF3HsKoPZYDpnxlnA2kU6
	 yrQv4ZLcWwpLIY8MKVit1psOCfQvYn01/AtnsBoX0JTB97TSW8cUZauqJ/VeITuykw
	 SVNV93MIRvAXQ==
Date: Thu, 18 Sep 2025 15:10:54 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Gui-Dong Han <hanguidong02@gmail.com>
Cc: "yanjun.zhu" <yanjun.zhu@linux.dev>, zyjzyj2000@gmail.com, jgg@ziepe.ca,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, stable@vger.kernel.org,
	"rpearsonhpe@gmail.com" <rpearsonhpe@gmail.com>
Subject: Re: [PATCH] RDMA/rxe: Fix race in do_task() when draining
Message-ID: <20250918121054.GF10800@unreal>
References: <20250917100657.1535424-1-hanguidong02@gmail.com>
 <a321729d-f8a1-4901-ae9d-f08339b5093b@linux.dev>
 <20250918095844.GD10800@unreal>
 <CAOPYjvZ-kn98bq0C_ng1e4hrC2LKh5jdo-fm1BB9M2ULbhp10A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOPYjvZ-kn98bq0C_ng1e4hrC2LKh5jdo-fm1BB9M2ULbhp10A@mail.gmail.com>

On Thu, Sep 18, 2025 at 08:02:04PM +0800, Gui-Dong Han wrote:
> On Thu, Sep 18, 2025 at 5:58 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Sep 17, 2025 at 12:30:56PM -0700, yanjun.zhu wrote:
> > > On 9/17/25 3:06 AM, Gui-Dong Han wrote:
> > > > When do_task() exhausts its RXE_MAX_ITERATIONS budget, it unconditionally
> > >
> > > From the source code, it will check ret value, then set it to
> > > TASK_STATE_IDLE, not unconditionally.
> > >
> > > > sets the task state to TASK_STATE_IDLE to reschedule. This overwrites
> > > > the TASK_STATE_DRAINING state that may have been concurrently set by
> > > > rxe_cleanup_task() or rxe_disable_task().
> > >
> > > From the source code, there is a spin lock to protect the state. It will not
> > > make race condition.
> > >
> > > >
> > > > This race condition breaks the cleanup and disable logic, which expects
> > > > the task to stop processing new work. The cleanup code may proceed while
> > > > do_task() reschedules itself, leading to a potential use-after-free.
> > > >
> > >
> > > Can you post the call trace when this problem occurred?
> > >
> > > Hi, Jason && Leon
> > >
> > > Please comment on this problem.
> >
> > The idea to recheck task->state looks correct to me, otherwise we overwrite it unconditionally.
> > However I would write this patch slightly different (without cont = 1):
> >
> > diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
> > index 6f8f353e95838..2ff5d7cc0a933 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_task.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_task.c
> > @@ -132,8 +132,10 @@ static void do_task(struct rxe_task *task)
> >                  * yield the cpu and reschedule the task
> >                  */
> >                 if (!ret) {
> > -                       task->state = TASK_STATE_IDLE;
> > -                       resched = 1;
> > +                       if (task->state != TASK_STATE_DRAINING) {
> > +                               task->state = TASK_STATE_IDLE;
> > +                               resched = 1;
> > +                       }
> >                         goto exit;
> >                 }
> >
> > @@ -151,7 +153,6 @@ static void do_task(struct rxe_task *task)
> >                         break;
> >
> >                 case TASK_STATE_DRAINING:
> > -                       task->state = TASK_STATE_DRAINED;
> >                         break;
> >
> >                 default:
> > (END)
> 
> Hi Leon,
> 
> Thanks for your review and for confirming the need for a fix.
> 
> Regarding your suggested patch, I believe removing the transition to
> TASK_STATE_DRAINED would cause an issue. As seen in the code and comments
> for rxe_cleanup_task() and is_done(), the cleanup process waits for the
> final TASK_STATE_DRAINED state. If the task remains stuck in DRAINING,
> the cleanup loop will never terminate.
> 
> My use of cont = 1 was intended as a minimal change. Since this
> regression was introduced during the migration from tasklets, restoring
> the pre-migration logic seemed like a reasonable approach. An alternative
> could be to set the state to TASK_STATE_DRAINED directly inside the
> if (!ret) block, and I am open to discussing the best fix.

Ahh, sorry, I misread that it is TASK_STATE_DRAINED and not TASK_STATE_DRAINING.

Thanks

> 
> Regards,
> Han
