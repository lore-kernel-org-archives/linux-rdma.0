From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 4/4] IB/ipoib: Support SendOnlyFullMember MCG
 for SendOnly join
Date: Mon, 2 May 2016 18:11:30 +0300
Message-ID: <CAJ3xEMjRQjakr+j419oiFPkrk=1KuwKxkznp_YKiwYcB2nNV4Q@mail.gmail.com>
References: <1462194141-8902-1-git-send-email-erezsh@mellanox.com>
	<1462194141-8902-5-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462194141-8902-5-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 2, 2016 at 4:02 PM, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -117,6 +117,8 @@ int ipoib_open(struct net_device *dev)
>
>         set_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
>
> +       priv->sm_fullmember_sendonly_support = false;
> +

isn't priv zeroed on allocation? this is typically the case in
networking drivers.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
