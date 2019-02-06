From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 13:04:57 -0800
Message-ID: <CAPcyv4id2rzJVUZw98PfJ-k05BvD-opwj0XhOWPKZQicmhXJ=g@mail.gmail.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org> <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <20190206183503.GO21860@bombadil.infradead.org> <20190206185233.GE12227@ziepe.ca>
 <CAPcyv4j4gDNHu836N4RfgQsE+eZU9Wt0N9Y09KQ43zV+4mK-eg@mail.gmail.com> <671e7ebc8e125d1ebd71de9943868183e27f052b.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <671e7ebc8e125d1ebd71de9943868183e27f052b.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 6, 2019 at 12:14 PM Doug Ledford <dledford@redhat.com> wrote:
>
> On Wed, 2019-02-06 at 11:45 -0800, Dan Williams wrote:
> > On Wed, Feb 6, 2019 at 10:52 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > On Wed, Feb 06, 2019 at 10:35:04AM -0800, Matthew Wilcox wrote:
> > >
> > > > > Admittedly, I'm coming in late to this conversation, but did I miss the
> > > > > portion where that alternative was ruled out?
> > > >
> > > > That's my preferred option too, but the preponderance of opinion leans
> > > > towards "We can't give people a way to make files un-truncatable".
> > >
> > > I haven't heard an explanation why blocking ftruncate is worse than
> > > giving people a way to break RDMA using process by calling ftruncate??
> > >
> > > Isn't it exactly the same argument the other way?
> >
> >
> > If the
> > RDMA application doesn't want it to happen, arrange for it by
> > permissions or other coordination to prevent truncation,
>
> I just argued the *exact* same thing, except from the other side: if you
> want a guaranteed ability to truncate, then arrange the perms so the
> RDMA or DAX capable things can't use the file.

That doesn't make sense. All we have to work with is rwx bits. It's
possible to prevents writes / truncates. There's no permission bit for
mmap, O_DIRECT and RDMA mappings, hence leases.

> >  but once the
> > two conflicting / valid requests have arrived at the filesystem try to
> > move the result forward to the user requested state not block and fail
> > indefinitely.
>
> Except this is wrong.  We already have ETXTBSY, and arguably it is much
> easier for ETXTBSY to simply kill all of the running processes with
> extreme prejudice.  But we don't do that.  We block indefinitely.  So,
> no, there is no expectation that things will "move forward to the user
> requested state".  Not when pages are in use by the kernel, and very
> arguably pages being used for direct I/O are absolutely in use by the
> kernel, then truncate blocks.
>
> There is a major case of dissonant cognitive behavior here if the
> syscall supports ETXTBSY, even though the ability to kill apps using the
> text pages is trivial, but thinks supporting EBUSY is out of the
> question.

It's introducing a new failure mode where one did not exist before.
It's especially problematic when the only difference between the case
when it fails and one where it doesn't comes down to the
idiosyncrasies of DAX mappings and whether or not the RDMA device has
capabilities like ODP.
