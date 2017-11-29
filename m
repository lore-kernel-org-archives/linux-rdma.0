From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Issue with IB/ipoib: Remove device when one port fails to init
Date: Wed, 29 Nov 2017 07:16:26 +0200
Message-ID: <20171129051626.GT29104@mtr-leonro.local>
References: <20171108140645.GA5683@yuvallap>
 <03848fab-3c72-681e-e32f-14560a84f59a@mellanox.com>
 <VI1PR0502MB36143F956ACD3518BC13C9CFB6560@VI1PR0502MB3614.eurprd05.prod.outlook.com>
 <20171108161356.GC6935@yuvallap>
 <20171109113923.GB2949@yuvallap>
 <VI1PR0502MB3614A65D0F63E0CDBBD00EF6B6570@VI1PR0502MB3614.eurprd05.prod.outlook.com>
 <20171109172112.GA3726@yuvallap>
 <AM4PR0501MB19723DE7524AA90DC8A2C111C33A0@AM4PR0501MB1972.eurprd05.prod.outlook.com>
 <20171128190345.GB2640@yuvallap>
 <20171128210012.GE21325@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mvuFargmsA+C2jC8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171128210012.GE21325-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mvuFargmsA+C2jC8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 28, 2017 at 02:00:12PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 28, 2017 at 09:03:46PM +0200, Yuval Shaia wrote:
>
> > I agree that patch as it is now does not really handle the case where one
> > port fails so it needs to be fixed.
> >
> > The thing is that from your perspective the idea itself is wrong, i.e. if
> > one (of for example two ports) fails the driver needs to continue and serve
> > the other port and just print error message.
>
> On this point, I think if ports are completely independent at the ipoib
> layer then they should not become linked during the add process.
>
> ie if a port is working and a second port fails then it should not
> kill the first port.
>
> However, it is unfortunate we have no recovery from this case at all.
>
> Alex V: However, why is the current behavior a problem? Is this
> because of a dual port card with IB and ROCE concurrently? And the
> add 'fails' the ROCE port even though it isn't even really a failure?
> We certainly shouldn't print in that case..

It is a problem for one port cards too, i see such print on my system:
root@mtr-leonro:~# dmesg |grep Fail
[    7.785329] Failed to init port, removing it
root@mtr-leonro:~# /mnt/iproute2/rdma/rdma link
1/1: mlx5_0/1: subnet_prefix fe80:0000:0000:0000 lid 13399 sm_lid 49151
lmc 0 state ACTIVE physical_state LINK_UP
2/1: mlx5_1/1: subnet_prefix fe80:0000:0000:0000 lid 13400 sm_lid 49151
lmc 0 state ACTIVE physical_state LINK_UP
3/1: mlx5_2/1: subnet_prefix fe80:0000:0000:0000 lid 13401 sm_lid 49151
lmc 0 state ACTIVE physical_state LINK_UP
4/1: mlx5_3/1: state DOWN physical_state DISABLED
5/1: mlx5_4/1: subnet_prefix fe80:0000:0000:0000 lid 13403 sm_lid 49151
lmc 0 state ACTIVE physical_state LINK_UP

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mvuFargmsA+C2jC8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloeQqoACgkQ5GN7iDZy
WKfN5g/+Lljuh2oGRq3F2+L+4OiZ4QFnAD+kV7ChSG+UW8NRC0vm28R10p56+2R4
5FGk/J4HVtdNY99HUWtvsOOUxSeJsGyvYGO+iPB00XZJds1/3vTVaipCDZWpahyq
k6O8WXaiBBeG19Yv7ORxfTILbVgjFT+7eInEOe5yyjO/8fOqfuvI8oZbGXa+UO/x
tIXuTGOkMwQfMDVHmSJqVwQrdt490DLCSY0079Znc4jDlZMFbSnzesFCjr6eneJc
2HJKFCICaP6sZ4c9y7i8ivMO+NvcoPFnFrFBpjKS1u1jg/+IBRTAZ755d3GSYmkt
OyyiSGWMvP1KH/eQ9cYgAaoTQlz7yD2znbwWtT+UvLbc1zdWB5jFspPwFdiwBn3l
x7lVcqhBmM0hAuhCbH12R1mXTD+Mi1dncyC2rBsayWsKyBzTrFWbf0/Id+nC3AsL
rj3iJYZ0U5IC1hgHa7gsyo5HS+fXnmfT1QEc0zxQR+XiocT26+5nGx2TiZimI5vb
uWkKSUDKr+zX1Qvz020U+BCVcpNIeQr+jGWRqpSWftiYR43xWecRE0LWKRTa8Tjq
wUpISy+evoifN+B0yZy3o6NA2T0HWWxwS7jDwyNU1oM9jc01myYZKDOqGlFoZWXT
N4mxLAEbEbxwYSBml9piu8F2for0Yas1sM9iMX9M6JgFsHrXPnQ=
=dmJo
-----END PGP SIGNATURE-----

--mvuFargmsA+C2jC8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
