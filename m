From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: dedicated list for rdma userspace programming
Date: Mon, 24 Apr 2017 14:58:57 +0300
Message-ID: <CACaajQs=04be-QDFgqjXj4u=qp4wC6KFU8y5g=kR7vkV0QkbdQ@mail.gmail.com>
References: <CACaajQu1jvvCYJk82_oGOGH7jbjXzbkw_YoggqvW7TZhXj4VBw@mail.gmail.com>
 <20170424104259.GH14088@mtr-leonro.local> <CACaajQu9y2HawOjeuwjYSHeFmYfhWreQORB5_61nPiEspoQ2JA@mail.gmail.com>
 <20170424114733.GI14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424114733.GI14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

2017-04-24 14:47 GMT+03:00 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> On Mon, Apr 24, 2017 at 02:07:14PM +0300, Vasiliy Tolstov wrote:
>> 2017-04-24 13:42 GMT+03:00 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>> > There are number of char devices exported by infiniband subsystem
>> > (/dev/infiniband/*) and the communication is performed with read/write
>> > interfaces to uverbs file [1].
>> >
>> > Right now, we are in process of migration from these interfaces to ioctl
>> > based, see Matan's latest RFC [2].
>>
>>
>> Where i can find tree with commits from [2] ?
>
> https://github.com/matanb10/linux tag: abi-devel-latest

Thanks!

>
>> And how much work needs to be done to get this work upstream? (1
>> month, 6 months, years...) ?
>
> At least one kernel cycle, and after transition read/write will be
> obsolete and will be dropped.
>

So 4.12-4.13 ?

>> If i want to try working with uverbs without C librarary, where i can
>> find some info about format of messages reader and writed to uverbs
>> device?
>
> Did you see Documentation/infiniband/user_verbs.txt?


https://www.kernel.org/doc/Documentation/infiniband/user_verbs.txt as
i see this nothing says about format of data writed/readed...

-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
