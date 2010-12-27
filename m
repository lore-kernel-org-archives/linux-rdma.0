From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [RFC 2/8] IB/srp: consolidate state change code
Date: Mon, 27 Dec 2010 16:12:49 +0100
Message-ID: <AANLkTimE83r3EKcDwOat3Q_5=gzmCjB9A0vhs11r=hMU@mail.gmail.com>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov> <1293139893-11678-3-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-3-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrot=
e:
> This is a break-out and slight cleanup of Bart Van Assche's work.
> ---
> =A0drivers/infiniband/ulp/srp/ib_srp.c | =A0 45 ++++++++++++++++++---=
-------------
> =A01 files changed, 24 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index 95fb9f0..a14975b 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -441,18 +441,28 @@ static void srp_disconnect_target(struct srp_ta=
rget_port *target)
> =A0 =A0 =A0 =A0wait_for_completion(&target->done);
> =A0}
>
> +static bool srp_change_state(struct srp_target_port *target,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum srp_target=
_state old,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum srp_target=
_state new)
> +{
> + =A0 =A0 =A0 int changed =3D false;
> +
> + =A0 =A0 =A0 spin_lock_irq(target->scsi_host->host_lock);
> + =A0 =A0 =A0 if (target->state =3D=3D old) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->state =3D new;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 changed =3D true;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock_irq(target->scsi_host->host_lock);
> + =A0 =A0 =A0 return changed;
> +}

The variable 'changed' either has the value 'true' or 'false' and is
converted by the return statement into the type bool, so I'm surprised
to see that this variable has been declared as an int ?

Even if this is not addressed, you can add:

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
