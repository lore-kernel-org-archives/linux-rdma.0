From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: Re: [patch][tests][perftest] Make the server and client
	agree	to	work via IPv4.
Date: Mon, 20 Sep 2010 09:33:14 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB78C9AF@orsmsx501.amr.corp.intel.com>
References: <E113D394D7C5DB4F8FF691FA7EE9DB443BF12865B9@MTLMAIL.mtl.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25AB78C89D@orsmsx501.amr.corp.intel.com>
	<E113D394D7C5DB4F8FF691FA7EE9DB443BF130E03A@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443BF130E03A@MTLMAIL.mtl.com>
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
To: Irena Gannon <irena@mellanox.co.il>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> 1. I don't see that this file exists in svn.
> [Irena] 	You can see the file in:
> svn://openib.tc.cornell.edu/gen1/trunk/tests/perftest. It was added in
> commit 2918.

Ok - I see this after updating my local tree.

> 
> 2. We want to support ipv6.
> [Irena]  	The IPv4 is used to open a socket in the beginning of the test
> just in order to exchange the connection info (lid, qp number) between the
> sides.
> 		This choice of IPv4 exists in the ib_XXXX_bw/ib_XXXX_lat tests
> as well, for example in the function pp_client_connect in the file
> 					tools\perftests\user\perf_utils.c

We should still support ipv6.  I don't see this sort of restriction placed on the Linux code.

I've seen this sort of problem before, but it's been so long ago that I don't remember if it was on Linux or Windows or what the resolution was.
