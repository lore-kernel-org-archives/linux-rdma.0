From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: possible isert bug in tear down sequence
Date: Thu, 9 Nov 2017 15:30:50 +0200
Message-ID: <e196fa80-d7ad-cfa7-651b-f343c0198a84@grimberg.me>
References: <BN3PR07MB2578825BFC784DF5DDB6E125F8570@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <BN3PR07MB2578825BFC784DF5DDB6E125F8570@BN3PR07MB2578.namprd07.prod.outlook.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "Amrani, Ram" <Ram.Amrani@cavium.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ram,

CC'ing target-devel where isert is normally maintained.

> I am experiencing an issue with isert's receive handler:
> 	static void isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
> 	{
> 		struct isert_conn *isert_conn = wc->qp->qp_context;
> 		...
> 	}
> The first line dereferences the QP. But I'm hitting a case where the QP was already
> deleted so this is bad.

Indeed, and should not happen.

> The scenario is triggered via 'ifconfig <Ethernet device> down',
> whilst the initiator and target are connected.

That would trigger a DEVICE_REMOVAL event. which should trigger free of
the iser connection (and its relevant rdma resources, including the qp).

> The handler is invoked via a work queue. Hence it is asynchronous.

Correct.

> It is valid to continue polling the CQ after the QP has been deleted,

It is valid in theory, but isert should never get there. isert always
drains the queue-pair before freeing it. ib_drain_qp() is designed to
guarantee that after calling it, no other completion will ever be
associated with the qp.

There are two possibilities here:
1. We have a bug in isert which posts a wr after calling ib_drain_qp()
which is very likely, but given that this is a recv completion I sorta
doubt it because it means that the QP is not even in error state (or is
it and its an FLUSH error completion?)

2. The device you tested with did not really drain the qp properly and a
stray completion found its way afterwards. What device did you test
with?

> but it isn't valid
> to dereference the QP due to this asynchronous nature. This is funny because the
> QP was destroyed by isert itself. The problem is, that even if isert raises a flag
> saying "I issued a destroy sequence so ignore this CQE" it will still need another
> way to get to iser_conn that isn't via the qp.

As I said, isert should make sure to not get there ever and uses
ib_drain_qp for it.
