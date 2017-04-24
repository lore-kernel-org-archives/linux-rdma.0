From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Mon, 24 Apr 2017 15:45:26 +0300
Message-ID: <CACaajQueUDeiqb0jyPPT-OFL=sgEn=apffC2SpLFZR2pbi04fg@mail.gmail.com>
References: <CACaajQu1jvvCYJk82_oGOGH7jbjXzbkw_YoggqvW7TZhXj4VBw@mail.gmail.com>
 <20170424104259.GH14088@mtr-leonro.local> <CACaajQu9y2HawOjeuwjYSHeFmYfhWreQORB5_61nPiEspoQ2JA@mail.gmail.com>
 <20170424114733.GI14088@mtr-leonro.local> <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ@mail.gmail.com>
 <20170424123413.GJ14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424123413.GJ14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2017-04-24 15:34 GMT+03:00 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>> >> And how much work needs to be done to get this work upstream? (1
>> >> month, 6 months, years...) ?
>> >
>> > At least one kernel cycle, and after transition read/write will be
>> > obsolete and will be dropped.
>> >
>>
>> So 4.12-4.13 ?
>
> 4.12 is almost closed. We are in rc8 now and merge window will be next
> week, so it will be 4.13-4.14 (optimistic).
>

Fine. So older interfaces will be deprecated and removed in next few
cycles. I think i can now create something that used old api and do
transition later (i'm use fedora)

>>
>> >> If i want to try working with uverbs without C librarary, where i can
>> >> find some info about format of messages reader and writed to uverbs
>> >> device?
>> >
>> > Did you see Documentation/infiniband/user_verbs.txt?
>>
>>
>> https://www.kernel.org/doc/Documentation/infiniband/user_verbs.txt as
>> i see this nothing says about format of data writed/readed...
>>
>
> See in include/uapi/rdma/ib_user_verbs.h, User fills struct from that
> file, and kernel performs copy_from_user to extract the data. That's
> all.

Thanks! If i need to establish communication between two nodes and
send/recv data (and get notification that data can be readed) does
this file  enough to do that?
(i'm plan to try create plain go binding, now only for fun, create
generator for this C struct/enums to plain go types)


-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
