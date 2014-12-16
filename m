From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH]RDMA/cma: fix first byte overwritten for AF_IB
Date: Tue, 16 Dec 2014 15:55:38 +0100
Message-ID: <CAMGffEno_VWBKkfCxggu9n94qBWULH=dj3AHyvWN_SH2CH8wBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

commit 56e620c453f2588cfc9898a41b110477f6417a5d
Author: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date:   Tue Dec 16 15:44:17 2014 +0100

    RDMA/cma: fix first byte overwritten for AF_IB

    If user attach private data for AF_IB, the first byte will
    be overwritten, because we always set the cma version no matter
    family is AF_IB, so move the version set inside if condition.

    Reported-by: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
    Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cm=
a.c
index d570030..22a22e2 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2618,10 +2618,10 @@ static int cma_format_hdr(void *hdr, struct
rdma_id_private *id_priv)
        struct cma_hdr *cma_hdr;

        cma_hdr =3D hdr;
-       cma_hdr->cma_version =3D CMA_VERSION;
        if (cma_family(id_priv) =3D=3D AF_INET) {
                struct sockaddr_in *src4, *dst4;

+               cma_hdr->cma_version =3D CMA_VERSION;
                src4 =3D (struct sockaddr_in *) cma_src_addr(id_priv);
                dst4 =3D (struct sockaddr_in *) cma_dst_addr(id_priv);

@@ -2632,6 +2632,7 @@ static int cma_format_hdr(void *hdr, struct
rdma_id_private *id_priv)
        } else if (cma_family(id_priv) =3D=3D AF_INET6) {
                struct sockaddr_in6 *src6, *dst6;

+               cma_hdr->cma_version =3D CMA_VERSION;
                src6 =3D (struct sockaddr_in6 *) cma_src_addr(id_priv);
                dst6 =3D (struct sockaddr_in6 *) cma_dst_addr(id_priv);



--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin
Tel: +49 30 5770083-42
=46ax: +49 30 5770085-98
Email: jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: http://www.profitbricks.de

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B.
Gesch=C3=A4ftsf=C3=BChrer: Andreas Gauger, Achim Weiss.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
