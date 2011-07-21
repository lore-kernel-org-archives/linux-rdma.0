From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/qib: defer hca error events to tasklet
Date: Thu, 21 Jul 2011 08:46:55 -0700
Message-ID: <CAL1RGDXSHs5hDC3JC5ozTa4gLzumMzRKQWNij_=aDk-3=hsUvg@mail.gmail.com>
References: <20110721132116.25683.74826.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110721132116.25683.74826.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +static ushort qib_krcvq01_no_msi;
> +module_param_named(krcvq01_no_msi, qib_krcvq01_no_msi, ushort, S_IRUGO);
> +MODULE_PARM_DESC(krcvq01_no_msi, "No MSI for kctx < 2");

First, the obvious question: is there really no better way to handle this
than to have yet another cryptically named module parameter for users
to try both ways?

Second, why can't this just be module_param() (why is _named needed?)?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
