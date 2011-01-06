From: Roland Dreier <rdreier@cisco.com>
Subject: Re: Re: [PATCH] infiniband/mthca : Fix userland mapping
	of mthca infiniband cards in Xen dom0
Date: Thu, 06 Jan 2011 10:51:57 -0800
Message-ID: <adalj2xdfw2.fsf@cisco.com>
References: <1293034260.30522.426.camel@trax> <adamxnfdty8.fsf@cisco.com>
	<AANLkTi=zMiVJfTRDeYvbxT46b0iASKG9jPgXqG81bqAK@mail.gmail.com>
	<20110106165549.GC18774@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20110106165549.GC18774@dumpdata.com> (Konrad Rzeszutek Wilk's
	message of "Thu, 6 Jan 2011 11:55:49 -0500")
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jackm@mellanox.co.il, Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com, rdreir@cisco.com, linux-rdma@vger.kernel.org, Vivien Bernet-Rollande <vbr@soprive.net>, sean.hefty@intel.com
List-Id: linux-rdma@vger.kernel.org

 > There is another way, which I hope can fix this issue (it fixes
 > the graphics drivers). Basically making the Xen MMU be aware of the E820
 > and consider any access to PFNs that are not in RAM to have VM_IO implicitly set.
 > 
 > The patches are at git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
 > 
 > stable/p2m-identity.v4.3
 > 
 > And posted on LKML )https://lkml.org/lkml/2010/12/30/163)
 > 
 > They _should_ take care of your problem as long as the PFNs you
 > are mapping fall within the PCI BAR regions (which I would presume they
 > do since you are using ioremap).

Yes, that should work fine for all the cases I know of in the RDMA
drivers.  We are just mapping some PCI BAR space into userspace for
direct access to hardware (just like graphics, I think).

I definitely prefer a solution that doesn't require driver authors to
add a Xen-specific fix that isn't required on any other architecture.

 - R.
