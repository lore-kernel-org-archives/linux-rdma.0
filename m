From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] opensm: compress IPV6 SNM groups to use a single MLID
Date: Tue, 1 Dec 2009 11:00:15 -0500
Message-ID: <f0e08f230912010800u76687d4eif9dfc6c0f1524056@mail.gmail.com>
References: <20091113061948.GJ7192@me> <20091113062104.GK7192@me>
	 <20091113201144.GS7192@me> <20091113203856.GT7192@me>
	 <20091113204041.GU7192@me>
	 <f0e08f230911160735i69ad3671m9a2667900b933e13@mail.gmail.com>
	 <20091126163634.GJ13817@me>
	 <f0e08f230911301148t8d573c7lf1f67972b5438b72@mail.gmail.com>
	 <20091201145847.GM16607@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091201145847.GM16607@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 1, 2009 at 9:58 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> =
wrote:
> On 14:48 Mon 30 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> The multicast tree (MLID) has one rate, MTU, etc. so these parameter=
s
>> should be enforced on multicast groups (MGIDs) overlaid on the same
>> MLID.
>
> Assuming that Multicast groups (MGIDs) are consistent in terms of rat=
e,
> MTU and packet life time parameters. Why should we share this over ML=
ID
> implementing MGID to MLID compression?
>
> Sharing P_Key helps to prevent P_Key violation traps,

Actually, that's a simplification not strictly required. One example
where that is the case is if there is no PKey enforcement in the
subnet.

> but what should be a reason for rate, MTU and packet life time?

As with any path (which in this case is the multicast tree), there is
a rate, MTU, and packet life time. As one example, if the tree does
not support the MTU, then MTU discards can occur. There are other more
subtle things that occur based on rate mismatches (overagressive
transmitters). These should be precluded rather than allowed (and then
having to debug the resulting issues).

-- Hal

>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
