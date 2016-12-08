From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] cma: resolve to first active IB port
Date: Thu, 8 Dec 2016 17:47:26 +0100
Message-ID: <CAMGffEnBfUnvKFHOKDuzXopa6m63RBOmHRhpeZun-UddXGjzvg@mail.gmail.com>
References: <CAMGffE=mSpm+zuG9wo-GV0HT4-ewg34uvOKCUrPRC61ATjxyVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMGffE=mSpm+zuG9wo-GV0HT4-ewg34uvOKCUrPRC61ATjxyVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 6, 2016 at 12:16 PM, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> w=
rote:
> Hi Doug, Sean and Hal,
>
> We have problem when connect connection from second port with AF_IB,
> when first port is down.
> We will fail when resovle route.
>
> It turned out when resolve addr, in cma_resolve_ib_dev, we will choose
> the first port if subnet_prefix is the same, in our case we use
> default well known prefix.
>
> I proposal fix below to resolve to first acrive IB port:
> Note: I will attach another one for easily apply if the format mangled by=
 gmail.
> Patch created based on Linux 4.9-rc7.
>
> From b42e51deb8da3c1b596cb4332b6815e5ac8658a7 Mon Sep 17 00:00:00 2001
> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Date: Tue, 6 Dec 2016 09:01:04 +0100
> Subject: [PATCH] cma: resolve to first active ib_port
>
> When resolve addr if we don't give src addr, cma core will try to resolve=
 to
> ib device on itself, current logic is only check if it has same
> subnet_prefix, which is not enough if we use default well known gid,
> we should also check if port is active.
>
> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c
> index 2a6fc47..9e46b42 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -684,6 +684,8 @@ static int cma_resolve_ib_dev(struct
> rdma_id_private *id_priv)
>              for (i =3D 0; !ib_get_cached_gid(cur_dev->device, p, i,
>                                 &gid, NULL);
>                   i++) {
> +                struct ib_port_attr attr;
> +
>                  if (!memcmp(&gid, dgid, sizeof(gid))) {
>                      cma_dev =3D cur_dev;
>                      sgid =3D gid;
> @@ -692,7 +694,9 @@ static int cma_resolve_ib_dev(struct
> rdma_id_private *id_priv)
>                  }
>
>                  if (!cma_dev && (gid.global.subnet_prefix =3D=3D
> -                         dgid->global.subnet_prefix)) {
> +                    dgid->global.subnet_prefix) &&
> +                    (!ib_query_port(cur_dev->device, p, &attr) &&
> +                    attr.state =3D=3D IB_PORT_ACTIVE)) {
>                      cma_dev =3D cur_dev;
>                      sgid =3D gid;
>                      id_priv->id.port_num =3D p;
> --
> 2.7.4

ping?
--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
