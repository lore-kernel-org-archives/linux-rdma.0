From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_cache.c: Cosmetic change to log
 message for consistency
Date: Thu, 15 Oct 2009 22:54:53 +0200
Message-ID: <20091015205453.GH20210@me>
References: <20091015133639.GB8041@comcast.net>
 <20091015192647.GF20210@me>
 <f0e08f230910151243o12ec4fffv70f6a278667f55e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910151243o12ec4fffv70f6a278667f55e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 15:43 Thu 15 Oct     , Hal Rosenstock wrote:
> On Thu, Oct 15, 2009 at 3:26 PM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
> > On 09:36 Thu 15 Oct =A0 =A0 , Hal Rosenstock wrote:
> >>
> >> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> diff --git a/opensm/opensm/osm_ucast_cache.c b/opensm/opensm/osm_u=
cast_cache.c
> >> index 31a5333..8db9df2 100644
> >> --- a/opensm/opensm/osm_ucast_cache.c
> >> +++ b/opensm/opensm/osm_ucast_cache.c
> >> @@ -876,7 +876,7 @@ void osm_ucast_cache_add_link(osm_ucast_mgr_t =
* p_mgr,
> >> =A0 =A0 =A0 if (osm_node_get_type(p_node_1) !=3D IB_NODE_TYPE_SWIT=
CH &&
> >> =A0 =A0 =A0 =A0 =A0 osm_node_get_type(p_node_2) !=3D IB_NODE_TYPE_=
SWITCH) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 OSM_LOG(p_mgr->p_log, OSM_LOG_INFO,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Dropping CA-2-CA link -=
 cache invalid\n");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Dropping CA/RTR-2-CA/RT=
R link - cache invalid\n");
> >
> > IMHO it looks more confusing after the change.
>=20
> It's more accurate and consistent;

This is a log message, not a spec, and 'CA/RTR-2-CA/RTR' as single link
abbreviation looks strange. If you want to make things clearer find a
clear single name or abbreviation for CA/RTR.

> There's another log message which
> says "CA/RTR-2-CA/RTR" rather than "CA-2-CA".

Likely I missed this in those big patch. Would be better to rename back
IMHO.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
