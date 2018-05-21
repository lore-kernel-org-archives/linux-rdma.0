From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 01/26] rculist: introduce list_next_or_null_rr_rcu()
Date: Mon, 21 May 2018 08:31:51 -0700
Message-ID: <20180521153151.GE3803@linux.vnet.ibm.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
 <20180518130413.16997-2-roman.penyaev@profitbricks.com>
 <20180519163735.GX3803@linux.vnet.ibm.com>
 <CAJrWOzAt8BDtypaRwYx_y9jpCVD5W_VL9aQsFsC3bL-XaoJz9g@mail.gmail.com>
 <20180520004318.GY3803@linux.vnet.ibm.com>
 <CAJrWOzBenkHg_5zs1VAxP_rVbCbOJO_eO0toJBhnzXuy_yWH2Q@mail.gmail.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJrWOzBenkHg_5zs1VAxP_rVbCbOJO_eO0toJBhnzXuy_yWH2Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Penyaev <roman.penyaev@profitbricks.com>
Cc: linux-block <linux-block@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, Swapnil Ingle <swapnil.ingle@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 21, 2018 at 03:50:10PM +0200, Roman Penyaev wrote:
> On Sun, May 20, 2018 at 2:43 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Sat, May 19, 2018 at 10:20:48PM +0200, Roman Penyaev wrote:
> >> On Sat, May 19, 2018 at 6:37 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Fri, May 18, 2018 at 03:03:48PM +0200, Roman Pen wrote:
> >> >> Function is going to be used in transport over RDMA module
> >> >> in subsequent patches.
> >> >>
> >> >> Function returns next element in round-robin fashion,
> >> >> i.e. head will be skipped.  NULL will be returned if list
> >> >> is observed as empty.
> >> >>
> >> >> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
> >> >> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >> >> Cc: linux-kernel@vger.kernel.org
> >> >> ---
> >> >>  include/linux/rculist.h | 19 +++++++++++++++++++
> >> >>  1 file changed, 19 insertions(+)
> >> >>
> >> >> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> >> >> index 127f534fec94..b0840d5ab25a 100644
> >> >> --- a/include/linux/rculist.h
> >> >> +++ b/include/linux/rculist.h
> >> >> @@ -339,6 +339,25 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
> >> >>  })
> >> >>
> >> >>  /**
> >> >> + * list_next_or_null_rr_rcu - get next list element in round-robin fashion.
> >> >> + * @head:    the head for the list.
> >> >> + * @ptr:        the list head to take the next element from.
> >> >> + * @type:       the type of the struct this is embedded in.
> >> >> + * @memb:       the name of the list_head within the struct.
> >> >> + *
> >> >> + * Next element returned in round-robin fashion, i.e. head will be skipped,
> >> >> + * but if list is observed as empty, NULL will be returned.
> >> >> + *
> >> >> + * This primitive may safely run concurrently with the _rcu list-mutation
> >> >> + * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
> >> >
> >> > Of course, all the set of list_next_or_null_rr_rcu() invocations that
> >> > are round-robining a given list must all be under the same RCU read-side
> >> > critical section.  For example, the following will break badly:
> >> >
> >> >         struct foo *take_rr_step(struct list_head *head, struct foo *ptr)
> >> >         {
> >> >                 struct foo *ret;
> >> >
> >> >                 rcu_read_lock();
> >> >                 ret = list_next_or_null_rr_rcu(head, ptr, struct foo, foolist);
> >> >                 rcu_read_unlock();  /* BUG */
> >> >                 return ret;
> >> >         }
> >> >
> >> > You need a big fat comment stating this, at the very least.  The resulting
> >> > bug can be very hard to trigger and even harder to debug.
> >> >
> >> > And yes, I know that the same restriction applies to list_next_rcu()
> >> > and friends.  The difference is that if you try to invoke those in an
> >> > infinite loop, you will be rapped on the knuckles as soon as you hit
> >> > the list header.  Without that knuckle-rapping, RCU CPU stall warnings
> >> > might tempt people to do something broken like take_rr_step() above.
> >>
> >> Hi Paul,
> >>
> >> I need -rr behaviour for doing IO load-balancing when I choose next RDMA
> >> connection from the list in order to send a request, i.e. my code is
> >> something like the following:
> >>
> >>         static struct conn *get_and_set_next_conn(void)
> >>         {
> >>                 struct conn *conn;
> >>
> >>                 conn = rcu_dereferece(rcu_conn);
> >>                 if (unlikely(!conn))
> >>                     return conn;
> >
> > Wait.  Don't you need to restart from the beginning of the list in
> > this case?  Or does the list never have anything added to it and is
> > rcu_conn initially the first element in the list?
> 
> Hi Paul,
> 
> No, I continue from the pointer, which I assigned on the previous IO
> in order to send IO fairly and keep load balanced.
> 
> Initially @rcu_conn points to the first element, but elements can
> be deleted from the list and list can become empty.
> 
> The deletion code is below.
> 
> >
> >>                 conn = list_next_or_null_rr_rcu(&conn_list,
> >>                                                 &conn->entry,
> >>                                                 typeof(*conn),
> >>                                                 entry);
> >>                 rcu_assign_pointer(rcu_conn, conn);
> >
> > Linus is correct to doubt this code.  You assign a pointer to the current
> > element to rcu_conn, which is presumably a per-CPU or global variable.
> > So far, so good ...
> 
> I use per-CPU, in the first example I did not show that not to overcomplicate
> the code.
> 
> >
> >>                 return conn;
> >>         }
> >>
> >>         rcu_read_lock();
> >>         conn = get_and_set_next_conn();
> >>         if (unlikely(!conn)) {
> >>                 /* ... */
> >>         }
> >>         err = rdma_io(conn, request);
> >>         rcu_read_unlock();
> >
> > ... except that some other CPU might well remove the entry referenced by
> > rcu_conn at this point.  It would have to wait for a grace period (e.g.,
> > synchronize_rcu()), but the current CPU has exited its RCU read-side
> > critical section, and therefore is not blocking the grace period.
> > Therefore, by the time get_and_set_next_conn() picks up rcu_conn, it
> > might well be referencing the freelist, or, even worse, some other type
> > of structure.
> >
> > What is your code doing to prevent this from happening?  (There are ways,
> > but I want to know what you were doing in this case.)
> 
> Probably I should have shown the way of removal at the very beginning,
> my fault.  So deletion looks as the following (a bit changed and
> simplified for the sake of clearness):

