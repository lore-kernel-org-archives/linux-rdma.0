From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: basic questions about partitions
Date: Mon, 12 Jul 2010 15:53:28 -0400
Message-ID: <AANLkTilajOitn1UidBCWeI7njymfwOTx9rl6bHo5Rv4G@mail.gmail.com>
References: <4C3B5FEA.1020904@utah.edu>
	<AANLkTil-bN-x31UkuPh38HWy5hhctp2x3rlZKyCCzoha@mail.gmail.com>
	<AANLkTikmGjn3zXsAFyH3MUEk41Tt2Iz8oJYcb0b0ocUC@mail.gmail.com>
	<4C3B6CE8.7080800@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3B6CE8.7080800-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 12, 2010 at 3:28 PM, Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org> wrote:
> =C2=A0Okay, how about this.
>
> With ethernet and a linux server, I can set up up aliases (virtual IP
> addresses) and assign multiple IPs to a single NIC. Can this be done =
with an
> HCA and IPoIB?

Yes.

> For example, could I configure ib0:1 to be 192.168.0.1/24 and
> ib0:2 to be 10.0.0.1/24?

See linux/Documentation/infiniband/ipoib.txt on how to do this.

> I have tried this on a RHEL5 box and it doesn't seem to want to accep=
t it,
> but I don't know if there is another piece somewhere that I need to
> configure.

The procedure is a little different. You'll need to create a child
interface (on a partition) first and then you will be able to
configure it as follows:

echo 0x8001 > /sys/class/net/ib0/create_child
ifconfig ib0.8001 ...

Note that you'll want the 0x8000 bit on for full membership.

-- Hal

> Tom
>
> On 7/12/2010 1:06 PM, Hal Rosenstock wrote:
>>
>> On Mon, Jul 12, 2010 at 3:03 PM, Hal Rosenstock
>> <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =C2=A0wrote:
>>>
>>> Hi Tom,
>>>
>>> On 7/12/10, Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org> =C2=A0wrote:
>>>>
>>>> =C2=A0 Hi,
>>>>
>>>> I have some basic questions about IB partitions.
>>>>
>>>> Can an HCA port belong to more than 1 partition at a time?
>>>
>>> Yes.
>>>
>>>> How do you configure partitions with opensm? From reading the open=
smd
>>>> man page, it looks like you just create a file called
>>>> /etc/osm-partitions.conf, with port GUIDs and such, but is this cu=
rrent?
>>>
>>> The default location depends on how OpenSM is configured/built.
>>
>> I missed this the first time around:
>>
>> and yes, the syntax indicated is current.
>>
>> -- Hal
>>
>>>> I ask because according to the man page the opensm configuration f=
ile is
>>>> in /etc/opensm/ . Can you tell opensm where to look for the partit=
ions
>>>> file?
>>>
>>> Yes, with either the -P option on the command line or
>>> partition_config_file line in the options file.
>>>
>>> -- Hal
>>>
>>>> Thanks,
>>>>
>>>> Tom
>>>>
>>>> --
>>>> Tom Ammon
>>>> Network Engineer
>>>> Office: 801.587.0976
>>>> Mobile: 801.674.9273
>>>>
>>>> Center for High Performance Computing
>>>> University of Utah
>>>> http://www.chpc.utah.edu
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>>
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
