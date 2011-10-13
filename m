From: Todd Pfaff <pfaff-nODyE7sJo+pGsCc+L4TfMfd9D2ou9A/h@public.gmane.org>
Subject: ofed-1.5.3.2 and libmthca and libtool version
Date: Thu, 13 Oct 2011 12:58:54 -0400 (EDT)
Message-ID: <alpine.LMD.2.00.1110131253200.12317@rhpcserv>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1904384566-1528052449-1318524050=:12317"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-ID: <alpine.LMD.2.00.1110131241180.12317@rhpcserv>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1904384566-1528052449-1318524050=:12317
Content-Type: TEXT/PLAIN; FORMAT=flowed; CHARSET=US-ASCII
Content-ID: <alpine.LMD.2.00.1110131241181.12317@rhpcserv>

I tried posting to an openfabrics.org list first...

> Date: Thu, 13 Oct 2011 09:51:57 -0700
> From: general-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> Subject: Auto-response for your message to the "general" mailing list
> 
> This list is no longer active. Please use linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> instead. Thanks.

...so now I'm posting here.  My apologies if this is not appropriate
content for this list.  I'm not subscribed to the linux-rdma list yet
so I don't know if this post will be accepted.  I'm still waiting to
get a response to my subscription request.


I'm attempting to build ofed-1.5.3.2 on an unsupported linux platform
(specifically, mandriva 2010.2 x86_64).

I had previously done an ofed-1.4-rc6 build on an older mandriva 2008.1
linux platform several years ago and have been using that successfully
since that time.

I've made progress after making some modifications to install.pl to solve
some problems (see attached diff):

   - linux distribution detection
     - forced to "unsupported"

   - path to lspci

   - exclude *-debuginfo rpm builds


The build is now failing in libmthca with errors about libtool version:

   libtool: Version mismatch error.  This is libtool 2.2.6b, but the
   libtool: definition of this LT_INIT comes from an older release.
   libtool: You should recreate aclocal.m4 with macros from libtool 2.2.6b
   libtool: and run autoconf again.

Any suggestions about how to solve this problem?


Is there any simple way to stop the install.pl build process from removing
all the rpm build directories before exiting, so one can attempt to do
some build steps manually for diagnostic purposes?


Thanks,
--
Todd Pfaff <pfaff-xc3H/SjimlosA/PxXw9srA@public.gmane.org>
http://www.rhpcs.mcmaster.ca/
--1904384566-1528052449-1318524050=:12317
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=OFED-1.5.3.2-patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LMD.2.00.1110131240500.12317@rhpcserv>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=OFED-1.5.3.2-patch

