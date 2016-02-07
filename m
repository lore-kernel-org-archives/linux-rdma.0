From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: mlx5_core Issue
Date: Sun, 7 Feb 2016 10:52:21 +0200
Message-ID: <20160207085221.GB17225@leon.nu>
References: <CAHkw+Lc3h5-0Km6J5j7xOHa0d-5gx1RO_dBRXYLfgGoyKzHkoA@mail.gmail.com>
 <20160206153613.GB8584@leon.nu>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160206153613.GB8584-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marc Smith <marc.smith-FHhu8y7Kp0U@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Feb 06, 2016 at 05:36:13PM +0200, Leon Romanovsky wrote:
> > I'm using Linux 4.1.11 and trying to get Mellanox 100 Gb adapters
> > working. When loading 'mlx5_core'.

I assume that this accepted patch [1] will fix your issue.

[1] https://patchwork.kernel.org/patch/7929551/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
