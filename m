From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] IB/srpt: Set srq_type to IB_SRQT_BASIC
Date: Thu, 12 Apr 2012 20:05:44 -0700
Message-ID: <1334286344.3137.4881.camel@haakon2.linux-iscsi.org>
References: <1334243053-6302-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1334243053-6302-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2012-04-12 at 08:04 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Since commit 96104eda0169 ("RDMA/core: Add SRQ type field"), kernel
> users of SRQs need to specify srq_type = IB_SRQT_BASIC in struct
> ib_srq_init_attr, or else most low-level drivers will fail in
> when srpt_add_one() calls ib_create_srq() and gets -ENOSYS.
> 
> (mlx4_ib works OK nearly all of the time, because it just needs
> srq_type != IB_SRQT_XRC.  And apparently nearly everyone using
> ib_srpt is using mlx4 hardware)
> 
> Reported-by: Alexey Shvetsov <alexxy@gentoo.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
> I'll send this on to Linus shortly...
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 69e2ad0..daf21b8 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -3232,6 +3232,7 @@ static void srpt_add_one(struct ib_device *device)
>  	srq_attr.attr.max_wr = sdev->srq_size;
>  	srq_attr.attr.max_sge = 1;
>  	srq_attr.attr.srq_limit = 0;
> +	srq_attr.srq_type = IB_SRQT_BASIC;
>  
>  	sdev->srq = ib_create_srq(sdev->pd, &srq_attr);
>  	if (IS_ERR(sdev->srq))

<nod>, unfortunately I've only been able to run this on mlx4 HCAs so
far..  Pulled into lio-core/master.

Thanks alot for the patch Roland!

--nab
