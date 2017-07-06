From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/mlx5: Respect mlx5_core reserved GIDs
Date: Thu, 6 Jul 2017 15:16:17 +0300
Message-ID: <20170706121617.bpomxvwrljfjwl25@mwanda>
References: <20170706093923.4azhres5ymy4vefp@mwanda>
 <20170706103811.GY1528@mtr-leonro.local>
 <20170706111057.vdhnx7agww7j3pcv@mwanda>
 <AM4PR0501MB194030AAB6D5D15585C416AADBD50@AM4PR0501MB1940.eurprd05.prod.outlook.com>
 <20170706114733.GZ1528@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170706114733.GZ1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ilan Tayari <ilant-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 06, 2017 at 02:47:33PM +0300, Leon Romanovsky wrote:
> 
> It works by chance, assuming that "->raw" will be always first member is
> not a good strategy, so I agree with Dan. It is NULL dereferencing.
> 

How these false positives normally look is like this:

	struct whatever *p = foo->bar;

	if (!foo)
		return -EINVAL;

It looks like a dereference but isn't.  And in this case it doesn't
matter if it's the first member or not.

Anyway, just from a correctness point of view it's better to not print
false positives.

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
