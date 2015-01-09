From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v1 00/10] NFS/RDMA server for 3.20
Date: Fri, 9 Jan 2015 15:44:58 -0500
Message-ID: <20150109204458.GC30452@fieldses.org>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net>
 <20150109203958.GB30452@fieldses.org>
 <629A4CE4-ECB9-4A1D-9179-CFAD2FC7AD91@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <629A4CE4-ECB9-4A1D-9179-CFAD2FC7AD91-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 09, 2015 at 03:40:51PM -0500, Chuck Lever wrote:
>=20
> On Jan 9, 2015, at 3:39 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wr=
ote:
>=20
> > On Fri, Jan 09, 2015 at 02:21:54PM -0500, Chuck Lever wrote:
> >> In addition to miscellaneous clean up, the following series of
> >> patches for the Linux NFS server introduces support in the
> >> server=E2=80=99s RPC/RDMA transport implementation for RDMA_NOMSG =
type
> >> messages, and fixes a bug that prevents the server from handling
> >> RPC/RDMA messages with inline content following a read list.
> >>=20
> >> These patches are contained in the branch "nfsd-rdma-for-3.20" at:
> >>=20
> >>  git://git.linux-nfs.org/projects/cel/cel-2.6.git
> >=20
> > They look OK to me; applying unless someone tells me otherwise.
>=20
> I=E2=80=99d like to update the patch descriptions in several of these=
 before
> you apply the series.

OK, let me know.--b.

>=20
> >=20
> > --b.
> >=20
> >>=20
> >> ---
> >>=20
> >> Chuck Lever (10):
> >>      svcrdma: Handle additional inline content
> >>      Move read list XDR round-up logic
> >>      svcrdma: Support RDMA_NOMSG requests
> >>      svcrdma: rc_position sanity checking
> >>      svcrdma: Plant reader function in struct svcxprt_rdma
> >>      svcrdma: Find rmsgp more reliably
> >>      svcrdma: Scrub BUG_ON() and WARN_ON() call sites
> >>      svcrdma: Clean up read chunk counting
> >>      svcrdma: Remove unused variable
> >>      svcrdma: Clean up dprintk
> >>=20
> >>=20
> >> include/linux/sunrpc/svc_rdma.h          |   13 +-
> >> net/sunrpc/xprtrdma/svc_rdma_marshal.c   |   16 --
> >> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  251 ++++++++++++++++++=
+-----------
> >> net/sunrpc/xprtrdma/svc_rdma_sendto.c    |   46 +++--
> >> net/sunrpc/xprtrdma/svc_rdma_transport.c |   47 +++---
> >> 5 files changed, 224 insertions(+), 149 deletions(-)
> >>=20
> >> --
> >> Chuck Lever
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-nf=
s" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> Chuck Lever
> chuck[dot]lever[at]oracle[dot]com
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
