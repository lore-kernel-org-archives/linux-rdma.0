From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2 3/5] ib-diags/saquery: Fix smkey handling
Date: Tue, 24 Apr 2012 10:17:28 -0400
Message-ID: <4F96B5F8.8070801@dev.mellanox.co.il>
References: <1335228837.17237.302.camel@auk75.llnl.gov> <1335229017-10677-1-git-send-email-foraker1@llnl.gov> <1335229017-10677-3-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335229017-10677-3-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, weiny2-i2BcT+NCU+M@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/23/2012 8:56 PM, Jim Foraker wrote:
> smkey is already defined as a global inside saquery.c, so remove
> broken support for passing it around as a function parameter
> 
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> ---
>  src/saquery.c |   59 ++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 30 deletions(-)
> 
> diff --git a/src/saquery.c b/src/saquery.c
> index e5fdb25..029228c 100644
> --- a/src/saquery.c
> +++ b/src/saquery.c
> @@ -85,7 +85,7 @@ struct query_cmd {
>  
>  static char *node_name_map_file = NULL;
>  static nn_map_t *node_name_map = NULL;
> -static uint64_t smkey = 1;
> +static uint64_t smkey = 0;

Why is the default for smkey being changed from 1 to 0 ? Note that even
though the name is smkey (due to the spec), it is really the default SA key.

-- Hal

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
