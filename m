From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] mlx4: Use kernel sizeof and alloc styles
Date: Sun, 04 Dec 2016 12:58:59 -0800
Message-ID: <1480885139.18162.484.camel@edumazet-glaptop3.roam.corp.google.com>
References: <8b20668cb08cce8b4af872863440e149bd25fa94.1480882180.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <8b20668cb08cce8b4af872863440e149bd25fa94.1480882180.git.joe@perches.com>
Sender: netdev-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2016-12-04 at 12:11 -0800, Joe Perches wrote:
> Convert sizeof foo to sizeof(foo) and allocations with multiplications
> to the appropriate kcalloc/kmalloc_array styles.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Gah.

This is one of the hotest NIC driver on linux at this moment, 
with XDP and other efforts going on.

Some kmalloc() are becoming kmalloc_node() in some dev branches, and
there is no kmalloc_array_node() yet.

This kind of patch is making rebases/backports very painful.

Could we wait ~6 months before doing such cleanup/changes please ?

If you believe a bug needs a fix, please send a patch to address it.

Thanks.
