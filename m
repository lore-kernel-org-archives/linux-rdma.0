From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: First byte of private_data transfered with rdma_connect() is
 always 0
Date: Tue, 16 Dec 2014 16:02:33 +0100
Message-ID: <CAD+HZHU2Mkqc92fvdyC_NnxwQ2odY7GLjAnX1eTjsJtKzZ9PYg@mail.gmail.com>
References: <20141216143242.GB4401@fholler.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141216143242.GB4401-99BIx50xQYGELgA04lAiVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Found the bug.
commit 56e620c453f2588cfc9898a41b110477f6417a5d
Author: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date:   Tue Dec 16 15:44:17 2014 +0100

    RDMA/cma: fix first byte overwritten for AF_IB

    If user attach private data for AF_IB, the first byte will
    be overwritten, because we always set the cma version no matter
    family is AF_IB, so move the version set inside if condition.

    Reported-by: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
    Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d570030..22a22e2 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2618,10 +2618,10 @@ static int cma_format_hdr(void *hdr, struct
rdma_id_private *id_priv)
        struct cma_hdr *cma_hdr;

        cma_hdr = hdr;
-       cma_hdr->cma_version = CMA_VERSION;
        if (cma_family(id_priv) == AF_INET) {
                struct sockaddr_in *src4, *dst4;

+               cma_hdr->cma_version = CMA_VERSION;
                src4 = (struct sockaddr_in *) cma_src_addr(id_priv);
                dst4 = (struct sockaddr_in *) cma_dst_addr(id_priv);

@@ -2632,6 +2632,7 @@ static int cma_format_hdr(void *hdr, struct
rdma_id_private *id_priv)
        } else if (cma_family(id_priv) == AF_INET6) {
                struct sockaddr_in6 *src6, *dst6;

+               cma_hdr->cma_version = CMA_VERSION;
                src6 = (struct sockaddr_in6 *) cma_src_addr(id_priv);
                dst6 = (struct sockaddr_in6 *) cma_dst_addr(id_priv);


2014-12-16 15:32 GMT+01:00 Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>:
> Hello,
>
> we are using the conn_param->private_data field to transfer data with the
> rdma_connect() call to the server.
> When it's done on a RDMA_PS_IB rdma_cm_id the first Byte of the
> private_data, that is received by the server is _always_ 0.
> When a RDMA_PS_TCP rdma_cm_id is used, the data is received correctly on the
> server.
>
> We are using:
> - kernel 3.14.13
> - Mellanox Technologies MT26428 HCA
> - mlx4_0 driver
>
> I attached a simple client and server module to reproduce the behaviour.
> Can somebody have a look? Is there a problem in our modules? Or is it a bug?
>
> ----------
> Connection establishment via GID (RDMA_PS_IB):
> client:
>     # insmod client.ko gid_addr=fe80:0000:0000:0000:0002:c903:0010:c0f5
>     [ 7328.586773] private_dataffff88022a263c50: 57 48 41 5a 20 55 50 20 53 45 52 56 45 52 3f 00  WHAZ UP SERVER?.
>
> server:
>     [ 1658.208238] private_dataffff8800b93e3bec: 00 48 41 5a 20 55 50 20 53 45 52 56 45 52 3f 00  .HAZ UP SERVER?.
>     [ 1658.208239] private_dataffff8800b93e3bfc: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     [ 1658.208241] private_dataffff8800b93e3c0c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     [ 1658.208242] private_dataffff8800b93e3c1c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     [ 1658.208244] private_dataffff8800b93e3c2c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     [ 1658.208245] private_dataffff8800b93e3c3c: 00 00 00 00 00 00 00 00 00 00 00 00              ............
>
>
> Connection establishment via IPv4 address (RDMA_PS_TCP):
> client:
>     # insmod client.ko ip_addr=10.50.100.62
>     [ 7179.219773] private_dataffff88022a263c50: 57 48 41 5a 20 55 50 20 53 45 # 52 56 45 52 3f 00  WHAZ UP SERVER?.
>
> server:
>     [ 1508.840508] private_dataffff8800b8d25b90: 57 48 41 5a 20 55 50 20 53 45 52 56 45 52 3f 00  WHAZ UP SERVER?.
>     [ 1508.840509] private_dataffff8800b8d25ba0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     [ 1508.840511] private_dataffff8800b8d25bb0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     [ 1508.840512] private_dataffff8800b8d25bc0: 00 00 00 00 00 00 00 00                          ........
> ----------
>
>
> thanks
>
> Fabian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
