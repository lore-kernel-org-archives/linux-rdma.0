From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 01/26] rculist: introduce list_next_or_null_rr_rcu()
Date: Fri, 18 May 2018 09:56:27 -0700
Message-ID: <CA+55aFw2u4=X1LPU5kdqPX1C182-oTRvf1qwJ7_Ac+newVXAJA@mail.gmail.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com> <20180518130413.16997-2-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518130413.16997-2-roman.penyaev@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Pen <roman.penyaev@profitbricks.com>
Cc: linux-block <linux-block@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, swapnil.ingle@profitbricks.com, danil.kipnis@profitbricks.com, jinpu.wang@profitbricks.com, Paul McKenney <paulmck@linux.vnet.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 18, 2018 at 6:07 AM Roman Pen <roman.penyaev@profitbricks.com>
wrote:

> Function is going to be used in transport over RDMA module
> in subsequent patches.

Does this really merit its own helper macro in a generic header?

It honestly smells more like "just have an inline helper function that is
specific to rdma" to me. Particularly since it's probably just one specific
list where you want this oddly specific behavior.

Also, if we really want a round-robin list traversal macro, this isn't the
way it should be implemented, I suspect, and it probably shouldn't be
RCU-specific to begin with.

Side note: I notice that I should already  have been more critical of even
the much simpler "list_next_or_null_rcu()" macro. The "documentation"
comment above the macro is pure and utter cut-and-paste garbage.

Paul, mind giving this a look?

                 Linus
