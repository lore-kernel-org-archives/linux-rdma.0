From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [for-2.6.33] rdma/cm: revert associating an RDMA
	device when binding to loopback
Date: Wed, 10 Feb 2010 10:10:49 -0800
Message-ID: <ada6365hsgm.fsf@roland-alpha.cisco.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>
	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>
	<4B6C498F.3060708@opengridcomputing.com>
	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>
	<4B6D9948.6040007@opengridcomputing.com>
	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>
	<79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com>
	<4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com>
	<adawrynwtz9.fsf@roland-alpha.cisco.com>
	<421D3D6710E847C5B7CAC00EB73117C4@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <421D3D6710E847C5B7CAC00EB73117C4-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Mon, 8 Feb 2010 16:41:15 -0800")
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
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

OK, I'm planning on sending this upstream later today.  Looks very small
and simple, and then we can figure our what if anything we want to do
for 2.6.34.

Make sense for everyone?

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
