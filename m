From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 08:24:01 -0600
Message-ID: <20180327142401.GC12318@ziepe.ca>
References: <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca>
 <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca>
 <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <ebb36fd4-62e2-394a-219f-686c45a6dc75@codeaurora.org>
 <1522101717.7364.14.camel@kernel.crashing.org>
 <20180326222756.GJ15554@ziepe.ca>
 <CAK8P3a3a+zUNLjqw9CL5rYkXhJ-GMVTVnBU2XUu2f3njZfrqKw@mail.gmail.com>
 <20180327094159.GA29373@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20180327094159.GA29373@arm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, Alexander Duyck <alexander.h.duyck@redhat.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 10:42:00AM +0100, Will Deacon wrote:
> On Tue, Mar 27, 2018 at 09:56:47AM +0200, Arnd Bergmann wrote:
> > On Tue, Mar 27, 2018 at 12:27 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > On Tue, Mar 27, 2018 at 09:01:57AM +1100, Benjamin Herrenschmidt wrote:
> > >> On Mon, 2018-03-26 at 17:46 -0400, Sinan Kaya wrote:
> > >
> > > I even see patches adding wmb() based on actual observed memory
> > > corruption during testing on Intel:
> > >
> > > https://patchwork.kernel.org/patch/10177207/
> > >
> > > So you think all of this is unnecessary and writel is totally strongly
> > > ordered, even on multi-socket Intel?
> > 
> > This example adds a wmb() between two writes to a coherent DMA
> > area, it is definitely required there. I'm pretty sure I've never seen
> > any bug reports pointing to a missing wmb() between memory
> > and MMIO write accesses, but if you remember seeing them in the
> > list, maybe you can look again for some evidence of something going
> > wrong on x86 without it?
> 
> If this is just about ordering accesses to coherent DMA, then using
> dma_wmb() instead will be much better performance on arm/arm64.

dma_wmb() is a NOP on x86, it was tested anyhow and didn't help
this case.. Confusing, but probably not relevant to this discussion.

Jason
