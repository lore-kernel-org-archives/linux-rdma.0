From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Remove unused pisize parameter from dump_portinfo in ibdiag_common
Date: Sat, 12 Dec 2015 11:34:20 -0500
Message-ID: <20151212163420.GJ7855@phlsvsds.ph.intel.com>
References: <5641D38B.605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5641D38B.605-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 01:22:51PM +0200, Hal Rosenstock wrote:
> 
> src/ibdiag_common.c: In function ?dump_portinfo?:
> src/ibdiag_common.c:856: warning: unused parameter ?pisize?
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
> index af5b3c4..21b0522 100644
> --- a/include/ibdiag_common.h
> +++ b/include/ibdiag_common.h
> @@ -150,7 +150,7 @@ int vsnprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
>  		   const char *format, va_list va_args);
>  int snprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
>  		  const char *format, ...);
> -void dump_portinfo(void *pi, int pisize, int tabs);
> +void dump_portinfo(void *pi, int tabs);
>  
>  /**
>   * Some common command line parsing
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index 5ec0167..3ebdbb9 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -853,7 +853,7 @@ int snprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
>  	return ret;
>  }
>  
> -void dump_portinfo(void *pi, int pisize, int tabs)
> +void dump_portinfo(void *pi, int tabs)
>  {
>  	int field, i;
>  	char val[64];
> diff --git a/src/saquery.c b/src/saquery.c
> index cc8d8dc..bd70b7b 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -304,7 +304,7 @@ static void dump_one_portinfo_record(void *data, struct query_params *p)
>  	       "\t\tOptions.................0x%x\n"
>  	       "\tPortInfo dump:\n",
>  	       cl_ntoh16(pir->lid), pir->port_num, pir->options);
> -	dump_portinfo(pi, sizeof(*pi), 2);
> +	dump_portinfo(pi, 2);
>  }
>  
>  static void dump_one_mcmember_record(void *data, struct query_params *p)
> diff --git a/src/smpquery.c b/src/smpquery.c
> index 187ef61..2bd7132 100644
> --- a/src/smpquery.c
> +++ b/src/smpquery.c
> @@ -161,7 +161,7 @@ static char *port_info(ib_portid_t * dest, char **argv, int argc)
>  		return "port info query failed";
>  
>  	printf("# Port info: %s port %d\n", portid2str(dest), orig_portnum);
> -	dump_portinfo(data, sizeof data, 0);
> +	dump_portinfo(data, 0);
>  	return 0;
>  }
>  
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
