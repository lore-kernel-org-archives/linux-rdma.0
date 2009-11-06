From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRPT and SCST
Date: Fri, 6 Nov 2009 08:06:41 +0100
Message-ID: <e2e108260911052306l230d8d7cxbae68bf08678d6fe@mail.gmail.com>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com>
	 <f3177b9e0911040802o7fce0f4fte02c52dfe940f582@mail.gmail.com>
	 <3142CEFB1403044F9954E2DF6C85660FBB34BF@orca.penguincomputing.com>
	 <f3177b9e0911041004t2e75d545v5cc10d5375550bde@mail.gmail.com>
	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4DD@orca.penguincomputing.com>
	 <4AF29201.6000606@penguincomputing.com> <4AF2D2B8.5080304@vlnb.net>
	 <e2e108260911051034o43db58cdi65b84ce46219bb94@mail.gmail.com>
	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4F9@orca.penguincomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4F9-/U8SqUwOx9/OOpeOfUw7maQk6oIRg43YAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arend Dittmer <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 6, 2009 at 3:54 AM, Philip Pokorny
<ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
> =3D=3D=3D=3D=3D=3D=3D Update
> At Chris's suggestion, I changed the scst threading to a *single* thr=
ead.=A0 I
> also changed the number of outstanding commands to 32 (from 64)=A0 We=
 have a
> relatively large number of initiators (50, currently testing with onl=
y 4)
> but each initiator has it's own dedicated, non-shared set of LVM "blo=
ck"
> devices.=A0 So it does not seem necessary to set the device queue siz=
e to
> initiators*device_queue_size.=A0 I set the total device queued comman=
ds to 37.
>
> Re-running the test, the storage is "stable" and completed the first =
phase
> of the test (create and check the filesystem) but now two of four cli=
ents
> have "live-locked" waiting for an I/O to complete for the last 15 min=
utes or
> so.
>
> On the initiators iostat looks like this:
>
> Device:=A0=A0=A0=A0=A0=A0=A0=A0 rrqm/s=A0=A0 wrqm/s=A0=A0 r/s=A0=A0 w=
/s=A0=A0=A0 rkB/s=A0=A0=A0 wkB/s avgrq-sz
> avgqu-sz=A0=A0 await=A0 svctm=A0 %util
> sdb=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=
 0.00=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00
> 160.02=A0=A0=A0 0.00=A0=A0 0.00 100.01
> sdb=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=
 0.00=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00
> 160.02=A0=A0=A0 0.00=A0=A0 0.00 100.01
> sdb=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=
 0.00=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00
> 160.02=A0=A0=A0 0.00=A0=A0 0.00 100.01
> sdb=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=
 0.00=A0 0.14=A0=A0=A0=A0 0.00=A0=A0=A0=A0 8.14=A0=A0 114.00
> 159.34 180114.00 7002.00 100.03
> sdb=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=
 0.00=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00
> 160.02=A0=A0=A0 0.00=A0=A0 0.00 100.01
> sdb=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=
 0.00=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00=A0=A0=A0=A0 0.00
> 160.02=A0=A0=A0 0.00=A0=A0 0.00 100.01
>
> This tells me that there is a pending I/O waiting to be completed but=
 it
> seems to have been lost on the server, because this is taking much to=
o
> long.=A0 There are 7 seconds "between" each line of output above so t=
hat's
> almost 30 seconds of output with *no* change in the I/O status.
>
> The "gzip | tar -x" I was running is "hung"

Hello Phil,

Can you please post the SCST target logs available for the above scenar=
io ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
