From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: fix not showing FDR10 speeds
Date: Sat, 7 Jul 2012 17:21:27 -0700
Message-ID: <20120707172127.c4b723d6d8dfd996cb560da1@llnl.gov>
References: <4FF5C40D.7020209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FF5C40D.7020209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 05 Jul 2012 12:42:53 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> Fix: ibnetdiscover shows FDR10 speeds as QDR due to bug in setting
> default parameters.
> 
> Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
>  src/ibnetdiscover.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
> index fe785b3..7e35449 100644
> --- a/src/ibnetdiscover.c
> +++ b/src/ibnetdiscover.c
> @@ -1108,6 +1108,8 @@ int main(int argc, char **argv)
>  	if (ibd_timeout)
>  		config.timeout_ms = ibd_timeout;
>  
> +	config.flags = ibd_ibnetdisc_flags;
> +
>  	if (argc && !(f = fopen(argv[0], "w")))
>  		IBERROR("can't open file %s for writing", argv[0]);
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
