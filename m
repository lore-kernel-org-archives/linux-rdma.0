From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RDMA bug] KASAN: use-after-free Read in __list_del_entry_valid
 (4)
Date: Thu, 23 Aug 2018 08:54:58 -0600
Message-ID: <20180823145458.GC9366@ziepe.ca>
References: <001a1141551246502d056845782e@google.com>
 <001a1140f6ac1677460568489287@google.com>
 <20180823061630.GB736@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180823061630.GB736@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, dasaratharaman.chandramouli@intel.com, leonro@mellanox.com, linux-kernel@vger.kernel.org, markb@mellanox.com, monis@mellanox.com, parav@mellanox.com, syzkaller-bugs@googlegroups.com, syzbot <syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 22, 2018 at 11:16:31PM -0700, Eric Biggers wrote:
> Hello RDMA / InfiniBand maintainers,
> 
> This is an RDMA bug and it still occurs on Linus' tree as of today
> (commit 815f0ddb346c1960).
> 
> I've also simplified the reproducer for it; see below after the original report.
> Apparently it involves a race between RDMA_USER_CM_CMD_RESOLVE_IP and
> RDMA_USER_CM_CMD_LISTEN.

That is an amazing reproducer!

I have a feeling this is the same cause as all the other syzkaller
bugs in this code: lack of any sane locking at all :\

We've talked about chucking a big lock around this whole thing, but
nobody has done it yet.. It isn't so simple.

Jason
