From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Outreachy kernel] [PATCH] infiniband: hw: Drop unnecessary
 continue
Date: Sat, 3 Mar 2018 15:07:13 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1803031506550.2302@hadrien>
References: <20180303130336.GA8210@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180303130336.GA8210@seema-Inspiron-15-3567>
Sender: linux-kernel-owner@vger.kernel.org
To: Arushi Singhal <arushisinghal19971997@gmail.com>
Cc: dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
List-Id: linux-rdma@vger.kernel.org



On Sat, 3 Mar 2018, Arushi Singhal wrote:

> Continue at the bottom of a loop are removed.
> Issue found using drop_continue.cocci Coccinelle script.
>
> Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
> ---
>  drivers/infiniband/hw/qib/qib_init.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
> index 3990f38..1bd3b32 100644
> --- a/drivers/infiniband/hw/qib/qib_init.c
> +++ b/drivers/infiniband/hw/qib/qib_init.c
> @@ -681,7 +681,6 @@ int qib_init(struct qib_devdata *dd, int reinit)
>  		if (lastfail) {
>  			qib_dev_err(dd,
>  				"failed to allocate kernel ctxt's rcvhdrq and/or egr bufs\n");
> -			continue;
>  		}

Again, the braces should be dropped too.

julia

>  	}
>
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20180303130336.GA8210%40seema-Inspiron-15-3567.
> For more options, visit https://groups.google.com/d/optout.
>
