From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 1/2] IDR: Expose the XArray lock
Date: Wed, 13 Jun 2018 11:49:03 -0700
Message-ID: <20180613184903.GA22381@bombadil.infradead.org>
References: <20180613123403.25233-1-willy@infradead.org>
 <20180613123403.25233-2-willy@infradead.org>
 <20180613173057.GA27281@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613173057.GA27281@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 13, 2018 at 11:30:57AM -0600, Jason Gunthorpe wrote:
> Hmm, what do I need to apply this?
> 
> drivers/infiniband/core/mad.c: In function ‘ib_register_mad_agent’:
> drivers/infiniband/core/mad.c:387:34: error: ‘struct idr’ has no member named ‘idr_xa’; did you mean ‘idr_rt’?
>   idr_lock(&ib_mad_clients);
>                                   ^     
>                                   idr_rt
> 
> Linus's master (be779f03d563981)  doesn't seem to have idr_xa?

*groan*.  My fault.  I just sent a replacement 1/2.  Sorry!
