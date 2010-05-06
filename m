From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] management: adding mad_dump_fields to libibmad
Date: Thu, 6 May 2010 13:27:13 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8MNEXMB1qlogic_"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--_002_4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8MNEXMB1qlogic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Sasha asked that I re-submit the patches for perfquery in a slightly differ=
ent format. This is the first of 3 patches.

This patch adds a function to libibmad that allows the caller to dump a con=
figurable range of MAD attributes. Basically, this provides an external int=
erface to the internal function _dump_fields.

Signed Off: Michael Heinz

---------------- snip --------------
diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniban=
d/mad.h
index 02ef551..0478c2b 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -1031,6 +1031,9 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err,
     mad_dump_portsamples_control;
=20
+MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz=
,
+								int start, int end);
+
 MAD_EXPORT int ibdebug;
=20
 #if __BYTE_ORDER =3D=3D __LITTLE_ENDIAN
diff --git a/libibmad/src/dump.c b/libibmad/src/dump.c
index 335e190..cc9c10f 100644
--- a/libibmad/src/dump.c
+++ b/libibmad/src/dump.c
@@ -671,6 +671,11 @@ static int _dump_fields(char *buf, int bufsz, void *da=
ta, int start, int end)
 	return (int)(s - buf);
 }
=20
+void mad_dump_fields(char *buf, int bufsz, void *val, int valsz, int start=
, int end)
+{
+	return _dump_fields(buf, bufsz, val, start, end);
+}
+
 void mad_dump_nodedesc(char *buf, int bufsz, void *val, int valsz)
 {
 	strncpy(buf, val, bufsz);
diff --git a/libibmad/src/libibmad.map b/libibmad/src/libibmad.map
index e2d0b05..5778e3e 100644
--- a/libibmad/src/libibmad.map
+++ b/libibmad/src/libibmad.map
@@ -20,6 +20,7 @@ IBMAD_1.3 {
 		mad_dump_nodedesc;
 		mad_dump_nodeinfo;
 		mad_dump_opervls;
+		mad_dump_fields;
 		mad_dump_perfcounters;
 		mad_dump_perfcounters_ext;
 		mad_dump_perfcounters_xmt_sl;

--_002_4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8MNEXMB1qlogic_
Content-Type: application/octet-stream; name="dump_fields.patch"
Content-Description: dump_fields.patch
Content-Disposition: attachment; filename="dump_fields.patch"; size=1395;
	creation-date="Mon, 19 Apr 2010 12:15:47 GMT";
	modification-date="Mon, 19 Apr 2010 12:15:47 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2xpYmlibWFkL2luY2x1ZGUvaW5maW5pYmFuZC9tYWQuaCBiL2xpYmlibWFk
L2luY2x1ZGUvaW5maW5pYmFuZC9tYWQuaAppbmRleCAwMmVmNTUxLi4wNDc4YzJiIDEwMDY0NAot
LS0gYS9saWJpYm1hZC9pbmNsdWRlL2luZmluaWJhbmQvbWFkLmgKKysrIGIvbGliaWJtYWQvaW5j
bHVkZS9pbmZpbmliYW5kL21hZC5oCkBAIC0xMDMxLDYgKzEwMzEsOSBAQCBNQURfRVhQT1JUIGli
X21hZF9kdW1wX2ZuCiAgICAgbWFkX2R1bXBfcGVyZmNvdW50ZXJzX3htdF9kaXNjLCBtYWRfZHVt
cF9wZXJmY291bnRlcnNfcmN2X2VyciwKICAgICBtYWRfZHVtcF9wb3J0c2FtcGxlc19jb250cm9s
OwogCitNQURfRVhQT1JUIHZvaWQgbWFkX2R1bXBfZmllbGRzKGNoYXIgKmJ1ZiwgaW50IGJ1ZnN6
LCB2b2lkICp2YWwsIGludCB2YWxzeiwKKwkJCQkJCQkJaW50IHN0YXJ0LCBpbnQgZW5kKTsKKwog
TUFEX0VYUE9SVCBpbnQgaWJkZWJ1ZzsKIAogI2lmIF9fQllURV9PUkRFUiA9PSBfX0xJVFRMRV9F
TkRJQU4KZGlmZiAtLWdpdCBhL2xpYmlibWFkL3NyYy9kdW1wLmMgYi9saWJpYm1hZC9zcmMvZHVt
cC5jCmluZGV4IDMzNWUxOTAuLmNjOWMxMGYgMTAwNjQ0Ci0tLSBhL2xpYmlibWFkL3NyYy9kdW1w
LmMKKysrIGIvbGliaWJtYWQvc3JjL2R1bXAuYwpAQCAtNjcxLDYgKzY3MSwxMSBAQCBzdGF0aWMg
aW50IF9kdW1wX2ZpZWxkcyhjaGFyICpidWYsIGludCBidWZzeiwgdm9pZCAqZGF0YSwgaW50IHN0
YXJ0LCBpbnQgZW5kKQogCXJldHVybiAoaW50KShzIC0gYnVmKTsKIH0KIAordm9pZCBtYWRfZHVt
cF9maWVsZHMoY2hhciAqYnVmLCBpbnQgYnVmc3osIHZvaWQgKnZhbCwgaW50IHZhbHN6LCBpbnQg
c3RhcnQsIGludCBlbmQpCit7CisJcmV0dXJuIF9kdW1wX2ZpZWxkcyhidWYsIGJ1ZnN6LCB2YWws
IHN0YXJ0LCBlbmQpOworfQorCiB2b2lkIG1hZF9kdW1wX25vZGVkZXNjKGNoYXIgKmJ1ZiwgaW50
IGJ1ZnN6LCB2b2lkICp2YWwsIGludCB2YWxzeikKIHsKIAlzdHJuY3B5KGJ1ZiwgdmFsLCBidWZz
eik7CmRpZmYgLS1naXQgYS9saWJpYm1hZC9zcmMvbGliaWJtYWQubWFwIGIvbGliaWJtYWQvc3Jj
L2xpYmlibWFkLm1hcAppbmRleCBlMmQwYjA1Li41Nzc4ZTNlIDEwMDY0NAotLS0gYS9saWJpYm1h
ZC9zcmMvbGliaWJtYWQubWFwCisrKyBiL2xpYmlibWFkL3NyYy9saWJpYm1hZC5tYXAKQEAgLTIw
LDYgKzIwLDcgQEAgSUJNQURfMS4zIHsKIAkJbWFkX2R1bXBfbm9kZWRlc2M7CiAJCW1hZF9kdW1w
X25vZGVpbmZvOwogCQltYWRfZHVtcF9vcGVydmxzOworCQltYWRfZHVtcF9maWVsZHM7CiAJCW1h
ZF9kdW1wX3BlcmZjb3VudGVyczsKIAkJbWFkX2R1bXBfcGVyZmNvdW50ZXJzX2V4dDsKIAkJbWFk
X2R1bXBfcGVyZmNvdW50ZXJzX3htdF9zbDsK

--_002_4C2744E8AD2982428C5BFE523DF8CDCB49A4740CD8MNEXMB1qlogic_--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
