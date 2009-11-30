From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] opensm: compress IPV6 SNM groups to use a single MLID
Date: Mon, 30 Nov 2009 14:48:59 -0500
Message-ID: <f0e08f230911301148t8d573c7lf1f67972b5438b72@mail.gmail.com>
References: <20091113061948.GJ7192@me> <20091113062104.GK7192@me>
	 <20091113201144.GS7192@me> <20091113203856.GT7192@me>
	 <20091113204041.GU7192@me>
	 <f0e08f230911160735i69ad3671m9a2667900b933e13@mail.gmail.com>
	 <20091126163634.GJ13817@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091126163634.GJ13817@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 26, 2009 at 11:36 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> On 10:35 Mon 16 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >
>> > Unlike previous solution where all IPv6 Solicited node multicast (=
SNM)
>> > requests were collapsed into a single multicast group in OpenSM, n=
ow
>> > each IPv6 SNM group is represented as a separate multicast group a=
nd
>> > all groups sharing same P_Key and scope values use a same MLID val=
ue.
>>
>> Shouldn't this also ensure groups sharing MLIDs have the same MTU,
>> rate, and packet lifetime ?
>
> For IPv6 SNM it was never implemented, so my rework meets an original
> plan.

Yes, it is same as original implementation in that regard but there
was little alternative with the approach taken. Now there is but from
your comments below it seems you are unclear this is needed.

> And in general it is an interesting question. Do we really need to ca=
re
> about those parameters while doing MGID to MLID compression? SA will
> reply properly MGID "based" queries, an "extra" packets will be dropp=
ed
> anyway, likely sooner is better, no?

Not sure what you mean by "extra packets dropped anyway, likely sooner
is better".

The multicast tree (MLID) has one rate, MTU, etc. so these parameters
should be enforced on multicast groups (MGIDs) overlaid on the same
MLID.

>> > This solution should be fully IBA complaint.
>>
>> Why the should qualification ?
>
> Only due to insufficient testing, etc..
>
>> Shouldn't the IBA compliant issues fixed be documented here ?
>
> Yes, but I cannot find where. The only needed change I found is in th=
e
> usage message and man page, but there is nothing about IBA compliance=
=2E

I was saying to add it to the patch description so it would be
documented properly. How can it be added now ?

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
