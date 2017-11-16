From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH/RFC] RDMA/iwpm: Fix uninitialized error code in iwpm_send_mapinfo()
Date: Thu, 16 Nov 2017 13:03:53 +0100
Message-ID: <CAMuHMdWA5cge8HomTuZ960rGCKueFmG6_KX4VCkY0XGWZfZZ2g@mail.gmail.com>
References: <1510827964-11100-1-git-send-email-geert@linux-m68k.org>
 <CAK8P3a2D6dnQELKww5V-=mNAzrD-XQoWtNTXCmgMtsnFnujq5A@mail.gmail.com>
 <CAMuHMdXcvBDGvQ0K38POmarUY65ntTw5-xh9s=Sk4ZH+98MrhQ@mail.gmail.com> <CAK8P3a38=xM+NSxuc+5gXXe0vWGxf6+Z6Av01YFiFWyseT1_ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK8P3a38=xM+NSxuc+5gXXe0vWGxf6+Z6Av01YFiFWyseT1_ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Arnd,

On Thu, Nov 16, 2017 at 12:32 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> On Thu, Nov 16, 2017 at 12:05 PM, Geert Uytterhoeven
> <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
> I see my problem now, my randconfig test series has a patch I never sent
> out, see https://pastebin.com/ZJDHP7g4 ;-)

I was already wondering why I suddenly started seeing many non-false
positives reaching Linus' tree ;-)
Lately you've been catching all of them in -next, before they had a chance
to appear in upstream.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
