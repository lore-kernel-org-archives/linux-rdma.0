From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-next 0/3] Driver fixes
Date: Mon, 4 Mar 2019 15:49:35 -0400
Message-ID: <20190304194935.GB1816@ziepe.ca>
References: <20190226164333.31476.43732.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190226164333.31476.43732.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 26, 2019 at 08:45:02AM -0800, Dennis Dalessandro wrote:
> Hi Jason and Doug,
> 
> Here are some fixes that didn't quite make the boat for 5.0-rc. So we can
> go ahead and send them to -next. The third patch here is really a v2 of:
> 
> https://patchwork.kernel.org/patch/10769005/
> 
> 
> Michael J. Ruhl (2):
>       IB/rdmavt: Fix concurrency panics in QP post_send and modify to error
>       IB/hfi1: Close race condition on user context disable and close
> 
> Mike Marciniszyn (1):
>       IB/rdmavt: Fix loopback send with invalidate ordering

Applied to for-next, thanks

Jason
