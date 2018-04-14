From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH 1/3] infiniband: i40iw: Replace GFP_ATOMIC with
 GFP_KERNEL in i40iw_add_mqh_4
Date: Fri, 13 Apr 2018 20:15:17 -0500
Message-ID: <20180414011517.GD18392@ssaleem-MOBL4.amr.corp.intel.com>
References: <1523431945-3508-1-git-send-email-baijiaju1990@gmail.com>
 <a2af56ae-075f-bd13-3308-6c6ebbca7694@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a2af56ae-075f-bd13-3308-6c6ebbca7694@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>, faisal.latif@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 11, 2018 at 10:53:13AM -0400, Dennis Dalessandro wrote:
> On 4/11/2018 3:32 AM, Jia-Ju Bai wrote:
> > i40iw_add_mqh_4() is never called in atomic context, because it
> > calls rtnl_lock() that can sleep.
> > 
> > Despite never getting called from atomic context,
> > i40iw_add_mqh_4() calls kzalloc() with GFP_ATOMIC,
> > which does not sleep for allocation.
> > GFP_ATOMIC is not necessary and can be replaced with GFP_KERNEL,
> > which can sleep and improve the possibility of sucessful allocation.
> 
> Just a general comment. I don't know that this is the greatest idea. I can
> imagine instances where sleeping is OK as far as how the code is written,
> but for performance reasons you would rather fail than sleep.
> 
> As to whether that is the case here I'll let the i40iw folks comment.
>

In this case, the changes Jia made look safe and not in the perf. path. Thanks!

 
> > This is found by a static analysis tool named DCNS written by myself.
> > And I also manually check it.
> You should probably post a pointer to your tool.
> 
> -Denny
