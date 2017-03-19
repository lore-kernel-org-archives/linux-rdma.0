From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Sun, 19 Mar 2017 09:01:15 +0200
Message-ID: <20170319070115.GP2079@mtr-leonro.local>
References: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
 <95e045a8-ace0-6a9a-b9a9-555cb2670572@grimberg.me>
 <d21c5571-78fd-7882-b4cc-c24f76f6ff47@redhat.com>
 <20170310165214.GC14379@mtr-leonro.local>
 <56e8ccd3-8116-89a1-2f65-eb61a91c5f84@mellanox.com>
 <860db62d-ae93-d94c-e5fb-88e7b643f737@redhat.com>
 <0a825b18-df06-9a6d-38c9-402f4ee121f7@mellanox.com>
 <7496c68a-15f3-d8cb-b17f-20f5a59a24d2@redhat.com>
 <31678a43-f76c-a921-e40c-470b0de1a86c@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cX4WM3qIY/fHWHDu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <31678a43-f76c-a921-e40c-470b0de1a86c-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--cX4WM3qIY/fHWHDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 16, 2017 at 06:51:16PM +0200, Sagi Grimberg wrote:
>
> > > > > > Sagi,
> > > > > > The release function is placed in global workqueue. I'm not familiar
> > > > > > with NVMe design and I don't know all the details, but maybe the
> > > > > > proper way will
> > > > > > be to create special workqueue with MEM_RECLAIM flag to ensure the
> > > > > > progress?
>
> Leon, the release work makes progress, but it is inherently slower
> than the establishment work and when we are bombarded with
> establishments we have no backpressure...

Sagi,
How do you see that release is slower than alloc? In this specific
test, all queues are empty and QP drains should finish immediately.

If we rely on the prints that Yi posted in the beginning of this thread,
the release function doesn't have enough priority for execution and
constantly delayed.

>
> > I tried with 4.11.0-rc2, and still can reproduced it with less than 2000
> > times.
>
> Yi,
>
> Can you try the below (untested) patch:
>
> I'm not at all convinced this is the way to go because it will
> slow down all the connect requests, but I'm curious to know
> if it'll make the issue go away.
>
> --
> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> index ecc4fe862561..f15fa6e6b640 100644
> --- a/drivers/nvme/target/rdma.c
> +++ b/drivers/nvme/target/rdma.c
> @@ -1199,6 +1199,9 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id
> *cm_id,
>         }
>         queue->port = cm_id->context;
>
> +       /* Let inflight queue teardown complete */
> +       flush_scheduled_work();
> +
>         ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
>         if (ret)
>                 goto release_queue;
> --
>
> Any other good ideas are welcome...

Maybe create separate workqueue and flush its only, instead of global
system queue.

It will stress the system a little bit less.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--cX4WM3qIY/fHWHDu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljOLLsACgkQ5GN7iDZy
WKemmQ//ZwoPC9MdxYrJD7VDSoEX0VY4wdbCbwWPgUnH+jyQXOKBnd4lb7+fFXz+
v2ZZGGk4UtH0Kplex+Cm4Hq7GujUl4d3ji6BDBaj8idbYREHD68yFbexLSChktnF
Qos314XRyZXCEnxHUFrBnjzbi9HgHYEo/pymDuhF5XiszYZ0xgPj3ohurFTKS6Ts
W8esSR1UBLgyXiVWIbXbPFPNp5z+PXgXMlotCXPspc0k0ckhjYU6kWb6EM5lw0yN
FDbqfZA1Ahb5X0mvvXUhBMbmMjV8euKUnKNeVfSQedwk62/7pvGnysB+fpVBb1+u
f+lebRJxajXKav8uKhO2YM4mjDzXXkw61BN/wgoaTI6FVCNNI0+2HL6NlG5631zB
9P29XylD4ogUO8G3a8CCgrO10Yu/l/9Toanh6gd2kXWMr44pglio5dInByPdp6pP
+Hs6zIzRyDcj7rjXT0GvBl/BeKVCv9WvRH1IoYkZSlB2wZ2dn9fQuaYWVvPKrOAm
NOjKiLT8K7i07U09+3Q6ON13+lVOuSzewNoiEl/siEeBoDplrm/vDOw5ZykxohTb
3Pj9w1LgJ5axpkfxWvTvz+Ya/oHZ3ieU9Z6CfO+fr2ppcXZtbZa8iHOxWtE8q4eT
lTuwKw8Si/4apZavGK0TFsysZ2VeF16CAHu8huCionjglV/knTQ=
=9Vlf
-----END PGP SIGNATURE-----

--cX4WM3qIY/fHWHDu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
