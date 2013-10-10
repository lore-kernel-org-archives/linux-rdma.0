From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/core: temporarily disable create_flow/destroy_flow
 uverbs
Date: Thu, 10 Oct 2013 12:30:35 +0300
Message-ID: <525673BB.7020900@mellanox.com>
References: <1381396255-13005-1-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381396255-13005-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/10/2013 12:10, Yann Droneaud wrote:
> create_flow/destroy_flow uverbs are under review and should
> be considered too experimental at this point.
>
> To not expose to userspace such experimental feature,
> the data structure and code is temporarily disabled for v3.12.
>
> The feature will be enabled after proper cleanup for v3.13.

NAK

The patches were on the list from April and went through review of Sean, 
Jason, Roland, Shawn and others.

You started your review few months after the point in time we submitted 
them, and after they were accepted.

We were very happy **and**  responsive for your feedback -- Matan sent 
patch on Sep 22nd to fix few issues you pointed on.

If you have more point fixes, we're **before** rc5 and 2-3 patches that 
fix things can get it, Matan review your prev
patchset which contained four patches and acked three of them.

So you now need to re-prepare a smaller patch set advocate for Roland to 
pick it up.


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
