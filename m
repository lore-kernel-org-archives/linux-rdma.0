From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 3/6] RDMA/i40iw: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Tue, 20 Mar 2018 08:56:26 -0600
Message-ID: <20180320145626.GJ19744@ziepe.ca>
References: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
 <1521514068-8856-4-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521514068-8856-4-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 19, 2018 at 10:47:45PM -0400, Sinan Kaya wrote:
> Code includes wmb() followed by writel(). writel() already has a barrier on
> some architectures like arm64.
> 
> This ends up CPU observing two barriers back to back before executing the
> register write.
> 
> Create a new wrapper function with relaxed write operator. Use the new
> wrapper when a write is following a wmb().
> 
> Since code already has an explicit barrier call, changing writel() to
> writel_relaxed().
> 
> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c  |  6 ++++--
>  drivers/infiniband/hw/i40iw/i40iw_osdep.h |  1 +
>  drivers/infiniband/hw/i40iw/i40iw_uk.c    |  2 +-
>  drivers/infiniband/hw/i40iw/i40iw_utils.c | 11 +++++++++++
>  4 files changed, 17 insertions(+), 3 deletions(-)

The one looks fine

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
