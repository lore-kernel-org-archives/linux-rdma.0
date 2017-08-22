From: Jeff Inman <jti-YOWKrPYUwWM@public.gmane.org>
Subject: small patches to librdmacm
Date: Tue, 22 Aug 2017 13:47:18 -0600
Message-ID: <C50D9A8A-457A-4DA6-B727-43B77117ED15@lanl.gov>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_6487B0B5-D261-47D4-8183-344EF31D23A8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_6487B0B5-D261-47D4-8183-344EF31D23A8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi folks,

I=E2=80=99m new to this.  Please let me know, if you need a different =
format, etc.

Of the two of these, 0001 is the one I care about.


0001:  The patch comment explains the details of the fix, but here=E2=80=99=
s some context:

Access to entries in the rsocket index 'idm' is effectively serialized =
by creation/destruction of file-descriptors for /dev/infiniband/rdma_cm. =
 New fds are created in rsocket -> rdma_create_id, and released in =
rclose -> rs_free -> rdma_destroy_id.  rs_free() was releasing the index =
with rs_remove() *after* calling rdma_destroy_id().  But closing the =
file-descriptor in rdma_destroy_id() yields to the scheduler, making it =
easy for another thread to get into rsocket() during the break.  This =
thread can get its own fd (because the first thread=E2=80=99s close has =
succeed) and store its own rs into the index, before the first thread =
has gotten around to calling rs_remove().  After the first thread does =
call rs_remove(), the second thread will segfault in most =
rsocket-related functions.

Note that I=E2=80=99m not assuming an rsocket can be simultaneously =
operated by different threads.  I just have separate threads that =
open/operate/close their own rsockets.  This seems to be working fine, =
except for this patched problem.  Am I mistaken that this is reasonable?


0002:  Removing the potential for segfaults when a legitimate rs is not =
found in the index.  This should never happen unless there is a bug like =
the one fixed in 0001 (or someone stupidly makes a call with a closed =
rsocket =E2=80=A6), so the tests should almost always be wasted.  Made =
this a separate patch, so you could ignore it, if you want.


Thanks,
Jeff

--
Jeff Inman
High-Performance Computing (HPC-ENV)
MS-B295, Los Alamos National Laboratory
Los Alamos, NM 87545







Jeff Inman (2):
  rsocket: fix a race-condition in rs_free()
  rsocket: fix segfaults when rs is not found in the index

 librdmacm/rsocket.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)



--Apple-Mail=_6487B0B5-D261-47D4-8183-344EF31D23A8
Content-Disposition: attachment;
	filename=0001-rsocket-fix-a-race-condition-in-rs_free.patch
Content-Type: application/octet-stream;
	name="0001-rsocket-fix-a-race-condition-in-rs_free.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=2073d3e0cf6f4816981ef7e5fc0a113888ad9b1f25=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Jeff=20Inman=20<jti-YOWKrPYUwWM@public.gmane.org>=0ADate:=20Thu,=20=
