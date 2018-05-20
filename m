From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 01/26] rculist: introduce list_next_or_null_rr_rcu()
Date: Sat, 19 May 2018 17:43:18 -0700
Message-ID: <20180520004318.GY3803@linux.vnet.ibm.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
 <20180518130413.16997-2-roman.penyaev@profitbricks.com>
 <20180519163735.GX3803@linux.vnet.ibm.com>
 <CAJrWOzAt8BDtypaRwYx_y9jpCVD5W_VL9aQsFsC3bL-XaoJz9g@mail.gmail.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJrWOzAt8BDtypaRwYx_y9jpCVD5W_VL9aQsFsC3bL-XaoJz9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Penyaev <roman.penyaev@profitbricks.com>
Cc: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, Swapnil Ingle <swapnil.ingle@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, May 19, 2018 at 10:20:48PM +0200, Roman Penyaev wrote:
> On Sat, May 19, 2018 at 6:37 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Fri, May 18, 2018 at 03:03:48PM +0200, Roman Pen wrote:
> >> Function is going to be used in transport over RDMA module
> >> in subsequent patches.
> >>
> >> Function returns next element in round-robin fashion,
> >> i.e. head will be skipped.  NULL will be returned if list
> >> is observed as empty.
> >>
> >> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
> >> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >> Cc: linux-kernel@vger.kernel.org
> >> ---
> >>  include/linux/rculist.h | 19 +++++++++++++++++++
> >>  1 file changed, 19 insertions(+)
> >>
> >> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> >> index 127f534fec94..b0840d5ab25a 100644
> >> --- a/include/linux/rculist.h
> >> +++ b/include/linux/rculist.h
> >> @@ -339,6 +339,25 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
> >>  })
> >>
> >>  /**
> >> + * list_next_or_null_rr_rcu - get next list element in round-robin fashion.
> >> + * @head:    the head for the list.
> >> + * @ptr:        the list head to take the next element from.
> >> + * @type:       the type of the struct this is embedded in.
> >> + * @memb:       the name of the list_head within the struct.
> >> + *
> >> + * Next element returned in round-robin fashion, i.e. head will be skipped,
> >> + * but if list is observed as empty, NULL will be returned.
> >> + *
> >> + * This primitive may safely run concurrently with the _rcu list-mutation
> >> + * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
> >
> > Of course, all the set of list_next_or_null_rr_rcu() invocations that
> > are round-robining a given list must all be under the same RCU read-side
> > critical section.  For example, the following will break badly:
> >
> >         struct foo *take_rr_step(struct list_head *head, struct foo *ptr)
> >         {
> >                 struct foo *ret;
> >
> >                 rcu_read_lock();
> >                 ret = list_next_or_null_rr_rcu(head, ptr, struct foo, foolist);
> >                 rcu_read_unlock();  /* BUG */
> >                 return ret;
> >         }
> >
> > You need a big fat comment stating this, at the very least.  The resulting
> > bug can be very hard to trigger and even harder to debug.
> >
> > And yes, I know that the same restriction applies to list_next_rcu()
> > and friends.  The difference is that if you try to invoke those in an
> > infinite loop, you will be rapped on the knuckles as soon as you hit
> > the list header.  Without that knuckle-rapping, RCU CPU stall warnings
> > might tempt people to do something broken like take_rr_step() above.
> 
> Hi Paul,
> 
> I need -rr behaviour for doing IO load-balancing when I choose next RDMA
> connection from the list in order to send a request, i.e. my code is
> something like the following:
> 
>         static struct conn *get_and_set_next_conn(void)
>         {
>                 struct conn *conn;
> 
>                 conn = rcu_dereferece(rcu_conn);
>                 if (unlikely(!conn))
>                     return conn;

Wait.  Don't you need to restart from the beginning of the list in
this case?  Or does the list never have anything added to it and is
rcu_conn initially the first element in the list?

>                 conn = list_next_or_null_rr_rcu(&conn_list,
>                                                 &conn->entry,
>                                                 typeof(*conn),
>                                                 entry);
>                 rcu_assign_pointer(rcu_conn, conn);

Linus is correct to doubt this code.  You assign a pointer to the current
element to rcu_conn, which is presumably a per-CPU or global variable.
So far, so good ...

>                 return conn;
>         }
> 
>         rcu_read_lock();
>         conn = get_and_set_next_conn();
>         if (unlikely(!conn)) {
>                 /* ... */
>         }
>         err = rdma_io(conn, request);
>         rcu_read_unlock();

