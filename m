From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/4] IB/mlx4: Fix out-of-range array index in
 destroy qp flow
Date: Thu, 1 Dec 2016 07:31:05 +0200
Message-ID: <20161201053105.GA4497@leon.nu>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
 <1480252702-8005-2-git-send-email-leon@kernel.org>
 <BLUPR02MB1683B2E832867815771A4B2C818B0@BLUPR02MB1683.namprd02.prod.outlook.com>
 <20161128083107.GB6380@leon.nu>
 <bdd9788e-d393-b23e-876c-ae84774fdccd@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bdd9788e-d393-b23e-876c-ae84774fdccd-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 28, 2016 at 08:29:55AM -0800, Bart Van Assche wrote:
> On 11/28/2016 12:31 AM, Leon Romanovsky wrote:
> >I'm extra cautions with stable tags and prefer to finalize my stable
> >checker in my submissions scripts first, before adding it manually and
> >I have plans to use it next kernel release.
>
> Hello Leon,
>
> Thanks for explaining your workflow. However, the question remains whether
> or not stable tags should be added to the patches in this series?

It can be added but I don't see any real advantage of it. Do you know
about real users who run RDMA stack from stable trees and don't rely on
distro kernel and/or OFED?

>
> Bart.

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYP7WZAAoJEORje4g2clinvB0P/2OXdslczSUafGhgo+f/Mr+f
DhB9sWOUr8a4cO0Q8C5j6geCysqkYHL3ijgdbQq6gAoMamX7ESLWxQzRBKpfVfHj
B9JNlkkM0qVwSIZs6yu/crLCfnX7ZdgebPF0BTyXTxT79hP/MTRso+aqFXUutcxx
jenkCEfnPdByek2jppnoZovTIUtyLmBpLSsFomfj8//uuN5qeAQ9nRwwERiAlmmY
Os79xNgf+E+Azgp0zE6p0dXEi0y4LF3ZioiiZ6DGVfBSVLIU691lqYhkBfKTEe6C
KNVw5k2TRBpos+gljduy0gS/GPgZeseB0WOXNgWEDi32pxc6Q6JafeJqOJ+nxHOk
BLBG4/U3Grl+N1M22c2Od6HBIFisTct2yMOC8KumDmGHJRXLuwyT8LkgrSPwE6BL
iayONDnUB/88SdvHKcWYGEwd552Dsok6lvPENGOLsh22Cholyf9fZ/3VVt19SdH4
OpsJnW0KZv+wQbmY1No7hIFWYOuwu0qGPxI68Y0L5ZTL66Q6lyDicvbJEw7H7agP
XUS9P6okVPXf5vOLHso/ABQ+6ZpwcmlGY2IAwpKLhg4842T8F3TwtAqf4fbJ8f0M
0Wz5YA05aWUp7ueoBRChSUoCGT1bunIYOYWX5LY6wLfw8dpBToT3kjpz9/3SfBka
i6ZxURWExgHTTX8b3Rx7
=v6tE
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
