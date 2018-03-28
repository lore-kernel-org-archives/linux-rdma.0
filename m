From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 20:56:50 +1100
Message-ID: <1522231010.21446.8.camel@kernel.crashing.org>
References: <20180327095745.GB29373@arm.com>
 <CAK8P3a0s+kP5=qEqTqAHGwB7j9ydaXD+oQJdLrFz=8swuWaDBg@mail.gmail.com>
 <20180327100944.GD29373@arm.com>
 <CAK8P3a0Xep0-EpGS9jnjUf1iJhRxH1WRztGQrvkdrLVaxBPT1w@mail.gmail.com>
 <20180327110258.GF2464@arm.com>
 <bba5ebd8-0643-6f09-9367-419b49e53535@codeaurora.org>
 <20180327143628.GA10642@arm.com>
 <1522186185.7364.59.camel@kernel.crashing.org>
 <20180328085338.GA28871@arm.com>
 <5d3973edea93473197505f2e42cd3107@AcuMS.aculab.com>
 <20180328090907.GC28871@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180328090907.GC28871@arm.com>
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
To: Will Deacon <will.deacon@arm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Oliver <oohall@gmail.com>, "Paul E.
 McKenney" <paulmck@linux.vnet.ibm.com>, "open list:LINUX FOR
 POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-03-28 at 10:09 +0100, Will Deacon wrote:
> On Wed, Mar 28, 2018 at 09:00:01AM +0000, David Laight wrote:
> > From: Will Deacon
> > > Sent: 28 March 2018 09:54
> > 
> > ...
> > > > > I don't think so. My reading of memory-barriers.txt says that writeX might
> > > > > expand to outX, and outX is not ordered with respect to other types of
> > > > > memory.
> > > > 
> > > > Ugh ?
> > > > 
> > > > My understanding of HW at least is the exact opposite. outX is *more*
> > > > ordered if anything, than any other accessors. IO space is completely
> > > > synchronous, non posted and ordered afaik.
> > > 
> > > I'm just going by memory-barriers.txt:
> > > 
> > > 
> > >  (*) inX(), outX():
> > > 
> > >      [...]
> > > 
> > >      They are guaranteed to be fully ordered with respect to each other.
> > > 
> > >      They are not guaranteed to be fully ordered with respect to other types of
> > >      memory and I/O operation.
> > 
> > A long time ago there was a document from Intel that said that inb/outb weren't
> > necessarily synchronised wrt memory accesses.
> > (Might be P-pro era).
> > However no processors actually behaved that way and more recent docs
> > say that inb/outb are fully ordered.
> 
> Thank you, David! I'll write another patch fixing this up and hopefully
> we'll soon have one making writeX/readX much clearer.

Thanks for doing the grunt work Will ! :-)

Cheers,
Ben.
