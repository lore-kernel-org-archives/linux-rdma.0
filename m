From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/3] mm/gup: Introduce get_user_pages_fast_longterm()
Date: Mon, 11 Feb 2019 14:55:10 -0800
Message-ID: <CAPcyv4htDHmH7PVm_=HOWwRKtpcKTPSjrHPLqhwp2vhBUWL4-w@mail.gmail.com>
References: <20190211201643.7599-1-ira.weiny@intel.com> <20190211201643.7599-3-ira.weiny@intel.com>
 <20190211203916.GA2771@ziepe.ca> <bcc03ee1-4c42-48c3-bc67-942c0f04875e@nvidia.com>
 <20190211212652.GA7790@iweiny-DESK2.sc.intel.com> <fc9c880b-24f8-7063-6094-00175bc27f7d@nvidia.com>
 <20190211215238.GA23825@iweiny-DESK2.sc.intel.com> <20190211220658.GH24692@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211220658.GH24692@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Ira Weiny <ira.weiny@intel.com>, John Hubbard <jhubbard@nvidia.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, Netdev <netdev@vger.kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 2:07 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Mon, Feb 11, 2019 at 01:52:38PM -0800, Ira Weiny wrote:
> > On Mon, Feb 11, 2019 at 01:39:12PM -0800, John Hubbard wrote:
> > > On 2/11/19 1:26 PM, Ira Weiny wrote:
> > > > On Mon, Feb 11, 2019 at 01:13:56PM -0800, John Hubbard wrote:
> > > >> On 2/11/19 12:39 PM, Jason Gunthorpe wrote:
> > > >>> On Mon, Feb 11, 2019 at 12:16:42PM -0800, ira.weiny@intel.com wrote:
> > > >>>> From: Ira Weiny <ira.weiny@intel.com>
> > > >> [...]
> > > >> It seems to me that the longterm vs. short-term is of questionable value.
> > > >
> > > > This is exactly why I did not post this before.  I've been waiting our other
> > > > discussions on how GUP pins are going to be handled to play out.  But with the
> > > > netdev thread today[1] it seems like we need to make sure we have a "safe" fast
> > > > variant for a while.  Introducing FOLL_LONGTERM seemed like the cleanest way to
> > > > do that even if we will not need the distinction in the future...  :-(
> > >
> > > Yes, I agree. Below...
> > >
> > > > [...]
> > > > This is also why I did not change the get_user_pages_longterm because we could
> > > > be ripping this all out by the end of the year...  (I hope. :-)
> > > >
> > > > So while this does "pollute" the GUP family of calls I'm hoping it is not
> > > > forever.
> > > >
> > > > Ira
> > > >
> > > > [1] https://lkml.org/lkml/2019/2/11/1789
> > > >
> > >
> > > Yes, and to be clear, I think your patchset here is fine. It is easy to find
> > > the FOLL_LONGTERM callers if and when we want to change anything. I just think
> > > also it's appopriate to go a bit further, and use FOLL_LONGTERM all by itself.
> > >
> > > That's because in either design outcome, it's better that way:
> > >
> > > is just right. The gup API already has _fast and non-fast variants, and once
> > > you get past a couple, you end up with a multiplication of names that really
> > > work better as flags. We're there.
> > >
> > > the _longterm API variants.
> >
> > Fair enough.   But to do that correctly I think we will need to convert
> > get_user_pages_fast() to use flags as well.  I have a version of this series
> > which includes a patch does this, but the patch touched a lot of subsystems and
> > a couple of different architectures...[1]
>
> I think this should be done anyhow, it is trouble the two basically
> identical interfaces have different signatures. This already caused a
> bug in vfio..
>
> I also wonder if someone should think about making fast into a flag
> too..
>
> But I'm not sure when fast should be used vs when it shouldn't :(

Effectively fast should always be used just in case the user cares
about performance. It's just that it may fail and need to fall back to
requiring the vma.

Personally I thought RDMA memory registration is a one-time / upfront
slow path so that non-fast-GUP is tolerable.

The workloads that *need* it are O_DIRECT users that can't tolerate a
vma lookup on every I/O.
