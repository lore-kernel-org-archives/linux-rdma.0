From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib-diags: Add cast to fix build on windows
Date: Thu, 22 Sep 2011 20:36:22 +0200
Message-ID: <CAO+b5-qaSWm4RbhJ4Sk85Kysp2pJYOq6GmYJ=2oJhnL_Q7sa7g@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E674F0@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E674F0-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ira Weiny (weiny2-i2BcT+NCU+M@public.gmane.org)" <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 22, 2011 at 8:29 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> =A0libibnetdisc/src/ibnetdisc.c | =A0 =A02 +-
> =A0src/ibportstate.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++--
> =A02 files changed, 3 insertions(+), 3 deletions(-)
> =A0mode change 100644 =3D> 100755 libibnetdisc/src/ibnetdisc.c
> =A0mode change 100644 =3D> 100755 src/ibportstate.c

A minor nit: is this mode change really necessary ? (I know Visual
Studio does enable the execute bit without asking.)

> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdis=
c.c
> index 86210eb..c93e7ad
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -201,7 +201,7 @@ static void debug_port(ib_portid_t * portid, ibnd=
_port_t * port)
>
> =A0static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
> =A0{
> - =A0 =A0 =A0 uint16_t devid =3D mad_get_field(port->node->info, 0, I=
B_NODE_DEVID_F);
> + =A0 =A0 =A0 uint16_t devid =3D (uint16_t) mad_get_field(port->node-=
>info, 0, IB_NODE_DEVID_F);

Has it been considered to disable the MSVC warnings about possible
truncation instead of inserting a cast ? MSVC generates such warnings
while gcc does not.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
