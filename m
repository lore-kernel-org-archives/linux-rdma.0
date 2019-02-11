From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/3] mm/gup: Introduce get_user_pages_fast_longterm()
Date: Mon, 11 Feb 2019 13:45:05 -0800
Message-ID: <CAPcyv4iEqYRzFgu4oqS8J+MtOuBrq6Dx7C7tcWZLj0C0ML9LQw@mail.gmail.com>
References: <20190211201643.7599-1-ira.weiny@intel.com> <20190211201643.7599-3-ira.weiny@intel.com>
 <20190211203916.GA2771@ziepe.ca> <bcc03ee1-4c42-48c3-bc67-942c0f04875e@nvidia.com>
 <20190211212652.GA7790@iweiny-DESK2.sc.intel.com> <fc9c880b-24f8-7063-6094-00175bc27f7d@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fc9c880b-24f8-7063-6094-00175bc27f7d@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, Netdev <netdev@vger.kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 1:39 PM John Hubbard <jhubbard@nvidia.com> wrote:
>
> On 2/11/19 1:26 PM, Ira Weiny wrote:
> > On Mon, Feb 11, 2019 at 01:13:56PM -0800, John Hubbard wrote:
> >> On 2/11/19 12:39 PM, Jason Gunthorpe wrote:
> >>> On Mon, Feb 11, 2019 at 12:16:42PM -0800, ira.weiny@intel.com wrote:
> >>>> From: Ira Weiny <ira.weiny@intel.com>
> >> [...]
> >> It seems to me that the longterm vs. short-term is of questionable value.
> >
> > This is exactly why I did not post this before.  I've been waiting our other
> > discussions on how GUP pins are going to be handled to play out.  But with the
> > netdev thread today[1] it seems like we need to make sure we have a "safe" fast
> > variant for a while.  Introducing FOLL_LONGTERM seemed like the cleanest way to
> > do that even if we will not need the distinction in the future...  :-(
>
> Yes, I agree. Below...
>
> > [...]
> > This is also why I did not change the get_user_pages_longterm because we could
> > be ripping this all out by the end of the year...  (I hope. :-)
> >
> > So while this does "pollute" the GUP family of calls I'm hoping it is not
> > forever.
> >
> > Ira
> >
> > [1] https://lkml.org/lkml/2019/2/11/1789
> >
>
> Yes, and to be clear, I think your patchset here is fine. It is easy to find
> the FOLL_LONGTERM callers if and when we want to change anything. I just think
> also it's appopriate to go a bit further, and use FOLL_LONGTERM all by itself.
>
> That's because in either design outcome, it's better that way:
>
> -- If we keep the concept of "I'm a long-term gup call site", then FOLL_LONGTERM
> is just right. The gup API already has _fast and non-fast variants, and once
> you get past a couple, you end up with a multiplication of names that really
> work better as flags. We're there.
>
> -- If we drop the concept, then you've already done part of the work, by removing
> the _longterm API variants.
>

A problem I now see with the _longterm name is that it hides its true
intent. It's really a "dax can't use page cache tricks to make it seem
like this page is ok to access indefinitely, if the system needs this
page back your pin would prevent the forward progress of the system
state.". If the discussion results in a need to have an explicit file
state (immutable or lease) then we'll continue to need a gup pin type
distinction. If the discussion resolves to one of the silent options
(fail truncate, lie about truncate) then FOLL_LONGTERM might be able
to die at that point.
