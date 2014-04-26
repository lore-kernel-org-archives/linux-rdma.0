From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] svcrdma: refactor marshalling logic
Date: Sat, 26 Apr 2014 12:43:36 -0400
Message-ID: <20140426164336.GA11272@fieldses.org>
References: <20140410183723.29724.18665.stgit@build.ogc.int>
 <20140425105838.GE22295@fieldses.org>
 <6B12FA09-0E8C-497A-9145-E2B7CAB16C53@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6B12FA09-0E8C-497A-9145-E2B7CAB16C53-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 25, 2014 at 09:24:47AM -0400, Chuck Lever wrote:
> Hi Bruce-
>=20
> On Apr 25, 2014, at 6:58 AM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> w=
rote:
>=20
> > On Thu, Apr 10, 2014 at 01:37:23PM -0500, Steve Wise wrote:
> >> From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
> >>=20
> >> This patch refactors the marshalling logic to remove the intermedi=
ary
> >> map structures.  It also fixes an existing bug where the NFSRDMA s=
erver
> >> was not minding the device fast register page list length limitati=
ons.
> >>=20
> >> Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
> >> ---
> >>=20
> >> include/linux/sunrpc/svc_rdma.h          |    3=20
> >> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  551 +++++++++---------=
------------
> >> net/sunrpc/xprtrdma/svc_rdma_sendto.c    |  230 +------------
> >> net/sunrpc/xprtrdma/svc_rdma_transport.c |   57 ++-
> >> 4 files changed, 222 insertions(+), 619 deletions(-)
> >=20
> > Is it possible to make this change in more than one step?
> >=20
> > RDMA is pretty esoteric to most of us, so honestly this will probab=
ly
> > get merged based just on your having tested it, but if it was possi=
ble
> > to break this up into smaller patches you might give us at least a
> > fighting chance of giving it some review=E2=80=A6.
>=20
> I agree it could be broken up.
>=20
> However, my testing revealed that the patch inadvertently breaks supp=
ort
> for HCAs that do not support FRMR.  I=E2=80=99ve reported this to Ste=
ve and Tom.
> IMO you should wait for a newer version of the refactoring patch.

Great, thanks, I'll wait.

> There are plenty of people who can review and test these patches.  We=
 are
> working on setting up regular testing in a broad array of environment=
s.
>=20
> In general it would be best for maintainers not to merge NFS/RDMA pat=
ches
> at least until you see Tested-by and/or Reviewed-by on the mailing
> list.

(which note this had).

> I
> also thought it was appropriate to mail patches To: you when they are=
 ready
> to be merged, but To: the mailing lists when asking for review.  Will=
 that
> be a problem?

It'd be clearer to add an [RFC ...] or say clearly in the email that
it's not meant to be applied yet.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
