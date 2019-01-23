From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/8] IB: cleanup debugfs usage
Date: Wed, 23 Jan 2019 14:15:57 -0700
Message-ID: <20190123211557.GA8556@ziepe.ca>
References: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 22, 2019 at 04:17:52PM +0100, Greg Kroah-Hartman wrote:
> When calling debugfs code, there is no need to ever check the return
> value of the call, as no logic should ever change if a call works
> properly or not.  Fix up a bunch of infiniband-specific code to not care
> about the results of debugfs.
> 
> Greg Kroah-Hartman (8):
>   infiniband: cxgb4: no need to check return value of debugfs_create functions
>   infiniband: hfi1: drop crazy DEBUGFS_SEQ_FILE_CREATE() macro
>   infiniband: hfi1: no need to check return value of debugfs_create functions
>   infiniband: qib: no need to check return value of debugfs_create functions
>   infiniband: mlx5: no need to check return value of debugfs_create functions
>   infiniband: ocrdma: no need to check return value of debugfs_create functions
>   infiniband: usnic: no need to check return value of debugfs_create functions
>   infiniband: ipoib: no need to check return value of debugfs_create functions

Applied to rdma for-next

Thanks,
Jason
