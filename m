From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: Re: RDMA tutorial feedback
Date: Wed, 18 Aug 2010 14:35:17 +0200 (CEST)
Message-ID: <6150416.1282134917725.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <AANLkTimDVeCu1ZTZTr1TvZF2vkSQ0keDVs4eheriywNN@mail.gmail.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9708393@orsmsx501.amr.corp.intel.com> <AANLkTin49UW3==170jBuhMJvJrcxFYGvUCF8-Xyqmz3J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin49UW3==170jBuhMJvJrcxFYGvUCF8-Xyqmz3J-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tarick Bedeir <tarick-LDovhz+uhNHQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Aug 16, 2010 06:39 PM, Tarick Bedeir <tarick-LDovhz+uhNHQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, Aug 16, 2010 at 1:00 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> wrote:
> >> When I started working on an IB-aware app last year, I couldn't
> >> find
> >> much in the way of an RDMA/verbs/IB tutorial on the web. =C2=A0Thi=
s
> >> doesn't
> >> seem to have changed, so I put together a few posts on my blog tha=
t
> >> I
> >> hope will be of use to the next guy who's got to start from
> >> scratch:
> >>
> >> http://thegeekinthecorner.wordpress.com/
> >>
> >> I'm very interested in the community's feedback.
> >
> > I think having something like this is great.
> >
> > Since you've started this work, additional APIs and functionality
> > have been added to the librdmacm which are intended to simplify
> > connection establishment. =C2=A0Notable changes include the additio=
n of
> > an rdma_getaddrinfo() call and support for synchronous operation.
> > =C2=A0If you download the latest librdmacm package from the OFA sit=
e, you
> > can take a look at the new samples, rdma_server and rdma_client,
> > which show how to make use of the new functionality.
> >
> > A few wrapper functions around libibverbs calls were also added, bu=
t
> > as those are inline calls, their use is limited.
>=20
> That's good to know -- I'll work on a post describing synchronous
> operation and rdma_getaddrinfo().
>=20
> Thank you for the feedback!
>=20
> Tarick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

Hi Tarick,

I'm interesting in your documentation.
It will be precious in my RDMA test.

Keep in touch.
Thank you very much.
Best regards,
Andrea

Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 -I-35020 - Legnaro (PD)- ITALIA
Office: E-101
Tel: +39 049 8068346
=46ax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
Cell: +39 3488245552			=09

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
