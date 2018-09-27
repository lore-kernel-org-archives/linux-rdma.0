From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] Please pull RDMA subsystem changes
Date: Thu, 27 Sep 2018 22:17:48 +0200
Message-ID: <20180927201748.GA17445@kroah.com>
References: <20180927182432.GA11505@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927182432.GA11505@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 12:24:32PM -0600, Jason Gunthorpe wrote:
> Hi Greg,
> 
> Second rc pull request
> 
> This has a few fixes for smaller regressions introduced this cycle and
> the usual various driver oops fixes.
> 
> There is one long standing race bug in the comp_channel that Steve was
> able to reproduce, track down and fix.
> 
> I believe the HFI1 driver regression breakage has been fixed in
> Bjorn's tree and I'm currently expecting the lingering ipoib issue to
> be fixed in the netdev tree, but patches are still delayed due to
> various holidays this month.
> 
> Thanks,
> Jason
> 
> The following changes since commit 8f28b178f71cc56eccf2a6e2c0ace17c82f900d7:
> 
>   RDMA/mlx4: Ensure that maximal send/receive SGE less than supported by HW (2018-09-06 13:16:12 -0600)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-linus

Now pulled, thanks.

greg k-h
