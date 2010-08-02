From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: use multiple CPU cores more effectively
Date: Mon, 2 Aug 2010 20:40:58 +0200
Message-ID: <AANLkTikYEvQfbWGLMZGZ_c+ggy0hAkiS9RAsBmGVKDDA@mail.gmail.com>
References: <201008021015.40472.bvanassche@acm.org>
	<4C56C336.4040009@vlnb.net>
	<AANLkTinBTv5SZJ_H9C15CWZ5hYGFe38840zy78+N-wbO@mail.gmail.com>
	<4C570B7F.2010306@vlnb.net>
	<1280774209.2451.10.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280774209.2451.10.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 2, 2010 at 8:36 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrot=
e:
>
> On Mon, 2010-08-02 at 22:16 +0400, Vladislav Bolkhovitin wrote:
> > Bart Van Assche, on 08/02/2010 07:57 PM wrote:
> > >>>
> > >>> block size =A0number of =A0 =A0IOPS =A0 =A0 =A0 =A0IOPS =A0 =A0=
 =A0IOPS
> > >>> =A0 in bytes =A0 =A0threads =A0 =A0 without =A0 =A0 with =A0 =A0=
 =A0with
> > >>> =A0 =A0($bs) =A0 =A0 ($numjobs) =A0this patch =A0thread=3Dn =A0=
thread=3Dy
> > >>> =A0 =A0 512 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A025,400 =A0 =A0=
 =A025,400 =A0 =A023,100
> > >>> =A0 =A0 512 =A0 =A0 =A0 =A0 128 =A0 =A0 =A0 122,000 =A0 =A0 122=
,000 =A0 153,000
> > >>> =A0 =A04096 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A025,000 =A0 =A0=
 =A025,000 =A0 =A022,700
> > >>> =A0 =A04096 =A0 =A0 =A0 =A0 128 =A0 =A0 =A0 122,000 =A0 =A0 121=
,000 =A0 157,000
> > >>> =A0 65536 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A014,300 =A0 =A0 =A0=
14,400 =A0 =A013,600
> > >>> =A0 65536 =A0 =A0 =A0 =A0 =A0 4 =A0 =A0 =A0 =A036,700 =A0 =A0 =A0=
36,700 =A0 =A036,600
> > >>> 524288 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 =A0 3,470 =A0 =A0 =A0 =
3,430 =A0 =A0 3,420
> > >>> 524288 =A0 =A0 =A0 =A0 =A0 4 =A0 =A0 =A0 =A0 5,020 =A0 =A0 =A0 =
5,020 =A0 =A0 4,990
>
> > I'm interested to see how much your changes affected processing lat=
ency,
> > i.e. to measure execution latency before and after changes. You can=
't do
> > that with several threads, because latency =3D 1/bandwidth only if =
you
> > always have only one command at time. So, all those sophisticated
> > measurements can't substitute a plane old:
>
> If my assumption that --numjobs=3D1 puts fio into a single-threaded m=
ode
> is correct, it seems that using this patch hurts individual command
> latency, at least in a gross sense. The table listed above shows a ~9=
%
> hit for single-threaded 0.5 KB and 4 KB requests, ~4.8% for 64 KB
> requests, and ~1.4% for 512 KB requests. It seems to win @ lots of
> requests and small block sizes, but still seems to hurt performance a=
t
> larger request sizes, though it seems they were tested with smaller
> thread counts.
>
> I've not reviewed the patch yet, but that's how I read the table abov=
e.
> I'm assuming latency is hurt by the need to schedule the kernel threa=
d,
> but the batching helps increase the IOPS for low request sizes.

Please note that the user has to enable mode thread=3Dy explicitly. The
default mode is thread=3Dn and in that mode neither latency nor
throughput is affected by this patch.

> Bart, you could also try xdd as a benchmark tool.

I'm familiar with xdd. However, I consider fio both as more powerful
and easier to user than xdd.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
