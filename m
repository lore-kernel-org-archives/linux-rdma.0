From: Hannes Weisbach <hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>
Subject: [PATCH] Add const qualifier in rdma_reg*, rdma_post_send*|write and ibv_reg_mr (was: Re: non-const pointer void * addr in rdma_reg_* and rdma_post_[send|write])
Date: Thu, 28 Nov 2013 20:47:48 +0100
Message-ID: <92ED2320-AE25-4A1B-8FDF-D31121D2B125@gmx.net>
References: <9A0BFE48-9AED-4C41-80C8-F943D1C64E99@gmx.net> <1385630590.21498.14.camel@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_63B14EE2-3932-4AA8-AC39-E45857C54F5A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385630590.21498.14.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_63B14EE2-3932-4AA8-AC39-E45857C54F5A
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Hi.
> Two days ago I started to work on a kernel patchset to address similar
> concerns on the verbs/RDMA APIs
Nice.
> 
> BTW, it's easier to change the kernel "internal" API than the public
> userspace API of the library. But adding "const" should not break
> compilation of existing userspace program.
That was my thought too.  However, because those functions are defined
in as inline in a header, they actually do break user code.  For
example, rdma_reg_msgs passes a const void * to ibv_reg_mr, which
takes a void *, thus resulting in a warning.  If you (like me) compile
with the -Werror flag, this results in broken code.  The only
offending libibverbs function I found so far is ibv_reg_mr().
> 
> PS: this issue could also be raised against libibverbs, so once you've
> fixed librdmacm, why not fix libibverbs after ?
This was my plan.  But first I wanted to see if there even is interest
in fixing this.  As a user I deal with librdmacm directly, so I
started to fix it first.

Anyway, since patching librdmacm alone would break user code, I also
included a patch for libibverbs, which adds the const qualifier to
'addr' parameter ib ibv_reg_mr().

lists.openfabrics.org says, this is also the mailing list for
libibverbs (README is outdated ;)), I hope this is ok.

Best regards,
Hannes


--Apple-Mail=_63B14EE2-3932-4AA8-AC39-E45857C54F5A
Content-Disposition: attachment;
	filename=0001-Make-addr-parameter-of-rdma_reg_-and-rdma_post_send-.patch
Content-Type: application/octet-stream;
	name="0001-Make-addr-parameter-of-rdma_reg_-and-rdma_post_send-.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=2074b73fe292c73fd9e7906e883588809c0908a404=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Hannes=20Weisbach=20=
