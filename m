From: Knut Omang <knut.omang@oracle.com>
Subject: Re: [PATCH v2 5/5] RDMA/core: Add runchecks.cfg for
 drivers/infiniband/core
Date: Mon, 18 Dec 2017 16:23:20 +0100
Message-ID: <1513610600.31439.168.camel@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <0ce3c307255b22d23f49d13213b76044647e6f60.1513430008.git-series.knut.omang@oracle.com>
         <20171218080223.GB18894@mtr-leonro.local>
         <1513600586.22938.29.camel@oracle.com>
         <20171218140428.GC18894@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171218140428.GC18894@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, =?ISO-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, =?ISO-8859-1?Q?=C5smund_=D8stvold?= <asmund.ostvold@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-12-18 at 16:04 +0200, Leon Romanovsky wrote:
> On Mon, Dec 18, 2017 at 01:36:26PM +0100, Knut Omang wrote:
> > On Mon, 2017-12-18 at 10:02 +0200, Leon Romanovsky wrote:
> > > On Sat, Dec 16, 2017 at 03:42:30PM +0100, Knut Omang wrote:
> > > > Add a runchecks.cfg to drivers/infiniband/core
> > > > to start "reining in" future checker errors,
> > > > and making it easier to selectively clean up existing
> > > > issues.
> > > >
> > > > This runchecks.cfg lets make C=3D2 M=3Ddrivers/infiniband/core
> > > > pass with all errors/warnings suppressed
> > > >
> > > > See Documentation/dev-tools/runchecks.rst for
> > > > motivation and details.
> > > >
> > > > Signed-off-by: Knut Omang <knut.omang@oracle.com>
> > > > Reviewed-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
> > > > Reviewed-by: =C3=85smund =C3=98stvold <asmund.ostvold@oracle.com>
> > > > ---
> > > >  drivers/infiniband/core/runchecks.cfg | 83 +++++++++++++++++++++++=
+++++-
> > > >  1 file changed, 83 insertions(+)
> > > >  create mode 100644 drivers/infiniband/core/runchecks.cfg
> > > >
> > > > diff --git a/drivers/infiniband/core/runchecks.cfg
> b/drivers/infiniband/core/runchecks.cfg
> > > > new file mode 100644
> > > > index 0000000..75ca57c
> > > > --- /dev/null
> > > > +++ b/drivers/infiniband/core/runchecks.cfg
> > > > @@ -0,0 +1,83 @@
> > > > +#
> > > > +# checker suppression lists for drivers/infiniband/core
> > > > +#
> > > > +# see Documentation/dev-tools/runchecks.rst
> > > > +#
> > > > +
> > > > +checker checkpatch
> > > > +##################
> > > > +
> > > > +# Accept somewhat longer lines:
> > > > +line_len 110
> > > > +
> > > > +# Uncategorized:
> > > > +#
> > > > +except TRAILING_STATEMENTS packer.c
> > > > +except NON_OCTAL_PERMISSIONS rw.c
> > > > +except STATIC_CONST_CHAR_ARRAY sysfs.c
> > > > +except SYMBOLIC_PERMS sysfs.c
> > > > +except NEEDLESS_IF sysfs.c
> > > > +except NAKED_SSCANF device.c
> > > > +except ALLOC_WITH_MULTIPLY fmr_pool.c iwpm_util.c cma.c
> > > > +except MULTIPLE_ASSIGNMENTS rw.c verbs.c
> > > > +except ALLOC_SIZEOF_STRUCT sysfs.c iwpm_util.c iwpm_msg.c cma.c cm=
.c iwcm.c
> > > > +except LOGICAL_CONTINUATIONS mad.c iwpm_util.c user_mad.c
> > > > +
> > > > +# Important to fix/go through from a quality perspective:
> > > > +#
> > > > +except AVOID_BUG rw.c mad.c cm.c iwcm.c cma.c
> > > > +except UNCOMMENTED_DEFINITION ucma.c fmr_pool.c multicast.c mad_rm=
pp.c
> > > > +except UNCOMMENTED_DEFINITION ucm.c umem.c cma.c user_mad.c cm.c
> > > > +except ASSIGN_IN_IF mad.c cma.c uverbs_ioctl_merge.c
> > > > +except SUSPECT_CODE_INDENT iwpm_util.c cma.c uverbs_ioctl.c user_m=
ad.c
> uverbs_cmd.c
> > > > +except COMPLEX_MACRO uverbs_ioctl_merge.c
> > > > +except BOOL_COMPARISON roce_gid_mgmt.c
> > > > +
> > > > +# Code simplification:
> > > > +#
> > > > +except UNNECESSARY_ELSE cache.c mad.c mad_rmpp.c
> > > > +except UNNECESSARY_PARENTHESES cma.c sa_query.c mad.c ucma.c mad_r=
mpp.c umem.c
> > > > +except UNNECESSARY_PARENTHESES user_mad.c uverbs_cmd.c uverbs_mars=
hall.c cm.c
> > > > +except EMBEDDED_FUNCTION_NAME mad.c umem.c cma.c ucma.c user_mad.c
> > > > +except RETURN_VOID sysfs.c sa_query.c mad.c cma.c ucm.c uverbs_mai=
n.c umem.c
> > > > +except CONSTANT_COMPARISON smi.c
> > > > +except OOM_MESSAGE iwpm_util.c
> > > > +
> > > > +# Style and readability:
> > > > +#
> > > > +except OPEN_BRACE cache.c mad.c umem_odp.c umem_rbtree.c cm.c
> > > > +except MULTILINE_DEREFERENCE mad.c cm.c cma.c uverbs_main.c
> > > > +except LONG_LINE cma.c
> > > > +except PARENTHESIS_ALIGNMENT umem.c cm.c
> > > > +except FUNCTION_ARGUMENTS verbs.c uverbs_cmd.c sa_query.c sysfs.c
> > > > +
> > > > +# Candidates to leave as exceptions (don't fix):
> > > > +except SPACING umem_rbtree.c
> > > > +except MACRO_ARG_REUSE ud_header.c sa_query.c uverbs_ioctl_merge.c
> > > > +
> > > > +# These are in most of the source files, ignore for all files:
> > > > +#
> > > > +pervasive BLOCK_COMMENT_STYLE ENOSYS BRACES OPEN_ENDED_LINE
> > > > +
> > > > +# These are easily autocorrected by checkpatch with --fix-inplace:
> > > > +#
> > > > +pervasive SIZEOF_PARENTHESIS SPACING LINE_SPACING SPACE_BEFORE_TAB=
 TABSTOP
