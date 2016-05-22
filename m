From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Sun, 22 May 2016 15:01:29 +0300
Message-ID: <20160522120129.GC25500@leon.nu>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
 <20160519122622.22041.41686.stgit@scvm10.sc.intel.com>
 <20160521123404.GB25500@leon.nu>
 <20160521162301.GA16770@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160521162301.GA16770-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 21, 2016 at 12:23:02PM -0400, Dennis Dalessandro wrote:
> On Sat, May 21, 2016 at 03:34:04PM +0300, Leon Romanovsky wrote:
> >On Thu, May 19, 2016 at 05:26:24AM -0700, Dennis Dalessandro wrote:
> >>IOCTL is more suited to what user space commands need to do than the
> >>write() interface. Add IOCTL definitions for all existing write commands
> >>and the handling for those. The write() interface will be removed in a
> >>follow on patch.
> >>
> >>Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>---
> >> drivers/staging/rdma/hfi1/common.h   |    5 +
> >> drivers/staging/rdma/hfi1/file_ops.c |  204 ++++++++++++++++++++++++++=
++++++++
> >> include/uapi/rdma/hfi/hfi1_user.h    |   40 +++++++
> >> 3 files changed, 248 insertions(+), 1 deletions(-)
> >>
> >
> ><...>
> >
> >>+#define IB_IOCTL_MAGIC 0x1b /* See Documentation/ioctl/ioctl-number.tx=
t */
> >>+
> >>+struct hfi1_cmd;
> >>+#define HFI1_IOCTL_ASSIGN_CTXT \
> >>+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_ASSIGN_CTXT, struct hfi1_user_info)
> >>+#define HFI1_IOCTL_CTXT_INFO \
> >>+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_CTXT_INFO, struct hfi1_ctxt_info)
> >>+#define HFI1_IOCTL_USER_INFO \
> >>+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_USER_INFO, struct hfi1_base_info)
> >>+#define HFI1_IOCTL_TID_UPDATE \
> >>+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_UPDATE, struct hfi1_tid_info)
> >>+#define HFI1_IOCTL_TID_FREE \
> >>+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_FREE, struct hfi1_tid_info)
> >>+#define HFI1_IOCTL_CREDIT_UPD \
> >>+	_IO(IB_IOCTL_MAGIC, HFI1_CMD_CREDIT_UPD)
> >>+#define HFI1_IOCTL_RECV_CTRL \
> >>+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_RECV_CTRL, int)
> >>+#define HFI1_IOCTL_POLL_TYPE \
> >>+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_POLL_TYPE, int)
> >>+#define HFI1_IOCTL_ACK_EVENT \
> >>+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_ACK_EVENT, unsigned long)
> >>+#define HFI1_IOCTL_SET_PKEY \
> >>+	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_SET_PKEY, __u16)
> >>+#define HFI1_IOCTL_CTXT_RESET \
> >>+	_IO(IB_IOCTL_MAGIC, HFI1_CMD_CTXT_RESET)
> >>+#define HFI1_IOCTL_TID_INVAL_READ \
> >>+	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_INVAL_READ, struct hfi1_tid_info)
> >>+#define HFI1_IOCTL_GET_VERS \
> >>+	_IOR(IB_IOCTL_MAGIC, HFI1_CMD_GET_VERS, int)
> >
> >I think the overall consensus over participants in OFVWG call was to use
> >one IOCTL to enter into device specific handler which will do all
> >necessary parsing and not spamming common IOCTL interface.
>=20
> That was for the verbs working group and the verbs 2.0 uAPI. This is for
> psm.

I'm glad that you are supporting my point.
It is vendor specific implementation for vendor specific driver and not
for whole IB core, so there is no need to pollute general IB ioctls.

> In the interim, while the OFVWG is solidifying its one API to rule them a=
ll,
> this solves our current and very specific problem of treating
> write()/writev() differently.

OFVWG is working on improving current verbs interface, for proprietary thin=
gs like this,
there is agreed API which will look similar to this:

1051 static long ib_uverbs_ioctl(struct file *filp, unsigned int cmd,
1052                                 unsigned long arg)
1053 {
1054         struct ib_uverbs_ioctl_hdr __user *user_hdr =3D
1055                 (struct ib_uverbs_ioctl_hdr __user *)arg;
1056         struct ib_uverbs_ioctl_hdr hdr;
1057
1058         struct ib_uverbs_file *file =3D filp->private_data;
1059         struct ib_device *ib_dev;
1060         int srcu_key;
1061         long ret =3D 0;
1062
1063         if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
1064                 return -EACCES;
1065
1066         if (cmd =3D=3D IB_USER_DIRECT_IOCTL_COMMAND) {
1067                 srcu_key =3D srcu_read_lock(&file->device->disassociat=
e_srcu);
1068                 ib_dev =3D srcu_dereference(file->device->ib_dev,
1069						&file->device->disassociate_srcu);
1070                 if (!ib_dev) {
1071			     srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
1072                         return -EIO;
1073                 }
1074
1075                 if (ib_dev->direct_fn)
1076                         ret =3D ib_dev->direct_fn(filp, arg);
1077
1078                 srcu_read_unlock(&file->device->disassociate_srcu,srcu=
_key);
1079                 return ret;

>=20
> -Denny

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXQZ+ZAAoJEORje4g2clinv/cQAIvKekH7jPCF1kcsSFL0Dt7j
HS/+FaFjiqbMIpUwOynDNkgbincmOGgCGsSOLpSdspmdTB2XV0pwOsBrR6WV6BJc
ODR+I8UNejm5twtmkUZBLZ4FEmHxIWqivlZpDJYsEquxeNWQDdr/OSmavqtqk30s
ECblw2snLM8Lq++ujAo7mbmAMbr0z3v9c4aVqOHWSVXPj6tx2EZ9d2n1+1pn/LAh
ky1nGYqalHPn209gEdIkA2eXMfTicTbcCIOyyA0earWB75UBxXZMHXV78EKn4yRU
B6WgFMVfr+73FfisyEbd+bgDKbElDBLoj7TffJ5uaNkpfPAmnnLxbJaN4QVpeuMh
Uvdh/i/JG008U/0UDDmdmgUawFpDmUid88YPdK5EAh7pXDagb4jSp2kbst86sPvo
+ITyUuA/ato2Z7iUYFTyjyVDu1wR2cgc1qdmDQC3rUYZLWzaorKMVrwpYb3HeeVD
UkAS9bd7N9IHnAVm2IYRVBH2ZltQBmWJ8Z48KT9/Nb0V47BVk+DtfF1O6DECWFHm
0CUva83E0lXbCszY05muXSf8lrsE2a1RL0cgu9IrgHN8D/wwAu1JtCK0GXMgwU0e
o4KZQV0NeUSDxekyLVWjncZ1Q1Dv4wRvH6Ad5hDIYRqecjUM58yTRhCz3/YnUNra
vaHr2ytwDC87OcX9bDQ4
=W1yu
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
