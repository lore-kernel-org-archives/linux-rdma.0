From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: possible isert bug in tear down sequence
Date: Thu, 9 Nov 2017 12:36:54 +0000
Message-ID: <BN3PR07MB2578825BFC784DF5DDB6E125F8570@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I am experiencing an issue with isert's receive handler:
	static void isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
	{
		struct isert_conn *isert_conn =3D wc->qp->qp_context;
		...
	}
The first line dereferences the QP. But I'm hitting a case where the QP was=
 already
deleted so this is bad. The scenario is triggered via 'ifconfig <Ethernet d=
evice> down',
whilst the initiator and target are connected.

The handler is invoked via a work queue. Hence it is asynchronous.
It is valid to continue polling the CQ after the QP has been deleted, but i=
t isn't valid
to dereference the QP due to this asynchronous nature. This is funny becaus=
e the
QP was destroyed by isert itself. The problem is, that even if isert raises=
 a flag
saying "I issued a destroy sequence so ignore this CQE" it will still need =
another
way to get to iser_conn that isn't via the qp.

I see that NFSoRDMA works differently and thus probably don't suffer from t=
his issue.

Do you find this analysis correct?

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
