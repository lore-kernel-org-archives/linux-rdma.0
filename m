From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] [v4.14.y] infiniband: fix race condition between
 infiniband mlx4, mlx5  driver and core dumping
Date: Fri, 14 Jun 2019 16:55:10 +0200
Message-ID: <20190614145510.GA14860@kroah.com>
References: <1560199937-23476-1-git-send-email-akaher@vmware.com>
 <9C189085-083D-46EA-98DB-B11AD62051B6@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9C189085-083D-46EA-98DB-B11AD62051B6@vmware.com>
Sender: stable-owner@vger.kernel.org
To: Ajay Kaher <akaher@vmware.com>
Cc: "aarcange@redhat.com" <aarcange@redhat.com>, "jannh@google.com" <jannh@google.com>, "oleg@redhat.com" <oleg@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>, "jgg@mellanox.com" <jgg@mellanox.com>, "mhocko@suse.com" <mhocko@suse.com>, "yishaih@mellanox.com" <yishaih@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "matanb@mellanox.com" <matanb@mellanox.com>, "leonro@mellanox.com" <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Srivatsa Bhat <srivatsab@vmwar>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 14, 2019 at 02:41:39PM +0000, Ajay Kaher wrote:
> 
> ﻿On 10/06/19, 6:22 PM, "Ajay Kaher" <akaher@vmware.com> wrote:
> 
> > This patch is the extension of following upstream commit to fix
> > the race condition between get_task_mm() and core dumping
> > for IB->mlx4 and IB->mlx5 drivers:
> > 
> > commit 04f5866e41fb ("coredump: fix race condition between
> > mmget_not_zero()/get_task_mm() and core dumping")'
> >    
> > Thanks to Jason for pointing this.
> >    
> > Signed-off-by: Ajay Kaher <akaher@vmware.com>
> > Acked-by: Jason Gunthorpe <jgg@mellanox.com>
> 
> Greg, I hope you would like to review and proceed further with this patch.  

If this is all calmed down now, I'll look at it next week, thanks.

greg k-h
