From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: RE: [PATCH v3 06/13] SoftiWarp connection management
Date: Wed, 31 Jan 2018 17:28:26 +0000
Message-ID: <OF06844577.AB3196A8-ON00258226.005F3420-00258226.005FFCF9@notes.na.collabserv.com>
References: <047b01d39a11$27609940$7621cbc0$@opengridcomputing.com>,<20180114223603.19961-1-bmt@zurich.ibm.com>
 <20180114223603.19961-7-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <047b01d39a11$27609940$7621cbc0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


-----"Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote: -----

>To: "'Bernard Metzler'" <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>,
><linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>Date: 01/30/2018 10:27PM
>Subject: RE: [PATCH v3 06/13] SoftiWarp connection management
>
>> 
>> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/siw/siw_cm.c | 2184
>> ++++++++++++++++++++++++++++++++++++
>>  drivers/infiniband/sw/siw/siw_cm.h |  156 +++
>>  2 files changed, 2340 insertions(+)
>>  create mode 100644 drivers/infiniband/sw/siw/siw_cm.c
>>  create mode 100644 drivers/infiniband/sw/siw/siw_cm.h
>
><snip>
>
>> diff --git a/drivers/infiniband/sw/siw/siw_cm.h


<snip>

>> +
>> +/*
>> + * Connection initiator waits 10 seconds to receive an
>> + * MPA reply after sending out MPA request. Reponder waits for
>> + * 5 seconds for MPA request to arrive if new TCP connection
>> + * was set up.
>> + */
>> +#define MPAREQ_TIMEOUT	(HZ*10)
>> +#define MPAREP_TIMEOUT	(HZ*5)
>> +
>
>These timeout times seem pretty low for a WAN link or even a brief
>network
>down event during MPA negotiation connection.   Any particular reason
>for 10
>and 5?
>
>
>
i picked those rather small numbers since it covers basically
only the latency after the TCP connection went up, so the
timer gets started only after the TCP connection was
established. at client side, we wait 5 seconds after sending the MPA
request to get the reply. on server side, we wait 10 seconds
for the MPA request, after we have accepted a new TCP connection.

maybe i shall make that longer? but the only real delay we have to
deal with is the server side application which thinks too long
if it shall 'accept' or 'reject' (maybe that is very artifical,
but i had to deal with cases of an application which never rejected/
accepted).

thanks
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
