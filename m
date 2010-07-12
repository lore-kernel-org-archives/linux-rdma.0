From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: basic questions about partitions
Date: Mon, 12 Jul 2010 15:06:07 -0400
Message-ID: <AANLkTikmGjn3zXsAFyH3MUEk41Tt2Iz8oJYcb0b0ocUC@mail.gmail.com>
References: <4C3B5FEA.1020904@utah.edu>
	<AANLkTil-bN-x31UkuPh38HWy5hhctp2x3rlZKyCCzoha@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTil-bN-x31UkuPh38HWy5hhctp2x3rlZKyCCzoha-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 12, 2010 at 3:03 PM, Hal Rosenstock
<hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Tom,
>
> On 7/12/10, Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org> wrote:
>> =C2=A0 Hi,
>>
>> I have some basic questions about IB partitions.
>>
>> Can an HCA port belong to more than 1 partition at a time?
>
> Yes.
>
>> How do you configure partitions with opensm? From reading the opensm=
d
>> man page, it looks like you just create a file called
>> /etc/osm-partitions.conf, with port GUIDs and such, but is this curr=
ent?
>
> The default location depends on how OpenSM is configured/built.

I missed this the first time around:

and yes, the syntax indicated is current.

-- Hal

>
>> I ask because according to the man page the opensm configuration fil=
e is
>> in /etc/opensm/ . Can you tell opensm where to look for the partitio=
ns file?
>
> Yes, with either the -P option on the command line or
> partition_config_file line in the options file.
>
> -- Hal
>
>> Thanks,
>>
>> Tom
>>
>> --
>> Tom Ammon
>> Network Engineer
>> Office: 801.587.0976
>> Mobile: 801.674.9273
>>
>> Center for High Performance Computing
>> University of Utah
>> http://www.chpc.utah.edu
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
