From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: Re: [patch 3/3] ib_srpt: propagate return value from kstrtoul()
Date: Fri, 04 Nov 2011 14:56:39 -0700
Message-ID: <1320443799.5859.173.camel@haakon2.linux-iscsi.org>
References: <20111104182830.GI5796@elgon.mountain>
Reply-To: nab@risingtidesystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111104182830.GI5796@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Bart Van Assche <bart.vanassche@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2011-11-04 at 21:28 +0300, Dan Carpenter wrote:
> These days we've renamed strict_strtoul() to kstrtoul().  It has a
> couple different error codes it could return.  Smatch complains if
> we return -EINVAL instead of using the return value that kstrtoul()
> gave us.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks fine to me, and will get this series queued up for -rc2.

Thanks Dan!

--nab

> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index f27b8da..04ccc04 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -3704,10 +3704,10 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rdma_size(
>  	unsigned long val;
>  	int ret;
>  
> -	ret = strict_strtoul(page, 0, &val);
> +	ret = kstrtoul(page, 0, &val);
>  	if (ret < 0) {
> -		pr_err("strict_strtoul() failed with ret: %d\n", ret);
> -		return -EINVAL;
> +		pr_err("kstrtoul() failed with ret: %d\n", ret);
> +		return ret;
>  	}
>  	if (val > MAX_SRPT_RDMA_SIZE) {
>  		pr_err("val: %lu exceeds MAX_SRPT_RDMA_SIZE: %d\n", val,
> @@ -3744,10 +3744,10 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
>  	unsigned long val;
>  	int ret;
>  
> -	ret = strict_strtoul(page, 0, &val);
> +	ret = kstrtoul(page, 0, &val);
>  	if (ret < 0) {
> -		pr_err("strict_strtoul() failed with ret: %d\n", ret);
> -		return -EINVAL;
> +		pr_err("kstrtoul() failed with ret: %d\n", ret);
> +		return ret;
>  	}
>  	if (val > MAX_SRPT_RSP_SIZE) {
>  		pr_err("val: %lu exceeds MAX_SRPT_RSP_SIZE: %d\n", val,
> @@ -3784,10 +3784,10 @@ static ssize_t srpt_tpg_attrib_store_srp_sq_size(
>  	unsigned long val;
>  	int ret;
>  
> -	ret = strict_strtoul(page, 0, &val);
> +	ret = kstrtoul(page, 0, &val);
>  	if (ret < 0) {
> -		pr_err("strict_strtoul() failed with ret: %d\n", ret);
> -		return -EINVAL;
> +		pr_err("kstrtoul() failed with ret: %d\n", ret);
> +		return ret;
>  	}
>  	if (val > MAX_SRPT_SRQ_SIZE) {
>  		pr_err("val: %lu exceeds MAX_SRPT_SRQ_SIZE: %d\n", val,
> @@ -3831,10 +3831,10 @@ static ssize_t srpt_tpg_store_enable(
>  	unsigned long tmp;
>          int ret;
>  
> -	ret = strict_strtoul(page, 0, &tmp);
> +	ret = kstrtoul(page, 0, &tmp);
>  	if (ret < 0) {
>  		printk(KERN_ERR "Unable to extract srpt_tpg_store_enable\n");
> -		return -EINVAL;
> +		return ret;
>  	}
>  
>  	if ((tmp != 0) && (tmp != 1)) {
