From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/mad: Use ID allocator routines to allocate agent
 number
Date: Wed, 30 May 2018 16:09:34 -0600
Message-ID: <20180530220934.GI30754@ziepe.ca>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
 <20180529154922.GA18457@ziepe.ca>
 <A470D739-D0CD-42EE-9196-8E7610B6DAF4@oracle.com>
 <20180529164032.GB18457@ziepe.ca>
 <20180530110216.00000913@dev.mellanox.co.il>
 <d8b75416-6a01-aa64-cd60-0cb4f2b6d0d5@oracle.com>
 <20180530151023.GB30754@ziepe.ca>
 <E67F0098-C2BC-49F6-AC55-3F9195712D4B@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E67F0098-C2BC-49F6-AC55-3F9195712D4B@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, jackm <jackm@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, Daniel Jurgens <danielj@mellanox.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 30, 2018 at 10:07:16PM +0200, Håkon Bugge wrote:
> 
> 
> > On 30 May 2018, at 17:10, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > On Wed, May 30, 2018 at 02:22:56PM +0200, Hans Westgaard Ry wrote:
> > 
> >> We came up with this code snippet which we think handles both preventing
> >> immediate re-use and too big/wrapping...
> > 
> > Isn't this basically the same as idr_alloc_cyclic ?
> 
> I draw my statement back. The idr_alloc_cyclic() is the family of idr's that associates a pointer with the bit. Hence, each bit is a bit + 64b.
> 
> That's why we ended up with Hans' pseudo code.

Okay, fair enough.

Is it worth adding a ida_get_new_cyclic for this?

Jason
