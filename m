From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3] coding-style: Clarify the expectations around bool
Date: Mon, 07 Jan 2019 16:38:50 -0800
Message-ID: <9bc80bb861899633ba93e6c81d36d2201b05936b.camel@perches.com>
References: <20190107211117.GA24142@ziepe.ca>
         <8ec3603317f477fe9923b87499a33da7a2cf81ff.camel@perches.com>
         <20190107232513.GA5336@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190107232513.GA5336@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gal Pressman <galpress@amazon.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2019-01-07 at 16:25 -0700, Jason Gunthorpe wrote:
> On Mon, Jan 07, 2019 at 02:10:22PM -0800, Joe Perches wrote:
> > On Mon, 2019-01-07 at 14:11 -0700, Jason Gunthorpe wrote:
> > > There has been some confusion since checkpatch started warning about bool
> > > use in structures, and people have been avoiding using it.
> > > 
> > > Many people feel there is still a legitimate place for bool in structures,
> > > so provide some guidance on bool usage derived from the entire thread that
> > > spawned the checkpatch warning.
> > 
> > Thanks Jason.
> > 
> > It'd be nice to combine this with some better checkpatch warning or
> > even a removal of that misleading warning from checkpatch
> > altogether.
> 
> Okay, do you have a preference?

Yes.
---
 scripts/checkpatch.pl | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 155fa9305166..cfe0396c9845 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6370,19 +6370,6 @@ sub process {
 			}
 		}
 
-# check for bool bitfields
-		if ($sline =~ /^.\s+bool\s*$Ident\s*:\s*\d+\s*;/) {
-			WARN("BOOL_BITFIELD",
-			     "Avoid using bool as bitfield.  Prefer bool bitfields as unsigned int or u<8|16|32>\n" . $herecurr);
-		}
-
-# check for bool use in .h files
-		if ($realfile =~ /\.h$/ &&
-		    $sline =~ /^.\s+bool\s*$Ident\s*(?::\s*d+\s*)?;/) {
-			CHK("BOOL_MEMBER",
-			    "Avoid using bool structure members because of possible alignment issues - see: https://lkml.org/lkml/2017/11/21/384\n" . $herecurr);
-		}
-
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
