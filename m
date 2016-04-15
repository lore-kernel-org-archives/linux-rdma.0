From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] dapl-2.1.9 release
Date: Fri, 15 Apr 2016 02:26:44 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F980D8FA39@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Vladimir Sokolovsky (vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release for uDAPL is available at http://downloads.openfabrics.org/=
dapl/dapl-2.1.9.tar.gz

Vlad, please pull into OFED 3.18-2=20

=A0=A0=A0=A0 md5sum: 7dc10c55fa54a4d41824908e8a0f9624 dapl-2.1.9.tar.gz=
=20

=46or v2.1 package install RPM packages as follow:

=A0=A0=A0=A0 dapl-2.1.9-1
=A0=A0=A0=A0 dapl-utils-2.1.9-1
=A0=A0=A0=A0=A0dapl-devel-2.1.9-1
=A0=A0=A0=A0 dapl-debuginfo-2.1.9-1

Release notes: http://downloads.openfabrics.org/dapl/documentation/uDAP=
L_release_notes.txt

Summary of changes:

Release 2.1.9
dtestcm: exchange provider IA address info via sockets
ucm: increase default REQ/RTU timers on scaling threshold
mpxyd: m_req_event assert during large io streams, HST to MIC
mcm: HST->MXS IO streams can overrun MPXYD proxy-in WR queue
mpxyd: cleanup warnings in MIC proxy code
openib: cleanup warnings in openib providers
common: cleanup warnings in common code base
dapltest: cleanup warnings, unused variables, etc
scm: backward compatibility issue with MTU negotiation
mcm: fix mtu interop issues when MIC and HOST differ
dtest: clean up warnings, keep variables and functions local

Release commit: http://git.openfabrics.org/?p=3D~ardavis/dapl.git;a=3Dc=
ommit;h=3D92d1bc4bf3089595012c11fa42d3da124490b4a0

Regards,=20

Arlin

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
