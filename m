From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 14/23] staging/rdma/hfi1: Implement Expected Receive
 TID caching
Date: Tue, 27 Oct 2015 17:22:10 +0900
Message-ID: <20151027082210.GA7383@kroah.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
 <1445869729-7507-15-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1445869729-7507-15-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: ira.weiny@intel.com
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, dennis.dalessandro@intel.com, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 26, 2015 at 10:28:40AM -0400, ira.weiny@intel.com wrote:
> From: Mitko Haralanov <mitko.haralanov@intel.com>
> 
> Expected receives work by user-space libraries (PSM) calling into the
> driver with information about the user's receive buffer and have the driver
> DMA-map that buffer and program the HFI to receive data directly into it.
> 
> This is an expensive operation as it requires the driver to pin the pages
> which
> the user's buffer maps to, DMA-map them, and then program the HFI.
> 
> When the receive is complete, user-space libraries have to call into the driver
> again so the buffer is removed from the HFI, un-mapped, and the pages unpinned.
> 
> All of these operations are expensive, considering that a lot of applications
> (especially micro-benchmarks) use the same buffer over and over.
> 
> In order to get better performance for user-space applications, it is highly
> beneficial that they don't continuously call into the driver to register and
> unregister the same buffer. Rather, they can register the buffer and cache it
> for future work. The buffer can be unregistered when it is freed by the user.
> 
> This change implements such buffer caching by making use of the kernel's MMU
> notifier API. User-space libraries call into the driver only when the need to
> register a new buffer.
> 
> Once a buffer is registered, it stays programmed into the HFI until the kernel
> notifies the driver that the buffer has been freed by the user. At that time,
> the user-space library is notified and it can do the necessary work to remove
> the buffer from its cache.
> 
> Buffers which have been invalidated by the kernel are not automatically removed
> from the HFI and do not have their pages unpinned. Buffers are only completely
> removed when the user-space libraries call into the driver to free them.  This
> is done to ensure that any ongoing transfers into that buffer are complete.
> This is important when a buffer is not completely freed but rather it is
> shrunk. The user-space library could still have uncompleted transfers into the
> remaining buffer.
> 
> With this feature, it is important that systems are setup with reasonable
> limits for the amount of lockable memory.  Keeping the limit at "unlimited" (as
> we've done up to this point), may result in jobs being killed by the kernel's
> OOM due to them taking up excessive amounts of memory.
> 
> Reviewed-by: Arthur Kepner <arthur.kepner@intel.com>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes from V2:
> 	Fix random Kconfig 0-day build error
> 	Fix leak of random memory to user space caught by Dan Carpenter
> 	Separate out pointer bug fix into a previous patch
> 	Change error checks in case statement per Dan's comments
> 
>  drivers/staging/rdma/hfi1/Kconfig        |    1 +
>  drivers/staging/rdma/hfi1/Makefile       |    2 +-
>  drivers/staging/rdma/hfi1/common.h       |   15 +-
>  drivers/staging/rdma/hfi1/file_ops.c     |  490 ++-----------
>  drivers/staging/rdma/hfi1/hfi.h          |   43 +-
>  drivers/staging/rdma/hfi1/init.c         |    5 +-
>  drivers/staging/rdma/hfi1/trace.h        |  132 ++--
>  drivers/staging/rdma/hfi1/user_exp_rcv.c | 1171 ++++++++++++++++++++++++++++++
>  drivers/staging/rdma/hfi1/user_exp_rcv.h |   82 +++
>  drivers/staging/rdma/hfi1/user_pages.c   |  110 +--
>  drivers/staging/rdma/hfi1/user_sdma.c    |   13 +
>  drivers/staging/rdma/hfi1/user_sdma.h    |   10 +-
>  include/uapi/rdma/hfi/hfi1_user.h        |   42 +-
>  13 files changed, 1481 insertions(+), 635 deletions(-)
>  create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.c
>  create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.h

This is way too big to review properly, please break it up into
reviewable chunks.

thanks,

greg k-h