Thank you!  Let's see...

>         static void remove_connection(conn)
>         {
>                 bool need_to_wait = false;
>                 int cpu;
> 
>                 /* Do not let RCU list add/delete happen in parallel */
>                 mutex_lock(&conn_lock);
> 
>                 list_del_rcu(&conn->entry);
> 
>                 /* Make sure everybody observes element removal */
>                 synchronize_rcu();

At this point, any reader who saw the element in the list is done, as you
comment in fact says.  But there might be a pointer to that element in the
per-CPU variables, however, from this point forward it cannot be the case
that one of the per-CPU variables gets set to the newly deleted element.
Which is your next block of code...

>                 /*
>                  * At this point nobody sees @conn in the list, but
> still we have
>                  * dangling pointer @rcu_conn which _can_ point to @conn.  Since
>                  * nobody can observe @conn in the list, we guarantee
> that IO path
>                  * will not assign @conn to @rcu_conn, i.e. @rcu_conn
> can be equal
>                  * to @conn, but can never again become @conn.
>                  */
> 
>                 /*
>                  * Get @next connection from current @conn which is going to be
>                  * removed.
>                  */
>                 next = list_next_or_null_rr_rcu(&conn_list, &conn->entry,
>                                                 typeof(*next), entry);
> 
>                 /*
>                  * Here @rcu_conn can be changed by reader side, so use @cmpxchg
>                  * in order to keep fairness in load-balancing and do not touch
>                  * the pointer which can be already changed by the IO path.
>                  *
>                  * Current path can be faster than IO path and the
> following race
>                  * exists:
>                  *
>                  *   CPU0                         CPU1
>                  *   ----                         ----
>                  *   conn = rcu_dereferece(rcu_conn);
>                  *   next = list_next_or_null_rr_rcu(conn)
>                  *
>                  *                                conn ==
> cmpxchg(rcu_conn, conn, next);
>                  *                                synchronize_rcu();
>                  *
>                  *   rcu_assign_pointer(rcu_conn, next);
>                  *   ^^^^^^^^^^^^^^^^^^
>                  *
>                  *   Here @rcu_conn is already equal to @next (done by
> @cmpxchg),
>                  *   so assignment to the same pointer is harmless.
>                  *
>                  */
>                 for_each_possible_cpu(cpu) {
>                         struct conn **rcu_conn;
> 
>                         rcu_conn = per_cpu_ptr(pcpu_rcu_conn, cpu);
>                         if (*rcu_conn != conn)
>                                 /*
>                                  * This @cpu will never again pick up @conn,
>                                  * so it is safe just to choose next CPU.
>                                  */
>                                 continue;

... Someone else might have picked up rcu_conn at this point...

>                         if (conn == cmpxchg(rcu_conn, conn, next))
>                                 /*
>                                  * @rcu_conn was successfully replaced
> with @next,
>                                  * that means that someone can also hold a @conn
>                                  * and dereferencing it, so wait for a
> grace period
>                                  * is required.
>                                  */
>                                 need_to_wait = true;

... But if there was any possibility of that, need_to_wait is true, and it
still cannot be the case that a reader finds the newly deleted element
in the list, so they cannot find that element, so the pcpu_rcu_conn
variables cannot be set to it.

>                 }
>                 if (need_to_wait)
>                         synchronize_rcu();

And at this point, the reader that might have picked up rcu_conn
just before the cmpxchg must have completed.  (Good show, by the way!
Many people miss the fact that they need this second synchronize_rcu().)

Hmmm...  What happens if this was the last element in the list, and
the relevant pcpu_rcu_conn variable references that newly removed
element?  Taking a look at list_next_or_null_rcu() and thus at
list_next_or_null_rcu(), and it does appear that you get NULL in that
case, as is right and good.

>                 mutex_unlock(&conn_lock);
> 
>                 kfree(conn);
>         }
> 
> 
> >
> >> i.e. usage of the @next pointer is under an RCU critical section.
> >>
> >> > Is it possible to instead do some sort of list_for_each_entry_rcu()-like
> >> > macro that makes it more obvious that the whole thing need to be under
> >> > a single RCU read-side critical section?  Such a macro would of course be
> >> > an infinite loop if the list never went empty, so presumably there would
> >> > be a break or return statement in there somewhere.
> >>
> >> The difference is that I do not need a loop, I take the @next conn pointer,
> >> save it for the following IO request and do IO for current IO request.
> >>
> >> It seems list_for_each_entry_rcu()-like with immediate "break" in the body
> >> of the loop does not look nice, I personally do not like it, i.e.:
> >>
> >>
> >>         static struct conn *get_and_set_next_conn(void)
> >>         {
> >>                 struct conn *conn;
> >>
> >>                 conn = rcu_dereferece(rcu_conn);
> >>                 if (unlikely(!conn))
> >>                     return conn;
> >>                 list_for_each_entry_rr_rcu(conn, &conn_list,
> >>                                            entry) {
> >>                         break;
> >>                 }
> >>                 rcu_assign_pointer(rcu_conn, conn);
> >>                 return conn;
> >>         }
> >>
> >>
> >> or maybe I did not fully get your idea?
> >
> > That would not help at all because you are still leaking the pointer out
> > of the RCU read-side critical section.  That is completely and utterly
> > broken unless you are somehow cleaning up rcu_conn when you remove
> > the element.  And getting that cleanup right is -extremely- tricky.
> > Unless you have some sort of proof of correctness, you will get a NACK
> > from me.
> 
> I understand all the consequences of the leaking pointer, and of course
> wrapped loop with RCU lock/unlock is simpler, but in order to keep
> load-balancing and IO fairness avoiding any locks on IO path I've come
> up with these RCU tricks and list_next_or_null_rr_rcu() macro.

