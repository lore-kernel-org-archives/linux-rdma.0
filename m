From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: "memory management error" with NFS/RDMA on RoCE
Date: Tue, 27 Jun 2017 20:36:20 +0300
Message-ID: <20170627173620.GT1248@mtr-leonro.local>
References: <7F0FCF80-DB7B-46F1-BB9A-0B070603DE61@oracle.com>
 <797a43c4-f30d-9deb-a332-c62cbd01be7b@grimberg.me>
 <2FEEE227-9BCF-4454-A056-3997C1E54686@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9ZRxqsK4bBEmgNeO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2FEEE227-9BCF-4454-A056-3997C1E54686-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9ZRxqsK4bBEmgNeO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 27, 2017 at 10:56:29AM -0400, Chuck Lever wrote:
> Hi Sagi-
>
> > On Jun 27, 2017, at 5:28 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> >
> >
> >> While running xfstests on an NFS/RDMA mount, I see this in
> >> the client's /var/log/messages multiple times:
> >> Jun 22 14:13:45 manet kernel: mlx5_0:dump_cqe:275:(pid 0): dump error cqe
> >> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
> >> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
> >> Jun 22 14:13:45 manet kernel: 00000000 00000000 00000000 00000000
> >> Jun 22 14:13:45 manet kernel: 00000000 08007806 250000cd 024027d3
> >> Jun 22 14:13:45 manet kernel: rpcrdma: fastreg: memory management operation error (6/0x78)
> >> As far as I can tell the client is able to recover and continue
> >> the test. However, this error is not supposed to happen in normal
> >> operation.
> >> This is with a Mellanox CX4 in RoCEv1 mode, v4.12-rc2.
> >
> > Is this a regression?
>
> I can't answer that question with authority, because I just
> started trying out NFS/RDMA on RoCE with mlx5. But Robert has
> reported very similar symptoms with iSER on v4.9. It appears
> to have been around for a while, if these are the same.
>
>
> > What kernel version are you running?
>
> v4.12-rc2.
>
>
> > FW revision?
>
> 12.18.2000
>
>
> > Is the below commit applied?
>
> This commit does not appear to be applied to my kernel.
>
>
> > commit 6e8484c5cf07c7ee632587e98c1a12d319dacb7c
> > Author: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Date:   Sun May 28 10:53:11 2017 +0300
> >
> >    RDMA/mlx5: set UMR wqe fence according to HCA cap
> >
> >    Cache the needed umr_fence and set the wqe ctrl segmennt
> >    accordingly.
> >
> >    Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >    Acked-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >    Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> >    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > This is the only thing that changed in that area
> > lately...
> >
> > Can you try without it?
>
> I haven't tried with it. I can pull it and see if it helps.
>
> I have tried:
>
> - with and without IOMMU enabled
> - with RoCE v1 and v2
> - with instrumentation:
>
> This can happen to any MR at any time after any number of
> uses. It does not appear to be "sticky" (ie, xprtrdma
> recovery from a memory management error clears the problem
> successfully by releasing the MR and allocating a new one).
>
> So it feels like a f/w or driver problem to me, at this
> point.

Jack and me discussed your issue tomorrow morning and we have strong
feeling that it is FW.

Thanks

>
> --
> Chuck Lever
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--9ZRxqsK4bBEmgNeO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllSl5QACgkQ5GN7iDZy
WKf3Dw/8DeHf1sR+DxND8qdFziNkxiOndwwDxBql4uYPcjBo2BFsCBRl1ZHxjQWv
+mOfdU1dtDDBlrpC+qX6Du4j/zTwRpOIZsYyZAkfXiatKJkCkLEHa+Rx4h1ePm5h
Y3zM5043b8zPzmRB7MIE5pu9LRuHPxVA+rSCJ+h29oGUBnQx/UKLD5zCj9eD83jy
Pu3eqg08JHCMydNmLWds6UOmUGpu92pudUx7Quv7uSbQkwvX8Jb2a53a8vlwzBYg
kC2q40YeZAnBjvAjVdSJ+Dsb8jHs7CgareLs1LancG7MQKyCGdS9P/bPLSUaUT5P
Y7KAP7HBUwWh6nD2UZ3lLgc2cx+8sUYE6eRj/Zu6JVSlSkUsNrH1BMHw4fp642NC
/CchCmPtaHsB5rYrbWS6aa03g2dLUncfngKQFuVJ26dveyZVcqUC2E3TGgR188ix
TXmbBET2vvlmbDvS08c4NOgt3oRTASYCe4VsPXC289+8aEyVqF+DbQv/a4yP5icB
RaOsLat8fYm/5o8gQ+FwfJQEQIYCxhnLlNkby56PEUcq2eUiPF2mXDtZpw+Z6tPS
OW37czcLFZWjL+eHfBhwbceV5U9YINCzahxBcx+GRROEpgy33M3cb/78HmFd9DfP
qSb8Gk1t+znj8rdX9BGgH9/okMd4kOiYy4Js6cQZ/Vsj7MzBzpU=
=3HUO
-----END PGP SIGNATURE-----

--9ZRxqsK4bBEmgNeO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
