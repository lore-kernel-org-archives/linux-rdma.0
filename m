From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libnes-1.0.0 release
Date: Tue, 8 Dec 2009 15:22:44 -0700
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE3D004865@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release of libnes library (1.0.0) is available at:

http://www.openfabrics.org/downloads/nes/libnes-1.0.0.tar.gz

sha1sum: e9d73b46cbc6c000f9904874fb1aba874b6ab8cf  libnes-1.0.0.tar.gz

Changes since last release:

Chien Tung (2):
      libnes: sync up with function prototype changes in libibverbs-1.1.3
      libnes: update version number to 1.0.0

Don Wood (2):
      libnes: Fix a thread safety problem on send and recv paths.
      libnes: Change the fence flag to read fence

Vlad, please pull this in for OFED 1.5.

Thanks,

Chien

--
Chien Tung | chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
