From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Add wait/retry version of ibnl_unicast
Date: Wed, 28 Jun 2017 15:30:03 -0500
Message-ID: <20170628203003.GA23300@ctung-MOBL3.amr.corp.intel.com>
References: <1498658565-3408-1-git-send-email-mustafa.ismail@intel.com>
 <20170628141211.GA16312@ctung-MOBL3.amr.corp.intel.com>
 <20170628153639.GF1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170628153639.GF1248-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 28, 2017 at 06:36:39PM +0300, Leon Romanovsky wrote:
> On Wed, Jun 28, 2017 at 09:12:11AM -0500, Chien Tin Tung wrote:
> > On Wed, Jun 28, 2017 at 09:02:45AM -0500, Mustafa Ismail wrote:
> > > Add a wait/retry version of ibnl_unicast, ibnl_unicast_wait,
> > > and modify ibnl_unicast to not wait/retry.  This eliminates
> > > the undesirable wait for future users of ibnl_unicast.
> > >
> > > Change Portmapper calls originating from kernel to user-space
> > > to use ibnl_unicast_wait and take advantage of the wait/retry
> > > logic in netlink_unicast.
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/iwpm_msg.c |  6 +++---
> > >  drivers/infiniband/core/netlink.c  | 12 +++++++++++-
> > >  include/rdma/rdma_netlink.h        | 10 ++++++++++
> > >  3 files changed, 24 insertions(+), 4 deletions(-)
> >
> > Please apply this patch instead of Leon's patch to revert
> > "IB/core: Add flow control to the portmapper netlink calls".
> >
> > Leon, we can work out names and parameters if this works for you.
> 
> Chien,
> 
> The names are less my worries with this patch. First of all, it misleads
> by using wait/retry naming, because it blocks and not waits.

Nope.  It does a single shot retry and waits in a waitqueue.
Go look at netlink_unicast and in turn netlink_attachskb.  If you still
disagree, please flag specific code where it blocks.

Here are the two functions for your convenience.


int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
                    u32 portid, int nonblock)
{
        struct sock *sk;
        int err;
        long timeo;

        skb = netlink_trim(skb, gfp_any());

        timeo = sock_sndtimeo(ssk, nonblock);
retry:
        sk = netlink_getsockbyportid(ssk, portid);
        if (IS_ERR(sk)) {
                kfree_skb(skb);
                return PTR_ERR(sk);
        }
        if (netlink_is_kernel(sk))
                return netlink_unicast_kernel(sk, skb, ssk);

        if (sk_filter(sk, skb)) {
                err = skb->len;
                kfree_skb(skb);
                sock_put(sk);
                return err;
        }

        err = netlink_attachskb(sk, skb, &timeo, ssk);
        if (err == 1)
                goto retry;
        if (err)
                return err;

        return netlink_sendskb(sk, skb);
}

/*
 * Attach a skb to a netlink socket.
 * The caller must hold a reference to the destination socket. On error, the
 * reference is dropped. The skb is not send to the destination, just all
 * all error checks are performed and memory in the queue is reserved.
 * Return values:
 * < 0: error. skb freed, reference to sock dropped.
 * 0: continue
 * 1: repeat lookup - reference dropped while waiting for socket memory.
 */
int netlink_attachskb(struct sock *sk, struct sk_buff *skb,
                      long *timeo, struct sock *ssk)
{
        struct netlink_sock *nlk;

        nlk = nlk_sk(sk);

        if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
             test_bit(NETLINK_S_CONGESTED, &nlk->state))) {
                DECLARE_WAITQUEUE(wait, current);
                if (!*timeo) {
                        if (!ssk || netlink_is_kernel(ssk))
                                netlink_overrun(sk);
                        sock_put(sk);
                        kfree_skb(skb);
                        return -EAGAIN;
                }

                __set_current_state(TASK_INTERRUPTIBLE);
                add_wait_queue(&nlk->wait, &wait);

                if ((atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
                     test_bit(NETLINK_S_CONGESTED, &nlk->state)) &&
                    !sock_flag(sk, SOCK_DEAD))
                        *timeo = schedule_timeout(*timeo);

                __set_current_state(TASK_RUNNING);
                remove_wait_queue(&nlk->wait, &wait);
                sock_put(sk);

                if (signal_pending(current)) {
                        kfree_skb(skb);
                        return sock_intr_errno(*timeo);
                }
                return 1;
        }
        netlink_skb_set_owner_r(skb, sk);
        return 0;
}


BTW, _nobody_ is resetting the socket attribute from O_NONBLOCK.

It is very difficult to understand your argument of "blocking" when you are not
sharing the specifics.  Please put your finger on it so everyone can understand
your point.

> The second, I disagree with solution in kernel for user space application which can't
> handle the netlink errors.

There is no guarantee delivery nor blocking on send.  Like I mentioned above,
it is a 1 shot retry with a set wait time.  The code obviousely handles error
condition as it can happen.


Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
