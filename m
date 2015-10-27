From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 19/23] staging/rdma/hfi: modify workqueue for
 parallelism
Date: Tue, 27 Oct 2015 17:44:36 +0900
Message-ID: <20151027084436.GA9810@kroah.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
 <1445869729-7507-20-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1445869729-7507-20-git-send-email-ira.weiny@intel.com>
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
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, dledford@redhat.com, dennis.dalessandro@intel.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 26, 2015 at 10:28:45AM -0400, ira.weiny@intel.com wrote:
> From: Mike Marciniszyn <mike.marciniszyn@intel.com>
> 
> The workqueue is currently single threaded per port which for a small number of
> SDMA engines is ok.
> 
> For hfi1, the there are up to 16 SDMA engines that can be fed descriptors in
> parallel.
> 
> This patch:
> - Converts to use alloc_workqueue
> - Changes the workqueue limit from 1 to num_sdma
> - Makes the queue WQ_CPU_INTENSIVE and WQ_HIGHPRI
> - The sdma_engine now has a cpu that is initialized
>   as the MSI-X vectors are setup
> - Adjusts the post send logic to call a new scheduler
>   that doesn't get the s_lock
> - The new and old workqueue schedule now pass a
>   cpu
> - post send now uses the new scheduler
> - RC/UC QPs now pre-compute the sc, sde
> - The sde wq is eliminated since the new hfi1_wq is
>   multi-threaded

When you have to start enumerating all of the different things that your
patch does, that's a huge hint that you need to break it up into smaller
pieces.

Please break this up, it's not acceptable as-is.

thanks,

greg k-h
