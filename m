From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 2/3] infiniband-diags: Initial changes for extended
 speed support in libibmad
Date: Fri, 8 Jul 2011 13:54:13 -0700
Message-ID: <20110708135413.30fe96d8.weiny2@llnl.gov>
References: <4E15E3C4.8020709@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E15E3C4.8020709-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 7 Jul 2011 09:50:12 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Need larger buffer for mad_dump_portinfo due to additional extended
> speed fields
> 
> Signed-off-by: Hal Rosenstock

Thanks, applied,
Ira

> ---
> diff --git a/src/saquery.c b/src/saquery.c
> index 7933fec..53ab1b6 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -419,7 +419,7 @@ static void dump_portinfo_record(void *data)
>  
>  static void dump_one_portinfo_record(void *data)
>  {
> -	char buf[2048], buf2[4096];
> +	char buf[2300], buf2[4096];
>  	ib_portinfo_record_t *pir = data;
>  	ib_port_info_t *pi = &pir->port_info;
>  
> diff --git a/src/smpquery.c b/src/smpquery.c
> index a46bb18..65bb65c 100644
> --- a/src/smpquery.c
> +++ b/src/smpquery.c
> @@ -131,7 +131,7 @@ static char *node_info(ib_portid_t * dest, char **argv, int argc)
>  
>  static char *port_info(ib_portid_t * dest, char **argv, int argc)
>  {
> -	char buf[2048];
> +	char buf[2300];
>  	char data[IB_SMP_DATA_SIZE] = { 0 };
>  	int portnum = 0;
>  


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
