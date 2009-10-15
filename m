From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libnes-0.9.0 release
Date: Wed, 14 Oct 2009 19:26:45 -0700
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE2C893EBC@azsmsx501.amr.corp.intel.com>
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
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New release of libnes library (0.9.0) is available at:

http://www.openfabrics.org/downloads/nes/

sha1sum: 6e9374ea9ace5e052c00aa868eea6793839d1ae8  libnes-0.9.0.tar.gz

Changes since last release:

Chien Tung (3):
      libnes: fix warning in src/nes_uverbs.c:756
      libnes: add support for sq_sig_all
      libnes: update version to 0.9.0

Don Wood (1):
      libnes: Flushing changes

Miroslaw Walukiewicz (1):
      libnes: hook up ibv_query_qp

Vlad, please pull this in for OFED 1.5.

Thanks,

Chien
--
Chien Tung | chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
