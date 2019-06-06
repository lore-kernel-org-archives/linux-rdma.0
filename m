From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: RFC: Run a dedicated hmm.git for 5.3
Date: Thu, 6 Jun 2019 15:25:49 +0000
Message-ID: <20190606152543.GE17392@mellanox.com>
References: <20190523155207.GC5104@redhat.com>
 <20190523163429.GC12159@ziepe.ca> <20190523173302.GD5104@redhat.com>
 <20190523175546.GE12159@ziepe.ca> <20190523182458.GA3571@redhat.com>
 <20190523191038.GG12159@ziepe.ca> <20190524064051.GA28855@infradead.org>
 <20190524124455.GB16845@ziepe.ca>
 <20190525155210.8a9a66385ac8169d0e144225@linux-foundation.org>
 <20190527191247.GA12540@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527191247.GA12540@ziepe.ca>
Content-Language: en-US
Content-ID: <994523D7B122E1489B649951953089FD@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Airlie <airlied@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <jglisse@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Kaike Wan <kaike.wan@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, dri-devel <dri-devel@lists.freedesktop.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 27, 2019 at 04:12:47PM -0300, Jason Gunthorpe wrote:
> On Sat, May 25, 2019 at 03:52:10PM -0700, Andrew Morton wrote:
> > On Fri, 24 May 2019 09:44:55 -0300 Jason Gunthorpe <jgg@ziepe.ca> wrote=
:
> >=20
> > > Now that -mm merged the basic hmm API skeleton I think running like
> > > this would get us quickly to the place we all want: comprehensive in =
tree
> > > users of hmm.
> > >=20
> > > Andrew, would this be acceptable to you?
> >=20
> > Sure.  Please take care not to permit this to reduce the amount of
> > exposure and review which the core HMM pieces get.
>=20
> Certainly, thanks all
>=20
> Jerome: I started a HMM branch on v5.2-rc2 in the rdma.git here:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=3Dhm=
m

I did a first round of collecting patches for hmm.git

Andrew, I'm checking linux-next and to stay co-ordinated, I see the
patches below are in your tree and now also in hmm.git. Can you please
drop them from your tree?=20

5b693741de2ace mm/hmm.c: suppress compilation warnings when CONFIG_HUGETLB_=
PAGE is not set
b2870fb882599a mm/hmm.c: only set FAULT_FLAG_ALLOW_RETRY for non-blocking
dff7babf8ae9f1 mm/hmm.c: support automatic NUMA balancing

I checked that the other two patches in -next also touching hmm.c are
best suited to go through your tree:

a76b9b318a7180 mm/devm_memremap_pages: fix final page put race
fc64c058d01b98 mm/memremap: rename and consolidate SECTION_SIZE

StephenR: Can you pick up the hmm branch from rdma.git for linux-next for
this cycle? As above we are moving the patches from -mm to hmm.git, so
there will be a conflict in -next until Andrew adjusts his tree,
thanks!

Regards,
Jason
(hashes are from today's linux-next)
