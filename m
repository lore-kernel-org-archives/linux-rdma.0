From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH][TRIVIAL] infiniband-diags: clean up exclude arguments
 to ibdiag_process_opts()
Date: Wed, 30 May 2012 11:01:13 -0700
Message-ID: <20120530110113.72f57906.weiny2@llnl.gov>
References: <1338397742-12366-1-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338397742-12366-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 30 May 2012 10:09:02 -0700
Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org> wrote:

> Alphabetize for standardization and greater clarity

Good idea, thanks applied,
Ira

> 
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> ---
>  src/ibcacheedit.c   |    2 +-
>  src/iblinkinfo.c    |    2 +-
>  src/ibnetdiscover.c |    2 +-
>  src/ibqueryerrors.c |    2 +-
>  src/ibsendtrap.c    |    2 +-
>  src/ibstat.c        |    2 +-
>  src/saquery.c       |    2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/src/ibcacheedit.c b/src/ibcacheedit.c
> index 28b8b21..f9e7dc9 100644
> --- a/src/ibcacheedit.c
> +++ b/src/ibcacheedit.c
> @@ -269,7 +269,7 @@ int main(int argc, char **argv)
>  	};
>  	char *usage_args = "<orig.cache> <new.cache>";
>  
> -	ibdiag_process_opts(argc, argv, NULL, "edCPDLGtsv",
> +	ibdiag_process_opts(argc, argv, NULL, "CDdeGLPstv",
>  			    opts, process_opt, usage_args,
>  			    NULL);
>  
> diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
> index 36aa6d1..a817920 100644
> --- a/src/iblinkinfo.c
> +++ b/src/iblinkinfo.c
> @@ -619,7 +619,7 @@ int main(int argc, char **argv)
>  	};
>  	char usage_args[] = "";
>  
> -	ibdiag_process_opts(argc, argv, &config, "SDandlpgRGL", opts,
> +	ibdiag_process_opts(argc, argv, &config, "aDdGgLlnpRS", opts,
>  			    process_opt, usage_args, NULL);
>  
>  	argc -= optind;
> diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
> index 8ec9421..4748be9 100644
> --- a/src/ibnetdiscover.c
> +++ b/src/ibnetdiscover.c
> @@ -1074,7 +1074,7 @@ int main(int argc, char **argv)
>  	};
>  	char usage_args[] = "[topology-file]";
>  
> -	ibdiag_process_opts(argc, argv, &config, "sGDL", opts, process_opt,
> +	ibdiag_process_opts(argc, argv, &config, "DGLs", opts, process_opt,
>  			    usage_args, NULL);
>  
>  	f = stdout;
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 4fec240..eb57418 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -901,7 +901,7 @@ int main(int argc, char **argv)
>  	char usage_args[] = "";
>  
>  	memset(suppressed_fields, 0, sizeof suppressed_fields);
> -	ibdiag_process_opts(argc, argv, &config, "scnSrRDGL", opts, process_opt,
> +	ibdiag_process_opts(argc, argv, &config, "cDGLnRrSs", opts, process_opt,
>  			    usage_args, NULL);
>  
>  	argc -= optind;
> diff --git a/src/ibsendtrap.c b/src/ibsendtrap.c
> index 2d63e35..f98d9cf 100644
> --- a/src/ibsendtrap.c
> +++ b/src/ibsendtrap.c
> @@ -192,7 +192,7 @@ int main(int argc, char **argv)
>  	snprintf(usage_args + n, sizeof(usage_args) - n,
>  		 "\n  default behavior is to send \"%s\"", traps[0].trap_name);
>  
> -	ibdiag_process_opts(argc, argv, NULL, "DLG", NULL, NULL,
> +	ibdiag_process_opts(argc, argv, NULL, "DGL", NULL, NULL,
>  			    usage_args, NULL);
>  
>  	argc -= optind;
> diff --git a/src/ibstat.c b/src/ibstat.c
> index f953cf4..3d971ed 100644
> --- a/src/ibstat.c
> +++ b/src/ibstat.c
> @@ -292,7 +292,7 @@ int main(int argc, char *argv[])
>  		NULL
>  	};
>  
> -	ibdiag_process_opts(argc, argv, NULL, "sDGLCPte", opts, process_opt,
> +	ibdiag_process_opts(argc, argv, NULL, "CDeGLPst", opts, process_opt,
>  			    usage_args, usage_examples);
>  
>  	argc -= optind;
> diff --git a/src/saquery.c b/src/saquery.c
> index e5fdb25..1e730a4 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -1638,7 +1638,7 @@ int main(int argc, char **argv)
>  	q = NULL;
>  	ibd_timeout = DEFAULT_SA_TIMEOUT_MS;
>  
> -	ibdiag_process_opts(argc, argv, &params, "DLGs", opts, process_opt,
> +	ibdiag_process_opts(argc, argv, &params, "DGLs", opts, process_opt,
>  			    usage_args, NULL);
>  
>  	argc -= optind;
> -- 
> 1.7.9.2
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
