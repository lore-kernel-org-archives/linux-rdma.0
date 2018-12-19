From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
Subject: Re: [PATCH rds linux-next v4 0/2] WARNING in rds_message_alloc_sgs
Date: Wed, 19 Dec 2018 12:54:39 +0200
Message-ID: <20181219105438.GA9593@srabinov-laptop>
References: <20181216070109.6758-1-shamir.rabinovitch@oracle.com>
 <20181218.145753.1550590342570044648.davem@davemloft.net>
 <6f6a4be5-99e8-de34-595d-f5b30c61c7ec@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6f6a4be5-99e8-de34-595d-f5b30c61c7ec@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: David Miller <davem@davemloft.net>, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, netdev@vger.kernel.org, gerd.rausch@oracle.com, haakon.bugge@oracle.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 18, 2018 at 03:02:24PM -0800, Santosh Shilimkar wrote:
> On 12/18/2018 2:57 PM, David Miller wrote:
> > From: Shamir Rabinovitch <shamir.rabinovitch@oracle.com>
> > Date: Sun, 16 Dec 2018 09:01:07 +0200
> > 
> > > From: shamir rabinovitch <shamir.rabinovitch@oracle.com>
> > > 
> > > This patch set fix google syzbot rds bug found in linux-next.
> > > The first patch solve the syzbot issue.
> > > The second patch fix issue mentioned by Leon Romanovsky that
> > > drivers should not call WARN_ON as result from user input.
> > > 
> > > syzbot bug report can be foud here: https://lkml.org/lkml/2018/10/31/28
> > > 
> > > v1->v2:
> > > - patch 1: make rds_iov_vector fields name more descriptive (Hakon)
> > > - patch 1: fix potential mem leak in rds_rm_size if krealloc fail
> > >    (Hakon)
> > > v2->v3:
> > > - patch 2: harden rds_sendmsg for invalid number of sgs (Gerd)
> > > v3->v4
> > > - Santosh a.b. on both patches + repost to net-dev
> > 
> > Does this bug exist in 'net' too?  It really should target the 'net'
> > tree if so, and then we can queue these fixes up for -stable too.
> > 
> yes, the bug exist in net too.
> 
> Shamir, please check if these apply cleanly to Dave's 'net' tree.
> 
> Regards,
> Santosh

Santosh, 

The patches apply cleanly on the master branch of 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git . 

See below the snippet of the log with the patches applied.

8472aa4edfcb (HEAD -> net/master#rds-syzbot-bug) net/rds: remove user triggered WARN_ON in rds_sendmsg
3f8d6b898c5e net/rds: fix warn in rds_message_alloc_sgs
3061169a47ee (net/master) Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
78abe3d0dfad net/smc: fix TCP fallback socket release
f7db2beb4c2c vxge: ensure data0 is initialized in when fetching firmware version information

Thanks, Shamir
