From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 01/26] rculist: introduce list_next_or_null_rr_rcu()
Date: Sat, 19 May 2018 14:04:10 -0700
Message-ID: <CA+55aFyES79+e5kNXW=3Dj2raW6VGh8snYBCJ30W_JmYiz03gA@mail.gmail.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
 <20180518130413.16997-2-roman.penyaev@profitbricks.com> <CA+55aFw2u4=X1LPU5kdqPX1C182-oTRvf1qwJ7_Ac+newVXAJA@mail.gmail.com>
 <CAJrWOzBb1YSC3UMA3Pe8cK8X3jJqOGCueg4Yg6hov9_eAhjoXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJrWOzBb1YSC3UMA3Pe8cK8X3jJqOGCueg4Yg6hov9_eAhjoXg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Pen <roman.penyaev@profitbricks.com>
Cc: linux-block <linux-block@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, swapnil.ingle@profitbricks.com, danil.kipnis@profitbricks.com, jinpu.wang@profitbricks.com, Paul McKenney <paulmck@linux.vnet.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, May 19, 2018 at 1:25 PM Roman Penyaev <
roman.penyaev@profitbricks.com> wrote:

> Another one list_for_each_entry_rcu()-like macro I am aware of is used in
> block/blk-mq-sched.c, is called list_for_each_entry_rcu_rr():


https://elixir.bootlin.com/linux/v4.17-rc5/source/block/blk-mq-sched.c#L370

> Can we do something generic with -rr semantics to cover both cases?

That loop actually looks more like what Paul was asking for, and makes it
(perhaps) a bit more obvious that the whole loop has to be done under the
same RCU read sequence that looked up that first 'skip' entry.

(Again, stronger locking than RCU is obviously also acceptable for the
"look up skip entry").

But another reason I really dislike that list_next_or_null_rr_rcu() macro
in the patch under discussion is that it's *really* not the right way to
skip one entry. It may work, but it's really ugly. Again, the
list_for_each_entry_rcu_rr() in blk-mq-sched.c looks better in that regard,
in that the skipping seems at least a _bit_ more explicit about what it's
doing.

And again, if you make this specific to one particular list (and it really
likely is just one particular list that wants this), you can use a nice
legible helper inline function instead of the macro with the member name.

Don't get me wrong - I absolutely adore our generic list handling macros,
but I think they work because they are simple. Once we get to "take the
next entry, but skip it if it's the head entry, and then return NULL if you
get back to the entry you started with" kind of semantics, an inline
function that takes a particular list and has a big comment about *why* you
want those semantics for that particular case sounds _much_ better to me
than adding some complex "generic" macro for a very very unusual special
case.

                  Linus
