From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH mlx5-next v1 1/8] net/mlx5: Add forward compatible support
 for the FTE match data
Date: Sun, 15 Jul 2018 11:03:11 +0300
Message-ID: <CAJ3xEMhO_89Fxj3=2=pas_R_9M6sPXOPu0V3saBaqeJ3j+-hkw@mail.gmail.com>
References: <20180711111045.6282-1-leon@kernel.org> <20180711111045.6282-2-leon@kernel.org>
 <CAJ3xEMipJhe0PdsmR7kshrG-dXSqaLJ5xorwbMZyBvdXy0jA0A@mail.gmail.com> <84e6a046-881d-65ce-ab58-2ed9691cc864@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <84e6a046-881d-65ce-ab58-2ed9691cc864@dev.mellanox.co.il>
Sender: netdev-owner@vger.kernel.org
To: Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 15, 2018 at 10:26 AM, Yishai Hadas
<yishaih@dev.mellanox.co.il> wrote:
> On 7/12/2018 11:53 PM, Or Gerlitz wrote:
>> On Wed, Jul 11, 2018 at 2:10 PM, Leon Romanovsky <leon@kernel.org> wrote:
>>> From: Yishai Hadas <yishaih@mellanox.com>

>>> Use the PRM size including the reserved when working with the FTE
>>> match data.

>> is this actually a bug fix?

> No, it's some requirement from the new API to enable forward compatible
> support without changing the kernel code.

ok, but

>>> Also drop some driver checks around the match criteria leaving the work
>>> for firmware to enable forward compatibility for future bits there.

>> not following,

> Same as for the 'reserved' field but also for extending the 'match criteria'
> field with new bits without changing the kernel.

-- we need a clear memo as part of your change-logs and/or cover-letter/s that
explains the overall approach/design for
doing-things-without-changing-the-kernel,
does this exist? the arch/approach need not be deciphered from the
code or change logs
snapshots but rather stated clearly.
