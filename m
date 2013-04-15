From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups -
 suggesting BOF during OFA conf to further discuss that
Date: Mon, 15 Apr 2013 16:21:09 +0300
Message-ID: <CAJZOPZLVyYODJ=z6KDfx0UJtaHpA7nUt2kwadEugpV1LWxhEMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ali Ayoub <ali-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz


>> RSS child QPs are plain UD or RAW Packet QPs that only have consecutive
>> QPNs which is common requirement of HW for configuring the RSS parent
>> which in networking is called the RSS indirection or dispatching QP. You
>> can send and receive on them.

> How do you ensure that the QPN's are consecutive?

Quoting from this patch change-log:

<start "A QP group is a set of QPs consists of a parent QP and two disjoint sets
of RSS and TSS QPs. The creation of a QP group is a two stage process:

In the the 1st stage, the parent QP is created.

In the 2nd stage the children QPs of the parent are created.

Each child QP indicates if its a RSS or TSS QP. Both the TSS
and RSS sets of QPs should have contiguous QP numbers." end>

When the parent is created we (the driver) are being told by the
consumer (providing instance of struct  ib_qpg_init_attrib) how many
child QPs they would need, so we can internally act up front and make
sure there's a consecutive chain of QPNs reserved for that group.

>> If an RSS child goes to the error state it will not receive data.

> If you transition it back to RTS would it start working again?

YES

> Could you remove it and add a new one?  (I guess not because the new QPN
> would likely not be consecutive.)

NO, its disallowed to destroy any of the child QPs as long as  the
parent is there, quoting from the change log:

<start "It is forbidden to modify parent QP state before all RSS/TSS children
were created. In the same manner it is disallowed to destroy the parent
QP unless all RSS/TSS children were destroyed." end>

>> Packets are routed to RSS childs only per the hash function output, not per
>> the state of that child.

> So if the QP chosen by the hash is in error state the packets get lost?
> Above you said they would not receive data.

indeed, get lost, which means data will not be received, not sure I am
following what isn't aligned to what I said in that above comment.

Actually these comments and questions on the series come just a week
before the annual OFA gathering, personally, I will not be there nor
Shlomo who is the author of the patches, but Tzahi Oved from Mellanox
who lead the architecture for the QP group concept is planned to
attend and same for Sean, Roland and I hope you (Ira) too, same for
Ali Ayoub and Liran Liss from Mellanox who are attending too, all in
all, nice quorum to get into a room and do white boarding, open
discussion, laughing, yelling and what ever needed to get a consensus.

It would be good if a BOF would be set to discuss the QP groups
concept and how to proceed with getting the verbs layer to support
RSS/TSS so we can finally

1. embed them within the verbs language
2. support MQ/RSS in the IPoIB network driver

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
