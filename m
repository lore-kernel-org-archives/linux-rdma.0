From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH ] mlx4_core: Verify that port types are the same only if
 DPDP supported
Date: Sun, 7 Dec 2014 21:24:26 -0800
Message-ID: <CAL1RGDWOh=Jmno-dsFr-4-jue+21VuEkEmYx3DFxhU615LuMzw@mail.gmail.com>
References: <1417891599-11860-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417891599-11860-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Dec 6, 2014 at 10:46 AM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> -       for (i = 0; i < dev->caps.num_ports - 1; i++) {
> -               if (port_type[i] != port_type[i + 1]) {
> -                       if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP)) {
> +       if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP))
> +               for (i = 0; i < dev->caps.num_ports - 1; i++) {
> +                       if (port_type[i] != port_type[i + 1]) {

I'm struggling to understand what this patch does.  It sure looks like
a NOP to me.

At least you need to resend it with a changelog that explains why we
want this change.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
