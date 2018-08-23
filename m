From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RDMA bug] KASAN: use-after-free Read in __list_del_entry_valid
 (4)
Date: Thu, 23 Aug 2018 11:17:32 -0600
Message-ID: <20180823171732.GC14664@ziepe.ca>
References: <001a1141551246502d056845782e@google.com>
 <001a1140f6ac1677460568489287@google.com>
 <20180823061630.GB736@sol.localdomain>
 <20180823145458.GC9366@ziepe.ca>
 <VI1PR0501MB22714BE9A34FA333671A0623D1370@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0501MB22714BE9A34FA333671A0623D1370@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dasaratharaman.chandramouli@intel.com" <dasaratharaman.chandramouli@intel.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Moni Shoua <monis@mellanox.com>, "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>, syzbot <syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 23, 2018 at 04:39:29PM +0000, Parav Pandit wrote:
> 
> 
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Thursday, August 23, 2018 9:55 AM
> > To: Eric Biggers <ebiggers@kernel.org>
> > Cc: Doug Ledford <dledford@redhat.com>; linux-rdma@vger.kernel.org;
> > dasaratharaman.chandramouli@intel.com; Leon Romanovsky
> > <leonro@mellanox.com>; linux-kernel@vger.kernel.org; Mark Bloch
> > <markb@mellanox.com>; Moni Shoua <monis@mellanox.com>; Parav Pandit
> > <parav@mellanox.com>; syzkaller-bugs@googlegroups.com; syzbot
> > <syzbot+29ee8f76017ce6cf03da@syzkaller.appspotmail.com>
> > Subject: Re: [RDMA bug] KASAN: use-after-free Read in __list_del_entry_valid
> > (4)
> > 
> > On Wed, Aug 22, 2018 at 11:16:31PM -0700, Eric Biggers wrote:
> > > Hello RDMA / InfiniBand maintainers,
> > >
> > > This is an RDMA bug and it still occurs on Linus' tree as of today
> > > (commit 815f0ddb346c1960).
> > >
> > > I've also simplified the reproducer for it; see below after the original report.
> > > Apparently it involves a race between RDMA_USER_CM_CMD_RESOLVE_IP
> > and
> > > RDMA_USER_CM_CMD_LISTEN.
> > 
> > That is an amazing reproducer!
> > 
> > I have a feeling this is the same cause as all the other syzkaller bugs in this code:
> > lack of any sane locking at all :\
> > 
> > We've talked about chucking a big lock around this whole thing, but nobody has
> > done it yet.. It isn't so simple.
> >
>
> I had some code in which reduces three locks (handler_lock,
> qp_mutex, id_lock) to single mutex to protect the cm_id and protects
> every exported symbol of rdmacm which works on cm_id.  But not ready
> enough to post it as patch yet. Lot of tests required before I get
> there and some refactor too before that.

That does sound promising..

Jason
