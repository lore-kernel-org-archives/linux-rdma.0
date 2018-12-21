From: Joe Perches <joe@perches.com>
Subject: rfc: bool structure members (was Re: [PATCH V3] net/mlx4: Get rid
 of page operation after dma_alloc_coherent)
Date: Thu, 20 Dec 2018 18:25:05 -0800
Message-ID: <072c2d9d187daf0672bf54ab035e47a05fd1cd1d.camel@perches.com>
References: <20181219182031.8675-1-swarren@wwwdotorg.org>
         <20181220174318.GA21404@ziepe.ca> <20181220174448.GA21149@lst.de>
         <1545328145.185366.500.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1545328145.185366.500.camel@acm.org>
Sender: netdev-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2018-12-20 at 09:49 -0800, Bart Van Assche wrote:
> On Thu, 2018-12-20 at 18:44 +0100, Christoph Hellwig wrote:
> > On Thu, Dec 20, 2018 at 10:43:18AM -0700, Jason Gunthorpe wrote:
> > > >   - chunk->coherent is an int not a bool since checkpatch complains about
> > > >     using bool in structs; see https://lkml.org/lkml/2017/11/21/384.
> > > 
> > > :( bool is much more readable and there is no performance concern in
> > > this struct. I think checkpatch is overzealous here.
> > 
> > Yes.  Nevermind that this for bool vs bitfield.  A int is worse in
> > every respect in the criteria used in that mail.
> 
> (+Joe Perches)
> 
> Hi Joe,

Hi all.

> This is the second time that I see that the checkpatch complaint about using
> bool in a structure leads kernel contributors to a bad decision. Please consider
> removing that warning from checkpatch.

I agree it's not a very good message nor is bool use
of structure members a real problem except in very
few cases.

I think the message could either be restated and bool
members described as OK for unshared memory structures.

Right now this is the test:

# check for bool use in .h files
		if ($realfile =~ /\.h$/ &&
		    $sline =~ /^.\s+bool\s*$Ident\s*(?::\s*d+\s*)?;/) {
			CHK("BOOL_MEMBER",
			    "Avoid using bool structure members because of possible alignment issues - see: https://lkml.org/lkml/2017/11/21/384\n" . $herecurr);
		}

What do you believe would be better message wording
or a perhaps an improved test?

btw: this can emit false positives for .h files with
static inline functions that declare bool automatics.

Linus' original email (https://lkml.org/lkml/2017/11/21/384) was:
---------------------------------------------------------------------
As others have already said, please don't use "bool" in structures at
all. It's an incredible waste of space, but it's also not entirely
clear what the type size even is. Usually a byte, but I don't think
there is any guarantee of it at all.

Use "bool" mainly as a return type from functions that return
true/false, and maybe as local variables in functions.

Maybe using single-bit bitfield with "bool" as the base type might
work, but the normal thing we tend to do is to just make sure the base
type is unsigned. It's a tiny bit more typing, but it's very
unambiguous what is going on, and you can specify the base type as you
wish and as it makes sense for packing etc.
