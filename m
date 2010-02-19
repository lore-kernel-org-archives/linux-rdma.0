From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: how to force opensmd to recalculate all paths?
Date: Fri, 19 Feb 2010 18:15:12 -0500
Message-ID: <f0e08f231002191515r146a80b2u5beab69b551e1097@mail.gmail.com>
References: <20100219114252.4060E3D1821@f53.poczta.interia.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100219114252.4060E3D1821-+mlwwcjWEkSOitzWlErfBcT2TbGLZofU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kovlensky-khu2bkKidpXVItvQsEIGlw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/18/10, kovlensky-khu2bkKidpXVItvQsEIGlw@public.gmane.org <kovlensky-khu2bkKidpXVItvQsEIGlw@public.gmane.org> wrote:
> Hi,
>
> My case is simple - opensm does not recalculate paths unless necessary,
> i.e. one of physical links on the way disappears. I just introduced
> significant topology changes and need opensm to take them into
> consideration. New links were added, a lot of them. Is there any way of
> telling opensm to recalculate all paths? At the moment all new links are
> happily ignored and i can find no way of doing that live.

That shouldn't be the case. OpenSM should do this on any
addition/subtraction of a link depending on the sweep_on_trap option.

> My vendor has bad habit of asking me to add ib link here and there to
> nullify bottleneck identified and, well, while all new paths are up, I can
> find no way of rebalancing paths, so they stay unused.
>
> I'm running OFED-1.3.2-20090119-0501, so all ideas for this version or a
> newer one are welcome.

Have you tried issuing SIGHUP ?  As Ira wrote, when opensm receives a
HUP signal, it should start a new heavy sweep as if  a trap was
received or a topology change was found. As Al wrote, the other
alternative is if you are using the console to resweep heavy.

Also, a newer OpenSM might help (not sure). There has been discussion
of a race in this area but it's unclear whether that's what you are
experiencing.

-- Hal

> Regards,
>
> kovlensky
>
>
> ----------------------------------------------------------------------
> Szybkie i niedrogie... Tylko dla mezczyzn!
> Sprawdz >>> http://link.interia.pl/f25a7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
