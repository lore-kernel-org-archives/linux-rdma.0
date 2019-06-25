From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v3 13/33] docs: infiniband: convert docs to ReST and
 rename to *.rst
Date: Tue, 25 Jun 2019 13:24:21 +0000
Message-ID: <20190625132418.GA18528@mellanox.com>
References: <cover.1560045490.git.mchehab+samsung@kernel.org>
 <09036fdb89c4bec94cb92d25398c026afdb134e7.1560045490.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <09036fdb89c4bec94cb92d25398c026afdb134e7.1560045490.git.mchehab+samsung@kernel.org>
Content-Language: en-US
Content-ID: <F7C52F5F4E05CF4E96AB692EE5D43B61@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 08, 2019 at 11:27:03PM -0300, Mauro Carvalho Chehab wrote:
> The InfiniBand docs are plain text with no markups.
> So, all we needed to do were to add the title markups and
> some markup sequences in order to properly parse tables,
> lists and literal blocks.
>=20
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  .../{core_locking.txt =3D> core_locking.rst}    |  64 ++++++-----
>  Documentation/infiniband/index.rst            |  23 ++++
>  .../infiniband/{ipoib.txt =3D> ipoib.rst}       |  24 ++--
>  .../infiniband/{opa_vnic.txt =3D> opa_vnic.rst} | 108 +++++++++---------
>  .../infiniband/{sysfs.txt =3D> sysfs.rst}       |   4 +-
>  .../{tag_matching.txt =3D> tag_matching.rst}    |   5 +
>  .../infiniband/{user_mad.txt =3D> user_mad.rst} |  33 ++++--
>  .../{user_verbs.txt =3D> user_verbs.rst}        |  12 +-
>  drivers/infiniband/core/user_mad.c            |   2 +-
>  drivers/infiniband/ulp/ipoib/Kconfig          |   2 +-
>  10 files changed, 174 insertions(+), 103 deletions(-)
>  rename Documentation/infiniband/{core_locking.txt =3D> core_locking.rst}=
 (78%)
>  create mode 100644 Documentation/infiniband/index.rst
>  rename Documentation/infiniband/{ipoib.txt =3D> ipoib.rst} (90%)
>  rename Documentation/infiniband/{opa_vnic.txt =3D> opa_vnic.rst} (63%)
>  rename Documentation/infiniband/{sysfs.txt =3D> sysfs.rst} (69%)
>  rename Documentation/infiniband/{tag_matching.txt =3D> tag_matching.rst}=
 (98%)
>  rename Documentation/infiniband/{user_mad.txt =3D> user_mad.rst} (90%)
>  rename Documentation/infiniband/{user_verbs.txt =3D> user_verbs.rst} (93=
%)

Applied to for-next, thanks

Jason
