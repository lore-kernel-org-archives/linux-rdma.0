From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v4] coding-style: Clarify the expectations around bool
Date: Mon, 14 Jan 2019 17:20:49 +0000
Message-ID: <20190114172044.GE22875@mellanox.com>
References: <20190110234805.GN6890@ziepe.ca>
 <20190111172940.zufmrhvukqo5hkat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111172940.zufmrhvukqo5hkat@gmail.com>
Content-Language: en-US
Content-ID: <420A43F343C15F47AEEDD50D202BF142@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joey Pabalinas <joeypabalinas@gmail.com>, Joe Perches <joe@perches.com>, Gal Pressman <galpress@amazon.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 11, 2019 at 07:29:40AM -1000, Joey Pabalinas wrote:
> On Thu, Jan 10, 2019 at 11:48:13PM +0000, Jason Gunthorpe wrote:
> > There has been some confusion since checkpatch started warning about bo=
ol
> > use in structures, and people have been avoiding using it.
> >=20
> > Many people feel there is still a legitimate place for bool in structur=
es,
> > so provide some guidance on bool usage derived from the entire thread t=
hat
> > spawned the checkpatch warning.
>=20
> Hey Jason,
>=20
> I very much agree that the bool expectations could be much clearer, and t=
his
> patch is a nice step in that direction! Just a couple small nitpicks:
>=20
> > +Do not use bool if cache line layout or size of the value matters, its=
 size
> > +and alignment varies based on the compiled architecture. Structures th=
at are
> > +optimized for alignment and size should not use bool.
>=20
> +Do not use bool if cache line layout or size of the value matters, as it=
s size
>                                                                     ^
>                                                                     |
> Adding an "as" makes the sentence flow a bit cleaner: --------------
>=20
> > +into a single bitwise 'flags' argument and 'flags' can often a more re=
adable
> > +alternative if the call-sites have naked true/false constants.
>=20
> +into a single bitwise 'flags' argument and 'flags' can often be a more r=
eadable
>                                                               ^
>                                                               |
> Missing a "be" here: -----------------------------------------
>=20
> Ack from me after those two corrections.
>=20
> Reviewed-by: Joey Pabalinas <joeypabalinas@gmail.com>

done, thanks

Jason
