Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083B5234973;
	Wed, 18 Mar 2026 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773846152; cv=none; b=ezR/tE4i+Y64VXl6MY2gatRvOsThI50O14b6A5/lYlBK0mc5E1P4Rr6WPQZxILslMNAXen9/mnRoyoS1lt3vx8ciHVpQ62xI9vXf2VMv6Gc7uu6Nq6sC3KBdOMVIByhie5raIj27NLXLSClB3GnYI+QW7bnlUt5iQf9dPD/WSA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773846152; c=relaxed/simple;
	bh=SLcN2sx05GXefwaI7EcCTrz09DHH/AX+GgtfSD1lp2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=on51a27qx1jfW8Ogr0DeO+y/9DPWTA3JPjtHl2Ejpce+B3jowu/vBJL6aeAqYd1U7SmE2BJSfE3eT2S7XWvy7c++bvbHF0zVJ7RLNhOJze4T79eM2I19Yrwz185ET26923N+QalI6bmEhQpgX4sEz/LfykDw6EcGlbYrxAiSNBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSOzDil2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSOzDil2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4454EC19421;
	Wed, 18 Mar 2026 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773846151;
	bh=SLcN2sx05GXefwaI7EcCTrz09DHH/AX+GgtfSD1lp2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MSOzDil22N9esD+nawW147c8T0+fNj5/TqWL+WwY+G1XhEi4dGJGy41dVrvuI/ojJ
	 5Uv0R+wKTVQKT4fTHTS5e+hvNyd9SoGXnlO7JrMcwziTe0b3QlPJ06YjAKfKHupnAk
	 zku1B2vp90zJcZbtjBUojX/42IGp3S43cYYnBskIGEBc+rlo0axEEaY3BCcYpIeVZp
	 gl+oWyysOnEpFiVXzIvro11CECNEgnIoWs+5+nXUk/Q43Tb49MmmLi/2q2KvQpQ+/C
	 dvWqT5yf+Ls/mF7XqpwPmvLYurPKydwsYjbuayxdsJs3Damz+k7kf2vMwrsl6G6Xq7
	 hHEvWJVdhFxJQ==
Date: Wed, 18 Mar 2026 17:02:25 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Hocko <mhocko@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/rxe: Replace use of system_unbound_wq with
 system_dfl_wq
Message-ID: <20260318150225.GD352386@unreal>
References: <20260313154023.298325-1-marco.crivellari@suse.com>
 <20260316201301.GL61385@unreal>
 <CAAofZF61VPo8VAX8zXUZnY-ydDYAR0N0mN2egaeTzXbiaKQbDw@mail.gmail.com>
 <20260317162429.GA61385@unreal>
 <CAAofZF4jW2hD+UsBG8w3zYPeGGaHeSx0tSY2Prd2dXLLBkaf1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAofZF4jW2hD+UsBG8w3zYPeGGaHeSx0tSY2Prd2dXLLBkaf1g@mail.gmail.com>

On Wed, Mar 18, 2026 at 01:20:01PM +0100, Marco Crivellari wrote:
> On Tue, Mar 17, 2026 at 5:24 PM Leon Romanovsky <leon@kernel.org> wrote:
> > [...]
> >
> > Actually, RXE already have one workqueue in rxe_alloc_wq(), just use it.
> 
> Hi Leon,
> 
> I noticed the workqueue is declared as static into a C file. So I
> changed it a bit, tell me if
> it's not the right approach.

Your fix is the most accurate and technically sound among all proposals.

Thanks

> You can see the diff below:
> 
> ---
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
> index ff8cd53f5f28..c56bae376c7f 100644
> --- a/drivers/infiniband/sw/rxe/rxe.h
> +++ b/drivers/infiniband/sw/rxe/rxe.h
> @@ -121,4 +121,6 @@ void rxe_port_up(struct rxe_dev *rxe);
> void rxe_port_down(struct rxe_dev *rxe);
> void rxe_set_port_state(struct rxe_dev *rxe);
> 
> +extern struct workqueue_struct *rxe_wq;
> +
> #endif /* RXE_H */
> diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c
> b/drivers/infiniband/sw/rxe/rxe_odp.c
> index d440c8cbaea5..ff904d5e54a7 100644
> --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> @@ -545,7 +545,7 @@ static int rxe_ib_advise_mr_prefetch(struct ib_pd *ibpd,
>                work->frags[i].mr = mr;
>        }
> 
> -       queue_work(system_dfl_wq, &work->work);
> +       queue_work(rxe_wq, &work->work);
> 
>        return 0;
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_task.c
> b/drivers/infiniband/sw/rxe/rxe_task.c
> index f522820b950c..801d06c969c9 100644
> --- a/drivers/infiniband/sw/rxe/rxe_task.c
> +++ b/drivers/infiniband/sw/rxe/rxe_task.c
> @@ -6,7 +6,7 @@
> 
> #include "rxe.h"
> 
> -static struct workqueue_struct *rxe_wq;
> +struct workqueue_struct *rxe_wq;
> 
> int rxe_alloc_wq(void)
> {
> 
> ---
> 
> Thanks!
> 
> -- 
> 
> Marco Crivellari
> 
> L3 Support Engineer
