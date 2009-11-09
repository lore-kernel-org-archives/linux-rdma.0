From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRPT and SCST
Date: Mon, 9 Nov 2009 13:43:53 -0700
Message-ID: <f3177b9e0911091243j135fe526t7c5a03f860d46b68@mail.gmail.com>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com>
	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4F9@orca.penguincomputing.com>
	 <e2e108260911052306l230d8d7cxbae68bf08678d6fe@mail.gmail.com>
	 <4AF40FBC.9080004@vlnb.net>
	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4FA@orca.penguincomputing.com>
	 <e2e108260911060653g6832c124uaa6e11072a12e448@mail.gmail.com>
	 <4AF45134.30207@vlnb.net>
	 <3142CEFB1403044F9954E2DF6C85660FBB34E6@orca.penguincomputing.com>
	 <e2e108260911080149t569fc016p6e38d86a15cb7d05@mail.gmail.com>
	 <4AF87B05.1050902@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF87B05.1050902-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arend Dittmer <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 9, 2009 at 1:26 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wr=
ote:
> Bart Van Assche, on 11/08/2009 12:49 PM wrote:
>>
>> On Fri, Nov 6, 2009 at 6:28 PM, Arend Dittmer
>> <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
>>>
>>> Please find attached the gzip'ed /var/log/messages.
>>
>> This log clearly show the login and logout actions from the differen=
t
>> initiators. I couldn't find anything unusual in the posted log file
>> however. Around which time did the initiator start complaining about
>> aborted SCSI commands ? Does this issue also happen when using the S=
RP
>> initiator included in a vanilla (non-OFED) Linux kernel ?
>
> It looks painfully similar to what Chris Worley experienced some time=
 ago
> and somehow fixed/workarounded.
>
> Chris, can you comment on this?

The "thread=3D1" fixed the problem mostly, but I am working with anothe=
r
group that says they still get an abort, but haven't gotten around to
providing me with the info I need to look at it.

Chris
>
>> Bart.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
