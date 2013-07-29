From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: Re: [patch] IB/mlx5: stack info leak in mlx5_ib_alloc_ucontext()
Date: Mon, 29 Jul 2013 15:02:28 +0300
Message-ID: <20130729120228.GA20064@mtldesk30>
References: <20130725170436.GC7026@elgon.mountain>
 <20130728072336.GB29427@mtldesk30>
 <20130728202323.GA5053@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130728202323.GA5053@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eli Cohen <eli@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 28, 2013 at 11:24:43PM +0300, Dan Carpenter wrote:
> 
> First let me say that I don't know how this code is called, it may
> be root only, but even in that case I think it's still worth
> applying my patch.

It can be called by non root users as well.

> 
> These info leak problems are a well known security problem so I
> didn't put a long explanation.  What you do is you fill the stack
> with function pointers, then you call the function that leaks.  Then
> you have a potentially useful pointer which was supposed to be
> secret.  Something like that anyway.
> 
> There are probably lots of other easier ways to defeat address space
> randomization.  There may be other ways you can use info leaks as
> well...
> 
> Anyway, regardless, static checkers and code auditors look for these
> leaks so applying the patch makes sense just to silence a warning.
> 

OK, I am convinced that it's worth applying.

Acked by Eli Cohen <eli@mellanox.com>
