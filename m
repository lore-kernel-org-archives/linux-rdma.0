From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1 2/6] amso1100: convert to using idr_alloc_cyclic
Date: Wed, 27 Mar 2013 09:27:55 -0700
Message-ID: <20130327162755.GC7395@htj.dyndns.org>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
 <1364390288-30968-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1364390288-30968-3-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, Tom Tucker <tom@opengridcomputing.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 27, 2013 at 09:18:04AM -0400, Jeff Layton wrote:
>  void c2_init_qp_table(struct c2_dev *c2dev)
>  {
>  	spin_lock_init(&c2dev->qp_table.lock);
> -	idr_init(&c2dev->qp_table.idr);
> +	idr_init_cyclic(&c2dev->qp_table.idr, 0);
>  }

Why is this necessary?  In general, why is idr_init_cyclic()
necessary?

Thanks.

-- 
tejun
