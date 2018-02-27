From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/core: reduce IB_POLL_BATCH constant
Date: Tue, 27 Feb 2018 15:09:58 -0700
Message-ID: <20180227220958.GA21714@ziepe.ca>
References: <20180220205924.2035765-1-arnd@arndb.de>
 <1519161268.3737.12.camel@wdc.com>
 <F2FB1034-BFB6-45ED-878E-6FADD756157D@oracle.com>
 <c3eab137-1c37-0e6c-a53a-df2cf80653d2@grimberg.me>
 <0f90134c-3d40-1d24-711f-e4ab32802bd8@mellanox.com>
 <c1bcd5cc-381d-2d94-1278-f9fb5c9c0b14@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c1bcd5cc-381d-2d94-1278-f9fb5c9c0b14@grimberg.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Max Gurtovoy <maxg@mellanox.com>, Chuck Lever <chuck.lever@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "arnd@arndb.de" <arnd@arndb.de>, "dledford@redhat.com" <dledford@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leonro@mellanox.com" <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 22, 2018 at 05:39:09PM +0200, Sagi Grimberg wrote:
> 
> >>The only reason why I added this array on-stack was to allow consumers
> >>that did not use ib_alloc_cq api to call it, but that seems like a
> >>wrong decision when thinking it over again (as probably these users
> >>did not set the wr_cqe correctly).
> >>
> >>How about we make ib_process_cq_direct use the cq wc array and add
> >>a WARN_ON statement (and fail it gracefully) if the caller used this
> >>API without calling ib_alloc_cq?
> >
> >but we tried to avoid cuncurrent access to cq->wc.
> 
> Not sure its a valid use-case. But if there is a compelling
> reason to keep it as is, then we can do smaller on-stack
> array.

Did we come to a conclusion what to do here?

Jason
