From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 07/10] net/mlx5: E-Switch, Change vhca id valid
 bool field to bit flag
Date: Mon, 10 Dec 2018 16:12:22 +0000
Message-ID: <20181210161216.GF3459@mellanox.com>
References: <20181210030442.7543-1-saeedm@mellanox.com>
 <20181210030442.7543-8-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210030442.7543-8-saeedm@mellanox.com>
Content-Language: en-US
Content-ID: <BDB9E507F4D64E46B26584B2849520BD@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Eli Britstein <elibr@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 09, 2018 at 07:04:39PM -0800, Saeed Mahameed wrote:
> From: Eli Britstein <elibr@mellanox.com>
>=20
> Change the driver flow destination struct to use bit flags with the vhca
> id valid being the 1st one. Done to avoid bool fields in structs, as
> warned by static checkers, with no functionality change.

This is a thing now? I thought the warning was not to use bool with
bitfields for some reason?

Jason
