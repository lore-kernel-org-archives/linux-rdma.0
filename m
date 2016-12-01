From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/4] IB/mlx4: Fix out-of-range array index in
 destroy qp flow
Date: Thu, 1 Dec 2016 09:02:53 +0200
Message-ID: <20161201070253.GB4497@leon.nu>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
 <1480252702-8005-2-git-send-email-leon@kernel.org>
 <BLUPR02MB1683B2E832867815771A4B2C818B0@BLUPR02MB1683.namprd02.prod.outlook.com>
 <20161128083107.GB6380@leon.nu>
 <bdd9788e-d393-b23e-876c-ae84774fdccd@sandisk.com>
 <20161201053105.GA4497@leon.nu>
 <BLUPR02MB16836D6466A901D088E1FE65818F0@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BLUPR02MB16836D6466A901D088E1FE65818F0-Y8PPn9RqzNfZ9ihocuPUdanrV9Ap65cLvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 01, 2016 at 05:35:42AM +0000, Bart Van Assche wrote:
> On 11/30/16 21:31, Leon Romanovsky wrote:
> > On Mon, Nov 28, 2016 at 08:29:55AM -0800, Bart Van Assche wrote:
> >> On 11/28/2016 12:31 AM, Leon Romanovsky wrote:
> >>> I'm extra cautions with stable tags and prefer to finalize my stable
> >>> checker in my submissions scripts first, before adding it manually and
> >>> I have plans to use it next kernel release.
> >>
> >> Thanks for explaining your workflow. However, the question remains whether
> >> or not stable tags should be added to the patches in this series?
> >
> > It can be added but I don't see any real advantage of it. Do you know
> > about real users who run RDMA stack from stable trees and don't rely on
> > distro kernel and/or OFED?
>
> Hello Leon,
>
> Many users who build an iSER or SRP storage target themselves use a
> recent stable kernel without OFED.

Hello Bart,

I'll take into account these users in my future submissions. Meanwhile this
series can be easily picked by various automatic scripts which stable
maintainers are running.

Thanks.

>
> Bart.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYP8sdAAoJEORje4g2clinANEQALkM82IaXiQ2T11Ame493yUG
bhxA45dyeeuzPizg/ca4hy4SWM3c4uRNvxc4hCItJVsiFJSNpJunOp7c7pvmdT7Y
jSd9b/6CwiKW44wDZhmW1IigH13sO3kyw/0PUMEV+rwibNCkyxsNkSfLvIyFSCDB
FEucXVTLP7Cluyws5qYKu3+BbjDqUGK6ccO8E7iyQ6mmd9kjHX/0hMbkkH5vZK5H
rGqSh8nn1EpW94LthAFCux6D4kLiI2i/oF/HiRZ05ACDW/Lc6fZSKF0s5UrM0ujx
wcbl9H+0tayNiNsc/ZAy7imXTTXfDEBZshUaK5bupiRoB49eJe7LJqpWFqHxp1LY
Ofz6xQouRuVlHyJSnzC6tztZlpxmIYVWjC+o/rds5bnwvt8sTOYL4+yp5TavIiED
tfGk7NHW4uGpdbI4lBeUfbEaYHPypylc14pazBO7hQyKGo3nmHcG3YN/+7JkVcSY
f8JjUY5mPgHdkm/de1Gx6payTKsVlD5I0esAq2mwr84348Da6bO7xLqOdJ5dtaad
KHXnujXj42WIxmDVkoVtj4U481IZfjUBX2rA+30bBZwb0pxV/0bBOyhkkRtHkeQS
KwB1dWNYlkdeLyfMCtYgRZEg92EtLmeRRKnDai1HjMbukXxLC3nW0zTkZK8ES6Vr
u0UZghve9amE2n5nvqGd
=b8Gc
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
