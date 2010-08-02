From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: use multiple CPU cores more effectively
Date: Mon, 2 Aug 2010 17:57:28 +0200
Message-ID: <AANLkTinBTv5SZJ_H9C15CWZ5hYGFe38840zy78+N-wbO@mail.gmail.com>
References: <201008021015.40472.bvanassche@acm.org>
	<4C56C336.4040009@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C56C336.4040009-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 2, 2010 at 3:08 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wr=
ote:
>
> Bart Van Assche, on 08/02/2010 12:15 PM wrote:
>>
>> SRP I/O with small block sizes causes a high CPU load. Processing IB
>> completions on the context of a kernel thread instead of in interrup=
t context
>> allows to process up to 25% more I/O operations per second. This pat=
ch does
>> add a kernel parameter 'thread' that allows to specify whether to pr=
ocess IB
>> completions in interrupt context or in kernel thread context. Also, =
the IB
>> receive notification processing loop is rewritten as proposed earlie=
r by Ralph
>> Campbell (see also https://patchwork.kernel.org/patch/89426/). As th=
e
>> measurement results below show, rewriting the IB receive notificatio=
n
>> processing loop did not have a measurable impact on performance. Pro=
cessing
>> IB receive notifications in thread context however does have a measu=
rable
>> impact: workloads with I/O depth one are processed at most 10% slowe=
r and
>> workloads with larger I/O depths are processed up to 25% faster.
>>
>> block size =A0number of =A0 =A0IOPS =A0 =A0 =A0 =A0IOPS =A0 =A0 =A0I=
OPS
>> =A0in bytes =A0 =A0threads =A0 =A0 without =A0 =A0 with =A0 =A0 =A0w=
ith
>> =A0 ($bs) =A0 =A0 ($numjobs) =A0this patch =A0thread=3Dn =A0thread=3D=
y
>> =A0 =A0512 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A025,400 =A0 =A0 =A025=
,400 =A0 =A023,100
>> =A0 =A0512 =A0 =A0 =A0 =A0 128 =A0 =A0 =A0 122,000 =A0 =A0 122,000 =A0=
 153,000
>> =A0 4096 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A025,000 =A0 =A0 =A025,0=
00 =A0 =A022,700
>> =A0 4096 =A0 =A0 =A0 =A0 128 =A0 =A0 =A0 122,000 =A0 =A0 121,000 =A0=
 157,000
>> =A065536 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A014,300 =A0 =A0 =A014,4=
00 =A0 =A013,600
>> =A065536 =A0 =A0 =A0 =A0 =A0 4 =A0 =A0 =A0 =A036,700 =A0 =A0 =A036,7=
00 =A0 =A036,600
>> 524288 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 3,470 =A0 =A0 =A0 3,430=
 =A0 =A0 3,420
>> 524288 =A0 =A0 =A0 =A0 =A0 4 =A0 =A0 =A0 =A0 5,020 =A0 =A0 =A0 5,020=
 =A0 =A0 4,990
>>
>> performance test used to gather the above results:
>> =A0 fio --bs=3D${bs} --ioengine=3Dsg --buffered=3D0 --size=3D128M --=
rw=3Dread \
>> =A0 =A0 =A0 --thread --numjobs=3D${numjobs} --loops=3D100 --group_re=
porting \
>> =A0 =A0 =A0 --gtod_reduce=3D1 --name=3D${dev} --filename=3D${dev}
>> other ib_srp kernel module parameters: srp_sg_tablesize=3D128
>
> How about results of "dd Xflags=3Ddirect" in different modes to find =
out the lowest
> latency the driver can process 512 and 4K packets? Sorry, I don't tru=
st fio, when
> it comes to precise latency measurements.

It would be interesting to compare such results, but unfortunately, dd
does not provide a way to perform I/O from multiple threads
simultaneously. I have tried to run multiple dd processes in parallel,
but that resulted in much lower IOPS results than a comparable
multithreaded fio test.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
