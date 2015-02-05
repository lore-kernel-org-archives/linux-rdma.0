From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] InfiniBand: Delete unnecessary checks before the function,
 call "srp_destroy_fr_pool"
Date: Thu, 5 Feb 2015 15:32:33 +0100
Message-ID: <54D37F01.7070709@sandisk.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <54D36190.1050407@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54D36190.1050407@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, Hal Rosenstock <hal.rosenstock@gmail.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

On 02/05/15 13:26, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 5 Feb 2015 13:20:42 +0100
> 
> The srp_destroy_fr_pool() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 0747c05..6f5dfa1 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -549,8 +549,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
>  				     "FR pool allocation failed (%d)\n", ret);
>  			goto err_qp;
>  		}
> -		if (ch->fr_pool)
> -			srp_destroy_fr_pool(ch->fr_pool);
> +		srp_destroy_fr_pool(ch->fr_pool);
>  		ch->fr_pool = fr_pool;
>  	} else if (!dev->use_fast_reg && dev->has_fmr) {
>  		fmr_pool = srp_alloc_fmr_pool(target);
> @@ -615,13 +614,12 @@ static void srp_free_ch_ib(struct srp_target_port *target,
>  	if (!ch->qp)
>  		return;
>  
> -	if (dev->use_fast_reg) {
> -		if (ch->fr_pool)
> -			srp_destroy_fr_pool(ch->fr_pool);
> -	} else {
> +	if (dev->use_fast_reg)
> +		srp_destroy_fr_pool(ch->fr_pool);
> +	else
>  		if (ch->fmr_pool)
>  			ib_destroy_fmr_pool(ch->fmr_pool);
> -	}
> +
>  	srp_destroy_qp(ch);
>  	ib_destroy_cq(ch->send_cq);
>  	ib_destroy_cq(ch->recv_cq);

This patch makes the code in srp_free_ch_ib() asymmetric which is
unfortunate. Please add a test in ib_destroy_fmr_pool() such that the
check before ib_destroy_fmr_pool() can also be eliminated.

Bart.
