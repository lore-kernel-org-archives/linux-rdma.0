From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Ensure fairness in ib_mad_completion_handler
Date: Thu, 24 Dec 2015 00:21:26 -0500
Message-ID: <567B80D6.803@redhat.com>
References: <1449784350-30214-1-git-send-email-ira.weiny@intel.com>
 <20151223200104.GR3860@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PVJgH8oemNxvj8jB2bxpHaAtlrgKa2oej"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151223200104.GR3860-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PVJgH8oemNxvj8jB2bxpHaAtlrgKa2oej
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/23/2015 03:01 PM, ira.weiny wrote:
> Doug,
>=20
> With your email troubles I just wanted to make sure you did not lose tr=
ack of
> this patch.
>=20
> https://patchwork.kernel.org/patch/7822511/

I've got it, thanks.

> Thanks,
> Ira
>=20
> On Thu, Dec 10, 2015 at 04:52:30PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>> From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> It was found that when a process was rapidly sending MADs other proces=
ses could
>> be hung in their unregister calls.
>>
>> This would happen when process A was injecting packets fast enough tha=
t the
>> single threaded workqueue was never exiting ib_mad_completion_handler.=

>> Therefore when process B called flush_workqueue via the unregister cal=
l it
>> would hang until process A stopped sending MADs.
>>
>> The fix is to periodically reschedule ib_mad_completion_handler after
>> processing a large number of completions.  The number of completions c=
hosen was
>> decided based on the defaults for the recv queue size.  However, it wa=
s kept
>> fixed such that increasing those queue sizes would not adversely affec=
t
>> fairness in the future.
>>
>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/core/mad.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/m=
ad.c
>> index 2281de122038..d4d2a618fd66 100644
>> --- a/drivers/infiniband/core/mad.c
>> +++ b/drivers/infiniband/core/mad.c
>> @@ -61,6 +61,18 @@ MODULE_PARM_DESC(send_queue_size, "Size of send que=
ue in number of work requests
>>  module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
>>  MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of=
 work requests");
>> =20
>> +/*
>> + * Define a limit on the number of completions which will be processe=
d by the
>> + * worker thread in a single work item.  This ensures that other work=
 items
>> + * (potentially from other users) are processed fairly.
>> + *
>> + * The number of completions was derived from the default queue sizes=
 above.
>> + * We use a value which is double the larger of the 2 queues (receive=
 @ 512)
>> + * but keep it fixed such that an increase in that value does not int=
roduce
>> + * unfairness.
>> + */
>> +#define MAD_COMPLETION_PROC_LIMIT 1024
>> +
>>  static struct list_head ib_mad_port_list;
>>  static u32 ib_mad_client_id =3D 0;
>> =20
>> @@ -2555,6 +2567,7 @@ static void ib_mad_completion_handler(struct wor=
k_struct *work)
>>  {
>>  	struct ib_mad_port_private *port_priv;
>>  	struct ib_wc wc;
>> +	int count =3D 0;
>> =20
>>  	port_priv =3D container_of(work, struct ib_mad_port_private, work);
>>  	ib_req_notify_cq(port_priv->cq, IB_CQ_NEXT_COMP);
>> @@ -2574,6 +2587,11 @@ static void ib_mad_completion_handler(struct wo=
rk_struct *work)
>>  			}
>>  		} else
>>  			mad_error_handler(port_priv, &wc);
>> +
>> +		if (++count > MAD_COMPLETION_PROC_LIMIT) {
>> +			queue_work(port_priv->wq, &port_priv->work);
>> +			break;
>> +		}
>>  	}
>>  }
>> =20
>> --=20
>> 1.8.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--PVJgH8oemNxvj8jB2bxpHaAtlrgKa2oej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWe4DXAAoJELgmozMOVy/dzP0P/1jZhXnq5cn0BERxALQVbNW4
B20hGiN5L8SAmyb0qEUS7ApGK49bYJxolKmj7xa1au2PLsE+LtMURTDjFOx2i87v
/5sN4/lLn3KWtDpHAssDH0ipP6kzxNHG1p+2w+0AlzErsBEog3/jn3QBK+LRV/51
sxKze3CFs/xZp5VjrGe37NwEty/JQ6KXHYfexPHhqdO0ADJPfjxgcNyTAg7rkEfj
dVADrF3Cq+AgEKm1a7Zzmx8SO4r3b/RQH4ogVSflaLqH5Wu6cikUacCtDy1UlvDi
Bkti/QOi5nMz0imeas90PecwliJ8tALyQUa3V+TtQb+wILRu2ARdcFnwTTQnbA4R
YTLE5GKHuHknRXdbxFzJ38gqY17paxiDJnmYwxoY0cLrpDRZBv3WcNmXjvzzZC4C
TB2Ctc9jwp2cKb8f767C+rO+qfXqXQNqTh6pxRo2sv8NVVTRPxsTJxlRqW0kCP53
AXJiH/cavaXfVN2rh69VAc2oTl+ef/1InVY7A03V5koKdSDKrIqPq3fUUx2pDXz0
ci4ZrKcC5Y5Z1TUT1nWY6Ip7EG7bfH6Bnl2+q7r3UD/fgoKfWZe0WZtnZu09lD4v
lUW3XPL4wl2k3M+cB2jGbpRyo8T/0Y9BiUqhcM4MnmPZXpvUbeQgLxWExx78D8oY
3FvHu7RMPvbHyayuhyua
=TfTt
-----END PGP SIGNATURE-----

--PVJgH8oemNxvj8jB2bxpHaAtlrgKa2oej--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
