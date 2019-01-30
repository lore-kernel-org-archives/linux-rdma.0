From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 5/5] RDMA/uverbs: add UVERBS_METHOD_REG_REMOTE_MR
Date: Wed, 30 Jan 2019 14:23:46 -0700
Message-ID: <20190130212346.GD17066@ziepe.ca>
References: <1548768386-28289-1-git-send-email-joeln@il.ibm.com>
 <1548768386-28289-6-git-send-email-joeln@il.ibm.com>
 <20190129170406.GD10094@ziepe.ca>
 <OF8090F111.AEB0B591-ONC2258392.002E4215-C2258392.002F0FDE@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF8090F111.AEB0B591-ONC2258392.002E4215-C2258392.002F0FDE@notes.na.collabserv.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Nider <JOELN@il.ibm.com>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org, linux-rdma-owner@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 30, 2019 at 10:34:02AM +0200, Joel Nider wrote:
> linux-rdma-owner@vger.kernel.org wrote on 01/29/2019 07:04:06 PM:
> 
> > On Tue, Jan 29, 2019 at 03:26:26PM +0200, Joel Nider wrote:
> > > Add a new handler for new uverb reg_remote_mr. The purpose is to 
> register
> > > a memory region in a different address space (i.e. process) than the
> > > caller.
> > > 
> > > The main use case which motivated this change is post-copy container
> > > migration. When a migration manager (i.e. CRIU) starts a migration, it
> > > must have an open connection for handling any page faults that occur
> > > in the container after restoration on the target machine. Even though
> > > CRIU establishes and maintains the connection, ultimately the memory
> > > is copied from the container being migrated (i.e. a remote address
> > > space). This container must remain passive -- meaning it cannot have
> > > any knowledge of the RDMA connection; therefore the migration manager
> > > must have the ability to register a remote memory region. This remote
> > > memory region will serve as the source for any memory pages that must
> > > be copied (on-demand or otherwise) during the migration.
> > > 
> > > Signed-off-by: Joel Nider <joeln@il.ibm.com>
> > >  drivers/infiniband/core/uverbs_std_types_mr.c | 129 
> +++++++++++++++++++++++++-
> > >  include/rdma/ib_verbs.h                       |   8 ++
> > >  include/uapi/rdma/ib_user_ioctl_cmds.h        |  13 +++
> > >  3 files changed, 149 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/
> > infiniband/core/uverbs_std_types_mr.c
> > > index 4d4be0c..bf7b4b2 100644
> > > +++ b/drivers/infiniband/core/uverbs_std_types_mr.c
> > > @@ -150,6 +150,99 @@ static int 
> UVERBS_HANDLER(UVERBS_METHOD_DM_MR_REG)(
> > >     return ret;
> > >  }
> > > 
> > > +static int UVERBS_HANDLER(UVERBS_METHOD_REG_REMOTE_MR)(
> > > +   struct uverbs_attr_bundle *attrs)
> > > +{
> > 
> > I think this should just be REG_MR with an optional remote PID
> > argument
> 
> Maybe I missed something.  Isn't REG_MR only implemented as a write() 
> command? In our earlier conversation you told me all new commands must be 
> implemented as ioctl() commands.

Yes - but we are also converting old write() commands into ioctl()
when they need new functionality. So in this case it should convert
reg_mr to ioctl() then add an optional report PID argument
> 
> > >  DECLARE_UVERBS_NAMED_OBJECT(
> > >     UVERBS_OBJECT_MR,
> > >     UVERBS_TYPE_ALLOC_IDR(uverbs_free_mr),
> > >     &UVERBS_METHOD(UVERBS_METHOD_DM_MR_REG),
> > >     &UVERBS_METHOD(UVERBS_METHOD_MR_DESTROY),
> > > -   &UVERBS_METHOD(UVERBS_METHOD_ADVISE_MR));
> > > +   &UVERBS_METHOD(UVERBS_METHOD_ADVISE_MR),
> > > +   &UVERBS_METHOD(UVERBS_METHOD_REG_REMOTE_MR),
> > > +);
> > 
> > I'm kind of surprised this compiles with the trailing comma?
> Personally, I think it is nicer with the trailing comma. Of course 
> syntactically it makes no sense, but when adding a new entry, you don't 
> have to touch the previous line, which makes the diff cleaner. If this is 
> against standard practices I will remove the comma.

Well, it is just that this is a macro call, and you usually can't have
a trailing comma in a function-macro call, at least I thought this was
the case.. Without some study I'm not sure what it expands to, or if
that expansion is even OK..

Jason
