From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 03/15 ibacm] acm.c: Cosmetic formatting change to acm
 log message
Date: Fri, 28 Jun 2013 01:48:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD37559@ORSMSX109.amr.corp.intel.com>
References: <51C43284.6010808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C43284.6010808-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/src/acm.c b/src/acm.c
> index e956b09..a124e93 100644
> --- a/src/acm.c
> +++ b/src/acm.c
> @@ -1277,7 +1277,7 @@ static void acm_process_acm_recv(struct acm_ep *ep,
> struct ibv_wc *wc, struct ac
>  	rec = (struct acm_resolve_rec *) mad->data;
>  	acm_format_name(2, log_data, sizeof log_data,
>  			rec->src_type, rec->src, sizeof rec->src);
> -	acm_log(2, "src  %s\n", log_data);
> +	acm_log(2, "src %s\n", log_data);
..
>  	acm_log(2, "dest %s\n", log_data);

The extra space after 'src' is intentional.  It's to line up the source and destination addresses, like this:

src  192.168...
dest 192.168...

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
