From: Jose Abreu <Jose.Abreu@synopsys.com>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 16:01:08 +0100
Message-ID: <922aa06f-8aff-ccdd-fab2-63a30a883d23@synopsys.com>
References: <1521692689.16434.293.camel@kernel.crashing.org>
 <CAOSf1CFv1HHCL3YOVhRn2U=grdNjaQ=A4m3xwxN2Rek1-_TySg@mail.gmail.com>
 <1521726722.16434.312.camel@kernel.crashing.org>
 <20180323163510.GC13033@ziepe.ca>
 <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com>
 <20180326165425.GA15554@ziepe.ca>
 <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca>
 <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca>
 <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <1522101616.7364.13.camel@kernel.crashing.org>
 <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, Will Deacon <will.deacon@arm.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Hi,

On 27-03-2018 15:46, Sinan Kaya wrote:
>
> Sinan
> "We are being told that if you use writel(), then you don't need a wmb() on
> all architectures."
>
> Alex:
> "I'm not sure who told you that but that is incorrect, at least for
> x86. If you attempt to use writel() without the wmb() we will have to
> NAK the patches. We will accept the wmb() with writel_releaxed() since
> that solves things for ARM."
>

So this means we should always use writel() + wmb() in *all*
accesses? I don't know about x86 but arc architecture doesn't
have a wmb() in the writel() function (in some configs).

I see the point in net drivers while you have dma + io accesses
but for most drivers this shouldn't be needed, right?

What about ordering of writes? Is it guaranteed that one write
will happen before the next one ?

Best Regards,
Jose Miguel Abreu
