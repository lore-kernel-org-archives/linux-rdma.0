From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 1/2] mlx4: remove unnecessary pci_set_drvdata()
Date: Tue, 15 Aug 2017 11:21:49 -0600
Message-ID: <20170815172149.GC15171@obsidianresearch.com>
References: <1502778786-14738-1-git-send-email-yanjun.zhu@oracle.com>
 <20170815071336.GL24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170815071336.GL24282@mtr-leonro.local>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Zhu Yanjun <yanjun.zhu@oracle.com>, saeedm@mellanox.com, matanb@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, yuval.shaia@oracle.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 15, 2017 at 10:13:36AM +0300, Leon Romanovsky wrote:
> On Tue, Aug 15, 2017 at 02:33:05AM -0400, Zhu Yanjun wrote:
> > The driver core clears the driver data to NULL after device_release
> > or on probe failure. Thus, it is not necessary to manually clear the
> > device driver data to NULL.
> >
> 
> It makes sense and I'm pretty sure that you are right, but I'm failing
> to find the function in device core which sets it to NULL. Can you help
> me and present the actual call stack to that code place?

http://elixir.free-electrons.com/linux/v4.13-rc1/source/drivers/base/dd.c#L840

The call to the remove callback is on line 833.

This is done after dropping devres, so you could allocate the drv data
inside a devm object and everything would unwind correctly.

In this case, the kfree is explicit, so I would advocate for still putting
the null near the kfree to minimize the time where a free'd pointer is
present - eg incase a devm callback or some other bug accidently
touches it.

Jason
