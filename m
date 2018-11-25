From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: remove unsafe skb_insert()
Date: Sun, 25 Nov 2018 10:29:36 -0800 (PST)
Message-ID: <20181125.102936.907000798531091562.davem@davemloft.net>
References: <20181125162623.127762-1-edumazet@google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181125162623.127762-1-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
To: edumazet@google.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, faisal.latif@intel.com, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sun, 25 Nov 2018 08:26:23 -0800

> I do not see how one can effectively use skb_insert() without holding
> some kind of lock. Otherwise other cpus could have changed the list
> right before we have a chance of acquiring list->lock.
> 
> Only existing user is in drivers/infiniband/hw/nes/nes_mgt.c and this
> one probably meant to use __skb_insert() since it appears nesqp->pau_list
> is protected by nesqp->pau_lock. This looks like nesqp->pau_lock
> could be removed, since nesqp->pau_list.lock could be used instead.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Good find.

Indeed, any of the queue SKB manipulation functions that take two SKBs
as an argument are suspect in this manner.

Applied, thanks Eric.