<hannes.weisbach-cl+VPiYnx/09lWAAmjDAixS11BummzK+@public.gmane.org>=0ADate:=20Thu,=2028=20Nov=202013=20=
20:35:07=20+0100=0ASubject:=20[PATCH]=20Make=20'addr'=20parameter=20of=20=
rdma_reg_*=20and=20rdma_post_send/write=0A=20const=0A=0AThe=20following=20=
functions=20should=20only=20read=20from=20their=20'addr'=20parameter=20=
and=20this=0Ashould=20be=20made=20explicit=20in=20the=20API=20by=20=
adding=20a=20const=20qualifier=20to=20the=0Aparameter:=0A=
rdma_reg_[read|write|msgs]=0Ardma_post_[send|write|ud_send]=0A=0A=
Signed-off-by:=20Hannes=20Weisbach=20<hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>=0A---=0A=20=
include/rdma/rdma_verbs.h=20|=2012=20++++++------=0A=201=20file=20=
changed,=206=20insertions(+),=206=20deletions(-)=0A=0Adiff=20--git=20=
a/include/rdma/rdma_verbs.h=20b/include/rdma/rdma_verbs.h=0Aindex=20=
198c6a5..57e8f1e=20100644=0A---=20a/include/rdma/rdma_verbs.h=0A+++=20=
b/include/rdma/rdma_verbs.h=0A@@=20-64,20=20+64,20=20@@=20void=20=
rdma_destroy_srq(struct=20rdma_cm_id=20*id);=0A=20=20*=20Memory=20=
registration=20helpers.=0A=20=20*/=0A=20static=20inline=20struct=20=
ibv_mr=20*=0A-rdma_reg_msgs(struct=20rdma_cm_id=20*id,=20void=20*addr,=20=
size_t=20length)=0A+rdma_reg_msgs(struct=20rdma_cm_id=20*id,=20const=20=
void=20*addr,=20size_t=20length)=0A=20{=0A=20=09return=20=
ibv_reg_mr(id->pd,=20addr,=20length,=20IBV_ACCESS_LOCAL_WRITE);=0A=20}=0A=
=20=0A=20static=20inline=20struct=20ibv_mr=20*=0A-rdma_reg_read(struct=20=
rdma_cm_id=20*id,=20void=20*addr,=20size_t=20length)=0A=
+rdma_reg_read(struct=20rdma_cm_id=20*id,=20const=20void=20*addr,=20=
size_t=20length)=0A=20{=0A=20=09return=20ibv_reg_mr(id->pd,=20addr,=20=
length,=20IBV_ACCESS_LOCAL_WRITE=20|=0A=20=09=09=09=09=09=09=
IBV_ACCESS_REMOTE_READ);=0A=20}=0A=20=0A=20static=20inline=20struct=20=
ibv_mr=20*=0A-rdma_reg_write(struct=20rdma_cm_id=20*id,=20void=20*addr,=20=
size_t=20length)=0A+rdma_reg_write(struct=20rdma_cm_id=20*id,=20const=20=
void=20*addr,=20size_t=20length)=0A=20{=0A=20=09return=20=
ibv_reg_mr(id->pd,=20addr,=20length,=20IBV_ACCESS_LOCAL_WRITE=20|=0A=20=09=
=09=09=09=09=09IBV_ACCESS_REMOTE_WRITE);=0A@@=20-182,7=20+182,7=20@@=20=
rdma_post_recv(struct=20rdma_cm_id=20*id,=20void=20*context,=20void=20=
*addr,=0A=20}=0A=20=0A=20static=20inline=20int=0A-rdma_post_send(struct=20=
rdma_cm_id=20*id,=20void=20*context,=20void=20*addr,=0A=
+rdma_post_send(struct=20rdma_cm_id=20*id,=20void=20*context,=20const=20=
void=20*addr,=0A=20=09=20=20=20=20=20=20=20size_t=20length,=20struct=20=
ibv_mr=20*mr,=20int=20flags)=0A=20{=0A=20=09struct=20ibv_sge=20sge;=0A@@=20=
-209,7=20+209,7=20@@=20rdma_post_read(struct=20rdma_cm_id=20*id,=20void=20=
*context,=20void=20*addr,=0A=20}=0A=20=0A=20static=20inline=20int=0A=
-rdma_post_write(struct=20rdma_cm_id=20*id,=20void=20*context,=20void=20=
*addr,=0A+rdma_post_write(struct=20rdma_cm_id=20*id,=20void=20*context,=20=
const=20void=20*addr,=0A=20=09=09size_t=20length,=20struct=20ibv_mr=20=
*mr,=20int=20flags,=0A=20=09=09uint64_t=20remote_addr,=20uint32_t=20=
rkey)=0A=20{=0A@@=20-223,7=20+223,7=20@@=20rdma_post_write(struct=20=
rdma_cm_id=20*id,=20void=20*context,=20void=20*addr,=0A=20}=0A=20=0A=20=
static=20inline=20int=0A-rdma_post_ud_send(struct=20rdma_cm_id=20*id,=20=
void=20*context,=20void=20*addr,=0A+rdma_post_ud_send(struct=20=
rdma_cm_id=20*id,=20void=20*context,=20const=20void=20*addr,=0A=20=09=09=20=
=20size_t=20length,=20struct=20ibv_mr=20*mr,=20int=20flags,=0A=20=09=09=20=
=20struct=20ibv_ah=20*ah,=20uint32_t=20remote_qpn)=0A=20{=0A--=20=0A=
1.8.3.2=0A=0A=

--Apple-Mail=_63B14EE2-3932-4AA8-AC39-E45857C54F5A
Content-Disposition: attachment;
	filename=0001-Make-ibv_mr_reg-parameter-void-addr-const.patch
Content-Type: application/octet-stream;
	name="0001-Make-ibv_mr_reg-parameter-void-addr-const.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20624b7c6c3236d299a14352525724194ebaf82214=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Hannes=20Weisbach=20=
<hannes.weisbach-cl+VPiYnx/09lWAAmjDAixS11BummzK+@public.gmane.org>=0ADate:=20Thu,=2028=20Nov=202013=20=
20:19:59=20+0100=0ASubject:=20[PATCH]=20Make=20ibv_mr_reg=20parameter=20=
'void=20*=20addr'=20const=0A=0Aibv_reg_mr=20does=20not=20modify=20the=20=
memory=20pointed=20to=20by=20addr.=20By=20declaring=20addr=0Aconst,=20=
this=20fact=20is=20made=20explicit=20in=20the=20API.=20The=20main=20=
reason=20for=20this=20change=0Ais=20the=20similar=20API-adaption=20in=20=
librdmacm.=20Also,=20passing=20non-const=20pointers=0Astill=20works,=20=
thus=20this=20change=20does=20not=20break=20user=20code.=0A=0A=
Signed-off-by:=20Hannes=20Weisbach=20<hannes_weisbach-hi6Y0CQ0nG0@public.gmane.org>=0A---=0A=20=
include/infiniband/verbs.h=20|=202=20+-=0A=201=20file=20changed,=201=20=
insertion(+),=201=20deletion(-)=0A=0Adiff=20--git=20=
a/include/infiniband/verbs.h=20b/include/infiniband/verbs.h=0Aindex=20=
4b1ab57..eeaa3cc=20100644=0A---=20a/include/infiniband/verbs.h=0A+++=20=
b/include/infiniband/verbs.h=0A@@=20-837,7=20+837,7=20@@=20int=20=
ibv_dealloc_pd(struct=20ibv_pd=20*pd);=0A=20/**=0A=20=20*=20ibv_reg_mr=20=
-=20Register=20a=20memory=20region=0A=20=20*/=0A-struct=20ibv_mr=20=
*ibv_reg_mr(struct=20ibv_pd=20*pd,=20void=20*addr,=0A+struct=20ibv_mr=20=
*ibv_reg_mr(struct=20ibv_pd=20*pd,=20const=20void=20*addr,=0A=20=09=09=09=
=20=20size_t=20length,=20int=20access);=0A=20=0A=20/**=0A--=20=0A1.8.3.2=0A=
=0A=

--Apple-Mail=_63B14EE2-3932-4AA8-AC39-E45857C54F5A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
