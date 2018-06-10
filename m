From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Sun, 10 Jun 2018 03:43:05 -0700
Message-ID: <20180610104305.GA9284@bombadil.infradead.org>
References: <20180608174218.32455-1-willy@infradead.org>
 <20180608174218.32455-3-willy@infradead.org>
 <20180610063028.GH12407@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180610063028.GH12407@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 10, 2018 at 09:30:28AM +0300, Leon Romanovsky wrote:
> 1. IBTA spec doesn't talk at all about the size of TransactionID, more
> on that in section "13.4.6.4 TRANSACTION ID USAGE", the specification
> says: "The contents of the TransactionID (TID) field are implementation-
> dependent. So let's don't call it mlx4 bug.

I was loosely paraphrasing the original bug report; suggested rewording
of the comments gratefully accepted.

> 2. The current implementation means that in mlx5-only network we will
> still have upto (1 << 24) TIDs. I don't know if it is really important,
> but worth to mention.

Actually, the TIDs will be up to 2^56.  We're limited to 2^24 clients,
each of which can send up to 2^32 messages.
