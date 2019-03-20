From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH -next] RDMA/hns: Make hns_roce_cmq_send static
Date: Wed, 20 Mar 2019 17:28:07 +0200
Message-ID: <20190320152807.GV4823@mtr-leonro.mtl.com>
References: <20190320135047.23184-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="I4VOKWutKNZEOIPu"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190320135047.23184-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--I4VOKWutKNZEOIPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 20, 2019 at 09:50:47PM +0800, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
>
> Fix sparse warning:
>
> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:1089:5:
>  warning: symbol 'hns_roce_cmq_send' was not declared. Should it be static?
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks for your patch, but such fix was already submitted.
https://patchwork.kernel.org/patch/10859135/

Thanks

--I4VOKWutKNZEOIPu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcklwHAAoJEORje4g2clinKrUP/AtHDfAKaNyFoPE102Vb8ekJ
9lOrywDsrqMhrJFVdyV8NXFA1whVvffuMeYatx17gg8gOL13uXiviVrpTyAc6mqN
7V7YYST1BRBIO+GXM3duaRD49Mx7ZnSe0EPfr4Pbbg9raVmSg4npaDsT4SwK5yt0
rZWGCEgCR7O33hfcprun9YXuB2OnfAK93jeFu1t9I/g8IEThbusue5j1uo7E5x7l
5BkAN2zAE56p/XMOsJbbEQKCUzqXgOrz0MTKavL2CVvweyvyrAJOyAORDqRUO/1n
AHZvLcSsuv8wcmSggT28Cz/3DhlCXBuHTwQ/Xi09Y1bRorQONKA8ValtaM/JlNW6
PmuNx8fhGuQtG2nRaNKtXp3SZHYH0tdekMbKjdACzVnjqiWJ4fsMDOkEnMAGeHEW
Qu6eeQYespX2c0xiLhBJWbhDhRhB6lNbS6CrexK+XX3/FwPDUBg2OdA2kkp9I7Ho
6o85zwbjDVfxFIKenJU1uZMg/G/ZynbYGAKR8FU5WFgfWjz9fnJr2nZ39+igWvgy
LbIeRw9i8RqgUfqIKA5iPxZUqjaI1L+ES02J6Ne/thK7Fc1sCQdRdwhrJVSjgZDI
WWZeC5mZ7Zcx/zZ1Yk86lyS9f6naes6LZfq5CD/T5MZ0+1iutr7iTjN+/vhr9McS
m1y3GyAn52qhPnZKsad1
=Ntm2
-----END PGP SIGNATURE-----

--I4VOKWutKNZEOIPu--
