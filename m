From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/22] IB/iser: Remove dead code in fmr_pool alloc/free
Date: Thu, 30 Jul 2015 16:52:13 +0300
Message-ID: <CAJ3xEMjKzXZ8DYdhXbZyscPCFZ6VJ80yXHRxoYiqqyKLgdd=NA@mail.gmail.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
	<1438243595-32288-12-git-send-email-sagig@mellanox.com>
	<CAJ3xEMh7H4+hUfV8qUr5wTsV02YG0vXTPGWLR=KKHeBMxA-zYA@mail.gmail.com>
	<55BA1736.2010204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BA1736.2010204-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 3:23 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Today, iser is not usable with no FRWR and no FMR support. (it once was
> when we bounced to higher-order allocations but we don't do that
> anymore). Memory registration is a requirement support for iser today.

OK, sure, we now have FRWR support, back then we didn't
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
