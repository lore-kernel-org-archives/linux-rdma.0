From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 2/3] ib/iser: remove buggy back-pointer setting
Date: Wed, 05 May 2010 12:50:44 -0500
Message-ID: <4BE1AFF4.30600@cs.wisc.edu>
References: <Pine.LNX.4.64.1005051726110.29957@zuben.voltaire.com> <Pine.LNX.4.64.1005051730170.29957@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1005051730170.29957-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/05/2010 09:30 AM, Or Gerlitz wrote:
> iscsi connection object life cycle includes binding and unbinding
> (conn_stop) to/from the iscsi transport connection object. Since
> iscsi connection objects are recycled, on the time the transport
> connection (e.g iser's ib connection) is released it is illegal
> to touch the iscsi connection tied to the transport back-pointer, as
> it may already point to a different transport connection.
>
> Signed-off-by: Or Gerlitz<ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>
> ---
>   drivers/infiniband/ulp/iser/iser_verbs.c |    2 --
>   1 file changed, 2 deletions(-)
>
> Index: linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
> ===================================================================
> --- linux-2.6.34-rc6.orig/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ linux-2.6.34-rc6/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -346,8 +346,6 @@ static void iser_conn_release(struct ise
>   	/* on EVENT_ADDR_ERROR there's no device yet for this conn */
>   	if (device != NULL)
>   		iser_device_try_release(device);
> -	if (ib_conn->iser_conn)
> -		ib_conn->iser_conn->ib_conn = NULL;
>   	iscsi_destroy_endpoint(ib_conn->ep);
>   }
>

I agree on it being a bug, but do you remember why that was added to 
iscsi_iser_conn_destroy originally? I later moved it to 
iser_conn_release in 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b40977d95fb3a1898ace6a7d97e4ed1a33a440a4) 
but I think Erez had added that null and some checks for it being null 
for a specific bug.

I am not 100% sure. Look in the git logs to make sure. I will check them 
too when I get some more time.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
