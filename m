From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 01/26] rculist: introduce list_next_or_null_rr_rcu()
Date: Mon, 21 May 2018 08:33:37 -0700
Message-ID: <20180521153337.GF3803@linux.vnet.ibm.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
 <20180518130413.16997-2-roman.penyaev@profitbricks.com>
 <20180519163735.GX3803@linux.vnet.ibm.com>
 <CAJrWOzAt8BDtypaRwYx_y9jpCVD5W_VL9aQsFsC3bL-XaoJz9g@mail.gmail.com>
 <20180520004318.GY3803@linux.vnet.ibm.com>
 <CAJrWOzBenkHg_5zs1VAxP_rVbCbOJO_eO0toJBhnzXuy_yWH2Q@mail.gmail.com>
 <CA+55aFymFCVqh4VxtqDPoFYh6zsGEDLSV79_AnsMp3M=t2mhqg@mail.gmail.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFymFCVqh4VxtqDPoFYh6zsGEDLSV79_AnsMp3M=t2mhqg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Pen <roman.penyaev@profitbricks.com>, linux-block <linux-block@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, swapnil.ingle@profitbricks.com, danil.kipnis@profitbricks.com, Jinpu Wang <jinpu.wang@profitbricks.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 21, 2018 at 08:16:59AM -0700, Linus Torvalds wrote:
> On Mon, May 21, 2018 at 6:51 AM Roman Penyaev <
> roman.penyaev@profitbricks.com> wrote:
> 
> > No, I continue from the pointer, which I assigned on the previous IO
> > in order to send IO fairly and keep load balanced.
> 
> Right. And that's exactly what has both me and Paul nervous. You're no
> longer in the RCU domain. You're using a pointer where the lifetime has
> nothing to do with RCU any more.
> 
> Can it be done? Sure. But you need *other* locking for it (that you haven't
> explained), and it's fragile as hell.

He looks to actually have it right, but I would want to see a big comment
on the read side noting the leak of the pointer and documenting why it
is OK.

							Thanx, Paul

> It's probably best to not use RCU for it at all, but depend on that "other
> locking" that you have to have anyway, to keep the pointer valid over the
> non-RCU region.
> 
>                 Linus
> 
