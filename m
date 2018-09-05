From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 2/3] IB/ipoib: Use dev_port to expose network
 interface port numbers
Date: Wed, 5 Sep 2018 16:41:03 +0300
Message-ID: <20180905134103.GS2977@mtr-leonro.mtl.com>
References: <20180903161316.25121-1-ar@cs.msu.ru>
 <20180903161316.25121-3-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7l042bGvurpep9Wg"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903161316.25121-3-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--7l042bGvurpep9Wg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 03, 2018 at 07:13:15PM +0300, Arseny Maslennikov wrote:
> Some InfiniBand network devices have multiple ports on the same PCI
> function. This initializes the `dev_port' sysfs field of those
> network interfaces with their port number.
>
> Prior to this the kernel erroneously used the `dev_id' sysfs
> field of those network interfaces to convey the port number to userspace.
>
> The use of `dev_id' was considered correct until Linux 3.15,
> when another field, `dev_port', was defined for this particular
> purpose and `dev_id' was reserved for distinguishing stacked ifaces
> (e.g: VLANs) with the same hardware address as their parent device.
>
> Similar fixes to net/mlx4_en and many other drivers, which started
> exporting this information through `dev_id' before 3.15, were accepted
> into the kernel 4 years ago.
> See 76a066f2a2a0 (`net/mlx4_en: Expose port number through sysfs').
>
> Signed-off-by: Arseny Maslennikov <ar@cs.msu.ru>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--7l042bGvurpep9Wg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbj9zvAAoJEORje4g2clinbZ0QAKruifVs2BhrMP1qUxJjUL3F
19nbgH435xStjuL/wYGfptABIhkfub84+S5nJ/yZl6X0WpHs2xsTW17iUNcr/cR3
Wtnvj+39d9dNO1lRuUzVF+r2fX/VeIXLQkIRZMD8D/Zg1LQZE6A4BUeksrL0EZMp
6m/JZ3QQnNa72wW8HPR5k5wojSNWPGbrp0eNu+UetVUcMgU9UV+3F9VfSCaf9Zxl
QQc6+d96sJ4B13Nk8y3NJSFSrnddKK873nyXRWH9CdNMdocni3kqisP+f9dyoew1
UGx/a4Wig+KQi9PB6rFRaLyErJCHrYwIw168HFdkxgpKe7KUEkq2NezbwJpolA50
u+Y0mkt63ZS6b7yGZ2iPp6/dUKXw086UwbufpURs2NDQCYGWeLUsa+DFWoaMoz5C
b4gHOJHiAC+vow3Ba1zyHsZten4pLMEtGDECa23FFLE4x5G12jmZSdAa2X4UoXRt
f3rhEBGJgJfv6VXRPq5ioAcUd0HshsPBxmg7tvw5SI+Ok7gMfq+/Pq+D+INNg5Iu
RqgFrMWaUqgUnSwglq+BIRGaZTU8FqFz0qMQarpvUhGTqOwxltT1O5ND8ANsLYZv
MElzB8yAGh5xtV6OorrX+emVOr2hjbAC+J8i7QW41qOLuSkziSLa8OHOkcIhypTw
AlZaLdugjLv3thOu9UkU
=Of19
-----END PGP SIGNATURE-----

--7l042bGvurpep9Wg--