... except that some other CPU might well remove the entry referenced by
rcu_conn at this point.  It would have to wait for a grace period (e.g.,
synchronize_rcu()), but the current CPU has exited its RCU read-side
critical section, and therefore is not blocking the grace period.
Therefore, by the time get_and_set_next_conn() picks up rcu_conn, it
might well be referencing the freelist, or, even worse, some other type
of structure.

What is your code doing to prevent this from happening?  (There are ways,
but I want to know what you were doing in this case.)

> i.e. usage of the @next pointer is under an RCU critical section.
> 
> > Is it possible to instead do some sort of list_for_each_entry_rcu()-like
> > macro that makes it more obvious that the whole thing need to be under
> > a single RCU read-side critical section?  Such a macro would of course be
> > an infinite loop if the list never went empty, so presumably there would
> > be a break or return statement in there somewhere.
> 
> The difference is that I do not need a loop, I take the @next conn pointer,
> save it for the following IO request and do IO for current IO request.
> 
> It seems list_for_each_entry_rcu()-like with immediate "break" in the body
> of the loop does not look nice, I personally do not like it, i.e.:
> 
> 
>         static struct conn *get_and_set_next_conn(void)
>         {
>                 struct conn *conn;
> 
>                 conn = rcu_dereferece(rcu_conn);
>                 if (unlikely(!conn))
>                     return conn;
>                 list_for_each_entry_rr_rcu(conn, &conn_list,
>                                            entry) {
>                         break;
>                 }
>                 rcu_assign_pointer(rcu_conn, conn);
>                 return conn;
>         }
> 
> 
> or maybe I did not fully get your idea?

That would not help at all because you are still leaking the pointer out
of the RCU read-side critical section.  That is completely and utterly
broken unless you are somehow cleaning up rcu_conn when you remove
the element.  And getting that cleanup right is -extremely- tricky.
Unless you have some sort of proof of correctness, you will get a NACK
from me.

More like this:

	list_for_each_entry_rr_rcu(conn, &conn_list, entry) {
		do_something_with(conn);
		if (done_for_now())
			break;
	}

> >> + */
> >> +#define list_next_or_null_rr_rcu(head, ptr, type, memb) \
> >> +({ \
> >> +     list_next_or_null_rcu(head, ptr, type, memb) ?: \
> >> +             list_next_or_null_rcu(head, READ_ONCE((ptr)->next), type, memb); \
> >
> > Are there any uses for this outside of RDMA?  If not, I am with Linus.
> > Define this within RDMA, where a smaller number of people can more
> > easily be kept aware of the restrictions on use.  If it turns out to be
> > more generally useful, we can take a look at exactly what makes sense
> > more globally.
> 
> The only one list_for_each_entry_rcu()-like macro I am aware of is used in
> block/blk-mq-sched.c, is called list_for_each_entry_rcu_rr():
> 
> https://elixir.bootlin.com/linux/v4.17-rc5/source/block/blk-mq-sched.c#L370
> 
> Does it make sense to implement generic list_next_or_null_rr_rcu() reusing
> my list_next_or_null_rr_rcu() variant?

Let's start with the basics:  It absolutely does not make sense to leak
pointers across rcu_read_unlock() unless you have arranged something else
to protect the pointed-to data in the meantime.  There are a number of ways
of implementing this protection.  Again, what protection are you using?

Your code at the above URL looks plausible to me at first glance: You
do rcu_read_lock(), a loop with list_for_each_entry_rcu_rr(), then
rcu_read_unlock().  But at second glance, it looks like htcx->queue
might have the same vulnerability as rcu_conn in your earlier code.

							Thanx, Paul

> > Even within RDMA, I strongly recommend the big fat comment called out above.
> > And the list_for_each_entry_rcu()-like formulation, if that can be made to
> > work within RDMA's code structure.
> >
> > Seem reasonable, or am I missing something here?
> 
> Thanks for clear explanation.
> 
> --
> Roman
> 
