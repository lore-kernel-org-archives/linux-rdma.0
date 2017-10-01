From: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: ibqueryerrors.c: Add support for additional counters in
 PortCountersExtended
Date: Sun, 1 Oct 2017 08:07:17 +0000
Message-ID: <DB6PR0501MB2245E78D6118FE145C8141D8A87C0@DB6PR0501MB2245.eurprd05.prod.outlook.com>
References: <2807E5FD2F6FDA4886F6618EAC48510E67D31C52@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67D31C52-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)'" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

Users don't set thresholds for old/new counters, they just set thresholds a=
nd if new counters are supported then thresholds are checked against new co=
unters and if only old counters are supported then thresholds are checked a=
gainst old counters.

-----Original Message-----
From: Weiny, Ira [mailto:ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]=20
Sent: Saturday, September 30, 2017 4:42 AM
To: 'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>; Ode=
d Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: ibqueryerrors.c: Add support for additional counters in PortCo=
untersExtended

Hal, Oded,

I have lost the original email from this submission but got it off of patch=
work.

Question on the hunk below.

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c                     =
                                 =20
index 304dc154c4b4..4ea762a1f344 100644                                    =
                                 =20
--- a/src/ibqueryerrors.c                                                  =
                                 =20
+++ b/src/ibqueryerrors.c                                                  =
                                 =20
@@ -105,15 +105,15 @@ static unsigned valid_gid(ib_gid_t * gid)            =
                                 =20
        return memcmp(&zero_gid, gid, sizeof(*gid));                       =
                                 =20
 }                                                                         =
                                 =20
                                                                           =
                                 =20
-static void set_thres(char *name, uint32_t val)                           =
                                 =20
+static void set_thres(char *name, uint64_t val)                           =
                                 =20
 {                                                                         =
                                 =20
        int f;                                                             =
                                 =20
        int n;                                                             =
                                 =20
        char tmp[256];                                                     =
                                 =20
-       for (f =3D IB_PC_FIRST_F; f <=3D IB_PC_LAST_F; f++) {              =
                                     =20
+       for (f =3D IB_PC_EXT_ERR_SYM_F; f <=3D IB_PC_EXT_XMT_WAIT_F; f++) {=
                                     =20

How does this change allow for users to set the old Port Counters threshold=
s?

Ira


                if (strcmp(name, mad_field_name(f)) =3D=3D 0) {            =
                                     =20
                        mad_encode_field(thresholds, f, &val);             =
                                 =20
-                       snprintf(tmp, 255, "[%s =3D %u]", name, val);      =
                                   =20
+                       snprintf(tmp, 255, "[%s =3D %lu]", name, val);     =
                                   =20
                        threshold_str =3D realloc(threshold_str,           =
                                   =20
                                        strlen(threshold_str)+strlen(tmp)+1=
);                               =20
                        if (!threshold_str) {                              =
                                 =20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
