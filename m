From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] prevent CVE-2012-2372 rds-ping causes kernel panic
Date: Mon, 22 Oct 2012 20:25:48 +0200
Message-ID: <50858FAC.10509@acm.org>
References: <20121022181253.GA13736@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121022181253.GA13736-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/22/12 20:12, Jay Fenlason wrote:
> If you use rds-ping of the local IP address of some Infiniband HCAs
> (QLogic, possibly others) the machine will panic with a BUG_ON due to
> an overly restrictive check.  Loosen the restriction a bit
>
> This should have gotten sent a while ago (it was first noticed in
>   https://bugzilla.redhat.com/show_bug.cgi?id=803936
> and patched in kernel-2.6.32-275.el6) but I got confused about its
> embargo status and lost it.
>
> Signed-off-by: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
> index e590949..7920c85 100644
> --- a/net/rds/ib_send.c
> +++ b/net/rds/ib_send.c
> @@ -544,7 +544,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
>   	int flow_controlled = 0;
>   	int nr_sig = 0;
>
> -	BUG_ON(off % RDS_FRAG_SIZE);
> +	BUG_ON(!conn->c_loopback && off % RDS_FRAG_SIZE);
>   	BUG_ON(hdr_off != 0 && hdr_off != sizeof(struct rds_header));
>
>   	/* Do not send cong updates to IB loopback */

Hello Jay,

The recommended approach for checking preconditions is to use 
WARN_ON_ONCE(), not BUG_ON(). Linus explained this last month in a 
message posted on the LKML (http://lkml.org/lkml/2012/9/27/461).

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
