From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm TRIVIAL] osmeventplugin: Fix compile warning
Date: Tue, 21 Jan 2014 23:33:01 -0500
Message-ID: <52DF49FD.2030506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


src/osmeventplugin.c: In function =C3=A2=C2=80=C2=98report=C3=A2=C2=80=C2=
=99:
src/osmeventplugin.c:198: warning: format =C3=A2=C2=80=C2=98%d=C3=A2=C2=
=80=C2=99 expects type =C3=A2=C2=80=C2=98int=C3=A2=C2=80=C2=99, but arg=
ument 3 has type =C3=A2=C2=80=C2=98void *=C3=A2=C2=80=C2=99

Pointed-out-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/osmeventplugin/src/osmeventplugin.c b/osmeventplugin/src/o=
smeventplugin.c
index 1eaf7ea..0f3f9fb 100644
--- a/osmeventplugin/src/osmeventplugin.c
+++ b/osmeventplugin/src/osmeventplugin.c
@@ -195,7 +195,8 @@ static void report(void *_log, osm_epi_event_id_t e=
vent_id, void *event_data)
 		fprintf(log->log_file, "Heavy sweep completed\n");
 		break;
 	case OSM_EVENT_ID_UCAST_ROUTING_DONE:
-		fprintf(log->log_file, "Unicast routing completed %d\n", event_data)=
;
+		fprintf(log->log_file, "Unicast routing completed %d\n",
+			(osm_epi_ucast_routing_flags_t) event_data);
 		break;
 	case OSM_EVENT_ID_STATE_CHANGE:
 		fprintf(log->log_file, "SM state changed\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
