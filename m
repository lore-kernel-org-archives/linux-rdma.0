From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: RFC on writel and writel_relaxed
Date: Mon, 26 Mar 2018 16:27:56 -0600
Message-ID: <20180326222756.GJ15554@ziepe.ca>
References: <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com>
 <20180326165425.GA15554@ziepe.ca>
 <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca>
 <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca>
 <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <ebb36fd4-62e2-394a-219f-686c45a6dc75@codeaurora.org>
 <1522101717.7364.14.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1522101717.7364.14.camel@kernel.crashing.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, Alexander Duyck <alexander.h.duyck@redhat.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 09:01:57AM +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2018-03-26 at 17:46 -0400, Sinan Kaya wrote:
> > On 3/26/2018 5:30 PM, Arnd Bergmann wrote:
> > > > But that was never a requirement of writel(),
> > > > Documentation/memory-barriers.txt gives an explicit example demanding
> > > > the wmb() before writel() for ordering system memory against writel.
> > > 
> > > Indeed, but it's in an example for when to use dma_wmb(), not wmb().
> > > Adding Alexander Duyck to Cc, he added that section as part of
> > > 1077fa36f23e ("arch: Add lightweight memory barriers dma_rmb() and
> > > dma_wmb()"). Also adding the other people that were involved with that.
> > > 
> > 
> > ARM developers can get away with not including wmb() in their code and use
> > writel() to observe memory writes due to implicit barriers.
> > 
> > However, same code will not work on Intel.
> 
> Wrong. It will.
> 
> You do NOT need wmb between writes to memory and writel.
> 
> > writel() has a compiler barrier in it for x86.
> > wmb() has a sync operation in it for x86. 
> > 
> > Unless wmb() is called, PCIe device won't observe memory updates from the CPU.
> 
> This is completely wrong. They will. Intel provides the necessary
> ordering guarantees without an explicit wmb.
> 
> Otherwise almost all drivers out there are broken which I very much
> doubt :-)

But.. Sinan is right, you look anywhere in the driver tree and you
find stuff like this:

drivers/net/ethernet/intel/i40e/i40e_txrx.c

        /* Force memory writes to complete before letting h/w
         * know there are new descriptors to fetch.
         */
        wmb();


It is *systemic*

I even see patches adding wmb() based on actual observed memory
corruption during testing on Intel:

https://patchwork.kernel.org/patch/10177207/

So you think all of this is unnecessary and writel is totally strongly
ordered, even on multi-socket Intel?

Jason
