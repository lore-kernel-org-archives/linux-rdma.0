From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 01/26] rculist: introduce list_next_or_null_rr_rcu()
Date: Tue, 22 May 2018 09:38:13 -0700
Message-ID: <CA+55aFx+4D5bBYSKb5jKjJ8SP=osGB=PCf8vW3RZH+R5fp5jgQ@mail.gmail.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
 <20180518130413.16997-2-roman.penyaev@profitbricks.com> <20180519163735.GX3803@linux.vnet.ibm.com>
 <CAJrWOzAt8BDtypaRwYx_y9jpCVD5W_VL9aQsFsC3bL-XaoJz9g@mail.gmail.com>
 <20180520004318.GY3803@linux.vnet.ibm.com> <CAJrWOzBenkHg_5zs1VAxP_rVbCbOJO_eO0toJBhnzXuy_yWH2Q@mail.gmail.com>
 <CA+55aFymFCVqh4VxtqDPoFYh6zsGEDLSV79_AnsMp3M=t2mhqg@mail.gmail.com>
 <20180521153337.GF3803@linux.vnet.ibm.com> <CAJrWOzDfJ46Vwz5k7VgUwz04EzCCUtt57jxCx1RC0LoOA3t0AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJrWOzDfJ46Vwz5k7VgUwz04EzCCUtt57jxCx1RC0LoOA3t0AA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Pen <roman.penyaev@profitbricks.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, swapnil.ingle@profitbricks.com, danil.kipnis@profitbricks.com, Jinpu Wang <jinpu.wang@profitbricks.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 22, 2018 at 2:09 AM Roman Penyaev <
roman.penyaev@profitbricks.com> wrote:

> Should I resend current patch with more clear comments about how careful
> caller should be with a leaking pointer?

No. Even if we go your way, there is *one* single user, and that one is
special and needs to take a lot more care.

Just roll your own version, and make it an inline function like I've asked
now now many times, and add a shit-ton of explanations of why it's safe to
use in that *one* situation.

I don't want any crazy and unsafe stuff in the generic header file that
absolutely *nobody* should ever use.

                  Linus
