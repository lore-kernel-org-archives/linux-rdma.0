From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH rdma-next 3/6] RDMA/ucontext: Do not allow BAR mappings to
 be executable
Date: Thu, 18 Apr 2019 02:23:26 -0500
Message-ID: <CAGXu5jKE-o11YeYyLOL4arJA-O5_BKYdtrdfLthFsm2pfjGnGg@mail.gmail.com>
References: <20190416110730.32230-1-leon@kernel.org> <20190416110730.32230-4-leon@kernel.org>
 <14063C7AD467DE4B82DEDB5C278E8663BE6A5513@FMSMSX108.amr.corp.intel.com>
 <20190418055759.GA3155@mellanox.com> <CAGXu5jKH-YwkzEp4UFckabJV_WOTAEQWSZ7787ovhSs215v2+Q@mail.gmail.com>
 <20190418070128.GE3206@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190418070128.GE3206@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Ruhl, Michael J" <michael.j.ruhl@intel.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Feras Daoud <ferasda@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 18, 2019 at 2:01 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Thu, Apr 18, 2019 at 01:30:07AM -0500, Kees Cook wrote:
>
> > Anything running with READ_IMPLIES_EXEC (i.e. a gnu stack marked WITH
> > execute) should be considered broken. Now, the trouble is that this
> > personality flag is carried across execve(), so if you have a launcher
> > that doesn't fix up the personality for children, you'll see this
> > spread all over your process tree. What is doing rdma mmap calls with
> > an executable stack? That really feels to me like the real source of
> > the problem.
>
> Apparently the Fortran runtime forces the READ_IMPLIES_EXEC and
> requires it for some real reason or another - Fortran and RDMA go
> together in alot of cases.

That's pretty unfortunate for the security of the resulting proceses. :(

> > Is the file for the driver coming out of /dev? Seems like that should
> > be mounted noexec and it would solve this too. (Though now I wonder
> > why /dev isn't noexec by default? /dev/pts is noexec...
>
> Yes - maybe?

I've found why /dev isn't noexec: to support old tools that mapped
/dev/zero with VM_EXEC to get executable mappings (instead of using
MAP_ANON). Seems like maybe this could change now?

> > Regardless, if you wanted to add a "ignore READ_IMPLIES_EXEC" flag to
> > struct file, maybe this bit could be populated by drivers?
>
> This would solve our problem.. How about a flag in struct
> file_operations?

Oh! That seems like it'd be pretty clean, I think. There's no flags
field currently, which vaguely surprises me...

I wonder if we could simply make devtmpfs ignore READ_IMPLIES_EXEC
entirely, though? And I wonder if we could defang READ_IMPLIES_EXEC a
bit in general. It was _supposed_ to be for the cases where binaries
were missing exec bits and a processor was just gaining NX ability. I
know this has been discussed before... ah-ha, here it is:
http://lkml.kernel.org/r/1462963502-11636-1-git-send-email-hecmargi@upv.es

> Do you agree it is worth drivers banning VM_EXEC for these truely
> non-executable pages?

I do: I think it's reasonable defense-in-depth.
