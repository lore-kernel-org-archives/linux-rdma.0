From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH/RFC] RDMA/iwpm: Fix uninitialized error code in iwpm_send_mapinfo()
Date: Wed, 29 Nov 2017 09:24:42 +0100
Message-ID: <CAMuHMdVMJAm3i65kjfo6ut6bMWsoi7pzGL1n2q6XZNY__=N4Jg@mail.gmail.com>
References: <1510827964-11100-1-git-send-email-geert@linux-m68k.org>
 <20171128230834.GH21325@ziepe.ca> <CAMuHMdUEcHMFML71E-8AOSpCrjComvJiij+dM9H=j7atnBsiZw@mail.gmail.com>
 <CAK8P3a2chJ_kSAX1R=mBoLCbo+4d60_y6wW-pdzxwxv=rCuC9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK8P3a2chJ_kSAX1R=mBoLCbo+4d60_y6wW-pdzxwxv=rCuC9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Arnd,

On Wed, Nov 29, 2017 at 9:20 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> On Wed, Nov 29, 2017 at 9:10 AM, Geert Uytterhoeven
> <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org> wrote:
>> On Wed, Nov 29, 2017 at 12:08 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>>> On Thu, Nov 16, 2017 at 11:26:04AM +0100, Geert Uytterhoeven wrote:
>>>> With gcc-4.1.2:
>>>>
>>>>     drivers/infiniband/core/iwpm_util.c: In function =E2=80=98iwpm_sen=
d_mapinfo=E2=80=99:
>>>>     drivers/infiniband/core/iwpm_util.c:647: warning: =E2=80=98ret=E2=
=80=99 may be used uninitialized in this function
>>>>
>>>> Indeed, if nl_client is not found in any of the scanned has buckets, r=
et
>>>> will be used uninitialized.
>>>>
>>>> Preinitialize ret to zero to fix this.
>>>
>>> Did we come to a conclusion if we should apply this to the RMDA tree? T=
he
>>> patch was marked RFC..
>>
>> So far no one commented on what's the correct behavior in case of failur=
e,
>> which was the actual reason for the RFC.
>
> As I said above, I think initializing to -EINVAL would be better than 0 h=
ere,

Sorry, I misread your comment as the -EINVAL being part of another function=
.

> but initializing 'ret' at declaration time is appropriate here (though
> I normally
> try to avoid doing so, see https://rusty.ozlabs.org/?p=3D232)

+1, but if loops are involved, you have not much choice.
I could move the preinitialization to just before the loop?
Would you like that?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
