From: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 07/16] IB/core: Introduce counter set query verb
Date: Fri, 20 Oct 2017 15:40:02 +0000
Message-ID: <AM6PR0502MB37838A23148C096EEC8FBA42BD430@AM6PR0502MB3783.eurprd05.prod.outlook.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <1508424118-27205-8-git-send-email-yishaih@mellanox.com>,<alpine.DEB.2.20.1710200547100.10736@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1710200547100.10736@nuc-kabylake>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Thu, 19 Oct 2017,=A0Christopher Lameter=A0wrote:
On Thu, 19 Oct 2017, Yishai Hadas wrote:

>> A counter set must be first attached to an IB object in order to
>> be queried for its underlay counters, downstream patches will
>> present bind and query methods for flow counters.
>> The user has an option as part of the query verb to force reading
>> the up-to-date hardware values instead of reading some cached
>> values by using the IB_COUNTER_SET_FORCE_UPDATE flag.

>What does "cached" mean in this context? Accurate to the last second? Or
>just return what was returned earlier? Semantics look a bit unclear to me.

When this flag is used - querying the counter does not guarantee accurate v=
alue from the hardware.
The driver might return a value that was true several nonsecs. or even seve=
ral seconds ago.


Explanation:

Querying the hardware is expensive,=A0 when user queries the hardware
the driver could decide to use the same query to query multiple counter-set
rather than a single one ( the one the user asked for)

The counter-sets the user did not ask for - are stored in the driver cache.
Driver may decide to return these value rather than query the hardware agai=
n.


Nevertheless,=A0 when using the=A0the query API=A0user can force the driver=
 to=A0
execute direct=A0hardware=A0query=A0, rather than return cached value.


Guy


    =
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
