From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibnetdiscover.c: Fix typo in help
Date: Fri, 24 Jun 2011 15:31:11 -0700
Message-ID: <20110624153111.07d9bb05.weiny2@llnl.gov>
References: <4DFF4488.6000004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFF4488.6000004-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 20 Jun 2011 06:00:56 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied,
Ira

> ---
> diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
> index 9768877..59304b6 100644
> --- a/src/ibnetdiscover.c
> +++ b/src/ibnetdiscover.c
> @@ -987,7 +987,7 @@ int main(int argc, char **argv)
>  	ibnd_fabric_t *diff_fabric = NULL;
>  
>  	const struct ibdiag_opt opts[] = {
> -		{"full", 'f', 0, NULL, "show full information (ports' speed and witdh)"},
> +		{"full", 'f', 0, NULL, "show full information (ports' speed and width)"},
>  		{"show", 's', 0, NULL, "show more information"},
>  		{"list", 'l', 0, NULL, "list of connected nodes"},
>  		{"grouping", 'g', 0, NULL, "show grouping"},


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
