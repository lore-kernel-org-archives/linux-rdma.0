From: Knut Omang <knut.omang@oracle.com>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via
 a wrapper program
Date: Mon, 18 Dec 2017 19:39:50 +0100
Message-ID: <1513622390.31439.239.camel@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <20171216094745.5e41ac51@xeon-e3> <1513476850.31439.108.camel@oracle.com>
         <20171218050043.GA1307@ziepe.ca> <1513576817.31581.58.camel@perches.com>
         <20171218174604.GA19056@ziepe.ca> <1513619815.2798.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1513619815.2798.2.camel@wdc.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "joe@perches.com" <joe@perches.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>
Cc: "corbet@lwn.net" <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "nicolas.palix@imag.fr" <nicolas.palix@imag.fr>, "asmund.ostvold@oracle.com" <asmund.ostvold@oracle.com>, "john.haxby@oracle.com" <john.haxby@oracle.com>, "alexander.levin@verizon.com" <alexander.levin@verizon.com>, "mchehab@kernel.org" <mchehab@kernel.org>, "haakon.bugge@oracle.com" <haakon.bugge@oracle.com>, "michal.lkml@markovi.net" <michal.lkml@markovi.net>, "Gilles.Muller@lip6.fr" <Gilles.Muller@lip6.fr>, "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-12-18 at 17:56 +0000, Bart Van Assche wrote:
> On Mon, 2017-12-18 at 10:46 -0700, Jason Gunthorpe wrote:
> > On Sun, Dec 17, 2017 at 10:00:17PM -0800, Joe Perches wrote:
> > 
> > > > Today when we run checkers we get so many warnings it is too hard to
> > > > make any sense of it.
> > > 
> > > Here is a list of the checkpatch messages for drivers/infiniband
> > > sorted by type.
> > > 
> > > Many of these might be corrected by using
> > > 
> > > $ ./scripts/checkpatch.pl -f --fix-inplace --types=<TYPE> \
> > >   $(git ls-files drivers/infiniband/)
> > 
> > How many of these do you think it is worth to fix?
> > 
> > We do get a steady trickle of changes in this topic every cycle.
> > 
> > Is it better to just do a big number of them all at once? Do you have
> > an idea how disruptive this kind of work is to the whole patch flow
> > eg new patches no longer applying to for-next, backports no longer
> > applying, merge conflicts?
> 
> In my opinion patches that only change the coding style and do not change any
> functionality are annoying. Before posting a patch that fixes a bug the change
> history (git log -p) has to be cheched to figure out which patch introduced
> the bug. Patches that only change coding style pollute the change history.

I agree with you - the problem is that style issues should not have existed. 
But when they do it becomes a problem to remove them and a problem to 
keep them - for instance us who try to be compliant by having style helpers 
in our editor, we end up having to manually revert old style mistakes back in
to avoid making unrelated whitespace changes or similar.

I think what we get with this patch set is that there's a way to rein in the
issues and to enable some regression testing without enforcing a lot of work 
or annoying history issues *right away*. That way this problem can be tackled when
appropriate for the subsystem in question, and the reason for holding back on 
some changes can be documented in the local runchecks.cfg file, focusing
willing helping hands on the issues considered most important for that 
subsystem.

Thanks,
Knut