17=20Aug=202017=2013:14:57=20-0600=0ASubject:=20[rsocket=201/2]=20=
rsocket:=20fix=20a=20race-condition=20in=20rs_free()=0A=0AIf=20rs_free()=20=
releases=20the=20fd=20before=20calling=20rs_remove(),=20a=20second=0A=
thread=20in=20rsocket()=20may=20acquire=20the=20same=20fd=20and=20store=20=
its=20own=20rs=20in=0Athe=20corresponding=20index-element.=20=20When=20=
the=20first=20thread=20then=20gets=0Aaround=20to=20calling=20rs_remove()=20=
it=20ends=20up=20removing=20the=20rs=20of=20the=20second=0Athread,=20and=20=
storing=20a=20NULL=20there.=0A=0ASeveral=20functions=20still=20do=20not=20=
check=20for=20NULL=20after=20retrieving=20an=20rs=0Afrom=20the=20index=20=
for=20an=20open=20rsocket.=20=20Thus,=20the=20second=20thread=20would=20=
get=0Aa=20segfault=20in=20any=20of=20the=20following=20functions:=20=
rrecv,=20rrecvfrom,=20rsend,=0Arsendto,=20rsendv,=20riomap,=20riounmap,=20=
riowrite.=0A=0AFixes:=20=20cf7aae3=20"rsocket:=20Index=20map=20item=20is=20=
cleaned=20before=20it=20is=20used=20in=20iomapping=20cleanup"=0A=0A=
Signed-off-by:=20Jeff=20Inman=20<jti-YOWKrPYUwWM@public.gmane.org>=0A---=0A=20=
librdmacm/rsocket.c=20|=20=20=20=206=20+++---=0A=201=20files=20changed,=20=
3=20insertions(+),=203=20deletions(-)=0A=0Adiff=20--git=20=
a/librdmacm/rsocket.c=20b/librdmacm/rsocket.c=0Aindex=20f28529c..77a6df4=20=
100644=0A---=20a/librdmacm/rsocket.c=0A+++=20b/librdmacm/rsocket.c=0A@@=20=
-1012,6=20+1012,9=20@@=20static=20void=20rs_free(struct=20rsocket=20*rs)=0A=
=20=09=09free(rs->target_buffer_list);=0A=20=09}=0A=20=0A+=09if=20=
(rs->index=20>=3D=200)=0A+=09=09rs_remove(rs);=0A+=0A=20=09if=20=
(rs->cm_id)=20{=0A=20=09=09rs_free_iomappings(rs);=0A=20=09=09if=20=
(rs->cm_id->qp)=20{=0A@@=20-1021,9=20+1024,6=20@@=20static=20void=20=
rs_free(struct=20rsocket=20*rs)=0A=20=09=09rdma_destroy_id(rs->cm_id);=0A=
=20=09}=0A=20=0A-=09if=20(rs->index=20>=3D=200)=0A-=09=09rs_remove(rs);=0A=
-=0A=20=09fastlock_destroy(&rs->map_lock);=0A=20=09=
fastlock_destroy(&rs->cq_wait_lock);=0A=20=09=
fastlock_destroy(&rs->cq_lock);=0A--=20=0A1.7.1=0A=0A=

--Apple-Mail=_6487B0B5-D261-47D4-8183-344EF31D23A8
Content-Disposition: attachment;
	filename=0002-rsocket-fix-segfaults-when-rs-is-not-found-in-the-in.patch
Content-Type: application/octet-stream;
	name="0002-rsocket-fix-segfaults-when-rs-is-not-found-in-the-in.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=2089f14b35b2fcf9b20b485be9d6c8280133c2dec9=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Jeff=20Inman=20<jti-YOWKrPYUwWM@public.gmane.org>=0ADate:=20Tue,=20=
22=20Aug=202017=2013:01:31=20-0600=0ASubject:=20[rsocket=202/2]=20=
rsocket:=20fix=20segfaults=20when=20rs=20is=20not=20found=20in=20the=20=
index=0A=0AFixes:=200b6aff4=20librdmacm:=20Define=20streaming=20over=20=
RDMA=20interface=20(rsockets)=0AFixes:=20bb9fcba=20rsocket:=20Add=20APIs=20=
for=20direct=20data=20placement=0A=0ASigned-off-by:=20Jeff=20Inman=20=
<jti-YOWKrPYUwWM@public.gmane.org>=0A---=0A=20librdmacm/rsocket.c=20|=20=20=2016=20=
++++++++++++++++=0A=201=20files=20changed,=2016=20insertions(+),=200=20=
deletions(-)=0A=0Adiff=20--git=20a/librdmacm/rsocket.c=20=
b/librdmacm/rsocket.c=0Aindex=2077a6df4..ca0b9bf=20100644=0A---=20=
a/librdmacm/rsocket.c=0A+++=20b/librdmacm/rsocket.c=0A@@=20-2420,6=20=
+2420,8=20@@=20ssize_t=20rrecv(int=20socket,=20void=20*buf,=20size_t=20=
len,=20int=20flags)=0A=20=09int=20ret=20=3D=200;=0A=20=0A=20=09rs=20=3D=20=
idm_at(&idm,=20socket);=0A+=09if=20(!rs)=0A+=09=09return=20ERR(EBADF);=0A=
=20=09if=20(rs->type=20=3D=3D=20SOCK_DGRAM)=20{=0A=20=09=09=
fastlock_acquire(&rs->rlock);=0A=20=09=09ret=20=3D=20ds_recvfrom(rs,=20=
buf,=20len,=20flags,=20NULL,=20NULL);=0A@@=20-2488,6=20+2490,8=20@@=20=
ssize_t=20rrecvfrom(int=20socket,=20void=20*buf,=20size_t=20len,=20int=20=
flags,=0A=20=09int=20ret;=0A=20=0A=20=09rs=20=3D=20idm_at(&idm,=20=
socket);=0A+=09if=20(!rs)=0A+=09=09return=20ERR(EBADF);=0A=20=09if=20=
(rs->type=20=3D=3D=20SOCK_DGRAM)=20{=0A=20=09=09=
fastlock_acquire(&rs->rlock);=0A=20=09=09ret=20=3D=20ds_recvfrom(rs,=20=
buf,=20len,=20flags,=20src_addr,=20addrlen);=0A@@=20-2691,6=20+2695,8=20=
@@=20ssize_t=20rsend(int=20socket,=20const=20void=20*buf,=20size_t=20=
len,=20int=20flags)=0A=20=09int=20ret=20=3D=200;=0A=20=0A=20=09rs=20=3D=20=
idm_at(&idm,=20socket);=0A+=09if=20(!rs)=0A+=09=09return=20ERR(EBADF);=0A=
=20=09if=20(rs->type=20=3D=3D=20SOCK_DGRAM)=20{=0A=20=09=09=
fastlock_acquire(&rs->slock);=0A=20=09=09ret=20=3D=20dsend(rs,=20buf,=20=
len,=20flags);=0A@@=20-2776,6=20+2782,8=20@@=20ssize_t=20rsendto(int=20=
socket,=20const=20void=20*buf,=20size_t=20len,=20int=20flags,=0A=20=09=
int=20ret;=0A=20=0A=20=09rs=20=3D=20idm_at(&idm,=20socket);=0A+=09if=20=
(!rs)=0A+=09=09return=20ERR(EBADF);=0A=20=09if=20(rs->type=20=3D=3D=20=
SOCK_STREAM)=20{=0A=20=09=09if=20(dest_addr=20||=20addrlen)=0A=20=09=09=09=
return=20ERR(EISCONN);=0A@@=20-2831,6=20+2839,8=20@@=20static=20ssize_t=20=
rsendv(int=20socket,=20const=20struct=20iovec=20*iov,=20int=20iovcnt,=20=
int=20flags=0A=20=09int=20i,=20ret=20=3D=200;=0A=20=0A=20=09rs=20=3D=20=
idm_at(&idm,=20socket);=0A+=09if=20(!rs)=0A+=09=09return=20ERR(EBADF);=0A=
=20=09if=20(rs->state=20&=20rs_opening)=20{=0A=20=09=09ret=20=3D=20=
rs_do_connect(rs);=0A=20=09=09if=20(ret)=20{=0A@@=20-3773,6=20+3783,8=20=
@@=20off_t=20riomap(int=20socket,=20void=20*buf,=20size_t=20len,=20int=20=
prot,=20int=20flags,=20off_t=20offse=0A=20=09int=20access=20=3D=20=
IBV_ACCESS_LOCAL_WRITE;=0A=20=0A=20=09rs=20=3D=20idm_at(&idm,=20socket);=0A=
+=09if=20(!rs)=0A+=09=09return=20ERR(EBADF);=0A=20=09if=20=
(!rs->cm_id->pd=20||=20(prot=20&=20~(PROT_WRITE=20|=20PROT_NONE)))=0A=20=09=
=09return=20ERR(EINVAL);=0A=20=0A@@=20-3821,6=20+3833,8=20@@=20int=20=
riounmap(int=20socket,=20void=20*buf,=20size_t=20len)=0A=20=09int=20ret=20=
=3D=200;=0A=20=0A=20=09rs=20=3D=20idm_at(&idm,=20socket);=0A+=09if=20=
(!rs)=0A+=09=09return=20ERR(EBADF);=0A=20=09=
fastlock_acquire(&rs->map_lock);=0A=20=0A=20=09for=20(entry=20=3D=20=
rs->iomap_list.next;=20entry=20!=3D=20&rs->iomap_list;=0A@@=20-3868,6=20=
+3882,8=20@@=20size_t=20riowrite(int=20socket,=20const=20void=20*buf,=20=
size_t=20count,=20off_t=20offset,=20int=20fla=0A=20=09int=20ret=20=3D=20=
0;=0A=20=0A=20=09rs=20=3D=20idm_at(&idm,=20socket);=0A+=09if=20(!rs)=0A+=09=
=09return=20ERR(EBADF);=0A=20=09fastlock_acquire(&rs->slock);=0A=20=09if=20=
(rs->iomap_pending)=20{=0A=20=09=09ret=20=3D=20rs_send_iomaps(rs,=20=
flags);=0A--=20=0A1.7.1=0A=0A=

--Apple-Mail=_6487B0B5-D261-47D4-8183-344EF31D23A8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii



--Apple-Mail=_6487B0B5-D261-47D4-8183-344EF31D23A8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
