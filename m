From: Greg KH <greg@kroah.com>
Subject: Re: Backport commit b7363e67 to stable 4.9.y
Date: Thu, 10 May 2018 12:48:25 +0200
Message-ID: <20180510104825.GB7059@kroah.com>
References: <CY1PR12MB0774AE97D2837E07B12129AEBC980@CY1PR12MB0774.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CY1PR12MB0774AE97D2837E07B12129AEBC980@CY1PR12MB0774.namprd12.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Raju Rangoju <rajur@chelsio.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, SWise OGC <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 10, 2018 at 06:41:17AM +0000, Raju  Rangoju wrote:
> Hi Greg,
> 
> Could you please backport the below commit to 4.9 stable tree. With a CPU bounded workqueue we see much lower cpu utilization and the same IOPs performance. 
> 

Your editor can use some '\n' characters :)

> commit b7363e67b23e04c23c2a99437feefac7292a88bc
> Author: Sagi Grimberg <sagi@grimberg.me>
> Date:   Wed Mar 8 22:03:17 2017 +0200
> 
>     IB/device: Convert ib-comp-wq to be CPU-bound

Now queued up, thanks.

greg k-h
