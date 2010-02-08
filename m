From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: rdma/cm: disallow loopback address for iwarp devices
Date: Mon, 8 Feb 2010 14:13:48 -0800
Message-ID: <7CC17592BE414EFCA00A1CB6033D047A@amr.corp.intel.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>
	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>
	<4B6C498F.3060708@opengridcomputing.com>
	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>
	<4B6D9948.6040007@opengridcomputing.com>
	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>
	<79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com>
	<4B6FFB1B.40905@mellanox.co.il>
	<4B701FE6.60302@opengridcomputing.com>
	<adawrynwtz9.fsf@roland-alpha.cisco.com>
	<20100208191927.GU16490@obsidianresearch.com>
	<4B706DED.9080403@opengridcomputing.com>
	<C8A2C57AD5FA4141860DBFF60BFDE2DC@amr.corp.intel.com>
	<4B707F2D.3030508@opengridcomputing.com>
	<41CC15C4-0200-4C9E-9E10-3D2A9B76D16B@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <41CC15C4-0200-4C9E-9E10-3D2A9B76D16B-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: 'Jeff Squyres' <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>What RDMA device is bound to when you use 127.0.0.1?  I'm not 100% sure, but I
>think that this might be where we got the rationale that we didn't need
>additional LOOPBACK tests in OMPI...  (if anyone else agrees with this
>interpretation, then it's at least one argument that allowing binding to
>LOOPBACK devices *is* a change in semantics, and therefore should be treated
>extremely carefully)

Are you certain that rdma_bind_addr does NOT work with 127.0.0.1, and that this
is now the problem?

It does appear to work on OFED 1.4 and on 2.6.26 based on ucmatose.  Is the
problem really with rdma_bind_addr succeeding, or with rdma_connect, which now
works, or rdma_bind_addr now assigning a device?

- Sean