> > > > +pervasive TRAILING_WHITESPACE POINTER_LOCATION INITIALISED_STATIC
> > > > +pervasive CODE_INDENT ELSE_AFTER_BRACE SYMBOLIC_PERMS LEADING_SPAC=
E
> > > > +pervasive PARENTHESIS_ALIGNMENT COMPARISON_TO_NULL TYPO_SPELLING
> > > > +
> > > > +checker sparse
> > > > +##############
> > > > +
> > > > +except SHADOW sysfs.c fmr_pool.c user_mad.c uverbs_main.c ucm.c uc=
ma.c
> > > > +except RETURN_VOID roce_gid_mgmt.c
> > > > +except TYPESIGN ucm.c ucma.c
> > > > +
> > > > +# From linux/device.h:
> > > > +except RETURN_VOID ucm.c
> > > > +
> > > > +checker checkdoc
> > > > +################
> > > > +
> > > > +except PARAM_DESC verbs.c device.c fmr_pool.c cache.c sa_query.c
> > > > +except X_PARAM verbs.c fmr_pool.c cache.c
> > >
> > > I missed most of the patches from this series and previous version to=
o,
> > > but in regards to IB. I don't want to see static checkers exceptions =
for
> > > core code. It does make a lot of sense for drivers which can be unmai=
ntained.
> >
> > And I couldn't agree more. But some aid in assessing the scope of the t=
ask
> > and tracking progress/prevent regressions would be good, wouldn't it?
>=20
> In current form, it doesn't fully prevent regressions, for example the
> line "except TYPESIGN ucm.c ucma.c" means that new code with such errors
> to the files ucm.c/ucma.c will be missed too.

Yes, that's true.

> > This file + enabling a build bot to run make C=3D2 allows you to preven=
t
> > any checker error types from appearing anywhere in core apart from for
> > the exception files and starting from this point of.
>=20
> We are talking about the same and our goal is the same too - to see it is=
 merged.
> I'm just saying that for the IB part, cleanup of IB/core is needed prior
> to merging IB related runcheck.cfg file, so it will include drivers only.

appreciated,=20
my take on it is that this initial runchecks.cfg file is more=20
of a plan for improvements than an exception list, and that the file can be=
 used
to track changes and for you to indicate importance or state of different=
=20
checks.

> > > Also, I agree with other reviewers, there is no excuse for adding
> > > checkpatch specifics per-subsystem/folder, the differences are better
> > > to be treated in checkpatch.pl itself.
> >
> > Hopefully my intention should be clearer if you look at the documentati=
on:
> >
> > https://lkml.org/lkml/2017/12/16/135
> >
> > The best is if no exceptions are needed, but until then let's at least =
get
> > automatic testing so that you and other reviewers can focus on the more=
 important
> > issues?
>=20
> Hiding simply mean that such errors will never be fixed

I agree that's a potential way to misuse this tool.

It depends on how we view/use the runchecks.cfg file - after all it is a do=
cumentation of
issues that exists, and can be used to indicate why it has not been fixed y=
et or to point=20
contributors to where the biggest pain points are.

Right now important detections that may hide potential bugs easily=20
drown in whitespace or sizeof issues. I found it very useful just to=20
do the exercise of creating these suppression lists.=20

I first started out fixing issues while the checkers discovered them,=20
but after a while I ended up taking a step back and starting over=20
again by first creating the "todo list" in the form of a runchecks.cfg file=
 that=20
narrowly suppresses everything, then starting to fix issues type by type wh=
ile
narrowing the exceptions list in the runchecks.cfg file=20
this gives IMHO cleaner and more focused commits, and every step would=20
pass the 'make C=3D2' test with no errors.

Thanks,
Knut

> Thanks
>=20
> >
> > Thanks,
> > Knut
> >
> > >
> > > Thanks
> > >
> > > > --
> > > > git-series 0.9.1
