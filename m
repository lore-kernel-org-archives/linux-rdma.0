From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: ibstat fix strncpy coverity check and
 -l bug
Date: Thu, 13 Jun 2013 06:58:21 -0400
Message-ID: <51B9A5CD.4010209@dev.mellanox.co.il>
References: <20130612211537.1eef2098a821426c466a83b5@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130612211537.1eef2098a821426c466a83b5-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/13/2013 12:15 AM, Ira Weiny wrote:
> 
> Changes since V1:
> 	Fix port parameter usage.
> 
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  src/ibstat.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/src/ibstat.c b/src/ibstat.c
> index 665bb0a..37f2361 100644
> --- a/src/ibstat.c
> +++ b/src/ibstat.c
> @@ -314,7 +314,8 @@ int main(int argc, char *argv[])
>  		if (i >= n)
>  			IBPANIC("'%s' IB device can't be found", argv[0]);
>  
> -		strncpy(names[i], argv[0], sizeof names[i]);
> +		strncpy(names[0], argv[0], sizeof(names[0])-1);
> +		names[0][sizeof(names[0])-1] = '\0';
>  		n = 1;
>  	}
>  
> @@ -324,16 +325,10 @@ int main(int argc, char *argv[])
>  		return 0;
>  	}
>  
> -	if (!list_only && argc) {
> -		if (ca_stat(argv[0], dev_port, short_format) < 0)
> -			IBPANIC("stat of IB device '%s' failed", argv[0]);
> -		return 0;
> -	}
> -
>  	for (i = 0; i < n; i++) {
>  		if (list_only)
>  			printf("%s\n", names[i]);
> -		else if (ca_stat(names[i], -1, short_format) < 0)
> +		else if (ca_stat(names[i], dev_port, short_format) < 0)

I don't think this works when ib device is not first one and port is
also supplied.

-- Hal

>  			IBPANIC("stat of IB device '%s' failed", names[i]);
>  	}
>  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
