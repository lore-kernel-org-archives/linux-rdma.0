From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [RFC 1/8] IB/srp: allow task management without a previous request
Date: Mon, 27 Dec 2010 16:01:58 +0100
Message-ID: <AANLkTi=sUbRP=Cg74DhXMRuhMRPMcW=JG-GsbuSd-gJ0@mail.gmail.com>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov> <1293139893-11678-2-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-2-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrot=
e:
>
> We can only have one task management comment outstanding, so move the
> completion and status to the target port. This allows us to handle
> resets of a LUN without a corresponding request having been sent.
> Meanwhile, we don't need to play games with host_scribble, just use i=
t
> as the pointer it is.
>
> This fixes a crash when we issue a bus reset using sg_reset.
>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=3D13893
> Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

You can add here "Reported-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>"
if you want.

> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband=
/ulp/srp/ib_srp.h
> index ed0dce9..c923731 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -68,7 +68,8 @@ enum {
> =A0 =A0 =A0 =A0SRP_TSK_MGMT_SQ_SIZE =A0 =A0=3D 1,
> =A0 =A0 =A0 =A0SRP_CMD_SQ_SIZE =A0 =A0 =A0 =A0 =3D SRP_REQ_SQ_SIZE - =
SRP_TSK_MGMT_SQ_SIZE,
>
> - =A0 =A0 =A0 SRP_TAG_TSK_MGMT =A0 =A0 =A0 =A0=3D 1 << (SRP_RQ_SHIFT =
+ 1),
> + =A0 =A0 =A0 SRP_TAG_NO_REQ =A0 =A0 =A0 =A0 =A0=3D ~0UL,
> + =A0 =A0 =A0 SRP_TAG_TSK_MGMT =A0 =A0 =A0 =A0=3D 1UL << 31,

According to ANSI C, enumeration types have the same size as an int,
so the above two declarations will assign a long to an int. The types
long and int do not need to have the same size, so I suggest to leave
out the capital L in the above.

And checkpatch says this:

WARNING: please, no space before tabs
#114: FILE: drivers/infiniband/ulp/srp/ib_srp.c:1462:
+^Itsk_mgmt->lun ^I^I=3D cpu_to_be64((u64) lun << 48);$

WARNING: please, no space before tabs
#115: FILE: drivers/infiniband/ulp/srp/ib_srp.c:1463:
+^Itsk_mgmt->tag ^I^I=3D req_tag | SRP_TAG_TSK_MGMT;$

WARNING: please, no space before tabs
#118: FILE: drivers/infiniband/ulp/srp/ib_srp.c:1465:
+^Itsk_mgmt->task_tag ^I=3D req_tag;$

total: 0 errors, 3 warnings, 211 lines checked

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
