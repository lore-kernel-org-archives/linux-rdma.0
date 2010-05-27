From: Ralph Campbell <ralph.campbell@qlogic.com>
Subject: Re: linux-next: Tree for May 27 (infiniband: qib)
Date: Thu, 27 May 2010 15:22:03 -0700
Message-ID: <1274998923.17393.28.camel@chromite.mv.qlogic.com>
References: <20100527152628.b23a14c6.sfr@canb.auug.org.au>
	 <20100527090503.d229dc53.randy.dunlap@oracle.com>
	 <adaaarlvx0z.fsf@roland-alpha.cisco.com>  <4BFEECD3.7020203@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <4BFEECD3.7020203@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rdreier@cisco.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2010-05-27 at 15:06 -0700, Randy Dunlap wrote:
> On 05/27/10 14:45, Roland Dreier wrote:
> >  > However, it looks like qib needs to handle DCA config in a way that
> >  > is similar to how it is handled in drivers/net/{myri10ge,igb,ixgbe}/
> >  > instead of assuming that DCA is enabled.
> > 
> > Looks like we're just going to rip out DCA support for now.
> > 
> >  > And please fix the linux-next 2010-may-25 reported qib problem:
> >  >   http://lkml.org/lkml/2010/5/25/321
> > 
> > I think that should be fixed in my for-next branch already (at least I
> > have a patch from Ralph called "IB/qib: Fix undefined symbol error when
> > CONFIG_PCI_MSI=n" in there).
> 
> Sounds good.  Was is posted to linux-rdma?
> 
> thanks,

Yes, I posted it to linux-rdma.

http://www.spinics.net/lists/linux-rdma/msg04140.html

http://www.spinics.net/lists/linux-rdma/msg04187.html
