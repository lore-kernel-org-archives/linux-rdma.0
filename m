From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.8 release
Date: Thu, 18 Feb 2016 01:10:07 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F980D5FDA9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Vladimir Sokolovsky (vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


New release for uDAPL (2.1.8) is available at http://downloads.openfabr=
ics.org/dapl/dapl-2.1.8.tar.gz

Vlad, please pull into OFED 3.18-2=20

=A0=A0=A0=A0 md5sum: 47cc7eb0302c20ab4fc08910e17e3c47 dapl-2.1.8.tar.gz=
=20

=46or v2.1 package install RPM packages as follow:

=A0=A0=A0=A0 dapl-2.1.8-1
=A0=A0=A0=A0 dapl-utils-2.1.8-1=A0=20
=A0=A0=A0=A0=A0dapl-devel-2.1.8-1
=A0=A0=A0=A0 dapl-debuginfo-2.1.8-1

Release notes: http://downloads.openfabrics.org/dapl/documentation/uDAP=
L_release_notes.txt

Summary of changes:

Release 2.1.8
 mpxyd: fix segfault in proxy_out debug logging
 mpxyd: fix debug memory buffer log function
 dtest: -D option is not valid with scif providers
 dtest/dapltest: add new automated test suite for HOST to MIC testing
 openib: update attributes correctly for iWARP transports
 openib_common: set providers mtu to active_mtu instead of 2048
 mpxyd: set affinity default to 2 for best performance
 mcm: cleanup unused variable in dapls_ib_mr_register
 dtest: enhancement to test, -D option for data check
 mcm: add support for Intel Omni-Path driver (hfi) via mic MFO mode
 mpxyd: fix ordering issues with the CCL Proxy receive side forwarding =
mechanism
 dtest: report results only if one of the pingpong tests are run
 mpxyd: with abnormal CM termination a CM object can be referenced afte=
r QP destroy
 mpxyd: proxy out WR resources exhausted with MFO mode endpoints
 release note update for CCL Proxy and Platform BIOS recommendations
 dtestx: add dat_ib_open_query only option with -q
 scm: CONN_PENDING: SOCKOPT ERR Connection refused ->

Release commit: http://git.openfabrics.org/?p=3D~ardavis/dapl.git;a=3Dc=
ommit;h=3Dc9a7fd2e658efa9021cc386d1b8ec3691a903959

Regards, Arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
