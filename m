From: Ezra Kissel <ezkissel-GZvvpLG7cYSVc3sceRu5cw@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 05 Sep 2012 16:12:44 -0400
Message-ID: <5047B23C.6080604@indiana.edu>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov> <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000@email.amazonses.com> <3F476926-8618-4233-A150-C5D487B55C68@ornl.gov> <0000013997a928ab-36ad5a02-3c82-4daf-8e8a-a86c65e92376-000000@email.amazonses.com> <78D8717C-0505-408B-8625-A9124AB33C9E@ornl.gov> <0000013997d35848-57319f33-839b-4480-a075-53b36f67bfe2-000000@email.amazonses.com> <E88DEA9F-416B-4663-A292-5780DFF9B641@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E88DEA9F-416B-4663-A292-5780DFF9B641-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/5/2012 3:48 PM, Atchley, Scott wrote:
> On Sep 5, 2012, at 3:06 PM, Christoph Lameter wrote:
>
>> On Wed, 5 Sep 2012, Atchley, Scott wrote:
>>
>>>> AFAICT the network stack is useful up to 1Gbps and
>>>> after that more and more band-aid comes into play.
>>>
>>> Hmm, many 10G Ethernet NICs can reach line rate. I have not yet tes=
ted any 40G Ethernet NICs, but I hope that they will get close to line =
rate. If not, what is the point? ;-)
>>
>> Oh yes they can under restricted circumstances. Large packets, multi=
ple
>> cores etc. With the band-aids=85.
>
> With Myricom 10G NICs, for example, you just need one core and it can=
 do line rate with 1500 byte MTU. Do you count the stateless offloads a=
s band-aids? Or something else?
>
> I have not tested any 40G NICs yet, but I imagine that one core will =
not be enough.
>
Since you are using netperf, you might also considering experimenting=20
with the TCP_SENDFILE test.  Using sendfile/splice calls can have a=20
significant impact for sockets-based apps.

Using 40G NICs (Mellanox ConnectX-3 EN), I've seen our applications hit=
=20
22Gb/s single core/stream while fully CPU bound.  With sendfile/splice,=
=20
there is no issue saturating a 40G link with about 40-50% core=20
utilization.  That being said, binding to the right core/node, message=20
size and memory alignment, interrupt handling, and proper host/NIC=20
tuning all have an impact on the performance.  The state of=20
high-performance networking is certainly not plug-and-play.

- ezra
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
