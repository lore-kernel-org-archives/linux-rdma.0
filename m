From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 11:45:56 -0800
Message-ID: <CAPcyv4j4gDNHu836N4RfgQsE+eZU9Wt0N9Y09KQ43zV+4mK-eg@mail.gmail.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org> <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <20190206183503.GO21860@bombadil.infradead.org> <20190206185233.GE12227@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206185233.GE12227@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>, Doug Ledford <dledford@redhat.com>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 6, 2019 at 10:52 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Wed, Feb 06, 2019 at 10:35:04AM -0800, Matthew Wilcox wrote:
>
> > > Admittedly, I'm coming in late to this conversation, but did I miss the
> > > portion where that alternative was ruled out?
> >
> > That's my preferred option too, but the preponderance of opinion leans
> > towards "We can't give people a way to make files un-truncatable".
>
> I haven't heard an explanation why blocking ftruncate is worse than
> giving people a way to break RDMA using process by calling ftruncate??
>
> Isn't it exactly the same argument the other way?

No, I don't think it is. The lease is there to set the expectation of
getting out of the way, it's not a silent un-coordinated failure. The
user asked for it, the kernel is just honoring a valid request. If the
RDMA application doesn't want it to happen, arrange for it by
permissions or other coordination to prevent truncation, but once the
two conflicting / valid requests have arrived at the filesystem try to
move the result forward to the user requested state not block and fail
indefinitely.
