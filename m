From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Bug#894995: rdma-core: Please add support for new architecture "riscv64" (RISC-V 64 bits little-endian)
Date: Fri, 20 Apr 2018 09:31:38 -0600
Message-ID: <20180420153138.GE30433@ziepe.ca>
References: <152297424964.29286.16311629290309565149.reportbug@reva.itsari.org> <1524139218.4781.9.camel@profitbricks.com> <152297424964.29286.16311629290309565149.reportbug@reva.itsari.org>
Reply-To: Jason Gunthorpe <jgg@ziepe.ca>, 894995@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist2=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.894995.B894995.152423830220086@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <1524139218.4781.9.camel@profitbricks.com>
List-URL: <https://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Benjamin Drung <benjamin.drung@profitbricks.com>
Cc: "Manuel A. Fernandez Montecelo" <mafm@debian.org>, 894995@bugs.debian.org, List Linux RDMA Mailing <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 19, 2018 at 02:00:18PM +0200, Benjamin Drung wrote:
> > I applied the same fix as for many other arches, which is to add the
> > arch to the
> > list of NO_COHERENT_DMA_ARCHS in debian/rules.
> > 
> > I am not sure if support could be added at a later date, but for the
> > time being,
> > seems to be the best way to get it working -- I don't know enough
> > details of the
> > architecture or the assembly language to get the necessary
> > incantations in
> > place.
> 
> RISC-V has a FENCE instruction and the A extension (which is part of
> the G instruction set) provides atomic memory operations. So the
> architecture should provide coherent DMA support. To enable support,
> util/udma_barrier.h needs to be adjusted. I am including
> linux-rdma@vger.kernel.org in the loop for help.

You can't tell from the instruction set if a chip is DMA coherent or
not. It depends how the cache's are designed, and if they have a
'snoop controller' or otherwise.

Generally if *any* DMA coherent implementations exist then we should
add the fences, otherwise better to just not compile the drivers that
have no chance of working.

Jason
