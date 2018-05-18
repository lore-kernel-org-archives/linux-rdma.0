From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 02/26] sysfs: export sysfs_remove_file_self()
Date: Fri, 18 May 2018 08:08:38 -0700
Message-ID: <20180518150838.GC1718769@devbig577.frc2.facebook.com>
References: <20180518130413.16997-1-roman.penyaev@profitbricks.com>
 <20180518130413.16997-3-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180518130413.16997-3-roman.penyaev@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Pen <roman.penyaev@profitbricks.com>
Cc: linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Bart Van Assche <bart.vanassche@sandisk.com>, Or Gerlitz <ogerlitz@mellanox.com>, Doug Ledford <dledford@redhat.com>, Swapnil Ingle <swapnil.ingle@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jack Wang <jinpu.wang@profitbricks.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 18, 2018 at 03:03:49PM +0200, Roman Pen wrote:
> Function is going to be used in transport over RDMA module
> in subsequent patches.
> 
> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-kernel@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to apply with other patches.

Thanks.

-- 
tejun
