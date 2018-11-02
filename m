From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] net/mlx5e: fix high stack usage
Date: Fri, 2 Nov 2018 17:23:26 +0100
Message-ID: <CAK8P3a2pvkfR1A6dHAMm8ETd13E1LSxXrEsQHSOFYWbr-7R2Sw@mail.gmail.com>
References: <20181102153316.1492515-1-arnd@arndb.de> <20181102160858.GA17096@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102160858.GA17096@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Tariq Toukan <tariqt@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>, Boris Pismenny <borisp@mellanox.com>, Ilya Lesokhin <ilyal@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>, Kamal Heib <kamalh@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 11/2/18, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Fri, Nov 02, 2018 at 04:33:03PM +0100, Arnd Bergmann wrote:
>> A patch that looks harmless causes the stack usage of the
>> mlx5e_grp_sw_update_stats()
>> function to drastically increase with x86 gcc-4.9 and higher (tested up =
to
>> 8.1):
>>
>> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function
>> =E2=80=98mlx5e_grp_sw_update_stats=E2=80=99:
>> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:216:1: warning: the
>> frame size of 1276 bytes is larger than 500 bytes [-Wframe-larger-than=
=3D]
>
> Why is the stack size so big here? The mlx5e_sw_stats is < 500 bytes
> and all the other on-stack stuff looks pretty small?

I am not entirely sure, but my analysis indicates that gcc tries loop unrol=
ling
or some other optimization that leads to two copies on the stack.

>> By splitting out the loop body into a non-inlined function, the stack si=
ze
>> goes
>> back down to under 500 bytes.
>
> Does this actually reduce the stack consumed or does this just suppress
> the warning?

It definitely reduces the total stack usage, the separate functions just
had the expected stack usage that was a few hundred bytes combined.

       Arnd
