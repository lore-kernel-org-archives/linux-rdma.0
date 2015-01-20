From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] ib_srpt: wait_for_completion_timeout does not return
 negativ status
Date: Tue, 20 Jan 2015 15:51:30 -0800
Message-ID: <1421797890.9970.14.camel@haakon3.risingtidesystems.com>
References: <1421407217-9105-1-git-send-email-der.herr@hofr.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421407217-9105-1-git-send-email-der.herr@hofr.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Bart Van Assche <bvanassche@acm.org>, Jingoo Han <jg1.han@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@infradead.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Nicholas,

On Fri, 2015-01-16 at 12:20 +0100, Nicholas Mc Guire wrote:
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
> 
> Patch is against 3.19.0-rc3 -next-20150109
> 
> Patch was compiletested only with x86_64_defconfig +
> CONFIG_TARGET_CORE=m, CONFIG_INFINIBAND=m, CONFIG_INFINIBAND_SRPT=m
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index eb694dd..4e58c76 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -3533,7 +3533,7 @@ static void srpt_close_session(struct se_session *se_sess)
>  	spin_unlock_irq(&sdev->spinlock);
>  
>  	res = wait_for_completion_timeout(&release_done, 60 * HZ);
> -	WARN_ON(res <= 0);
> +	WARN_ON(res == 0);
>  }
>  
>  /**

Notice that 'res' here is still incorrectly defined as an 'int', instead
of 'unsigned long'.

I've updated your patch to use the proper type for res, and added a
short commit log to describe what it's doing.

Merged into target-pending/for-next.

Thanks!

--nab
