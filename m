From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH mlx5-next v1 1/8] net/mlx5: Add forward compatible support
 for the FTE match data
Date: Thu, 12 Jul 2018 23:53:54 +0300
Message-ID: <CAJ3xEMipJhe0PdsmR7kshrG-dXSqaLJ5xorwbMZyBvdXy0jA0A@mail.gmail.com>
References: <20180711111045.6282-1-leon@kernel.org> <20180711111045.6282-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180711111045.6282-2-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 11, 2018 at 2:10 PM, Leon Romanovsky <leon@kernel.org> wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>
> Use the PRM size including the reserved when working with the FTE
> match data.

is this actually a bug fix?

> This comes to support forward compatibility for cases that current
> reserved data will be exposed by the firmware and could be used by an
> application by DEVX without changing the kernel.

something went wrong in the phrasing/wording of "used by an application by DEVX"
I can't follow on that part of the sentence, please try to improve/fix it.

> Also drop some driver checks around the match criteria leaving the work
> for firmware to enable forward compatibility for future bits there.

not following,

OTOH we can always patch the kernel to add new bits for checking, why
remove these checks?

OTOH, suppose today we check that one of four bits is set and now one
added bit #5 and the
kernel doesn't check it, what removing the existing four checks buys you?
