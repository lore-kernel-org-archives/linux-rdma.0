From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Fix command line parsing bug in
 ibccconfig, ibccquery, saquery, and smpquery.
Date: Tue, 24 Jul 2012 10:32:08 -0700
Message-ID: <20120724103208.fb53cd7d84da781e5bbf9939@llnl.gov>
References: <1343087133.18615.160.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343087133.18615.160.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Jul 2012 16:45:33 -0700
Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:

> Ensure user's inputted operation directly matches an operation name or
> operation alias.  Do not base it on the length of the input, which can
> lead to conflicts with operation selection.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Thanks, applied,

Ira

> ---
>  src/ibccconfig.c |    5 ++---
>  src/ibccquery.c  |    5 ++---
>  src/saquery.c    |    5 ++---
>  src/smpquery.c   |    5 ++---
>  4 files changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/src/ibccconfig.c b/src/ibccconfig.c
> index c81b7fa..a2572d0 100644
> --- a/src/ibccconfig.c
> +++ b/src/ibccconfig.c
> @@ -561,10 +561,9 @@ static char *congestion_control_table(ib_portid_t * dest, char **argv, int argc)
>  static op_fn_t *match_op(char *name)
>  {
>  	const match_rec_t *r;
> -	unsigned len = strlen(name);
>  	for (r = match_tbl; r->name; r++)
> -		if (!strncasecmp(r->name, name, len) ||
> -		    (r->alias && !strncasecmp(r->alias, name, len)))
> +		if (!strcasecmp(r->name, name) ||
> +		    (r->alias && !strcasecmp(r->alias, name)))
>  			return r->fn;
>  	return NULL;
>  }
> diff --git a/src/ibccquery.c b/src/ibccquery.c
> index cf8b35a..5f9cf33 100644
> --- a/src/ibccquery.c
> +++ b/src/ibccquery.c
> @@ -347,10 +347,9 @@ static char *timestamp_dump(ib_portid_t * dest, char **argv, int argc)
>  static op_fn_t *match_op(char *name)
>  {
>  	const match_rec_t *r;
> -	unsigned len = strlen(name);
>  	for (r = match_tbl; r->name; r++)
> -		if (!strncasecmp(r->name, name, len) ||
> -		    (r->alias && !strncasecmp(r->alias, name, len)))
> +		if (!strcasecmp(r->name, name) ||
> +		    (r->alias && !strcasecmp(r->alias, name)))
>  			return r->fn;
>  	return NULL;
>  }
> diff --git a/src/saquery.c b/src/saquery.c
> index e5fdb25..7c5f2cf 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -1327,11 +1327,10 @@ static const struct query_cmd query_cmds[] = {
>  static const struct query_cmd *find_query(const char *name)
>  {
>  	const struct query_cmd *q;
> -	unsigned len = strlen(name);
>  
>  	for (q = query_cmds; q->name; q++)
> -		if (!strncasecmp(name, q->name, len) ||
> -		    (q->alias && !strncasecmp(name, q->alias, len)))
> +		if (!strcasecmp(name, q->name) ||
> +		    (q->alias && !strcasecmp(name, q->alias)))
>  			return q;
>  
>  	return NULL;
> diff --git a/src/smpquery.c b/src/smpquery.c
> index cecfa68..6468f23 100644
> --- a/src/smpquery.c
> +++ b/src/smpquery.c
> @@ -401,10 +401,9 @@ static char *guid_info(ib_portid_t * dest, char **argv, int argc)
>  static op_fn_t *match_op(char *name)
>  {
>  	const match_rec_t *r;
> -	unsigned len = strlen(name);
>  	for (r = match_tbl; r->name; r++)
> -		if (!strncasecmp(r->name, name, len) ||
> -		    (r->alias && !strncasecmp(r->alias, name, len)))
> +		if (!strcasecmp(r->name, name) ||
> +		    (r->alias && !strcasecmp(r->alias, name)))
>  			return r->fn;
>  	return NULL;
>  }
> -- 
> 1.7.1
> 
> 
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
