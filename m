From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/mlx5: Respect mlx5_core reserved GIDs
Date: Thu, 6 Jul 2017 14:44:59 +0300
Message-ID: <20170706114459.tvbzopzpn634r7gv@mwanda>
References: <20170706093923.4azhres5ymy4vefp@mwanda>
 <20170706103811.GY1528@mtr-leonro.local>
 <20170706111057.vdhnx7agww7j3pcv@mwanda>
 <AM4PR0501MB194030AAB6D5D15585C416AADBD50@AM4PR0501MB1940.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AM4PR0501MB194030AAB6D5D15585C416AADBD50-dp/nxUn679gfNUYDR5dMTsDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilan Tayari <ilant-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ah...  You're right, of course.  I've been meaning to fix those false
positives for a while.

The only problem is that how would I still catch the bug if ->raw wasn't
the first member...  I need to think about that some more...

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
