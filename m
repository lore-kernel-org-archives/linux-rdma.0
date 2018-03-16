From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 18/18] infiniband: cxgb4: Eliminate duplicate barriers
 on weakly-ordered archs
Date: Fri, 16 Mar 2018 16:13:47 -0600
Message-ID: <20180316221347.GA958@ziepe.ca>
References: <1521216991-28706-1-git-send-email-okaya@codeaurora.org>
 <1521216991-28706-19-git-send-email-okaya@codeaurora.org>
 <003601d3bd6a$783d6970$68b83c50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <003601d3bd6a$783d6970$68b83c50$@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Sinan Kaya' <okaya@codeaurora.org>, netdev@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 'Steve Wise' <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 'Michael Werner' <werner@chelsio.com>, 'Casey Leedom' <leedom@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 16, 2018 at 04:05:10PM -0500, Steve Wise wrote:
> > Code includes wmb() followed by writel(). writel() already has a barrier
> on
> > some architectures like arm64.
> > 
> > This ends up CPU observing two barriers back to back before executing the
> > register write.
> > 
> > Since code already has an explicit barrier call, changing writel() to
> > writel_relaxed().
> > 
> > Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> 
> NAK - This isn't correct for PowerPC.  For PowerPC, writeX_relaxed() is just
> writeX().  

?? Why is changing writex() to writeX() a NAK then?

> I was just looking at this with Chelsio developers, and they said the
> writeX() should be replaced with __raw_writeX(), not writeX_relaxed(), to
> get rid of the extra barrier for all architectures.

That doesn't seem semanticaly sane.

__raw_writeX() should not appear in driver code, IMHO. Only the arch
code can know what the exact semantics of that accessor are..

If ppc can't use writel_relaxed to optimize then we probably need yet
another io accessor semantic defined :(

Jason
