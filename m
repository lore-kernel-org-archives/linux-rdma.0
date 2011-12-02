From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: =?UTF-8?Q?Re=3A_=5BRFC=5D_=E2=80=93_Proposal_for_new_process_for_OFED_releases?=
Date: Fri, 2 Dec 2011 12:12:28 -0600 (CST)
Message-ID: <alpine.DEB.2.00.1112021211520.13405@router.home>
References: <CD250C48050CFB4D95E78C95F2FDDD6E237661EA@MTLDAG01.mtl.com> <1828884A29C6694DAF28B7E6B8A8237323FC20F5@ORSMSX102.amr.corp.intel.com> <CAO+b5-pDHQ3m18V7hFbqLxnf3-D+E3==R09+jHzAjEhNMJDzKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pDHQ3m18V7hFbqLxnf3-D+E3==R09+jHzAjEhNMJDzKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2 Dec 2011, Bart Van Assche wrote:

> On Fri, Dec 2, 2011 at 1:04 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > - What should we do with modules like SDP that are not in kernel?
> >
> > Either remove them or carry them forward as experimental features.
>
> Wat I expect is that reworking the SDP implementation such that it can
> be included upstream will take less work in the long term than
> maintaining it as out-of-tree code.

What were the issues that prevented the merging of the SDP
implementation?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
