From: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ib/cm: Cancel pending lap message when destroying an ID
Date: Thu, 3 Mar 2011 13:58:36 +0200
Message-ID: <AANLkTi=HNbN7jcYPg+j4GUC+_owX=Eq3Ay0KRMkhwkHN@mail.gmail.com>
References: <AANLkTikD-2VkuLDZBQiBcrY2xovt53DS02Oqx=u8qdJG@mail.gmail.com>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25CC86C58E@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC86C58E-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Good catch, although, I think we can simplify the fix to the patch be=
low
> (completely untested). =A0Please let me know if this solves the issue=
 for you.
>
> =A0drivers/infiniband/core/cm.c | =A0 =A02 ++
> =A01 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/c=
m.c
> index 1d9616b..79da42d 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -888,6 +888,8 @@ retest:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, 0, =
NULL, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case IB_CM_ESTABLISHED:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cm_id->lap_state =3D=3D IB_CM_LAP_S=
ENT)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ib_cancel_mad(cm_id_pri=
v->av.port->mad_agent, cm_id_priv->msg);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irq(&cm_id_priv->lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ib_send_cm_dreq(cm_id, NULL, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto retest;
>
>

Hi Sean
I tried this and it doesn't fix the issue in my test. It operates only
in IB_CM_ESTABLISHED but in my tests the order of operations in client
side is
1. rdma_connect() was called
2. lap was sent (for which apr will never be received - according to te=
st case)
3. rdma_disconnect() was called
4. rdma_destroy_id() was called (state here is IB_CM_DREQ_SENT)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
