From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] KASAN: use-after-free Read in rdma_listen
Date: Fri, 6 Jul 2018 19:52:25 -0600
Message-ID: <20180707015225.GC9976@ziepe.ca>
References: <b7dd13a9-cb0d-7e10-beb2-3fb25214067a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b7dd13a9-cb0d-7e10-beb2-3fb25214067a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Bortoli <tomasbortoli@gmail.com>
Cc: dledford@redhat.com, leon@kernel.org, parav@mellanox.com, roland@purestorage.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On Sat, Jul 07, 2018 at 03:41:30AM +0200, Tomas Bortoli wrote:
> I don't have a background on usage or internals of the driver at issue
> but I hope these clues will help in finding the proper fix.

I think anything is useful, thanks..

The truth is that nobody is left that seems to really understand this
code and syzkaller has shown it is full of various bugs..

If there is someone out there that would like to tackle it, let me
know. There might be a possibility to support such work.

Jason
