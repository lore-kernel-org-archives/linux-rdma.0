From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH 1/3] infiniband: i40iw: Replace GFP_ATOMIC with
 GFP_KERNEL in i40iw_add_mqh_4
Date: Fri, 13 Apr 2018 20:10:29 -0500
Message-ID: <20180414011029.GA18392@ssaleem-MOBL4.amr.corp.intel.com>
References: <1523431945-3508-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1523431945-3508-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: faisal.latif@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 11, 2018 at 03:32:25PM +0800, Jia-Ju Bai wrote:
> i40iw_add_mqh_4() is never called in atomic context, because it 
> calls rtnl_lock() that can sleep.
> 
> Despite never getting called from atomic context,
> i40iw_add_mqh_4() calls kzalloc() with GFP_ATOMIC,
> which does not sleep for allocation.
> GFP_ATOMIC is not necessary and can be replaced with GFP_KERNEL,
> which can sleep and improve the possibility of sucessful allocation.
> 
> This is found by a static analysis tool named DCNS written by myself.
> And I also manually check it.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---

Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
