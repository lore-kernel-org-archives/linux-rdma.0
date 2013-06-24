From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V1 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Mon, 24 Jun 2013 14:10:53 -0700
Message-ID: <CAL1RGDUqKNkGCeW6pguEeWR8i7-CaLOq2Kria8vFkyY4H4fmgw@mail.gmail.com>
References: <1370950973-11716-1-git-send-email-ogerlitz@mellanox.com> <1370950973-11716-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370950973-11716-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 11, 2013 at 4:42 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> +struct ib_kern_flow {
> +       struct ib_device  *device;
> +       struct ib_uobject *uobject;
> +       void              *flow_context;
> +};

I don't think it makes sense to put a structure with kernel pointers
in it into an include file under include/uapi.  For one thing the size
of pointers depends on whether userspace is 32-bit or 64-bit (but of
course there are many other reasons why this will break).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
