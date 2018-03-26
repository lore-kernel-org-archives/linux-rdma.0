From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 08:26:58 +1100
Message-ID: <1522099618.7364.0.camel@kernel.crashing.org>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <1521692689.16434.293.camel@kernel.crashing.org>
 <CAOSf1CFv1HHCL3YOVhRn2U=grdNjaQ=A4m3xwxN2Rek1-_TySg@mail.gmail.com>
 <1521726722.16434.312.camel@kernel.crashing.org>
 <20180323163510.GC13033@ziepe.ca>
 <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com>
 <20180326165425.GA15554@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180326165425.GA15554@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@ACULAB.COM>
Cc: Sinan Kaya <okaya@codeaurora.org>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT
 AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2018-03-26 at 10:54 -0600, Jason Gunthorpe wrote:
> On Mon, Mar 26, 2018 at 11:08:45AM +0000, David Laight wrote:
> > > > This is a super performance critical operation for most drivers and
> > > > directly impacts network performance.
> > 
> > Perhaps there ought to be writel_nobarrier() (etc) that never contain
> > any barriers at all.
> > This might mean that they are always just the memory operation,
> > but it would make it more obvious what the driver was doing.
> 
> I think that is what writel_relaxed is supposed to be.
> 
> The only restriction it has is that the writes to a single device
> using UC memory must be kept in program order..

Which requires barriers on some architectures :-)

Also we don't have a clear definition of what happens on WC memory.

Cheers,
Ben.
