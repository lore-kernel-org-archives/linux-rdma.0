From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: OFED 1.5.2: libibumad.so version bump
Date: Thu, 2 Sep 2010 15:52:56 -0600
Message-ID: <20100902215256.GU24971@obsidianresearch.com>
References: <4C7CCB01.909@dev.mellanox.co.il> <20100831124915.ac4dc1bd.weiny2@llnl.gov> <AANLkTim1_D5+GMWX80X0afu8A8_kizbQUq1KUhxxSLpz@mail.gmail.com> <20100902140502.62489af7.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100902140502.62489af7.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yevgeny Kliteynik <kliteyn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OpenFabricsEWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Mark A. Grondona" <mgrondona-i2BcT+NCU+M@public.gmane.org>, "Moody, Adam T." <moody20-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 02, 2010 at 02:05:02PM -0700, Ira Weiny wrote:

> > The ABI compatibility is not achieved by administrative means
> > (separate repos, etc.) but rather than review and discipline to
> > achieve this as a unmutable goal.
> 
> I agree that ABI compatibility will require more discipline.  That is what
> made me think of the separate git trees.  I feel it will be _easier_ to
> maintain this discipline when the trees are separate.

I would almost think the reverse.. It feels like there are *too many*
GIT trees and too few maintainers. I do argee that including the core
MAD libraries with opensm is kinda silly.

Consider bundling all the core libraries into a single git tree and
considering a group of people to watch for these issues for all the
libraries, together.

It feels like ongoing development of many of these libs has stopped,
plus they are so tiny, it might be a better use of everyones time this
way?

When I say combine together, I really mean that, shared configure
script, etc, etc. Not like we see in the management.git.

As it is, building the core OFA userspace from source is a huge
PITA. Just finding the proper git trees is often hard..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
