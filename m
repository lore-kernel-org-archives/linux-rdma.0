From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 09:00:01 +0000
Message-ID: <5d3973edea93473197505f2e42cd3107@AcuMS.aculab.com>
References: <CAK8P3a3a+zUNLjqw9CL5rYkXhJ-GMVTVnBU2XUu2f3njZfrqKw@mail.gmail.com>
 <1522141019.7364.43.camel@kernel.crashing.org>
 <20180327095745.GB29373@arm.com>
 <CAK8P3a0s+kP5=qEqTqAHGwB7j9ydaXD+oQJdLrFz=8swuWaDBg@mail.gmail.com>
 <20180327100944.GD29373@arm.com>
 <CAK8P3a0Xep0-EpGS9jnjUf1iJhRxH1WRztGQrvkdrLVaxBPT1w@mail.gmail.com>
 <20180327110258.GF2464@arm.com>
 <bba5ebd8-0643-6f09-9367-419b49e53535@codeaurora.org>
 <20180327143628.GA10642@arm.com>
 <1522186185.7364.59.camel@kernel.crashing.org>
 <20180328085338.GA28871@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180328085338.GA28871@arm.com>
Content-Language: en-US
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
To: 'Will Deacon' <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Oliver <oohall@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open list:LINUX FOR
 POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

From: Will Deacon
> Sent: 28 March 2018 09:54
...
> > > I don't think so. My reading of memory-barriers.txt says that writeX =
might
> > > expand to outX, and outX is not ordered with respect to other types o=
f
> > > memory.
> >
> > Ugh ?
> >
> > My understanding of HW at least is the exact opposite. outX is *more*
> > ordered if anything, than any other accessors. IO space is completely
> > synchronous, non posted and ordered afaik.
>=20
> I'm just going by memory-barriers.txt:
>=20
>=20
>  (*) inX(), outX():
>=20
>      [...]
>=20
>      They are guaranteed to be fully ordered with respect to each other.
>=20
>      They are not guaranteed to be fully ordered with respect to other ty=
pes of
>      memory and I/O operation.

A long time ago there was a document from Intel that said that inb/outb wer=
en't
necessarily synchronised wrt memory accesses.
(Might be P-pro era).
However no processors actually behaved that way and more recent docs
say that inb/outb are fully ordered.

	David
