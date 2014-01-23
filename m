From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 1/2] IB/core: Fix build warnings
Date: Thu, 23 Jan 2014 16:15:38 +0100
Message-ID: <1390490138.11718.23.camel@localhost.localdomain>
References: <1383466844-8805-1-git-send-email-ogerlitz@mellanox.com>
		 <1383466844-8805-2-git-send-email-ogerlitz@mellanox.com>
	 <1390470420.9865.1.camel@localhost.localdomain>
	 <52E10B12.2080504@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52E10B12.2080504-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Or,

Le jeudi 23 janvier 2014 =C3=A0 14:29 +0200, Or Gerlitz a =C3=A9crit :
> On 23/01/2014 11:47, Yann Droneaud wrote:
> > Le dimanche 03 novembre 2013 =C3=A0 10:20 +0200, Or Gerlitz a =C3=A9=
crit :
> >> >Fix the below few "make W=3D1" build warnings we have on the IB c=
ore.
> >> >
> >> >drivers/infiniband/core/sysfs.c: In function =E2=80=98state_show=E2=
=80=99:
> >> >drivers/infiniband/core/sysfs.c:107: warning: comparison of unsig=
ned expression >=3D 0 is always true
> >> >drivers/infiniband/core/verbs.c: In function =E2=80=98ib_modify_q=
p_is_ok=E2=80=99:
> >> >drivers/infiniband/core/verbs.c:783: warning: comparison of unsig=
ned expression < 0 is always false
> >> >drivers/infiniband/core/verbs.c:784: warning: comparison of unsig=
ned expression < 0 is always false
> >> >drivers/infiniband/core/iwcm.c: In function =E2=80=98destroy_cm_i=
d=E2=80=99:
> >> >drivers/infiniband/core/iwcm.c:330: warning: variable =E2=80=98re=
t=E2=80=99 set but not used
> >> >
> >> >Signed-off-by: Or Gerlitz<ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Yann Droneaud<ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> >
> > PS: Perhaps you could split the patch in two parts: one to remove t=
he
> > unused variable, and another to remove the check on unsigned variab=
les ?

> Roland decided not to take the  unsigned expression < 0 patches, writ=
ing=20
> to me
>=20
> "I applied the unused variable fix, but the others seem not needed,
> because the latest kernel seems to include -Wno-sign-compare."
>=20
> what's your thinking?
>=20

I think Roland should write to the list instead of answering privately,
but you're probably not asking my opinion about this matter.

Regarding the warnings, I've double check GCC behavor. AFAICT it's not
related to -Wno-sign-compare enabled or not, but some subtle issue.

The actual option to trigger the warning is -Wtype-limits, and it's
implied with -Wextra. And -Wextra is enabled with make W=3D1.

A simple test case such as the one below will trigger the warning:

  int f(unsigned int ui)
  {
      if (ui < 0)
         return -1;

      return 0;
  }

Tested with GCC 4.8.2 under Fedora 20, compiled for x86_64,
cross-compiled for ARM and Power (ppc64), it produces the warning:

$ gcc -Wtype-limits -c warning-simple.c=20
warning-simple.c: In function 'f':
warning-simple.c:3:3: warning: comparison of unsigned expression < 0 is
always false [-Wtype-limits]
   if (ui < 0)
   ^

The same will happen with a more elaborate condition:

$ diff -u1 warning-simple.c warning-elaborate.c
--- warning-simple.c
+++ warning-elaborate.c
@@ -2,3 +2,3 @@
 {
-  if (ui < 0)
+  if (ui < 0 || ui > 1000)
     return -1;

$ gcc -Wtype-limits  -c warning-elaborate.c=20
warning-elaborate.c: In function 'f':
warning-elaborate.c:3:3: warning: comparison of unsigned expression < 0
is always false [-Wtype-limits]
   if (ui < 0 || ui > 1000)
   ^

But as noted by Roland, the error is not shown when compiling the kerne=
l
InfiniBand modules. Which might sound surprising since the code your
patch was about looks really like my simplified test case.
=20
One must note that your patch is about fixing comparaison of enum type
against 0.

So, let's try with the following test case which replaces unsigned int
with an enum:

  enum e {
    E0,
    E1,
  };

  int f(enum e ee)
  {
    if (ee < 0)
      return -1;

    if (ee > 1000)
      return -1;

    return 0;
  }

Then no warning is reported while compiling this testcase with GCC 4.8
under Fedora 20, compiled for x86_64, cross-compiled for ARM and Power
(ppc64).

Indeed, an enum is mostly like an int.

That explains why Roland and I weren't able to notice the warning when
compiling with W=3D1.

To trigger the warning, because it can triggered, one should built for
an ABI that mandate either unsigned enums or short enums.

=46or those who want to try this other side of the ABI world, short enu=
ms
can be enabled for free with -fshort-enums (use with care).

In this case multiple warnings are reported:

$ gcc -fshort-enums -Wtype-limits -c warning-enum.c=20
warning-enum.c: In function 'f':
warning-enum.c:8:3: warning: comparison is always false due to limited
range of data type [-Wtype-limits]
   if (ee < 0) {
   ^
warning-enum.c:11:3: warning: comparison is always false due to limited
range of data type [-Wtype-limits]
   if (ee > 1000) {
   ^

(For C++, have a look at -fstrict-enums).

To conclude, I think you will have to give some details on your build
environment so that we could reproduce the warning.

In the mean time, Roland was right to apply on the subset of your patch
that remove the unused variable.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
