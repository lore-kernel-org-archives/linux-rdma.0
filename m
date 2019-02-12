From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC 17/19] RDMA/irdma: Add ABI definitions
Date: Tue, 12 Feb 2019 16:05:08 -0700
Message-ID: <20190212230508.GV24692@ziepe.ca>
References: <20190212214402.23284-1-shiraz.saleem@intel.com>
 <20190212214402.23284-18-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190212214402.23284-18-shiraz.saleem@intel.com>
Sender: netdev-owner@vger.kernel.org
To: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 12, 2019 at 03:44:00PM -0600, Shiraz Saleem wrote:

> +struct irdma_create_cq_req {
> +	__aligned_u64 user_cq_buf;
> +	__aligned_u64 user_shadow_area;
> +};

This is the right way to use u64 in uapi headers

> +
> +struct irdma_create_qp_req {
> +	__u64 user_wqe_bufs;
> +	__u64 user_compl_ctx;
> +};

and this is wrong.. See my prior email.

Jason
