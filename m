From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH v3 18/18] infiniband: cxgb4: Eliminate duplicate barriers on weakly-ordered archs
Date: Fri, 16 Mar 2018 18:04:40 -0500
Message-ID: <004401d3bd7b$2a2e70b0$7e8b5210$@opengridcomputing.com>
References: <1521216991-28706-1-git-send-email-okaya@codeaurora.org> <1521216991-28706-19-git-send-email-okaya@codeaurora.org> <003601d3bd6a$783d6970$68b83c50$@opengridcomputing.com> <20180316221347.GA958@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316221347.GA958@ziepe.ca>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Jason Gunthorpe' <jgg@ziepe.ca>
Cc: 'Sinan Kaya' <okaya@codeaurora.org>, netdev@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 'Steve Wise' <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 'Michael Werner' <werner@chelsio.com>, 'Casey Leedom' <leedom@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

> 
> On Fri, Mar 16, 2018 at 04:05:10PM -0500, Steve Wise wrote:
> > > Code includes wmb() followed by writel(). writel() already has a
barrier
> > on
> > > some architectures like arm64.
> > >
> > > This ends up CPU observing two barriers back to back before executing
> the
> > > register write.
> > >
> > > Since code already has an explicit barrier call, changing writel() to
> > > writel_relaxed().
> > >
> > > Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> >
> > NAK - This isn't correct for PowerPC.  For PowerPC, writeX_relaxed() is
just
> > writeX().
> 
> ?? Why is changing writex() to writeX() a NAK then?

Because I want it correct for PPC as well.

> 
> > I was just looking at this with Chelsio developers, and they said the
> > writeX() should be replaced with __raw_writeX(), not writeX_relaxed(),
to
> > get rid of the extra barrier for all architectures.
> 
> That doesn't seem semanticaly sane.
> 
> __raw_writeX() should not appear in driver code, IMHO. Only the arch
> code can know what the exact semantics of that accessor are..
> 
> If ppc can't use writel_relaxed to optimize then we probably need yet
> another io accessor semantic defined :(


Anybody understand why the PPC implementation of writeX_relaxed() isn't
relaxed?


Steve.
