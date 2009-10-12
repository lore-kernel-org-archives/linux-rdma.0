From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa_path_record.c: separate router guid
 resolution code
Date: Mon, 12 Oct 2009 18:25:09 +0200
Message-ID: <20091012162509.GA31774@me>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BA3@orsmsx501.amr.corp.intel.com>
 <20091004001942.GM17846@me>
 <f0e08f230910050643j63ce8e81s6d6c9bb35f2fcea5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910050643j63ce8e81s6d6c9bb35f2fcea5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09:43 Mon 05 Oct     , Hal Rosenstock wrote:
> On Sat, Oct 3, 2009 at 8:19 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> >
> > Move off subnet destination (router address) resolution code to sep=
arate
> > function to improve readability.
> >
> > Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> > ---
> > =A0opensm/opensm/osm_sa_path_record.c | =A0122 +++++++++++++++-----=
---------------
> > =A01 files changed, 52 insertions(+), 70 deletions(-)
> >
> > diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm=
_sa_path_record.c
> > index b9c6055..c91c7a2 100644
> > --- a/opensm/opensm/osm_sa_path_record.c
> > +++ b/opensm/opensm/osm_sa_path_record.c
> > @@ -1115,6 +1115,39 @@ Exit:
> >
> > =A0/***************************************************************=
*******
> > =A0****************************************************************=
******/
> > +/* Find the router port that is configured to handle this prefix, =
if any */
> > +static ib_net64_t find_router(osm_sa_t *sa, ib_net64_t prefix)
> > +{
> > + =A0 =A0 =A0 osm_prefix_route_t *route =3D NULL;
> > + =A0 =A0 =A0 osm_router_t *rtr;
> > + =A0 =A0 =A0 cl_qlist_t *l =3D &sa->p_subn->prefix_routes_list;
> > + =A0 =A0 =A0 cl_list_item_t *i;
> > +
> > + =A0 =A0 =A0 OSM_LOG(sa->p_log, OSM_LOG_VERBOSE, "Non local DGID s=
ubnet prefix "
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 "0x%016" PRIx64 "\n", cl_ntoh64(prefi=
x));
> > +
> > + =A0 =A0 =A0 for (i =3D cl_qlist_head(l); i !=3D cl_qlist_end(l); =
i =3D cl_qlist_next(i)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 osm_prefix_route_t *r =3D (osm_prefix=
_route_t *)i;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!r->prefix || r->prefix =3D=3D pr=
efix) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 route =3D r;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > + =A0 =A0 =A0 }
> > + =A0 =A0 =A0 if (!route)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>=20
> This makes the client error (bad GID) log an error now. Do we want to
> preserve the original behavior ?

I agree that logging verbosity can be reduced to warning level for such
client's error cases.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
