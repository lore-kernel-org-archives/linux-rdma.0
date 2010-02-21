From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: num reserved eqs presented as log and
Date: Sun, 21 Feb 2010 13:26:50 +0200
Message-ID: <4B81187A.6010904@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sunday -10,January,-28163 09:59 PM, Roland Dreier [rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org] wrote:
> Follow Up Flag: Warning: May contain useful information
> Due By: Sunday, February 21, 2010 3:00 PM
> Flag Status: Red
> 
>  > Multifunctional firmware should present number of reserved EQs as  > an actual number (number of reserved eqs is not necessarily a power  > of 2).
>  > Older drivers treat this field as log, so when there are relatively big  > number of reserved eqs, they would fail.
>  > The firmware would present the number of EQs as log in a single function mode  > (which would also work for older driver versions) and as actual number (in other field)  > in multifunctional mode. The new code would check both fields.
>  > Fixes commit be504b0b9fbe9ba447c93ef0f5789f377102d555
> 
> I can't really follow this changelog.  The (very old) ConnextX PRM I have states that the field returned by the firmware is the actual number, so the old driver behavior was wrong.  Or was the PRM wrong?
> 
> Are you changing the firmware behavior to make that field into a log?
> 
> Is this really the best way to clean this up, having the same information twice in two different formats?

The old driver behavior was wrong. The bug was hidden because the firmware was showing small number of reserved EQs,
so even when it was treated as log, there was not an issue.
New firmware versions use bigger number of reserved EQs, and using the same field would break older drivers, that treat this
field as log, So the firmware needs to write the log to this field.
Another issue is that in multifunctional case (SRIOV) the number of reserved EQs is not power of 2, so using the log field is not possible.
In this case the firmware would use the new field, which is visible by new drivers.
The firmware algorithm would be:

if multifunctional :
	new_field = num_multifunctional_eqs
else:
	old_field = log2(num_singlefunctional_eqs)

--Yevgeny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
