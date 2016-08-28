From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/{core,hw}: Add constant for node_desc
Date: Sun, 28 Aug 2016 09:09:26 +0300
Message-ID: <20160828060926.GJ594@leon.nu>
References: <1472115186-10718-1-git-send-email-yuval.shaia@oracle.com>
 <b366ef68-3f46-a245-2495-76107954219e@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="iRjOs3ViPWHdlw/I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b366ef68-3f46-a245-2495-76107954219e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--iRjOs3ViPWHdlw/I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 25, 2016 at 10:23:22AM -0400, Doug Ledford wrote:
> On 8/25/2016 4:53 AM, Yuval Shaia wrote:
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/core/sysfs.c              |    2 +-
> >  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
> >  drivers/infiniband/hw/cxgb3/iwch_provider.h  |    1 +
> >  drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |    1 +
> >  drivers/infiniband/hw/cxgb4/provider.c       |    2 +-
> >  drivers/infiniband/hw/hfi1/verbs.c           |    3 ++-
> >  drivers/infiniband/hw/mlx4/mad.c             |    3 ++-
> >  drivers/infiniband/hw/mlx4/main.c            |    6 +++---
> >  drivers/infiniband/hw/mlx5/mad.c             |    2 +-
> >  drivers/infiniband/hw/mlx5/main.c            |    6 +++---
> >  drivers/infiniband/hw/mthca/mthca_mad.c      |    3 ++-
> >  drivers/infiniband/hw/mthca/mthca_provider.c |    5 +++--
> >  drivers/infiniband/hw/ocrdma/ocrdma.h        |    1 +
> >  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    2 +-
> >  drivers/infiniband/hw/qib/qib_verbs.c        |    3 ++-
> >  include/rdma/ib_verbs.h                      |    6 ++++--
> >  16 files changed, 29 insertions(+), 19 deletions(-)
>
> Thanks, applied to for-next.

Doug,
Which version did you apply? This with error or v1?

Thanks

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--iRjOs3ViPWHdlw/I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwoAWAAoJEORje4g2clinDbwP/0PUpa/5swD19F+CHKvKO3fZ
SjZluL+rsC9iiN6u98nt0A+gD3jZaHqRrtMZfFaycdTTVr0blJI/2p695YuCCsoj
Wc+wc+9q8sXArhm2i55pF9P9yXfXi4urUEuEm7KwDw5mNViAE7u1cxVESkslWk/I
Ch0NlSS9Dwv5jOpZceDNv7XHlRODudqKDCGpWIQw19ad4wBuOH5ytcAPKz0Rcv2q
Y95SIxAOzuZqxP234NO9ZK/tyG0WCy6bhZRtjHM6XNE8gZ4dbiSfq0QcrOCofL34
IVXwL6svqpXcU1P3ZHqgwu3yMAo50tbnQoac6XyZaDyMdlkblBodKimWd859/Txi
aFZH5HxWahhTBCyXuBQwJ9wanvf4lcRrcLfvNEkOvXOKrj65U9yp3uMeKxqc4Eki
77DBn+5A8qqM0RdP3cVHEV22pTHFbj3N+7SKieEHupbgr/ozQMVVw8h7njNFEY4i
yfqAO8yXdVTJ6GBuiGwa2k+iwdu83NkNVUWPJ8ERXVMt3z8yUi3vXtS7RkAqch6N
8I9geZDZZx8YuDK6WY/Ev3KJk1XuYy7fSu0P7GWnhbTOjUk/V3iGZp9dw55H6qf6
8jt3bCaz9WcDhAN6+o8PAJjKEp4vTows9OcnQgQBOQxlFfxBFclSfTZUnvEpfU9s
0RiMM/ydBOWI27dPEYFA
=gdhP
-----END PGP SIGNATURE-----

--iRjOs3ViPWHdlw/I--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