LS0tIGluc3RhbGwucGwub3JpZwkyMDExLTA3LTI0IDEwOjUyOjEwLjAwMDAw
MDAwMCAtMDQwMA0KKysrIGluc3RhbGwucGwJMjAxMS0xMC0xMyAxMToyMjow
OS4wMDAwMDAwMDAgLTA0MDANCkBAIC05MiwzNSArOTIsMzUgQEANCiBteSAk
ZGlzdF9ycG1fdmVyID0gMDsNCiBteSAkZGlzdF9ycG1fcmVsID0gMDsNCiAN
Ci1pZiAoLWYgIi9ldGMvaXNzdWUiKSB7DQotICAgIGlmICgtZiAiL3Vzci9i
aW4vZHBrZyIpIHsNCi0gICAgICAgIGlmICgtZiAiL2V0Yy9sc2ItcmVsZWFz
ZSIpIHsNCi0gICAgICAgICAgICBvcGVuIChMU0IsICIvZXRjL2xzYi1yZWxl
YXNlIikgfHwgZGllICIiOw0KLSAgICAgICAgICAgIHdoaWxlICg8TFNCPikg
ew0KLSAgICAgICAgICAgICAgICBpZiAoL0RJU1RSSUJfREVTQ1JJUFRJT04v
KSB7DQotICAgICAgICAgICAgICAgICAgICAkZGlzdF9ycG0gPSAoc3BsaXQg
Jz0nLCAkXylbMV07DQotICAgICAgICAgICAgICAgICAgICAkZGlzdF9ycG0g
PX4gcy8iLy9nOw0KLSAgICAgICAgICAgICAgICAgICAgJGRpc3RfcnBtID1+
IHMvIC9fL2c7DQotICAgICAgICAgICAgICAgIH0NCi0gICAgICAgICAgICB9
DQotICAgICAgICAgICAgY2xvc2UgTFNCOw0KLSAgICAgICAgfQ0KLSAgICAg
ICAgZWxzZSB7DQotICAgICAgICAgICAgJGRpc3RfcnBtID0gImRlYmlhbiI7
DQotICAgICAgICB9DQotICAgIH0NCi0gICAgZWxzZSB7DQotICAgICAgICAk
ZGlzdF9ycG0gPSBgcnBtIC1xZiAvZXRjL2lzc3VlIHwgaGVhZCAtMWA7DQot
ICAgICAgICBjaG9tcCAkZGlzdF9ycG07DQotICAgICAgICAkZGlzdF9ycG0g
PSBgcnBtIC1xIC0tcXVlcnlmb3JtYXQgIlsle05BTUV9XS1bJXtWRVJTSU9O
fV0tWyV7UkVMRUFTRX1dIiAkZGlzdF9ycG1gOw0KLSAgICAgICAgY2hvbXAg
JGRpc3RfcnBtOw0KLSAgICAgICAgJGRpc3RfcnBtX3ZlciA9IGdldF9ycG1f
dmVyX2luc3QoJGRpc3RfcnBtKTsNCi0gICAgICAgICRkaXN0X3JwbV9yZWwg
PSBnZXRfcnBtX3JlbF9pbnN0KCRkaXN0X3JwbSk7DQotICAgIH0NCi19DQot
ZWxzZSB7DQorI2lmICgtZiAiL2V0Yy9pc3N1ZSIpIHsNCisjICAgIGlmICgt
ZiAiL3Vzci9iaW4vZHBrZyIpIHsNCisjICAgICAgICBpZiAoLWYgIi9ldGMv
bHNiLXJlbGVhc2UiKSB7DQorIyAgICAgICAgICAgIG9wZW4gKExTQiwgIi9l
dGMvbHNiLXJlbGVhc2UiKSB8fCBkaWUgIiI7DQorIyAgICAgICAgICAgIHdo
aWxlICg8TFNCPikgew0KKyMgICAgICAgICAgICAgICAgaWYgKC9ESVNUUklC
X0RFU0NSSVBUSU9OLykgew0KKyMgICAgICAgICAgICAgICAgICAgICRkaXN0
X3JwbSA9IChzcGxpdCAnPScsICRfKVsxXTsNCisjICAgICAgICAgICAgICAg
ICAgICAkZGlzdF9ycG0gPX4gcy8iLy9nOw0KKyMgICAgICAgICAgICAgICAg
ICAgICRkaXN0X3JwbSA9fiBzLyAvXy9nOw0KKyMgICAgICAgICAgICAgICAg
fQ0KKyMgICAgICAgICAgICB9DQorIyAgICAgICAgICAgIGNsb3NlIExTQjsN
CisjICAgICAgICB9DQorIyAgICAgICAgZWxzZSB7DQorIyAgICAgICAgICAg
ICRkaXN0X3JwbSA9ICJkZWJpYW4iOw0KKyMgICAgICAgIH0NCisjICAgIH0N
CisjICAgIGVsc2Ugew0KKyMgICAgICAgICRkaXN0X3JwbSA9IGBycG0gLXFm
IC9ldGMvaXNzdWUgfCBoZWFkIC0xYDsNCisjICAgICAgICBjaG9tcCAkZGlz
dF9ycG07DQorIyAgICAgICAgJGRpc3RfcnBtID0gYHJwbSAtcSAtLXF1ZXJ5
Zm9ybWF0ICJbJXtOQU1FfV0tWyV7VkVSU0lPTn1dLVsle1JFTEVBU0V9XSIg
JGRpc3RfcnBtYDsNCisjICAgICAgICBjaG9tcCAkZGlzdF9ycG07DQorIyAg
ICAgICAgJGRpc3RfcnBtX3ZlciA9IGdldF9ycG1fdmVyX2luc3QoJGRpc3Rf
cnBtKTsNCisjICAgICAgICAkZGlzdF9ycG1fcmVsID0gZ2V0X3JwbV9yZWxf
aW5zdCgkZGlzdF9ycG0pOw0KKyMgICAgfQ0KKyN9DQorI2Vsc2Ugew0KICAg
ICAkZGlzdF9ycG0gPSAidW5zdXBwb3J0ZWQiOw0KLX0NCisjfQ0KIGNob21w
ICRkaXN0X3JwbTsNCiANCiBpZiAoJGRpc3RfcnBtID1+IC9vcGVuU1VTRS1y
ZWxlYXNlLTExLjIvKSB7DQpAQCAtMjgzLDggKzI4Myw4IEBADQogICAgICRu
ZXR3b3JrX2RpciA9ICIvZXRjL3N5c2NvbmZpZy9uZXR3b3JrLXNjcmlwdHMi
Ow0KIH0NCiANCi1teSAkc2V0cGNpID0gJy9zYmluL3NldHBjaSc7DQotbXkg
JGxzcGNpID0gJy9zYmluL2xzcGNpJzsNCitteSAkc2V0cGNpID0gJy91c3Iv
YmluL3NldHBjaSc7DQorbXkgJGxzcGNpID0gJy91c3IvYmluL2xzcGNpJzsN
CiANCiAjIExpc3Qgb2YgcGFja2FnZXMgdGhhdCB3ZXJlIGluY2x1ZGVkIGlu
IHRoZSBwcmV2aW91cyBPRkVEIHJlbGVhc2VzDQogIyBmb3IgdW5pbnN0YWxs
IHB1cnBvc2UNCkBAIC0xODMzLDcgKzE4MzMsNyBAQA0KICAgICB9DQogDQog
ICAgICMgZGVidWdpbmZvIFJQTSBjdXJyZW50bHkgYXJlIG5vdCBzdXBwb3J0
ZWQgb24gU3VTRQ0KLSAgICBpZiAoJERJU1RSTyA9fiBtL1NMRVMvIG9yICRE
SVNUUk8gZXEgJ0RFQklBTicpIHsNCisgICAgaWYgKCRESVNUUk8gZXEgJ3Vu
c3VwcG9ydGVkJyBvciAkRElTVFJPID1+IG0vU0xFUy8gb3IgJERJU1RSTyBl
cSAnREVCSUFOJykgew0KICAgICAgICAgZm9yIG15ICRwYWNrYWdlIChAYWxs
X3BhY2thZ2VzKSB7DQogICAgICAgICAgICAgaWYgKCRwYWNrYWdlID1+IG0v
LWRlYnVnaW5mby8pIHsNCiAgICAgICAgICAgICAgICAgJHBhY2thZ2VzX2lu
Zm97JHBhY2thZ2V9eydhdmFpbGFibGUnfSA9IDA7DQpAQCAtMzY0MCw3ICsz
NjQwLDcgQEANCiBzdWIgY291bnRfcG9ydHMNCiB7DQogICAgIG15ICRjbnQg
PSAwOw0KLSAgICBvcGVuKExTUENJLCAiL3NiaW4vbHNwY2kgLW58Iik7DQor
ICAgIG9wZW4oTFNQQ0ksICIkbHNwY2kgLW58Iik7DQogDQogICAgIHdoaWxl
ICg8TFNQQ0k+KSB7DQogICAgICAgICBpZiAoLzE1YjM6NjI4Mi8pIHsNCg==

--1904384566-1528052449-1318524050=:12317--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
