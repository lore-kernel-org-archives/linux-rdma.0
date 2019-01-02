From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband/qedr: Potential null ptr dereference of qp
Date: Wed, 2 Jan 2019 16:28:09 -0700
Message-ID: <20190102232809.GA29987@ziepe.ca>
References: <20181224182445.21256-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181224182445.21256-1-pakki001@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 24, 2018 at 12:24:45PM -0600, Aditya Pakki wrote:
> idr_find() may fail and return a NULL pointer. The fix checks the
> return value of the function and returns an error in case of NULL.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
> ---
>  drivers/infiniband/hw/qedr/qedr_iw_cm.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied to for-rc thanks

Jason
