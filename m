From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Intermitted "Failed to obtain HW semaphore, aborting" error
Date: Sun, 3 Feb 2013 22:27:40 +0200
Message-ID: <CAJZOPZLXB3-vPrJ34nZhOx3nfBEV2zZ-nm1ovYro3s_bQLskgw@mail.gmail.com>
References: <510DF227.30307@vt.edu>
	<510E0D9B.9020907@mellanox.com>
	<510E7FB6.8050603@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510E7FB6.8050603-PjAqaU27lzQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 3, 2013 at 5:18 PM, Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org> wrote:
[...]
> I am unable to run ibv_devinfo on the bad node, here is an output from a
> good node
> $ ibv_devinfo
> hca_id: mlx4_0
>         transport:                      InfiniBand (0)
>         fw_ver:                         2.10.2370
[...]

should be step in the right direction if you upgrade your firmware to
the latest GA, 2.11.0500 avail on the Mellanox site.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
