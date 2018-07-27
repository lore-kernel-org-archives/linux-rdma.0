From: Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH] net/rds/Kconfig: RDS should depend on IPV6
Date: Fri, 27 Jul 2018 15:11:44 +0200
Message-ID: <CADYN=9+y5tzO8c1B7yiyTYTtt4jJT2hFc+6qtN=jFoqHbQje-g@mail.gmail.com>
References: <20180725222008.32186-1-anders.roxell@linaro.org> <68f68676-0d91-125f-5697-31cc459ab24e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <68f68676-0d91-125f-5697-31cc459ab24e@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: eric.dumazet@gmail.com
Cc: David Miller <davem@davemloft.net>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, ka-cheong.poon@oracle.com, Networking <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 27 Jul 2018 at 13:52, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 07/25/2018 03:20 PM, Anders Roxell wrote:
> > Build error, implicit declaration of function __inet6_ehashfn shows up
> > When RDS is enabled but not IPV6.
> > net/rds/connection.c: In function =E2=80=98rds_conn_bucket=E2=80=99:
> > net/rds/connection.c:67:9: error: implicit declaration of function =E2=
=80=98__inet6_ehashfn=E2=80=99; did you mean =E2=80=98__inet_ehashfn=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]
> >   hash =3D __inet6_ehashfn(lhash, 0, fhash, 0, rds_hash_secret);
> >          ^~~~~~~~~~~~~~~
> >          __inet_ehashfn
> >
> > Current code adds IPV6 as a depends on in config RDS.
> >
> > Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation =
to struct in6_addr")
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> > ---
> >  net/rds/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/rds/Kconfig b/net/rds/Kconfig
> > index 41f75563b54b..607128f10bcd 100644
> > --- a/net/rds/Kconfig
> > +++ b/net/rds/Kconfig
> > @@ -1,7 +1,7 @@
> >
> >  config RDS
> >       tristate "The RDS Protocol"
> > -     depends on INET
> > +     depends on INET && CONFIG_IPV6
>
> You probably meant :
>
>         depends on INET && IPV6

Hmm... Yes, I'll send out a new patch to fix it.

I'm sorry.

Cheers,
Anders

>
>
> >       ---help---
> >         The RDS (Reliable Datagram Sockets) protocol provides reliable,
> >         sequenced delivery of datagrams over Infiniband or TCP.
> >
