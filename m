From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v4] coding-style: Clarify the expectations around bool
Date: Mon, 14 Jan 2019 17:26:10 +0000
Message-ID: <20190114172603.GF22875@mellanox.com>
References: <20190110234805.GN6890@ziepe.ca>
 <20190113164936.GW6310@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190113164936.GW6310@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <9B58898B74CCDD49A5E17C8658896DD4@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Joe Perches <joe@perches.com>, Gal Pressman <galpress@amazon.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 13, 2019 at 08:49:36AM -0800, Matthew Wilcox wrote:
> On Thu, Jan 10, 2019 at 11:48:13PM +0000, Jason Gunthorpe wrote:
> > +The Linux kernel bool type is an alias for the C99 _Bool type. bool va=
lues can
> > +only evaluate to 0 or 1, and implicit or explicit conversion to bool
> > +automatically converts the value to true or false. When using bool typ=
es the
> > +!! construction is not needed, which eliminates a class of bugs.
> > +
> > +When working with bool values the true and false definitions should be=
 used
> > +instead of 0 and 1.
> > +
> > +bool function return types and stack variables are always fine to use =
whenever
> > +appropriate. Use of bool is encouraged to improve readability and is o=
ften a
> > +better option than 'int' for storing boolean values.
>=20
> It's awkward to start a sentence with a lower case letter.  How about
> rephrasing this paragraph and the following one as:
>=20
>   Using bool as the return type of a function or as a variable is always
>   fine when appropriate.  It often improves readability and is a better o=
ption
>   than int for storing boolean values.  Using bool in data structures is
>   more debatable; its size and alignment can vary between architectures.

This is more concise, but I think if the coding style is not going to
give a concrete advise then it should at least provide some general
information so the reader can try and make an informed choice.

That is why I had it expand on some of the rationals a little bit,
along with a concrete direction to not use bool in the cases Linus
specifically called out.

> > +Do not use bool if cache line layout or size of the value matters, its=
 size
> > +and alignment varies based on the compiled architecture. Structures th=
at are
> > +optimized for alignment and size should not use bool.
> > +
> > +If a structure has many true/false values, consider consolidating them=
 into a
> > +bitfield with 1 bit members, or using an appropriate fixed width type,=
 such as
> > +u8.

JAson
