From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: why flipping responder_resources/initiator_depth?
Date: Mon, 23 Jun 2014 08:55:07 +0300
Message-ID: <CAJZOPZKqYiGpxi8bjDu5TBu0G6EX_DjRLvEVhNDTy9L79h6MbQ@mail.gmail.com>
References: <53A688FB.6070600@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823739931CCAD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823739931CCAD-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 23, 2014 at 8:00 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Any special reason for that? specifically, it doesn't comply with our
>> common sense (...) and the text in the  rdma_connect/rdma_accept man
>> pages http://linux.die.net/man/3/rdma_connect that say:

> Flipping the values keeps the meaning the same on both sides, with the meaning relative to the local, versus remote side, as opposed to the sender of the message.

But the meaning need not be the same on both sides. It's very
common/possible for the quantity of how many inflight rdma-reads will
be initiated/responded by each side of the connection to be
asymmetrical - can be N for the client --> server direction and M for
the server --> client direction.In the real life example below N=0

A case where only side initiated rdma-reads, say the server, which is
commonn in many transactional storage protocols (SRP, iSER) so the
client and server need to negoiate how many inflight rdma-reads the
server is allowed to issue, as I see things, this is the expected
flow:

1. the client to put into the responder_resources they provide to
rdma_connect the the maximum number of outstanding RDMA read that they
will be able accept from the server side

2. the server to apply a minimum function between the
responder_resources which were advertized by the client (and they get
in the connection request event params) to how many inflight
rdma-reads  their HCA supports

Isn't this paradigm robust and simple? and can be extended to the case
where only the client or both sides issue rdma-reads/atomics?

Also note that this flipping decision taken by the Linux CM will make
applications to potentially not properly inter-operate with instances
running over other CMs (e.g windows, ESX, realtime/proprietary OS in
commercial storage boxes, etc).

I find the current practice being both not inter-operable and
confusing. I don't see how it follows the terms terms "local" and
"remote" used in the man page.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
