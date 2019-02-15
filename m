From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 00/19] Add unified Intel Ethernet RDMA driver (irdma)
Date: Fri, 15 Feb 2019 10:20:11 -0700
Message-ID: <20190215172011.GB30706@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190215171107.6464-1-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 15, 2019 at 11:10:47AM -0600, Shiraz Saleem wrote:

> The unified driver is currently being tested on X722 with rdma-core-v22.
> X722 is supported by this driver, but only if CONFIG_INFINIBAND_I40IW
> is disabled in the kernel. We desire to deprecate or phase out i40iw
> from the kernel and can submit patches to do the same. We would like to
> move forward with this unified driver model for current and future HW.

You need to do better than this.. rdma-core should setup to detect
which of the kernel drivers is present and do the right thing. This
may require some new infrastructure work, but siw and rxe need this
capability as well.

> This series was built against rdma-next.
> commit 21a428a019c9 ("RDMA: Handle PD allocations by IB/core")
> It includes both net and rdma patches for the purposes
> of review. It will be split into two separate patch series, one for
> net-next and rdma-next once RFC is accepted.
> 
> [1] https://patchwork.kernel.org/patch/10419583/

Be aware we cannot take net-next into rdma. You would be best to
submit a clean -rcX based PR to both net and RDMA for your net
portion.

Jason
