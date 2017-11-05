From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Vendor-specific QPs
Date: Sun, 5 Nov 2017 09:25:00 +0200
Message-ID: <20171105072500.GE31774@mtr-leonro.local>
References: <VI1PR05MB12784029D1DE2689A8194A58B9590@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20171102200158.GU18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102200158.GU18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 02:01:58PM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 30, 2017 at 03:23:24PM +0000, Alex Margolin wrote:
>
> > We propose using the "reserved" range of QP types to serve the
> > vendor-specific implementation, both within the Verbs API (API patch
> > below) and the IB subsystem (ib_core). The solution requires minor
> > changes to IB core, namely removing some restrictions that apply to
> > standard QPs at creation, but most of the flow (and the one for
> > modify and destroy) remains identical.
>
> > The changes to support such QPs will remain in the vendor-specific
> > area of the API, i.e. Mellanox "Direct Verbs" portion, and the
> > change in ib_core is to use specific IB_QPT_RESERVED* definitions to
> > cut through some of the required checks (but still using most of the
> > logic, where applicable). No change to libibverbs is required.
>
> Don't like the idea of a generic RESERVED.
>
> Add a type called IB_QPT_DIRECT_VERBS and put any other information

+1
If we go in this route, it will be much easier for me to present QP types.

root@mtr-leonro:~# /mnt/iproute2/rdma/rdma res show qp dev mlx5_1
QPN	DEV	USER/KERNEL	TYPE	STATE	PID	COMM
8	mlx5_1	USER		UD	RESET	1	rdma
7	mlx5_1	USER		UD	RTS	1	rdma
1	mlx5_1	USER		GSI	RTS	1	rdma
1	mlx5_1	USER		GSI	RTS	1	rdma
0	mlx5_1	USER		SMI	RTS	1	rdma

Thanks

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln+vMwACgkQ5GN7iDZy
WKcx+w//c2Pp2Z1G9Env2vsqqqV58QoKg7MF4KLRn3MQb26jfpRzi/2WjG6N0qhd
lTldXQUKBDFJB3+l5F9JmYUlexn4LuwTqleL1s41r1gdZFenParcuBcbe6NFXCuV
fz7oMFNl8EK/bnUsLViQwiWlBviK8dsPBcAZTdTG2fUfKum4krupb65N3j1WaNG6
IafoDKOA8k7qIJnbhaABt3Vz1/TI2qRhE+a8vmuIhQwAcjuGt13zZDNySATBxd5s
A10wMx84yEyB5ZueRjFQrNpy5OT+XSC7f49E49UlLVNtlkZQSqGudHV77NeSJtNw
yP3iEqngcVo9q2nKi2ytBUhumiayXHvNZKnX30dM04pTHXCFYxEcoZa3rwU3wT3v
TN5mXOH0jbg6Ko5Kqz/IJOhAxyfE03Jf6VqaNf7RfOmLzrj9tBKvNaY19wdsP6HP
xpiGcJAbqeEqOvEdBS/+9FT2rxJlweYp8uhv1Z5GoChMVDKwufLuRx0CAq9IZMZX
6usR6HI3bEvJSugYOJyh7bQCQulmdWrEfasxUummJOY5BG7N5e4DhVlMzAODfuDK
sZZ6d/4BYF1tumq6IWkwoaspPZDYvUh0hCD6M7DHyfK5AL7tPv2bxNAnKyK2ZecT
51PCt7gKmoazW6MsRjBC+h2iqKBxH1LUM/0+9ogmqGkx1lTzyIs=
=Yz20
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
