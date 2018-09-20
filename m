From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH mlx5-next v1 7/7] net/mlx5: Update mlx5_ifc with DEVX UID bits
Date: Thu, 20 Sep 2018 23:11:41 +0300
Message-ID: <CAJ3xEMjeoKXYRcuirSb0+M0E8UZQA+qTMnVaLcufGn8JdpeFAQ@mail.gmail.com>
References: <20180920183526.13995-1-leon@kernel.org> <20180920183526.13995-8-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920183526.13995-8-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 20, 2018 at 9:35 PM, Leon Romanovsky wrote:
> Add DEVX information to WQ, SRQ, CQ, TRI, TIS, QP,
> RQ, XRCD, PD, MKEY and MCG.

typo - TRI --> TIR

"DEVX information" is a bit cryptic - what does xxx_valid means
for the devx use case (fw command is issued by devx process) - and
what semantics does it have for non-devx callers -- e.g the Eth driver when
they deal with tir/tis/etc

Explain and elaborate further at the change log

Or.
