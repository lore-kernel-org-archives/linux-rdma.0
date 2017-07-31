From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] IB/hns: Fix the bug of polling cq failed for
 loopback Qps
Date: Mon, 31 Jul 2017 11:07:31 +0300
Message-ID: <20170731080731.GT13672@mtr-leonro.local>
References: <20170719114829.sctq34wns6h6zvxz@mwanda>
 <59769D18.4020400@huawei.com>
 <20170725071118.3erfnxyiqi7ittl3@mwanda>
 <597C3939.2060407@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="foM9DbudB2CcldhH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <597C3939.2060407-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--foM9DbudB2CcldhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 29, 2017 at 03:28:57PM +0800, Wei Hu (Xavier) wrote:
>
>
> On 2017/7/25 15:11, Dan Carpenter wrote:
> > This is a Smatch check.https://lwn.net/Articles/629250/
> >
> > regards,
> > dan carpenter
> Hi, Dan Carpenter
>
> Thanks,
> I have another question,
> We use "make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- " to compile kernel
> with cross compiler.
> If we want check only some files in some directories, how to use this smatch
> tool to check them?

You can provide relevant directories to the make call, something like that:
make CHECK="smatch -p=kernel" C=1 drivers/infiniband/hw/hns/


>
> Regards
> Wei Hu
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--foM9DbudB2CcldhH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll+5UMACgkQ5GN7iDZy
WKcwOA/9FuTB5nODTTDGXzF3AN/HkCKfrwNBCifCsvXlNWOV+yyQK0yvPksA3zWp
KR/hyrEXyb8JOHe7hpu6wgZ90Rn00Rmi76xwWxCBs81VtfCOGJiKUEC6SVDegUEg
ocepH0gajhxWHhF1EDI6GZLJ7agAHwZXSP8/ZOkCgwZgf1GxAJT3prfhRq+o5O8J
nCyfyzuAUnMXOBLhBrREiBrHuN+8aFMT9HLvNgIg+hPBofOWRldVhQl1L4IHE8kj
qJTHHRnichfavSyGh9urcmLeecZxPtBzPiO4ZbQB9rBfpdB7rAwrBwD0CgLrj27I
cRaYYAd9HwYxpzHfZs8rSp/lKjT4BbeujF5CKudLJtjXRhvocdAeB8Kllv7WQEQx
VVRJSelyqptq3vtpGDtl0X/u7TmkisAbI9mzrj1U5qsWhpb7Yt56cMunD9m/pzAv
ypWt40EJLlPNzzk74wZQ5/esi7mkyPLRbnL47Nl+Xvoqm2bRT4wgWrye3MGejjR4
xW1mW5kr1iCpwKq8gXT5TWdgcByY99VG/vzcfdbDPTt+dm1wa4RsYyqhjtZ0FQql
DO5C3bEQIRCwiYUeWn6fqSKIS6l9WDT0B6BLwHWVhOPtzI436fB+aKz6dKH1SpPR
s5AID5PrypdmVuyNHpluCS0SZsjUeWZ3liXp8UAKFMmrVLuJ74Q=
=ASD4
-----END PGP SIGNATURE-----

--foM9DbudB2CcldhH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
