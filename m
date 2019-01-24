From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH rdma-next 00/12] Add SRQ and XRC support for ODP MRs
Date: Thu, 24 Jan 2019 12:25:12 +0000
Message-ID: <20190124122509.GR3604@mtr-leonro.mtl.com>
References: <20190122064851.6032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122064851.6032-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2019 at 08:48:39AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> This series extend ODP to work with SRQ and XRC. Being both per-operation
> (e.g. RDMA write, RDMA read and atomic) and per-transport (e.g. RC, UD and XRC),
> we extend IB/core and mlx5 driver to provide needed information to user space.
>
> Thanks
>
> Moni Shoua (12):
>   IB/mlx5: Fix locking SRQ object in ODP event
>   IB/core: Allocate bit for SRQ ODP support
>   IB/uverbs: Expose XRC ODP device capabilities
>   IB/mlx5: Remove useless check in ODP handler
>   IB/mlx5: Clean mlx5_ib_mr_responder_pfault_handler() signature
>   IB/mlx5: Add XRC initiator ODP support
>   IB/mlx5: Let read user wqe also from SRQ buffer
>   IB/mlx5: Add ODP SRQ support
>   IB/mlx5: Advertise SRQ ODP support for supported transports
>   net/mlx5: Add XRC transport to ODP device capabilities layout
>   IB/mlx5: Advertise XRC ODP support
>   net/mlx5: Set ODP SRQ support in firmware


Doug, Jason,

Please pay attention that patches below should go to shared branch:
net/mlx5: Add XRC transport to ODP device capabilities layout
net/mlx5: Set ODP SRQ support in firmware

Thanks

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcSa6lAAoJEORje4g2clinMgwQAKFZvRh+fscAAyxr24npqTiH
3+V7fdKxPAyx6nZLvbrr7gWmG3wLBVWBSZMFtBPeZLIMymIrHkoyfL7IcLlfCBGT
dDbuQl7+qFeyrJgMUznCdQwC40Un2Uyd3uoEL/Mmyth+FxaKh19Q9XTEcr9B8bTf
caBt3gPv44x4KdRxc92FQWfGakpIIja7frCuA2NvHJZIt17rubyJzcjXKaCQILBl
6oepIvVhLONwYyQKxJTViMkx8P6AJrwdZ1kAE1XLlNU+eJ4Da8y0CgXtJ1i41qBt
gTSyK1k9BIJ84ASp/RZ/BKCyeaoQOcJp58fQuRRc8QV4+xJVGAa9std0ufUokMxx
YQxVcZMj4/vUOVHgJqdPaoZ3WsRiTfKVKk1IHiNwpKfusMi5LrQbrXGovUqycdIN
83ObhI90cp9usU9/8w47xo0ibCvF1Y75sdRsMe9wusWDPA9fFbjT0WywuFUVMhlS
YVFmTVEnAuTiw5LErtbHgh4HUqnaq1OEcw3S2Yz2G22USN69lTc2IoqF72Z+AaID
twMdpqn0FVhlVQ1M/6P48mqzLeB8kEJmW6/x4cji/0JH3mPINQSk8RBygXad0+YF
ZvX8YvO1jrcXQ0y0QvwTDg/OiJH+P8bBUWe1wz8DBbHc8kHQAB27Tv1nKRV4chDB
gpfG+aEODXtW8LHzDmOK
=Wyzd
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
