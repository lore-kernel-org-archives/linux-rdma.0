From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow reads
	and eventually hangs
Date: Tue, 15 Sep 2009 08:10:36 +0200
Message-ID: <e2e108260909142310vb353718uea99d50ab638a865@mail.gmail.com>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>
	 <e2e108260909060617y13a1ded8jd6686d02521ecb4@mail.gmail.com>
	 <f3177b9e0909060636k6e293c06la3dfe9f929da4915@mail.gmail.com>
	 <f3177b9e0909060641i296c7aefp322712f52de9786a@mail.gmail.com>
	 <4AA4F561.504@vlnb.net>
	 <f3177b9e0909081529i4dd74faq9a6c5a4783b5ded4@mail.gmail.com>
	 <e2e108260909090938x6b72c519teed7dfd280eac804@mail.gmail.com>
	 <f3177b9e0909111250w159def51h9b720366e27fa3a7@mail.gmail.com>
	 <4AAE909F.6030202@vlnb.net>
	 <f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 15, 2009 at 1:03 AM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>
> On Mon, Sep 14, 2009 at 12:51 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org=
> wrote:
> > Chris Worley, on 09/11/2009 11:50 PM wrote:
> >>
> >> I've definitely removed the switch/firmware from being the cause.
> >>
> >> I'm thinking the reason you can't repeat the test may be latency
> >> related. =A0We get ~50usecs average latency (on small block sizes)=
,
> >> which can't be achieved using regular SSD's (and rotating drives a=
re
> >> nowhere close). =A0Maybe a ramdisk would help repeat the issue.
> >
> > I think you should try to reproduce the problem with ramdisk or nul=
lio. By
> > so you will eliminate possible influence of the SSD backend.
>
> W/ 12GB RAM in the target, I created a 7GB ramdisk:
>
> mount -t ramfs -o size=3D7g ramfs /mnt/
> dd if=3D/dev/zero of=3D/mnt/foo bs=3D1024k count=3D7000
> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
>
> Then, on the initiator, I tested it... and it hung during sequential
> 8KB block reads:
>
> fio --rw=3Dread --bs=3D8k --numjobs=3D64 --iodepth=3D64 --sync=3D0 --=
direct=3D1
> --randrepeat=3D0 \
> =A0 --group_reporting --ioengine=3Dlibaio --filename=3D/dev/sde --nam=
e=3Dtest
> --loops=3D10000 --runtime=3D600
>
> Note that I was running the SM on the target this time too.

Which Linux distro was installed on the inititiator and on the target
? And if applicable, which OFED version ? Which kernel messages were
logged by SRPT around the time the issue occurred (after having
enabled SRPT logging first) ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
