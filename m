From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/i40iw: Fix incorrect iterator type
Date: Wed, 19 Sep 2018 10:13:41 -0600
Message-ID: <20180919161341.GB9867@ziepe.ca>
References: <20180917140707.1253738-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917140707.1253738-1-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <Haakon.Bugge@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, faisal.latif@intel.com, shiraz.saleem@intel.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 17, 2018 at 04:07:07PM +0200, Håkon Bugge wrote:
> Commit f27b4746f378 ("i40iw: add connection management code") uses an
> incorrect rcu iterator, whilst holding the rtnl_lock. Since the
> critical region invokes i40iw_manage_qhash(), which is a sleeping
> function, the rcu locking and traversal cannot be used.
> 
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> ---
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason
