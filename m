From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: double implementation of create QP in the stack.
Date: Tue, 04 Jan 2011 14:43:04 -0800
Message-ID: <ada1v4sguiv.fsf@cisco.com>
References: <BE2BFE91933D1B4089447C644860408066C541D1@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408066C541D1-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
	(Miroslaw Walukiewicz's message of "Thu, 23 Dec 2010 13:43:25 +0000")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I see that the /drivers/infiniband/core contains two identical
> implementations of the qp create implementation.

 > One is in verbs.c

 > ...

 > And ib_uverbs_cmd.c contains a second one.

 > Is there any reason for such double implementation of create_qp().

No good reason I don't think... the two implementations are very nearly
the same, and it would be a nice cleanup to unify the common code into a
single place.

Although with that said I think there are many cleanup opportunities in
the nes drive you could look at too ;)  For example consolidate all the
256pbl/4kpbl handling in nes_verbs.c so you don't have variations on the
same code in reg_mr, create_cq, create_qp.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
