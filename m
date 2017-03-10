From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Fri, 10 Mar 2017 18:52:14 +0200
Message-ID: <20170310165214.GC14379@mtr-leonro.local>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
 <95e045a8-ace0-6a9a-b9a9-555cb2670572@grimberg.me>
 <d21c5571-78fd-7882-b4cc-c24f76f6ff47@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GdlkuMH+DRYbUHkj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d21c5571-78fd-7882-b4cc-c24f76f6ff47-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--GdlkuMH+DRYbUHkj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 09, 2017 at 12:20:14PM +0800, Yi Zhang wrote:
>
> > I'm using CX5-LX device and have not seen any issues with it.
> >
> > Would it be possible to retest with kmemleak?
> >
> Here is the device I used.
>
> Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]
>
> The issue always can be reproduced with about 1000 time.
>
> Another thing is I found one strange phenomenon from the log:
>
> before the OOM occurred, most of the log are  about "adding queue", and
> after the OOM occurred, most of the log are about "nvmet_rdma: freeing
> queue".
>
> seems the release work: "schedule_work(&queue->release_work);" not executed
> timely, not sure whether the OOM is caused by this reason.

Sagi,
The release function is placed in global workqueue. I'm not familiar
with NVMe design and I don't know all the details, but maybe the proper way will
be to create special workqueue with MEM_RECLAIM flag to ensure the progress?

>
> Here is the log before/after OOM
> http://pastebin.com/Zb6w4nEv
>
> > _______________________________________________
> > Linux-nvme mailing list
> > Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> > http://lists.infradead.org/mailman/listinfo/linux-nvme
>
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

--GdlkuMH+DRYbUHkj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljC2b4ACgkQ5GN7iDZy
WKdBNRAAiK47QNw602HZnSUlWKZa+hrWmUu8+5PvdVEt4YiKTjyLSW9IP2zcwQdy
OapmiASBFuY4eulGxk+77ZH1QrLQg6V0afo3knCRUXm2mCUIxE6gUoKVpTJrRorR
eszy5GOpOZfzVY7WVPviCcMS0qn0rwReBQ2+EYn5lAEGo1ekfhrobVmqO35PfxoG
ODD8eI2RhASOp/6dgeGUM6AQZ0oc2vPALN3HNHROMyhgKw0JxisZ31mKG4KLg6F5
czHXjLZlWZONThdix0cJlb6VXQtXegHkPpgT0Vnw5nR3ClpXISOPsht5434g6C/Y
pCQF4+ZQkzw8aks5EGtLUsmpBXxPjm0MYwmSOYwZWNRltylO4kXHfQNB+cLiYI7O
EsCKj38w2DlE1oKnChqF4qu+wDRt8nSSbL1TG5LCwODc/GyxYlMkA1ygQH79yTdj
W140OA8+0HkbkgKU/Cp/Shd0isErA6TM4tdyURPDa8ABpi0dtMItdevqGSwoNfSA
jES8tTsz4/BRkP/8e7bQ2BCJySnpZfz/Nz1+8izO6TFrY+2I3r9MdmF7/yEs/tAl
nkEsUQSv/IzrgJNlzxxPL++Q40FZGxTKtMvNRMJ7YS6DcHzDh8FBVbL+QlTaJvSi
ZijEu6P/Dg09D9D/Mcd0H+u5Du4O2roy4ZkVcWxj9dhMwDlEeHE=
=3Sm6
-----END PGP SIGNATURE-----

--GdlkuMH+DRYbUHkj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
