From: Roland Dreier <rdreier@cisco.com>
Subject: Re: linux-next: Tree for May 27 (infiniband: qib)
Date: Thu, 27 May 2010 14:45:48 -0700
Message-ID: <adaaarlvx0z.fsf@roland-alpha.cisco.com>
References: <20100527152628.b23a14c6.sfr@canb.auug.org.au>
	<20100527090503.d229dc53.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20100527090503.d229dc53.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Thu, 27 May 2010 09:05:03 -0700")
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ralph Campbell <ralph.campbell@qlogic.com>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

 > However, it looks like qib needs to handle DCA config in a way that
 > is similar to how it is handled in drivers/net/{myri10ge,igb,ixgbe}/
 > instead of assuming that DCA is enabled.

Looks like we're just going to rip out DCA support for now.

 > And please fix the linux-next 2010-may-25 reported qib problem:
 >   http://lkml.org/lkml/2010/5/25/321

I think that should be fixed in my for-next branch already (at least I
have a patch from Ralph called "IB/qib: Fix undefined symbol error when
CONFIG_PCI_MSI=n" in there).

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