At first glance, it appears that you have handled this correctly.  But I
can make mistakes just as easily as the next guy, so what have you done
to validate your algorithm?

> > More like this:
> >
> >         list_for_each_entry_rr_rcu(conn, &conn_list, entry) {
> >                 do_something_with(conn);
> >                 if (done_for_now())
> >                         break;
> >         }
> >
> >> >> + */
> >> >> +#define list_next_or_null_rr_rcu(head, ptr, type, memb) \
> >> >> +({ \
> >> >> +     list_next_or_null_rcu(head, ptr, type, memb) ?: \
> >> >> +             list_next_or_null_rcu(head, READ_ONCE((ptr)->next), type, memb); \
> >> >
> >> > Are there any uses for this outside of RDMA?  If not, I am with Linus.
> >> > Define this within RDMA, where a smaller number of people can more
> >> > easily be kept aware of the restrictions on use.  If it turns out to be
> >> > more generally useful, we can take a look at exactly what makes sense
> >> > more globally.
> >>
> >> The only one list_for_each_entry_rcu()-like macro I am aware of is used in
> >> block/blk-mq-sched.c, is called list_for_each_entry_rcu_rr():
> >>
> >> https://elixir.bootlin.com/linux/v4.17-rc5/source/block/blk-mq-sched.c#L370
> >>
> >> Does it make sense to implement generic list_next_or_null_rr_rcu() reusing
> >> my list_next_or_null_rr_rcu() variant?
> >
> > Let's start with the basics:  It absolutely does not make sense to leak
> > pointers across rcu_read_unlock() unless you have arranged something else
> > to protect the pointed-to data in the meantime.  There are a number of ways
> > of implementing this protection.  Again, what protection are you using?
> >
> > Your code at the above URL looks plausible to me at first glance: You
> > do rcu_read_lock(), a loop with list_for_each_entry_rcu_rr(), then
> > rcu_read_unlock().  But at second glance, it looks like htcx->queue
> > might have the same vulnerability as rcu_conn in your earlier code.
> 
> I am not the author of the code at the URL I specified. I provided the
> link answering the question to show other possible users of round-robin
> semantics for RCU list traversal.  In my 'list_next_or_null_rr_rcu()'
> case I can't use a loop, I leak the pointer and indeed have to be very
> careful.  But perhaps we can come up with some generic solution to cover
> both cases: -rr loop and -rr next.

Ah.  Could you please check their update-side code to make sure that it
looks correct to you?

							Thanx, Paul
