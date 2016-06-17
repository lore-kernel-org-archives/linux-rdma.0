From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] mlx5: fix 64-bit division on times
Date: Fri, 17 Jun 2016 17:24:40 +0200
Message-ID: <7479054.ALBOnYT4q2@wuerfel>
References: <20160615152816.2800830-1-arnd@arndb.de> <20160615152816.2800830-2-arnd@arndb.de> <CALzJLG9S_Q37ErepBm-7rm7vVdEZH-1gXbay+zpveHSYhpPi5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALzJLG9S_Q37ErepBm-7rm7vVdEZH-1gXbay+zpveHSYhpPi5A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Achiad Shochat <achiad@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, Gal Pressman <galp@mellanox.com>, Maor Gottlieb <maorg@mellanox.com>, Huy Nguyen <huyn@mellanox.com>, Linux Netdev List <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Friday, June 17, 2016 6:09:00 PM CEST Saeed Mahameed wrote:
> On Wed, Jun 15, 2016 at 6:27 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > The mlx5 driver fails to build on 32-bit architectures after some
> > references to 64-bit divisions got added:
> >
> > drivers/net/built-in.o: In function `mlx5e_rx_am':
> > :(.text+0xf88ac): undefined reference to `__aeabi_ldivmod'
> >
> > The driver even performs three division here, and it uses the
> > obsolete 'struct timespec' that we want to get rid of.
> >
> > Using ktime_t and ktime_us_delta() replaces one of the divisions
> > and is mildly more efficient, aside from working across 'settimeofday'
> > calls and being the right type for the y2038 conversion.
> >
> > Using a u32 instead of s64 to store the number of microseconds
> > limits the maximum time to about 71 minutes, but if we exceed that
> > time, we probably don't care about the result any more for the
> > purpose of rx coalescing.
> >
> > For the number of packets, we are taking the difference between
> > two 'unsigned int', so the result won't ever be greater than that
> > either.
> >
> > After those changes, the other two divisions are done as 32-bit
> > arithmetic operations, which are much faster.
> 
> Nice catch Arnd,  we originally fixed this with div_u64, but your
> solution looks wiser.
> does ktime_t gives time in a resolution same as timespec ?

ktime_t is a 64-bit nanosecond counter, so the resolution is the same
as ktime_get_ts64(), which is the "monotonic" equivalent of
getnstimeofday().

There are also variants that have the same resolution but are
less accurate and don't set the exact lower bits in order to
get a faster reading, but the above are all as accurate as the machine
allows.

	Arnd
