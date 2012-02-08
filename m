From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
Date: Wed, 8 Feb 2012 23:26:19 +0200
Message-ID: <CAJZOPZJtXGq36Hx5BQAc2Q7znErJ-Uaiqs-DaJQ=jCSy49uTiQ@mail.gmail.com>
References: <1311923731.7845.25.camel@edumazet-laptop>
	<1328181135.2279.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAG4TOxMVmEe3KiDuaO6ZWq0vNchi1Mrf=mr2RSNJY2oXX0hD+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG4TOxMVmEe3KiDuaO6ZWq0vNchi1Mrf=mr2RSNJY2oXX0hD+Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 2, 2012 at 7:08 PM, Roland Dreier <roland@kernel.org> wrote=
:
> On Thu, Feb 2, 2012 at 3:12 AM, Eric Dumazet <eric.dumazet@gmail.com>=
 wrote:

>> Any news on this patch ?

> Sorry, just dropped it in the shuffle. =A0I'll get it into 3.4, thank=
s.

Roland,

I noted that you typically use the for-next branch of the infiniband
tree for fixes during
the 1 < kernN-rc < (say) 6 time and for features during (kernN-rc > 6)
till kern(N+1)-rc1

This means that the window of time when features are actually accepted
into your tree is kind of very limited. Would it be possible to
maintain two branches: for-next and (say) rc-fixes, such that
practically patches are reviewed/accepted to for-next at almost all
times?

BTW I see that networking and scsi maintainers use two trees
(net/net-next) and (scsi-misc/scsi-rc-fixes), maybe it would be eaiser
for you go this way?

Or.
