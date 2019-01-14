From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] RDMA/cma: Rollback source IP address if failing to
 acquire device
Date: Mon, 14 Jan 2019 15:28:52 -0700
Message-ID: <20190114222852.GA22588@ziepe.ca>
References: <20190110062727.GA25844@myunghoj-Precision-5530>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190110062727.GA25844@myunghoj-Precision-5530>
Sender: linux-kernel-owner@vger.kernel.org
To: Myungho Jung <mhjungk@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Parav Pandit <parav@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 09, 2019 at 10:27:31PM -0800, Myungho Jung wrote:
> If cma_acquire_dev_by_src_ip() returns error in addr_handler(), the
> device state changes back to RDMA_CM_ADDR_BOUND but the resolved source
> IP address is still left. After that, if rdma_destroy_id() is called
> after rdma_listen(), the device is freed without removed from
> listen_any_list in cma_cancel_operation(). Revert to the previous IP
> address if acquiring device fails.
> 
> Reported-by: syzbot+f3ce716af730c8f96637@syzkaller.appspotmail.com
> Signed-off-by: Myungho Jung <mhjungk@gmail.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/infiniband/core/cma.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

Applied to for-next, thanks

Jason
