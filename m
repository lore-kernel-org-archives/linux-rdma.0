From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2 0/6] RFC: gup+dma: tracking dma-pinned pages
Date: Thu, 29 Nov 2018 19:00:23 -0800
Message-ID: <04c18816-e15d-bffd-e8be-eceefae77197@nvidia.com>
References: <20181110085041.10071-1-jhubbard@nvidia.com>
 <942cb823-9b18-69e7-84aa-557a68f9d7e9@talpey.com>
 <97934904-2754-77e0-5fcb-83f2311362ee@nvidia.com>
 <5159e02f-17f8-df8b-600c-1b09356e46a9@talpey.com>
 <c1ba07d6-ebfa-ddb9-c25e-e5c1bfbecf74@nvidia.com>
 <15e4a0c0-cadd-e549-962f-8d9aa9fc033a@talpey.com>
 <313bf82d-cdeb-8c75-3772-7a124ecdfbd5@nvidia.com>
 <2aa422df-d5df-5ddb-a2e4-c5e5283653b5@talpey.com>
 <7a68b7fc-ff9d-381e-2444-909c9c2f6679@nvidia.com>
 <1939f47a-eaec-3f2c-4ae7-f92d9fba7693@talpey.com>
 <0f093af1-dee9-51b6-0795-2c073a951fed@nvidia.com>
 <c64387d6-c51d-185a-d2a4-1fedcdac0abe@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c64387d6-c51d-185a-d2a4-1fedcdac0abe@talpey.com>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Talpey <tom@talpey.com>, john.hubbard@gmail.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 11/29/18 6:30 PM, Tom Talpey wrote:
> On 11/29/2018 9:21 PM, John Hubbard wrote:
>> On 11/29/18 6:18 PM, Tom Talpey wrote:
>>> On 11/29/2018 8:39 PM, John Hubbard wrote:
>>>> On 11/28/18 5:59 AM, Tom Talpey wrote:
>>>>> On 11/27/2018 9:52 PM, John Hubbard wrote:
>>>>>> On 11/27/18 5:21 PM, Tom Talpey wrote:
>>>>>>> On 11/21/2018 5:06 PM, John Hubbard wrote:
>>>>>>>> On 11/21/18 8:49 AM, Tom Talpey wrote:
>>>>>>>>> On 11/21/2018 1:09 AM, John Hubbard wrote:
>>>>>>>>>> On 11/19/18 10:57 AM, Tom Talpey wrote:
>>>>>> [...]
>>> Excerpting from below:
>>>
>>>> Baseline 4.20.0-rc3 (commit f2ce1065e767), as before:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 read: IOPS=3D193k, BW=3D753MiB/s (790MB=
/s)(1024MiB/1360msec)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 : usr=3D16.26%, sys=3D48.05%, ctx=3D251258, majf=3D0, minf=3D7=
3
>>>
>>> vs
>>>
>>>> With patches applied:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 read: IOPS=3D193k, BW=3D753MiB/s (790MB=
/s)(1024MiB/1360msec)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 : usr=3D16.26%, sys=3D48.05%, ctx=3D251258, majf=3D0, minf=3D7=
3
>>>
>>> Perfect results, not CPU limited, and full IOPS.
>>>
>>> Curiously identical, so I trust you've checked that you measured
>>> both targets, but if so, I say it's good.
>>>
>>
>> Argh, copy-paste error in the email. The real "before" is ever so slight=
ly
>> better, at 194K IOPS and 759 MB/s:
>=20
> Definitely better - note the system CPU is lower, which is probably the
> reason for the increased IOPS.
>=20
>>=C2=A0=C2=A0=C2=A0 cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 : usr=3D18.24%, sys=3D44.77%, ctx=3D251527, majf=3D0, minf=3D73
>=20
> Good result - a correct implementation, and faster.
>=20

Thanks, Tom, I really appreciate your experience and help on what performan=
ce=20
should look like here. (I'm sure you can guess that this is the first time=
=20
I've worked with fio, heh.)

I'll send out a new, non-RFC patchset soon, then.

thanks,
--=20
John Hubbard
NVIDIA
