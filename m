From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V1 1/2] IB/core: Fix build warnings
Date: Thu, 23 Jan 2014 14:29:06 +0200
Message-ID: <52E10B12.2080504@mellanox.com>
References: <1383466844-8805-1-git-send-email-ogerlitz@mellanox.com>	 <1383466844-8805-2-git-send-email-ogerlitz@mellanox.com> <1390470420.9865.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390470420.9865.1.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 23/01/2014 11:47, Yann Droneaud wrote:
> Hi,
>
> Le dimanche 03 novembre 2013 =C3=A0 10:20 +0200, Or Gerlitz a =C3=A9c=
rit :
>> >Fix the below few "make W=3D1" build warnings we have on the IB cor=
e.
>> >
>> >drivers/infiniband/core/sysfs.c: In function =E2=80=98state_show=E2=
=80=99:
>> >drivers/infiniband/core/sysfs.c:107: warning: comparison of unsigne=
d expression >=3D 0 is always true
>> >drivers/infiniband/core/verbs.c: In function =E2=80=98ib_modify_qp_=
is_ok=E2=80=99:
>> >drivers/infiniband/core/verbs.c:783: warning: comparison of unsigne=
d expression < 0 is always false
>> >drivers/infiniband/core/verbs.c:784: warning: comparison of unsigne=
d expression < 0 is always false
>> >drivers/infiniband/core/iwcm.c: In function =E2=80=98destroy_cm_id=E2=
=80=99:
>> >drivers/infiniband/core/iwcm.c:330: warning: variable =E2=80=98ret=E2=
=80=99 set but not used
>> >
>> >Signed-off-by: Or Gerlitz<ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yann Droneaud<ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
>
> PS: Perhaps you could split the patch in two parts: one to remove the
> unused variable, and another to remove the check on unsigned variable=
s ?
Roland decided not to take the  unsigned expression < 0 patches, writin=
g=20
to me

"I applied the unused variable fix, but the others seem not needed,
because the latest kernel seems to include -Wno-sign-compare."

what's your thinking?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
