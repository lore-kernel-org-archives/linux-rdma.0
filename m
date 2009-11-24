From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/9] rdma/cm: fix loopback address support
Date: Tue, 24 Nov 2009 21:22:34 +0200
Message-ID: <15ddcffd0911241122o3b4e815cs193fbc19c9c3cb4e@mail.gmail.com>
References: <OF34959131.79AC5DD5-ON88257677.00543B51-88257677.005450AC@us.ibm.com>
	<4B0BA10B.8010207@voltaire.com> <4B0BAD77.8070806@mellanox.co.il>
	<35A21E7711734ABAA1497D924BA7FA9A@amr.corp.intel.com>
	<15ddcffd0911241109m3b93cfdek4e3bc4d73e28dffa@mail.gmail.com>
	<18E034707AEA41A0AB0C0B91C53B4AE2@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <18E034707AEA41A0AB0C0B91C53B4AE2-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Changes were your changes to mckey, plus changes Dave added to cmatose to
> support IPv6. =A0The actual library itself hasn't been modified.

okay, got it. I was under the impression that mckey still misses an
option to get from the user an ipv6 multicast address which isn't all
zeros nor unmapped, correct? or the -m option will work with both ipv4
and ipv6 addresses?

Or.
