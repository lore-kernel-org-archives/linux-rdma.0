From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: [ANNOUNCE] uDAPL library: v1 - compat-1.2.15 and v2 -
 dapl-2.0.25 release
Date: Wed, 25 Nov 2009 01:14:41 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98361B96C04@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, "ewg@lists.openfabrics.org" <ewg@lists.openfabrics.org>
Cc: Vladimir Sokolovsky <vlad@dev.mellanox.co.il>
List-Id: linux-rdma@vger.kernel.org


New release for uDAPL 1.2 and 2.0 available on the OFA download page and in=
 my git tree.

md5sum: d7b710aebd8bb9b48b6b8982f71f62c7 compat-dapl-1.2.15.tar.gz=20
md5sum: 3a14b650bbfbe38243eb4a11157bef5d dapl-2.0.25.tar.gz=20

Summary of v1 and v2 changes since last release:=20

v1 - Release 1.2.15 fixes:=20
v1 - dtest, dapltest: conflict with dapl-2 utils package, change to dapl1, =
dapltest1=20
v1 - scm: fix compiler warning, unused variable=20

v2 - Release 2.0.25 fixes:=20
v2 - winof scm: initialize opt for NODELAY setsockopt=20
v2 - winof cma: windows definition for EADDRNOTAVAIL missing=20
v2 - scm: client side setsockopt NODELAY fails if data arrives before setti=
ng=20
v2 - cma: setup_listener Cannot assign requested address=20
v2 - common: seg fault in dapl_evd_wait with multi-thread application using=
 CNO's.=20
v2 - ucm: inbound DREQ/DREP handshake should transition QP.=20
v2 - winof: Remove duplicate include of comp_channel.cpp from cm.c as it is=
 included in opensm_ucb/device=20
v2 - winof: Utilize WinOF version of inet_ntop() for Windows OSes which do =
not support inet_ntop().=20

Vlad, please pull both new packages into latest OFED 1.5 build and install =
the following:
=20
dapl-2.0.25-1=20
dapl-utils-2.0.25-1=20
dapl-devel-2.0.25-1=20
dapl-debuginfo-2.0.25-1=20
compat-dapl-1.2.15-1=20
compat-dapl-devel-1.2.15-1=20

See http://www.openfabrics.org/downloads/dapl/ more details.

Thanks,

-arlin
