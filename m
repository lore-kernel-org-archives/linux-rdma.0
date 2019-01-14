From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v4] coding-style: Clarify the expectations around bool
Date: Mon, 14 Jan 2019 17:28:34 +0000
Message-ID: <20190114172827.GG22875@mellanox.com>
References: <20190110234805.GN6890@ziepe.ca>
 <d09397d56df116e0d2b8e1a56ace0a37@vaga.pv.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <d09397d56df116e0d2b8e1a56ace0a37@vaga.pv.it>
Content-Language: en-US
Content-ID: <ACD50DC412CF9A41B0647F6ED9BBD7BE@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Federico Vaga <federico.vaga@vaga.pv.it>
Cc: Joe Perches <joe@perches.com>, Gal Pressman <galpress@amazon.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 13, 2019 at 05:01:39PM +0100, Federico Vaga wrote:

> > -17) Don't re-invent the kernel macros
> > +17) Using bool
> > +--------------
> > +
> > +The Linux kernel bool type is an alias for the C99 _Bool type. bool
> > values can
> > +only evaluate to 0 or 1, and implicit or explicit conversion to bool
> > +automatically converts the value to true or false. When using bool
> > types the
> > +!! construction is not needed, which eliminates a class of bugs.
> > +
> > +When working with bool values the true and false definitions should be
> > used
> > +instead of 0 and 1.
>=20
> A very minor thing. I would suggest to keep consistent, in the
> statement, the mapping between definitions ("true and false [...]")
> and their correspondent integer values ("[...] instead of 1 and 0").
>=20
> In few words, I propose to change "0 and 1" into "1 and 0".

Hm, sure, seems harmless

> > +Similarly for function arguments, many true/false values can be
> > consolidated
> > +into a single bitwise 'flags' argument and 'flags' can often a more
> > readable
> > +alternative if the call-sites have naked true/false constants.
>=20
> Of course, English is not my primary language, but it looks to me
> that here a "be" is missing: "[...] and 'flags' can often a more
> readable alternative [...]".

yes, sthanks
=20
> > +Otherwise limited use of bool in structures and arguments can improve
> > +readability.
>=20
> I'm going to update the Italian translations for this. Do you want
> me to contribute directly to this patch? Otherwise I will send a
> dedicated patch later when this one get accepted.
=20
I think you should send it as an update I guess? I don't really know
the process for translations

Jason
