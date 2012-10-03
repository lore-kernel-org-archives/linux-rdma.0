From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: Tree for Oct 2 (ipoib_netlink.c)
Date: Wed, 3 Oct 2012 06:55:12 +0200
Message-ID: <CAJZOPZLgGMnK0eKT9RR+ZYMndy4bDZfxOUq6o3mj8+3_BoBfSQ@mail.gmail.com>
References: <10635.1349221831@neuling.org>
	<1349238780-27850-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349238780-27850-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 3, 2012 at 6:33 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>
> I'll be sending the following to Linus shortly:
>
> [PATCH] IPoIB: Fix build with CONFIG_INFINIBAND_IPOIB_CM=n
>
> With the new netlink support in commit 862096a8bbf8 ("IB/ipoib: Add more
> rtnl_link_ops callbacks") we need ipoib_set_mode() to be available even
> if connected mode isn't built.  Move the function from ipoib_cm.c to
> ipoib_main.c (and make a few CM-related macros available unconditonally).
>
> This fixes the build error
>
>     drivers/built-in.o: In function 'ipoib_changelink':
>     ipoib_netlink.c:(.text+0x6a5fc9): undefined reference to 'ipoib_set_mode'
>     ipoib_netlink.c:(.text+0x6a5fe3): undefined reference to 'ipoib_set_mode'
>
> when CONFIG_INFINIBAND_IPOIB_CM isn't set.
>
> Reported-by: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>


Hi Roland,

Thanks for quickly covering on me here, I'll make sure to deeply test
my patches with different config options next time/s

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
