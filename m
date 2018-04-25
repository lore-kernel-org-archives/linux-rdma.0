From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/nes: fix nes_netdev_start_xmit()'s return type
Date: Wed, 25 Apr 2018 18:35:22 +0300
Message-ID: <20180425153522.GL24820@mtr-leonro.local>
References: <20180424131545.2810-1-luc.vanoostenryck@gmail.com>
 <20180424173612.GI24820@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MPkR1dXiUZqK+927"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180424173612.GI24820@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-kernel@vger.kernel.org, Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--MPkR1dXiUZqK+927
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 24, 2018 at 08:36:12PM +0300, Leon Romanovsky wrote:
> On Tue, Apr 24, 2018 at 03:15:45PM +0200, Luc Van Oostenryck wrote:
> > The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
> > which is a typedef for an enum type, but the implementation in this
> > driver returns an 'int'.
> >
> > Fix this by returning 'netdev_tx_t' in this driver too.
> >
> > Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> > ---
> >  drivers/infiniband/hw/nes/nes_nic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> ipoib_start_xmit() needs the same fix.
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--MPkR1dXiUZqK+927
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrgoDoACgkQ5GN7iDZy
WKetBxAAlws39az3yZgdMtP6DT9RMB7gte8ad7BJCpuLMg0UpK/J7PNUjVkiR5PY
XLm75R2BYqcjDEUXdLjFG4oFTMU1h/5URxE6R1IV9Szc/QpIrDJs+N2irqbaWAp/
X0sIbkb5rl0sxwjZonbzfGBhfTJ1Bc56d8TrwVOC9eMRGVaGW8EmkRiWVxwt60TO
uzops44nLEf0fkkw6LP35AyMG3JXJl7dg2IuW1oSnnUuaAiRkOagR94P9hhmevpi
/20d/Jc7JywyjszTBXOATL5rCKkmRtQ4Mo24NZyjdbTQWswmwVvLHfGgybDAzbg8
+hHC8FbfE8ASxI00lk/cKrd9zganheYvDf57eoPF401GeKEXSxwtgNMlxg+mhQ08
RlXiI/bRAniB5HcJpHe+xchE/HoIAX+fLxOzadYpX8LC5lZbJFn+lkCj7y1HwLe+
XRxutACMBOZqcujTNjFCtXiUU+pfDM3le9okcuXgqZTUmo4oUewb7KL9F4qqbCPk
5MFVg9iHgyNWFV60Rqxar3ggWhcRESKsZRUglH7ovxjprIHRdAXDJiY+IngVoxf+
4QWceuc/S7jglveIeJa866AFpbnE7TlsI6VMLRCeIbv9oAISD3U+EVOIVXHnZcfT
4LLVQo4FCsUbIcc5Xy2Y5hqjwRYLy+mD2gbmhtCVH4DsR++hqZQ=
=E8Jf
-----END PGP SIGNATURE-----

--MPkR1dXiUZqK+927--
