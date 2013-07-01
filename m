From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH for-next 0/8] Add Mellanox mlx5 driver for Connect-IB devices
Date: Mon, 1 Jul 2013 11:11:50 -0700
Message-ID: <CAL1RGDW_Z06ZqpOhz3tAkKn=rpLEZE6hWZkLNd9OQgCbrX6YAg@mail.gmail.com>
References: <1371384149-24558-1-git-send-email-eli@dev.mellanox.co.il>
 <CAJZOPZ+NQa3CWnw3rZQh2UuwdrNhiwtVSyuk9D9YtwfQQ9e1XA@mail.gmail.com>
 <CAJZOPZKLb9k1xXkTnrtzYKpwrSJDQgBpONUVCp3et36JeaEi-Q@mail.gmail.com>
 <CAL1RGDX5mHj5oVqFhQ4Ssr25jpL4rV2Tv=zXvLOZfwupJ0gqJw@mail.gmail.com> <1372701839.2481.3.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1372701839.2481.3.camel@joe-AO722>
Sender: netdev-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, Eli Cohen <eli@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Eli Cohen <eli@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 1, 2013 at 11:03 AM, Joe Perches <joe@perches.com> wrote:
> There's some value in block enabling/disabling messages
> that dynamic_debug doesn't currently offer.

As far as I can see, the mlx5 stuff ends up being per-file.  Which
dynamic debug already does offer.

 - R.
