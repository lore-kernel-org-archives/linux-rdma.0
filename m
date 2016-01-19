From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/sysfs: Fix sparse warning on attr_id
Date: Tue, 19 Jan 2016 14:14:01 -0500
Message-ID: <569E8AF9.2090307@redhat.com>
References: <1451879065-6513-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FRO5DbUVrwibKoV1aX9E70ArXa5ca7UfH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451879065-6513-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FRO5DbUVrwibKoV1aX9E70ArXa5ca7UfH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/03/2016 10:44 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Attributed ID was declared as an int while the value should really be b=
ig
> endian 16.
>=20
> Fixes: 35c4cbb17811 ("IB/core: Create get_perf_mad function in sysfs.c"=
)
>=20
> Reported-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/sysfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/=
sysfs.c
> index 2daf83276cdf..3de93517efe4 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -77,7 +77,7 @@ struct port_table_attribute {
>  	struct port_attribute	attr;
>  	char			name[8];
>  	int			index;
> -	int			attr_id;
> +	__be16			attr_id;
>  };
> =20
>  static ssize_t port_attr_show(struct kobject *kobj,
> @@ -413,7 +413,7 @@ struct port_table_attribute port_pma_attr_ext_##_na=
me =3D {		\
>   * Get a Perfmgmt MAD block of data.
>   * Returns error code or the number of bytes retrieved.
>   */
> -static int get_perf_mad(struct ib_device *dev, int port_num, int attr,=

> +static int get_perf_mad(struct ib_device *dev, int port_num, __be16 at=
tr,
>  		void *data, int offset, size_t size)
>  {
>  	struct ib_mad *in_mad;
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--FRO5DbUVrwibKoV1aX9E70ArXa5ca7UfH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnor5AAoJELgmozMOVy/dUtgQAJBKDWT8ytXCRDAbkafSAUxQ
3NpaBVMqyhPZk5Wp9DBtFifj5icZ60wldbiUMhZqqb942L3XurUWXJ71FyKi7ie+
OTfdYfSW/+TQA+hiFJtNuebWK8QKOBy1pKauGM9NRbSGozJuS3B0zGcgi+GHLAPf
J1lDIemHVFTco/5UQ/3GAZkOUEN3WzbwPMk7ZAWNnyRMkNi4GahcJHcpfeG5OBAQ
Jtrvk6rQ1gba2IAhzaeCwlPYTItdd7l0tx6rSe8SOZ9l5h0qUQTHhz1c32q6Yf/X
R0MQM2QCjg2S5C6w1K3ADJak+NjJrTGVMg3KCddLae2DBtGNKEBl7FLkTWQIXaGI
U241nRM4jw/EsJqITWCF80i9nMboDlwiH9kgJDPOB3vCfqAqm7D7DwQNmuV45oR8
R8s8f6Bal0mfixHS97u63fEQRNYngQp83eYdO8xp9m01R6NFRlCO8i/MVRqGZAlT
WAz7iY2R5DMoU+TqSkrEai+tSdRWt3XSY6VP3w2/qr3QC3C6R+HBBLrQ+tqHNb50
mT7/Hwpjwds5ETLUTknBMEbZhUY1WdsUA8GzUt83xUXINnXhJMBkqjQbr04n6SOX
+TSkwgIlpojSR8PHB/hLEdR4rYxGOchEWUaaZK+pPwF47q954cvd3ejvcAtCSGPV
v3ElAQ3x/HKGxgsBnC28
=wXye
-----END PGP SIGNATURE-----

--FRO5DbUVrwibKoV1aX9E70ArXa5ca7UfH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
