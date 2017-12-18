From: Knut Omang <knut.omang@oracle.com>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via
 a wrapper program
Date: Mon, 18 Dec 2017 17:41:26 +0100
Message-ID: <1513615286.31439.178.camel@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <20171216094745.5e41ac51@xeon-e3> <1513476850.31439.108.camel@oracle.com>
         <20171218050043.GA1307@ziepe.ca> <1513576817.31581.58.camel@perches.com>
         <1513602315.22938.49.camel@oracle.com>
         <1513611003.31581.71.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1513611003.31581.71.camel@perches.com>
Sender: linux-doc-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stephen Hemminger <stephen@networkplumber.org>, linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Nicolas Palix <nicolas.palix@imag.fr>, Jonathan Corbet <corbet@lwn.net>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, Matthew Wilcox <willy@infradead.org>, cocci@systeme.lip6.fr, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, Doug Ledford <dledford@redhat.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Shuah Khan <shuah@kernel.org>, linux-kbuild@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>, Julia Lawall <Julia.Lawall@lip6.fr>, John Haxby <john.haxby@oracle.com>, =?ISO-8859-1?Q?=C5smund_=D8stvold?= <asmund.ostvold@oracle.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ke
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-12-18 at 07:30 -0800, Joe Perches wrote:
> On Mon, 2017-12-18 at 14:05 +0100, Knut Omang wrote:
> > > Here is a list of the checkpatch messages for drivers/infiniband
> > > sorted by type.
> > > 
> > > Many of these might be corrected by using
> > > 
> > > $ ./scripts/checkpatch.pl -f --fix-inplace --types=<TYPE> \
> > >   $(git ls-files drivers/infiniband/)
> > 
> > Yes, and I already did that work piece by piece for individual types,
> > just to test the runchecks tool, and want to post that set once the 
> > runchecks script and Makefile changes itself are in,
> 
> I think those are independent of any runcheck tool changes and
> could be posted now.  In general, don't keep patches in a local
> tree waiting on some other unrelated patch.

It becomes related in that the runchecks.cfg file is updated 
in all the patches to keep 'make C=2' run with 0 errors while 
enabling more checks. I think they serve well as examples of 
how a workflow with runchecks could be.

> Just fyi:
> 
> There is a script that helps automate checkpatch "by-type" conversions
> with compilation, .o difference checking, and git commit editing.
> 
> https://lkml.org/lkml/2014/7/11/794

oh - good to know - seems it would have been a good help
during my little exercise..

Thanks,
Knut
