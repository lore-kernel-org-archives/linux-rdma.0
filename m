From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: basic questions about partitions
Date: Tue, 13 Jul 2010 13:44:48 -0400
Message-ID: <AANLkTinqEhNWWqevmvzl8rdNtvqprc3lgWC5-8jYYq70@mail.gmail.com>
References: <4C3B5FEA.1020904@utah.edu>
	<AANLkTil-bN-x31UkuPh38HWy5hhctp2x3rlZKyCCzoha@mail.gmail.com>
	<AANLkTikmGjn3zXsAFyH3MUEk41Tt2Iz8oJYcb0b0ocUC@mail.gmail.com>
	<4C3B6CE8.7080800@utah.edu>
	<AANLkTilajOitn1UidBCWeI7njymfwOTx9rl6bHo5Rv4G@mail.gmail.com>
	<4C3C9970.2060100@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3C9970.2060100-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tom,

On Tue, Jul 13, 2010 at 12:50 PM, Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org> wrote:
> =C2=A0Hal,
>
>> The procedure is a little different. You'll need to create a child
>> interface (on a partition) first and then you will be able to
>> configure it as follows:
>>
>> echo 0x8001> =C2=A0/sys/class/net/ib0/create_child
>> ifconfig ib0.8001 ...
>>
>> Note that you'll want the 0x8000 bit on for full membership.
>
> What does "full membership" mean?

=46or a partition, full members can talk with both full and limited
members whereas limited members can only talk with full members.

> And are you saying that for full
> membership, any value beginning with 0x8 would work?

The 0x8000 bit is the (full) membership bit so 0x8abc is the pkey for
full membership in the 0xabc partition. 15 bits of pkey can be used
for partition although my example above only used 12 bits.

> Can an HCA have full membership on multiple partitions simultaneously=
?

Yes.

-- Hal

> Thanks,
>
> Tom
>
>
>> -- Hal
>>
>>> Tom
>>>
>>> On 7/12/2010 1:06 PM, Hal Rosenstock wrote:
>>>>
>>>> On Mon, Jul 12, 2010 at 3:03 PM, Hal Rosenstock
>>>> <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =C2=A0 =C2=A0wrote:
>>>>>
>>>>> Hi Tom,
>>>>>
>>>>> On 7/12/10, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org> =C2=A0 =C2=A0wrote:
>>>>>>
>>>>>> =C2=A0 Hi,
>>>>>>
>>>>>> I have some basic questions about IB partitions.
>>>>>>
>>>>>> Can an HCA port belong to more than 1 partition at a time?
>>>>>
>>>>> Yes.
>>>>>
>>>>>> How do you configure partitions with opensm? From reading the op=
ensmd
>>>>>> man page, it looks like you just create a file called
>>>>>> /etc/osm-partitions.conf, with port GUIDs and such, but is this
>>>>>> current?
>>>>>
>>>>> The default location depends on how OpenSM is configured/built.
>>>>
>>>> I missed this the first time around:
>>>>
>>>> and yes, the syntax indicated is current.
>>>>
>>>> -- Hal
>>>>
>>>>>> I ask because according to the man page the opensm configuration=
 file
>>>>>> is
>>>>>> in /etc/opensm/ . Can you tell opensm where to look for the part=
itions
>>>>>> file?
>>>>>
>>>>> Yes, with either the -P option on the command line or
>>>>> partition_config_file line in the options file.
>>>>>
>>>>> -- Hal
>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> Tom
>>>>>>
>>>>>> --
>>>>>> Tom Ammon
>>>>>> Network Engineer
>>>>>> Office: 801.587.0976
>>>>>> Mobile: 801.674.9273
>>>>>>
>>>>>> Center for High Performance Computing
>>>>>> University of Utah
>>>>>> http://www.chpc.utah.edu
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-=
rdma"
>>>>>> in
>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-in=
fo.html
>>>>>>
>>> --
>>> Tom Ammon
>>> Network Engineer
>>> Office: 801.587.0976
>>> Mobile: 801.674.9273
>>>
>>> Center for High Performance Computing
>>> University of Utah
>>> http://www.chpc.utah.edu
>>>
>>>
>
> --
> Tom Ammon
> Network Engineer
> Office: 801.587.0976
> Mobile: 801.674.9273
>
> Center for High Performance Computing
> University of Utah
> http://www.chpc.utah.edu
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
