From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: fix some obvious -Wsign-compare warnings
Date: Sat, 3 Oct 2009 02:33:57 +0200
Message-ID: <20091003003357.GD17846@me>
References: <20091001192536.GY17846@me>
 <f0e08f230910021041p28307726j6bb280220abd1eae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910021041p28307726j6bb280220abd1eae-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dale Purdy <purdy-sJ/iWh9BUns@public.gmane.org>, "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:41 Fri 02 Oct     , Hal Rosenstock wrote:
>=20
> > diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcas=
t_mgr.c
> > index 6f51404..aaab91a 100644
> > --- a/opensm/opensm/osm_mcast_mgr.c
> > +++ b/opensm/opensm/osm_mcast_mgr.c
> > @@ -1004,7 +1004,7 @@ static int mcast_mgr_set_mftables(osm_sm_t * =
sm)
> > =A0 =A0 =A0 =A0osm_switch_t *p_sw;
> > =A0 =A0 =A0 =A0osm_mcast_tbl_t *p_tbl;
> > =A0 =A0 =A0 =A0int block_notdone, ret =3D 0;
> > - =A0 =A0 =A0 int16_t block_num, max_block =3D -1;
> > + =A0 =A0 =A0 uint16_t block_num, max_block =3D -1;
>=20
> Doesn't this change break the loop which uses block_num/max_block lik=
e:
>=20
> for (block_num =3D 0; block_num <=3D max_block; block_num++) {
> ...

Yes, it breaks (I was too fast, sorry). The breakage is also catched by
Dale. The patch below should fix this.

Sasha

=46rom 0121a81ecb3124760817819cf170bb137523082c Mon Sep 17 00:00:00 200=
1
=46rom: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date: Sat, 3 Oct 2009 02:19:49 +0200
Subject: [PATCH] opensm: fix endless looping in mcast_mgr

The bug was introduced by broken signed -> unsigned conversion. Fix thi=
s
properly (including sign-compare warning).

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_switch.h |    2 +-
 opensm/opensm/osm_mcast_mgr.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/include/opensm/osm_switch.h b/opensm/include/opensm=
/osm_switch.h
index e281842..37c1c4f 100644
--- a/opensm/include/opensm/osm_switch.h
+++ b/opensm/include/opensm/osm_switch.h
@@ -103,7 +103,7 @@ typedef struct osm_switch {
 	uint8_t *lft;
 	uint8_t *new_lft;
 	osm_mcast_tbl_t mcast_tbl;
-	uint32_t mft_block_num;
+	int32_t mft_block_num;
 	uint32_t mft_position;
 	unsigned endport_links;
 	unsigned need_update;
diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mg=
r.c
index aaab91a..6f51404 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -1004,7 +1004,7 @@ static int mcast_mgr_set_mftables(osm_sm_t * sm)
 	osm_switch_t *p_sw;
 	osm_mcast_tbl_t *p_tbl;
 	int block_notdone, ret =3D 0;
-	uint16_t block_num, max_block =3D -1;
+	int16_t block_num, max_block =3D -1;
=20
 	p_sw =3D (osm_switch_t *) cl_qmap_head(p_sw_tbl);
 	while (p_sw !=3D (osm_switch_t *) cl_qmap_end(p_sw_tbl)) {
--=20
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
