From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] infiniband: hw: Drop unnecessary continue
Date: Tue, 6 Mar 2018 16:35:05 -0700
Message-ID: <20180306233505.GD8328@ziepe.ca>
References: <20180303162457.GA21730@seema-Inspiron-15-3567>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180303162457.GA21730@seema-Inspiron-15-3567>
Sender: linux-kernel-owner@vger.kernel.org
To: Arushi <arushisinghal19971997@gmail.com>
Cc: dennis.dalessandro@intel.com, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Sat, Mar 03, 2018 at 09:54:57PM +0530, Arushi wrote:
> Continue at the bottom of a loop are removed.
> Issue found using drop_continue.cocci Coccinelle script.
> 
> Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
> Changes in v2:
> - Braces is dropped from if with single statement.
> 
>  drivers/infiniband/hw/qib/qib_init.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

applied to for-next

Thanks
Jason
