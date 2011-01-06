From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: Re: [PATCH] infiniband/mthca : Fix userland
	mapping of mthca infiniband cards in Xen dom0
Date: Thu, 6 Jan 2011 11:55:49 -0500
Message-ID: <20110106165549.GC18774@dumpdata.com>
References: <1293034260.30522.426.camel@trax> <adamxnfdty8.fsf@cisco.com>
	<AANLkTi=zMiVJfTRDeYvbxT46b0iASKG9jPgXqG81bqAK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <xen-devel-bounces@lists.xensource.com>
Content-Disposition: inline
In-Reply-To: <AANLkTi=zMiVJfTRDeYvbxT46b0iASKG9jPgXqG81bqAK@mail.gmail.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: Vivien Bernet-Rollande <vbr@soprive.net>
Cc: jackm@mellanox.co.il, Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com, linux-rdma@vger.kernel.org, Roland Dreier <rdreier@cisco.com>, rdreir@cisco.com, sean.hefty@intel.com
List-Id: linux-rdma@vger.kernel.org

> To sum up :
>  - Xen needs the _PAGE_IOMAP flag set on the vm_page_prot for the
> device to work.
>  - I understand the proper way to do this is to set the VM_IO flag,
> and then call vm_get_page_prot()
> 
> > There are quite a few drivers under drivers/infiniband/hw that call
> > io_remap_pfn_range() -- presumably they all need the analogous fix?
> 
> I only have access to Mellanox Infinihost HBAs for testing, but once

There is another way, which I hope can fix this issue (it fixes
the graphics drivers). Basically making the Xen MMU be aware of the E820
and consider any access to PFNs that are not in RAM to have VM_IO implicitly set.

The patches are at git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git

stable/p2m-identity.v4.3

And posted on LKML )https://lkml.org/lkml/2010/12/30/163)

They _should_ take care of your problem as long as the PFNs you
are mapping fall within the PCI BAR regions (which I would presume they
do since you are using ioremap).

Please tell me if they work (or not).
