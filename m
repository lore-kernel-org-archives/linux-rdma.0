From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v2] infiniband/mm: convert put_page() to put_user_page*()
Date: Mon, 27 May 2019 22:56:56 +0000
Message-ID: <20190527225651.GA18539@mellanox.com>
References: <20190525014522.8042-1-jhubbard@nvidia.com>
 <20190525014522.8042-2-jhubbard@nvidia.com>
 <20190526110631.GD1075@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190526110631.GD1075@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <5BC0AB5A2E48604C93A93DEB61B51614@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: "john.hubbard@gmail.com" <john.hubbard@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 26, 2019 at 04:06:31AM -0700, Matthew Wilcox wrote:
> On Fri, May 24, 2019 at 06:45:22PM -0700, john.hubbard@gmail.com wrote:
> > For infiniband code that retains pages via get_user_pages*(),
> > release those pages via the new put_user_page(), or
> > put_user_pages*(), instead of put_page()
>=20
> I have no objection to this particular patch, but ...
>=20
> > This is a tiny part of the second step of fixing the problem described
> > in [1]. The steps are:
> >=20
> > 1) Provide put_user_page*() routines, intended to be used
> >    for releasing pages that were pinned via get_user_pages*().
> >=20
> > 2) Convert all of the call sites for get_user_pages*(), to
> >    invoke put_user_page*(), instead of put_page(). This involves dozens=
 of
> >    call sites, and will take some time.
> >=20
> > 3) After (2) is complete, use get_user_pages*() and put_user_page*() to
> >    implement tracking of these pages. This tracking will be separate fr=
om
> >    the existing struct page refcounting.
> >=20
> > 4) Use the tracking and identification of these pages, to implement
> >    special handling (especially in writeback paths) when the pages are
> >    backed by a filesystem. Again, [1] provides details as to why that i=
s
> >    desirable.
>=20
> I thought we agreed at LSFMM that the future is a new get_user_bvec()
> / put_user_bvec().  This is largely going to touch the same places as
> step 2 in your list above.  Is it worth doing step 2?

I think so, as these two conversions can run in parallel, whichever we
finish first, biovec or put_user_pages lets John progress to step #3

Jason
