From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via
 a wrapper program
Date: Mon, 18 Dec 2017 09:53:00 -0800
Message-ID: <1513619580.31581.110.camel@perches.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <20171216094745.5e41ac51@xeon-e3> <1513476850.31439.108.camel@oracle.com>
         <20171218050043.GA1307@ziepe.ca> <1513576817.31581.58.camel@perches.com>
         <20171218174604.GA19056@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20171218174604.GA19056@ziepe.ca>
Sender: linux-doc-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Knut Omang <knut.omang@oracle.com>, Stephen Hemminger <stephen@networkplumber.org>, linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Nicolas Palix <nicolas.palix@imag.fr>, Jonathan Corbet <corbet@lwn.net>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, Matthew Wilcox <willy@infradead.org>, cocci@systeme.lip6.fr, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, Doug Ledford <dledford@redhat.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Shuah Khan <shuah@kernel.org>, linux-kbuild@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>, Julia Lawall <Julia.Lawall@lip6.fr>, John Haxby <john.haxby@oracle.com>, =?ISO-8859-1?Q?=C5smund_=D8stvold?= <asmund.ostvold@oracle.com>, Masahiro
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-12-18 at 10:46 -0700, Jason Gunthorpe wrote:
> On Sun, Dec 17, 2017 at 10:00:17PM -0800, Joe Perches wrote:
> 
> > > Today when we run checkers we get so many warnings it is too hard to
> > > make any sense of it.
> > 
> > Here is a list of the checkpatch messages for drivers/infiniband
> > sorted by type.
> > 
> > Many of these might be corrected by using
> > 
> > $ ./scripts/checkpatch.pl -f --fix-inplace --types=<TYPE> \
> >   $(git ls-files drivers/infiniband/)
> 
> How many of these do you think it is worth to fix?
> 
> We do get a steady trickle of changes in this topic every cycle.
> 
> Is it better to just do a big number of them all at once?

I think so.

> Do you have
> an idea how disruptive this kind of work is to the whole patch flow
> eg new patches no longer applying to for-next, backports no longer
> applying, merge conflicts?

Some do complain about backport patch purity.

I think that difficulty is overstated, but then
again, I don't do backports very often.

I think the best time for any rather wholesale
change is immediately after an rc-1 so overall
in-flight patch conflict volume is minimized.
