From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 3/5] RDMA/hns: Increase checking CMQ status
 timeout value
Date: Wed, 23 May 2018 09:23:46 +0300
Message-ID: <20180523062346.GB5729@mtr-leonro.mtl.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-4-git-send-email-xavier.huwei@huawei.com>
 <20180523054918.GB2933@mtr-leonro.mtl.com>
 <5B0505A9.8040908@huawei.com>
 <5B050714.2040205@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B050714.2040205@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2018 at 02:15:48PM +0800, Wei Hu (Xavier) wrote:
>
>
> On 2018/5/23 14:09, Wei Hu (Xavier) wrote:
> >
> > On 2018/5/23 13:49, Leon Romanovsky wrote:
> >> On Thu, May 17, 2018 at 04:02:51PM +0800, Wei Hu (Xavier) wrote:
> >>> This patch increases checking CMQ status timeout value and
> >>> uses the same value with NIC driver to avoid deficiency of
> >>> time.
> >>>
> >>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
> >>> ---
> >>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
> >>> index 182b672..f16df1b 100644
> >>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
> >>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
> >>> @@ -76,7 +76,7 @@
> >>>  #define HNS_ROCE_V2_PAGE_SIZE_SUPPORTED		0xFFFFF000
> >>>  #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
> >>>  #define HNS_ROCE_INVALID_LKEY			0x100
> >>> -#define HNS_ROCE_CMQ_TX_TIMEOUT			200
> >>> +#define HNS_ROCE_CMQ_TX_TIMEOUT			30000
> >> Don't you think that loop of 30 seconds too much?
> >>
> >> Thanks
> > Leon, 30ms
> Because firmware take turns excuting NIC and RoCE command.
> Although RoCE command does not  take so long,  we still use
> the same timeout value with NIC driver.

Sorry, you are right it is 30ms and not 30s.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbBQjyAAoJEORje4g2clinxMkQAIJ5hCq4bFowGwpaaSdlwkp8
gy9JTUMq7a456zR3NQJ2iaU0rF1tWAr4mI3FcGjTCYTpbrPdBpM54z4xBF/vmqI8
xNG2WWE91FwCw1YsJ9Hl5YC1cQ16J5Ot0vKOWKUbIGJjXEzmxsegGUL/LfpzXoRn
chEh0Jikt0+zQcUMdIqurFzAoqC8jXXL3m4Idos7YfZc/J1krSBc2b5TfdfgLODB
E6LimI2xoJnUzIjYamGu7jYFMzwPSoW9ThdVbstk5rQLkX7UfrBmnMIN7kwdx7GG
LEaX8cZnHbqN+XtXAwPXmToRbPjyfozdrBNAMlpaNdvdlzk6LM3OcwQX6r7JrE9K
V5YoTyhaYFqENw3FmapMNo9PKwziqrHFAveDXCTRPQLY6vqMbSIqpVWtD7FH6ztl
NMKtmthJZGxMUAXAzSqb6o/j++sLAxeppg3OdNEBod7wFa7fU/2ztWRg2Uq0OgrN
LeuQSoGjKZwLyGYqzO6Dz4wANdDXn6aAEfoFIULeDhQTp/S7NYudEPmEVrl+rINA
YDQsfD3Qvix1e9T6tHgcRvf27uR5KoClDNcvnK/RsqJR0X2dXlFUCVs8Oh4Kpo4j
715XNsOO4tmF6gVzzDnUXLrtqR0gvesjyRQNkAQNPlIzF+RPywn8nhHKbSft0TA1
0WIvHlQWjnap7xVz/s7Z
=8nhN
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
