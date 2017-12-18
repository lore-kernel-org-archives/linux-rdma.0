From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 5/5] RDMA/core: Add runchecks.cfg for
 drivers/infiniband/core
Date: Mon, 18 Dec 2017 13:36:26 +0100
Message-ID: <1513600586.22938.29.camel@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <0ce3c307255b22d23f49d13213b76044647e6f60.1513430008.git-series.knut.omang@oracle.com>
         <20171218080223.GB18894@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171218080223.GB18894-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?H=E5kon?= Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?=C5smund_=D8stvold?= <asmund.ostvold-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-12-18 at 10:02 +0200, Leon Romanovsky wrote:
> On Sat, Dec 16, 2017 at 03:42:30PM +0100, Knut Omang wrote:
> > Add a runchecks.cfg to drivers/infiniband/core
> > to start "reining in" future checker errors,
> > and making it easier to selectively clean up existing
> > issues.
> >=20
> > This runchecks.cfg lets make C=3D2 M=3Ddrivers/infiniband/core
> > pass with all errors/warnings suppressed
> >=20
> > See Documentation/dev-tools/runchecks.rst for
> > motivation and details.
> >=20
> > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: H=C3=A5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: =C3=85smund =C3=98stvold <asmund.ostvold-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/core/runchecks.cfg | 83 +++++++++++++++++++++++++++=
+-
> >  1 file changed, 83 insertions(+)
> >  create mode 100644 drivers/infiniband/core/runchecks.cfg
> >=20
> > diff --git a/drivers/infiniband/core/runchecks.cfg b/drivers/infiniband=
/core/runchecks.cfg
> > new file mode 100644
> > index 0000000..75ca57c
> > --- /dev/null
> > +++ b/drivers/infiniband/core/runchecks.cfg
> > @@ -0,0 +1,83 @@
> > +#
> > +# checker suppression lists for drivers/infiniband/core
> > +#
> > +# see Documentation/dev-tools/runchecks.rst
> > +#
> > +
> > +checker checkpatch
> > +##################
> > +
> > +# Accept somewhat longer lines:
> > +line_len 110
> > +
> > +# Uncategorized:
> > +#
> > +except TRAILING_STATEMENTS packer.c
> > +except NON_OCTAL_PERMISSIONS rw.c
> > +except STATIC_CONST_CHAR_ARRAY sysfs.c
> > +except SYMBOLIC_PERMS sysfs.c
> > +except NEEDLESS_IF sysfs.c
> > +except NAKED_SSCANF device.c
> > +except ALLOC_WITH_MULTIPLY fmr_pool.c iwpm_util.c cma.c
> > +except MULTIPLE_ASSIGNMENTS rw.c verbs.c
> > +except ALLOC_SIZEOF_STRUCT sysfs.c iwpm_util.c iwpm_msg.c cma.c cm.c i=
wcm.c
> > +except LOGICAL_CONTINUATIONS mad.c iwpm_util.c user_mad.c
> > +
> > +# Important to fix/go through from a quality perspective:
> > +#
> > +except AVOID_BUG rw.c mad.c cm.c iwcm.c cma.c
> > +except UNCOMMENTED_DEFINITION ucma.c fmr_pool.c multicast.c mad_rmpp.c
> > +except UNCOMMENTED_DEFINITION ucm.c umem.c cma.c user_mad.c cm.c
> > +except ASSIGN_IN_IF mad.c cma.c uverbs_ioctl_merge.c
> > +except SUSPECT_CODE_INDENT iwpm_util.c cma.c uverbs_ioctl.c user_mad.c=
 uverbs_cmd.c
> > +except COMPLEX_MACRO uverbs_ioctl_merge.c
> > +except BOOL_COMPARISON roce_gid_mgmt.c
> > +
> > +# Code simplification:
> > +#
> > +except UNNECESSARY_ELSE cache.c mad.c mad_rmpp.c
> > +except UNNECESSARY_PARENTHESES cma.c sa_query.c mad.c ucma.c mad_rmpp.=
c umem.c
> > +except UNNECESSARY_PARENTHESES user_mad.c uverbs_cmd.c uverbs_marshall=
.c cm.c
> > +except EMBEDDED_FUNCTION_NAME mad.c umem.c cma.c ucma.c user_mad.c
> > +except RETURN_VOID sysfs.c sa_query.c mad.c cma.c ucm.c uverbs_main.c =
umem.c
> > +except CONSTANT_COMPARISON smi.c
> > +except OOM_MESSAGE iwpm_util.c
> > +
> > +# Style and readability:
> > +#
> > +except OPEN_BRACE cache.c mad.c umem_odp.c umem_rbtree.c cm.c
> > +except MULTILINE_DEREFERENCE mad.c cm.c cma.c uverbs_main.c
> > +except LONG_LINE cma.c
> > +except PARENTHESIS_ALIGNMENT umem.c cm.c
> > +except FUNCTION_ARGUMENTS verbs.c uverbs_cmd.c sa_query.c sysfs.c
> > +
> > +# Candidates to leave as exceptions (don't fix):
> > +except SPACING umem_rbtree.c
> > +except MACRO_ARG_REUSE ud_header.c sa_query.c uverbs_ioctl_merge.c
> > +
> > +# These are in most of the source files, ignore for all files:
> > +#
> > +pervasive BLOCK_COMMENT_STYLE ENOSYS BRACES OPEN_ENDED_LINE
> > +
> > +# These are easily autocorrected by checkpatch with --fix-inplace:
> > +#
> > +pervasive SIZEOF_PARENTHESIS SPACING LINE_SPACING SPACE_BEFORE_TAB TAB=
STOP
> > +pervasive TRAILING_WHITESPACE POINTER_LOCATION INITIALISED_STATIC
> > +pervasive CODE_INDENT ELSE_AFTER_BRACE SYMBOLIC_PERMS LEADING_SPACE
> > +pervasive PARENTHESIS_ALIGNMENT COMPARISON_TO_NULL TYPO_SPELLING
> > +
> > +checker sparse
> > +##############
> > +
> > +except SHADOW sysfs.c fmr_pool.c user_mad.c uverbs_main.c ucm.c ucma.c
> > +except RETURN_VOID roce_gid_mgmt.c
> > +except TYPESIGN ucm.c ucma.c
> > +
> > +# From linux/device.h:
> > +except RETURN_VOID ucm.c
> > +
> > +checker checkdoc
> > +################
> > +
> > +except PARAM_DESC verbs.c device.c fmr_pool.c cache.c sa_query.c
> > +except X_PARAM verbs.c fmr_pool.c cache.c
>=20
> I missed most of the patches from this series and previous version too,
> but in regards to IB. I don't want to see static checkers exceptions for
> core code. It does make a lot of sense for drivers which can be unmaintai=
ned.

And I couldn't agree more. But some aid in assessing the scope of the task=
=20
and tracking progress/prevent regressions would be good, wouldn't it?

This file + enabling a build bot to run make C=3D2 allows you to prevent=
=20
any checker error types from appearing anywhere in core apart from for=20
the exception files and starting from this point of.

> Also, I agree with other reviewers, there is no excuse for adding
> checkpatch specifics per-subsystem/folder, the differences are better
> to be treated in checkpatch.pl itself.

Hopefully my intention should be clearer if you look at the documentation:

https://lkml.org/lkml/2017/12/16/135

The best is if no exceptions are needed, but until then let's at least get
automatic testing so that you and other reviewers can focus on the more imp=
ortant=20
issues?

Thanks,
Knut

>=20
> Thanks
>=20
> > --
> > git-series 0.9.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
