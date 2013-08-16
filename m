From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH libibverbs] XRC - Sample application issues
Date: Fri, 16 Aug 2013 15:10:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA64F6@ORSMSX109.amr.corp.intel.com>
References: <1375974336-26314-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375974336-26314-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Sternberg, Jay E" <jay.e.sternberg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> @@ -884,6 +884,13 @@ int main(int argc, char *argv[])
>  	if (ctx.use_event)
>  		ibv_ack_cq_events(ctx.recv_cq, num_cq_events);
> 
> +	/* Process should wait before closing its resources to make sure
> +	  * latest daemon's response sent via its target QP destined to an XSRQ
> +	  * created by another client won't be lost.
> +	  * Failure to do so will cause the client to wait for that sent message
> forever.
> +	  * See comment on pp_post_send.
> +	*/
> +	sleep(1);

I dislike adding sleep calls into code.  Isn't there a more robust way to handle this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
