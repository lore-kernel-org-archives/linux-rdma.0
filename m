From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH fixes/for-3.6 2/3] IB/ipoib: Fix AB-BA deadlock when
 deleting neighbours
Date: Wed, 12 Sep 2012 09:23:29 -0700
Message-ID: <CAL1RGDUGuEE-5X10j6Y0B8fkSH1a1=NDARFYumwwmSjtE0WsJw@mail.gmail.com>
References: <1346253275-12347-1-git-send-email-ogerlitz@mellanox.com> <1346253275-12347-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346253275-12347-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

thanks, applied this and 1/3

On Wed, Aug 29, 2012 at 8:14 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>                 while ((neigh = rcu_dereference_protected(*np,
> -                                                         lockdep_is_held(&ntbl->rwlock))) != NULL) {
> +                                      lockdep_is_held(&priv->lock))) != NULL) {

please try to avoid messing up indentation when doing fixes like this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
