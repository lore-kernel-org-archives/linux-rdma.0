From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 3/6] RDMA/ucontext: Do not allow BAR mappings
 to be executable
Date: Thu, 18 Apr 2019 04:01:28 -0300
Message-ID: <20190418070128.GE3206@ziepe.ca>
References: <20190416110730.32230-1-leon@kernel.org>
 <20190416110730.32230-4-leon@kernel.org>
 <14063C7AD467DE4B82DEDB5C278E8663BE6A5513@FMSMSX108.amr.corp.intel.com>
 <20190418055759.GA3155@mellanox.com>
 <CAGXu5jKH-YwkzEp4UFckabJV_WOTAEQWSZ7787ovhSs215v2+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKH-YwkzEp4UFckabJV_WOTAEQWSZ7787ovhSs215v2+Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Ruhl, Michael J" <michael.j.ruhl@intel.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Feras Daoud <ferasda@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 18, 2019 at 01:30:07AM -0500, Kees Cook wrote:

> Anything running with READ_IMPLIES_EXEC (i.e. a gnu stack marked WITH
> execute) should be considered broken. Now, the trouble is that this
> personality flag is carried across execve(), so if you have a launcher
> that doesn't fix up the personality for children, you'll see this
> spread all over your process tree. What is doing rdma mmap calls with
> an executable stack? That really feels to me like the real source of
> the problem.

Apparently the Fortran runtime forces the READ_IMPLIES_EXEC and
requires it for some real reason or another - Fortran and RDMA go
together in alot of cases.
 
> Is the file for the driver coming out of /dev? Seems like that should
> be mounted noexec and it would solve this too. (Though now I wonder
> why /dev isn't noexec by default? /dev/pts is noexec...

Yes - maybe?
 
> Regardless, if you wanted to add a "ignore READ_IMPLIES_EXEC" flag to
> struct file, maybe this bit could be populated by drivers?

This would solve our problem.. How about a flag in struct
file_operations?

Do you agree it is worth drivers banning VM_EXEC for these truely
non-executable pages?

Thanks,
Jason
