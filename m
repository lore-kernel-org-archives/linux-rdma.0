From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: how to re-use a QP for a new connection
Date: Mon, 23 Jun 2014 16:12:16 -0500
Message-ID: <53A89830.1060808@opengridcomputing.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com> <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com> <5F77D836-4EE1-458D-B256-3C0EF4B1F2C2@oracle.com> <1828884A29C6694DAF28B7E6B8A8237399313467@ORSMSX109.amr.corp.intel.com> <8E9844F1-AFDC-4F28-B646-596BCBC3FAA8@oracle.com> <1828884A29C6694DAF28B7E6B8A823739931EDD5@ORSMSX109.amr.corp.intel.com> <1F02274F-B3FC-40EE-A46D-FB178EA3781B@oracle.com> <1828884A29C6694DAF28B7E6B8A823739931EE90@ORSMSX109.amr.corp.intel.com> <98556348-B33A-4C2C-9D4E-AEA57FB472CE@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <98556348-B33A-4C2C-9D4E-AEA57FB472CE-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/23/2014 12:31 PM, Chuck Lever wrote:
> On Jun 23, 2014, at 1:25 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote=
:
>
>>> For the record, with both mlx4 and cxgb4, we see FRMRs left valid
>>> after a FAST_REG_MR is flushed during a connection loss. More study
>>> needed, obviously.
>> Is the bug that this type of WR completes in error, but actually exp=
osed the memory region?
> We haven=92t checked if the MR is exposed; hadn=92t thought of that!

I don't think this is a bug.  It is a race where HW is in the process o=
f=20
fast-registering the memory at the time the QP is moved out of RTS=20
causing all pending work requests to get FLUSHED.  I looked at both the=
=20
IBTA IB and IETF iWARP Verbs specs, and neither state explicitly what=20
=46LUSHED status means.  They both say "at the the time the QP was move=
d=20
to ERROR the work request was not complete".  That's doesn't indicate=20
that the work request was canceled or didn't actually complete.  At=20
least that's how I read it.  Irregardless, the chelsio hardware behaves=
=20
this way.  And apparently the mlx hardware does too.

Anyway, for cxgb4 at least, the FRMR can be left in the valid state. =20
The correct procedure, in the case of a fast-reg wr completing as=20
=46LUSHED is to dereg the MR if you want to ensure the region is invali=
dated.

> What we do know is that a subsequent LOCAL_INVALIDATE using the rkey =
that
> should work (if FAST_REG_MR had indeed never been done) fails in some=
 cases.
> With mlx4, the LINV completes with IB_WC_MW_BIND_ERR. Steve can provi=
de
> more detail about the exact failure mode with cxgb4.

cxgb4 completes with IB_WC_LOC_ACCESS_ERR.

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
