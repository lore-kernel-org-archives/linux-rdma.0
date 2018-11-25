From: Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: remove unsafe skb_insert()
Date: Sun, 25 Nov 2018 15:37:43 -0800
Message-ID: <CANn89i+mEYyLWt74jK-0ruUjHafgAPMdFKJGgM37B-iuZzk12g@mail.gmail.com>
References: <20181125162623.127762-1-edumazet@google.com> <20181125.102936.907000798531091562.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181125.102936.907000798531091562.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, faisal.latif@intel.com, Doug Ledford <dledford@redhat.com>, jgg@ziepe.ca, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 25, 2018 at 10:29 AM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Sun, 25 Nov 2018 08:26:23 -0800
>
> > I do not see how one can effectively use skb_insert() without holding
> > some kind of lock. Otherwise other cpus could have changed the list
> > right before we have a chance of acquiring list->lock.
> >
> > Only existing user is in drivers/infiniband/hw/nes/nes_mgt.c and this
> > one probably meant to use __skb_insert() since it appears nesqp->pau_list
> > is protected by nesqp->pau_lock. This looks like nesqp->pau_lock
> > could be removed, since nesqp->pau_list.lock could be used instead.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> Good find.
>
> Indeed, any of the queue SKB manipulation functions that take two SKBs
> as an argument are suspect in this manner.
>
> Applied, thanks Eric.

Oh well, this does not build.

Since you have not pushed your tree yet, maybe we can replace this
with a version that actually compiles.

Please let me know if a relative patch or a v2 is needed, thanks.
