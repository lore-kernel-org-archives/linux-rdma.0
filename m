From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to re-use a QP for a new connection
Date: Mon, 23 Jun 2014 13:31:44 -0400
Message-ID: <98556348-B33A-4C2C-9D4E-AEA57FB472CE@oracle.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com> <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com> <5F77D836-4EE1-458D-B256-3C0EF4B1F2C2@oracle.com> <1828884A29C6694DAF28B7E6B8A8237399313467@ORSMSX109.amr.corp.intel.com> <8E9844F1-AFDC-4F28-B646-596BCBC3FAA8@oracle.com> <1828884A29C6694DAF28B7E6B8A823739931EDD5@ORSMSX109.amr.corp.intel.com> <1F02274F-B3FC-40EE-A46D-FB178EA3781B@oracle.com> <1828884A29C6694DAF28B7E6B8A823739931EE90@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823739931EE90-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jun 23, 2014, at 1:25 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> For the record, with both mlx4 and cxgb4, we see FRMRs left valid
>> after a FAST_REG_MR is flushed during a connection loss. More study
>> needed, obviously.
>=20
> Is the bug that this type of WR completes in error, but actually expo=
sed the memory region?

We haven=92t checked if the MR is exposed; hadn=92t thought of that!

What we do know is that a subsequent LOCAL_INVALIDATE using the rkey th=
at
should work (if FAST_REG_MR had indeed never been done) fails in some c=
ases.
With mlx4, the LINV completes with IB_WC_MW_BIND_ERR. Steve can provide
more detail about the exact failure mode with cxgb4.

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
