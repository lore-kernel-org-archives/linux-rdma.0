From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 08:27:12 +1100
Message-ID: <1522186032.7364.57.camel@kernel.crashing.org>
References: <20180326210951.GD15554@ziepe.ca>
 <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <ebb36fd4-62e2-394a-219f-686c45a6dc75@codeaurora.org>
 <1522101717.7364.14.camel@kernel.crashing.org>
 <20180326222756.GJ15554@ziepe.ca>
 <CAK8P3a3a+zUNLjqw9CL5rYkXhJ-GMVTVnBU2XUu2f3njZfrqKw@mail.gmail.com>
 <1522141019.7364.43.camel@kernel.crashing.org>
 <CAK8P3a0gCYjw78snni_1Jkk5uA5a-j0x-XZDrN=RaZfXctOSoA@mail.gmail.com>
 <1522149801.7364.49.camel@kernel.crashing.org>
 <4f27ac42a6953589157f4d7f18051366@codeaurora.org>
 <20180327141215.GA12318@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180327141215.GA12318@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>, okaya@codeaurora.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, Will Deacon <will.deacon@arm.com>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, Alexander Duyck <alexander.h.duyck@redhat.com>, "open list:LINUX FOR POWERPC (32-BIT AND
 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2018-03-27 at 08:12 -0600, Jason Gunthorpe wrote:
> > I have been converting wmb+writel to wmb+writel_relaxed. (About 30 patches)
> > 
> > I will have to just remove the wmb and keep writel, then repost.
> 
> Okay, but before you do that, can we get a statement how this works
> for WC?
> 
> Some of these writels are to WC memory, do they need the wmb()?!?

This is an issue as we don't have well defined semantics for WC.

At this point, I would suggest staying away from that (ie, not changing
them). We need to look into it.

I know for example that on powerpc I cannot give you any weaker
semantic on WC for writel (I have to put a full sync in there), but I
am trying to see if I can make writel_relaxed both work with the
existing semantics and provide combining. But it's not yet a given (our
weaker IO barrier, eieio, isn't architecturally defined to do anything
on G=0 space, looking with the HW guys at what the HW actually does).

Cheers,
Ben.
