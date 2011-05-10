From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH V4 3/6] IB Core: Run Netlink
Date: Tue, 10 May 2011 12:28:21 -0700
Message-ID: <BANLkTim_zvRjOuTvNdC2fGWMfYptYrVTTA@mail.gmail.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com> <1294068834-17778-4-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294068834-17778-4-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: nirmu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +#include <net/ib_netlink.h>

Was the latest version of this actually tested?  Patch 1 put this header in
<rdma/ib_netlink.h> as far as I can see, so I don't see how this could
even build.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
