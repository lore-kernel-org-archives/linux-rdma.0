From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v3 18/18] infiniband: cxgb4: Eliminate duplicate barriers
 on weakly-ordered archs
Date: Sun, 18 Mar 2018 19:48:05 -0600
Message-ID: <20180319014805.GA27186@ziepe.ca>
References: <1521216991-28706-1-git-send-email-okaya@codeaurora.org>
 <1521216991-28706-19-git-send-email-okaya@codeaurora.org>
 <003601d3bd6a$783d6970$68b83c50$@opengridcomputing.com>
 <83387f6e-adcb-14e9-2c22-96abf9493cc6@codeaurora.org>
 <004501d3bd7b$505e70f0$f11b52d0$@opengridcomputing.com>
 <740c7d45-450e-c9b3-ceed-7bc7fcefbc5a@codeaurora.org>
 <71e37a55-537b-d75a-cfde-f188b7cfce8e@codeaurora.org>
 <1f5e3b14-05a1-08d0-c0cb-00805526448d@codeaurora.org>
 <20180317150520.GA23463@ziepe.ca>
 <ac9c34e1-0a81-a494-c7c7-ac9c3922095a@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac9c34e1-0a81-a494-c7c7-ac9c3922095a@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: Steve Wise <swise@opengridcomputing.com>, netdev@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 'Steve Wise' <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 'Michael Werner' <werner@chelsio.com>, 'Casey Leedom' <leedom@chelsio.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Mar 17, 2018 at 02:30:10PM -0400, Sinan Kaya wrote:

> Somebody also has to take a task and work very hard to get rid of __raw_writeX()
> APIs in drivers/net directory. It looked like a very common practice though
> it clearly violates multiarch portability concerns Jason and Deve highlighted.

When you posted your list I thought most of the hits were in what I'd
think of 'one-arch drivers', eg an IRQ controller or clock driver or
something.. Some might have a reason for it (eg avoiding the swap, for
instance), maybe it is a hold over from before writel_relaxed, or
maybe it is just a cargo-cult behavior..

It is the obviously multi-arch drivers that probably need some
attention..

Jason
