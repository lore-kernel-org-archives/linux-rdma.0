From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 01/26] rculist: introduce list_next_or_null_rr_rcu()
Date: Sat, 19 May 2018 13:56:45 -0700
Message-ID: <CA+55aFwNByHq+OG5QmL4V2fXeduFHbTVOct6X0REHFRoLsrpdg@mail.gmail.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
 <20180518130413.16997-2-roman.penyaev@profitbricks.com> <20180519163735.GX3803@linux.vnet.ibm.com>
 <CAJrWOzAt8BDtypaRwYx_y9jpCVD5W_VL9aQsFsC3bL-XaoJz9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJrWOzAt8BDtypaRwYx_y9jpCVD5W_VL9aQsFsC3bL-XaoJz9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Pen <roman.penyaev@profitbricks.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, swapnil.ingle@profitbricks.com, danil.kipnis@profitbricks.com, jinpu.wang@profitbricks.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, May 19, 2018 at 1:21 PM Roman Penyaev <
roman.penyaev@profitbricks.com> wrote:

> I need -rr behaviour for doing IO load-balancing when I choose next RDMA
> connection from the list in order to send a request, i.e. my code is
> something like the following:
[ incomplete pseudoicode ]
> i.e. usage of the @next pointer is under an RCU critical section.

That's not enough. The whole chain to look up the pointer you are taking
'next' of needs to be under RCU, and that's not clear from your example.

It's *probably* the case, but basically you have to prove that the starting
point is still on the same RCU list. That wasn't clear from your example.

The above is (as Paul said) true of list_next_rcu() too, so it's not like
this is anything specific to the 'rr' version.

              Linus
