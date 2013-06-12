From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags 3/6] ibstat.c: fix
 buffer-not-null-terminated
Date: Wed, 12 Jun 2013 14:22:58 -0700
Message-ID: <20130612142258.7512162f044aa68314dd4ad1@intel.com>
References: <51B87DD9.1080701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B87DD9.1080701-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Same comment as previous patch and this should have been rolled into that patch anyway.

Ira

On Wed, 12 Jun 2013 09:55:37 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> 
> Buffer may not have a null terminator if the source string's length is
> equal to the buffer size.
> 
> Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/ibstat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/src/ibstat.c b/src/ibstat.c
> index acb9e8e..bdc021b 100644
> --- a/src/ibstat.c
> +++ b/src/ibstat.c
> @@ -279,7 +279,7 @@ int main(int argc, char *argv[])
>  	int dev_port = -1;
>  	int n, i;
>  
> -	memset(names, 0, sizeof(names[0][0] * UMAD_MAX_DEVICES * UMAD_CA_NAME_LEN));
> +	memset(names, 0, sizeof(names[0][0]) * UMAD_MAX_DEVICES * UMAD_CA_NAME_LEN);
>  	const struct ibdiag_opt opts[] = {
>  		{"list_of_cas", 'l', 0, NULL, "list all IB devices"},
>  		{"short", 's', 0, NULL, "short output"},
> -- 
> 1.7.8.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
