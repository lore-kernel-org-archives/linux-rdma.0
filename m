From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH/RFC] RDMA/iwpm: Fix uninitialized error code in
 iwpm_send_mapinfo()
Date: Tue, 28 Nov 2017 16:08:34 -0700
Message-ID: <20171128230834.GH21325@ziepe.ca>
References: <1510827964-11100-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510827964-11100-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>, Doug Ledford <dledford@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 11:26:04AM +0100, Geert Uytterhoeven wrote:
> With gcc-4.1.2:
> 
>     drivers/infiniband/core/iwpm_util.c: In function ‘iwpm_send_mapinfo’:
>     drivers/infiniband/core/iwpm_util.c:647: warning: ‘ret’ may be used uninitialized in this function
> 
> Indeed, if nl_client is not found in any of the scanned has buckets, ret
> will be used uninitialized.
> 
> Preinitialize ret to zero to fix this.

Did we come to a conclusion if we should apply this to the RMDA tree? The
patch was marked RFC..

Thanks,
Jason

> Fixes: 30dc5e63d6a5ad24 ("RDMA/core: Add support for iWARP Port Mapper user space service")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> RFC as I have no idea if this can ever happen, and if yes, what's the
> correct behavior to handle it:
>   - return 0,
>   - return an error code,
>   - don't send anything,
>   - anything else?
>  drivers/infiniband/core/iwpm_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
> index 3c4faadb8cddd7fd..eb000b540495acd1 100644
> +++ b/drivers/infiniband/core/iwpm_util.c
> @@ -644,7 +644,7 @@ int iwpm_send_mapinfo(u8 nl_client, int iwpm_pid)
>  	int i = 0, nlmsg_bytes = 0;
>  	unsigned long flags;
>  	const char *err_str = "";
> -	int ret;
> +	int ret = 0;
>  
>  	skb = dev_alloc_skb(NLMSG_GOODSIZE);
>  	if (!skb) {
