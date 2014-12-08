From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH ] mlx4_core: Verify that port types are the same only if
 DPDP supported
Date: Mon, 8 Dec 2014 08:29:01 +0200
Message-ID: <20141208062900.GA3121@yuval-lab>
References: <1417891599-11860-1-git-send-email-yuval.shaia@oracle.com>
 <CAL1RGDWOh=Jmno-dsFr-4-jue+21VuEkEmYx3DFxhU615LuMzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDWOh=Jmno-dsFr-4-jue+21VuEkEmYx3DFxhU615LuMzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 07, 2014 at 09:24:26PM -0800, Roland Dreier wrote:
> On Sat, Dec 6, 2014 at 10:46 AM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > -       for (i = 0; i < dev->caps.num_ports - 1; i++) {
> > -               if (port_type[i] != port_type[i + 1]) {
> > -                       if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP)) {
> > +       if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP))
> > +               for (i = 0; i < dev->caps.num_ports - 1; i++) {
> > +                       if (port_type[i] != port_type[i + 1]) {
> 
> I'm struggling to understand what this patch does.  It sure looks like
> a NOP to me.
Move check out of the loop just to make the code more nice & readable.
> 
> At least you need to resend it with a changelog that explains why we
> want this change.
Will do.
> 
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
