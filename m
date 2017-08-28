From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH v1 11/11] IB/rxe: Handle NETDEV_CHANGE events
Date: Mon, 28 Aug 2017 12:38:11 +0000
Message-ID: <D5C986D7.1DF85%Andrew.Boyer@emc.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-12-git-send-email-andrew.boyer@dell.com>
 <20170827103008.GA10391@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170827103008.GA10391@yuvallap>
Content-Language: en-US
Content-ID: <D31A10BAAFB6B944A5378BB98075C676-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 8/27/17, 6:30 AM, "Yuval Shaia" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

>On Fri, Aug 25, 2017 at 03:05:56PM -0400, Andrew Boyer wrote:
>> Without this fix, ports configured on top of ixgbe miss link up
>> notifications. ibv_query_port() will continue to return IBV_PORT_DOWN
>>even
>> though the port is up and working.
>>=20
>> Fixes: 8700e3e7c485 ("Soft RoCE driver")
>> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/rxe/rxe_net.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c
>>b/drivers/infiniband/sw/rxe/rxe_net.c
>> index 3ba76e7..133c6c4 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_net.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
>> @@ -651,8 +651,13 @@ static int rxe_notify(struct notifier_block
>>*not_blk,
>>  		pr_info("%s changed mtu to %d\n", ndev->name, ndev->mtu);
>>  		rxe_set_mtu(rxe, ndev->mtu);
>>  		break;
>> -	case NETDEV_REBOOT:
>>  	case NETDEV_CHANGE:
>> +		if (netif_running(ndev) && netif_carrier_ok(ndev))
>> +			rxe_port_up(rxe, port_num);
>
>On top of which branch/patch this patch is based on?

Yikes, it relies on an internal patch that Doug wasn=B9t interested in
taking. Will respin.

>
>> +		else
>> +			rxe_port_down(rxe, port_num);
>> +		break;
>> +	case NETDEV_REBOOT:
>>  	case NETDEV_GOING_DOWN:
>>  	case NETDEV_CHANGEADDR:
>>  	case NETDEV_CHANGENAME:
>> --=20
>> 1.8.3.1
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
