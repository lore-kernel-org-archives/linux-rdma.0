From: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SDP zcopy performance measurement
Date: Mon, 2 May 2011 13:58:25 +0530
Message-ID: <BANLkTin2US-zVP61rNmFWgFzZMA=FFZNrQ@mail.gmail.com>
References: <BANLkTimet4Q0qYgsmf=jqOkTr72D3MOeCw@mail.gmail.com>
	<BANLkTimtUd7g026vd=V2n4EXiaw-25H1Ow@mail.gmail.com>
	<BANLkTim4ynR08yDvZbEwHEp9=8hesihf3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTim4ynR08yDvZbEwHEp9=8hesihf3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Output when running LD_PRELOAD=/usr/lib64/libsdp.so netperf -L
172.31.134.10 -H 172.31.134.1 -c -C -- -m 1048576 :

netperf: data send error: Connection reset by peer
len was -1

while LD_PRELOAD=/usr/lib64/libsdp.so netperf -L 172.31.134.10 -H
172.31.134.1 -c -C -- -m 65436 works fine.

System Configuration:

RHEL 5.5
OFED 1.5.2
netperf 2.4.5


Please help.

On Mon, Apr 25, 2011 at 5:14 PM, bhavinkumar thumar
<bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I have tried with following cmd: LD_PRELOAD=libsdp.so netperf -L
> 172.31.133.1 -H 172.31.132.1 -c -C -- -m 65536.
> it works but when I increase the message size (-m 655360), it doesn't work!
>
> so I don't think that the problem is due to the absence of full path
> for libsdp.so
>
> -Bhavin
>
> On Mon, Apr 25, 2011 at 5:05 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>> On Mon, Apr 25, 2011 at 1:24 PM, bhavinkumar thumar
>> <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>> I am having issue with SDP performance measurement. I tried Netperf
>>> with following command:
>>>
>>> LD_PRELOAD=libsdp.so netperf -L 172.31.133.1 -H 172.31.132.1 -c -C -- -m 655360
>>>
>>> this doesn't work. sdp_zcopy_thresh is set to 65536.
>>
>> Have you already tried to specify the full path for libsdp.so in
>> LD_PRELOAD=... ?
>>
>> Bart.
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
