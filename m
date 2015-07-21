From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: deprecating amso1100
Date: Tue, 21 Jul 2015 15:43:48 -0500
Message-ID: <55AEAF04.1020801@opengridcomputing.com>
References: <55AE93E0.9060002@opengridcomputing.com>
 <1AE4059B-F6BD-48ED-A1C6-8A9024DDF217@redhat.com>
 <D2F193D21ECD8C45917AD3D5B26513300C49590A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D2F193D21ECD8C45917AD3D5B26513300C49590A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/21/2015 3:42 PM, Dalessandro, Dennis wrote:
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
>> Sent: Tuesday, July 21, 2015 2:49 PM
>> To: Steve Wise
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: deprecating amso1100
>>
>>
>>> On Jul 21, 2015, at 2:48 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+v7I7tHvgBF7@public.gmane.org=
m>
>> wrote:
>>> Hey Doug,
>>>
>>> How should I submit changes to deprecate amso1100?  The HW hasn't b=
een
>> sold since 2005, and the SW has definite bit rot.  Its time to remov=
e it...
>>> Thanks,
>>>
>>> Steve.
>> Send me a git patch that uses git mv to move it to staging and we=E2=
=80=99ll leave it
>> there for a release or two and then remove it after that.
> Steve, "git format-patch -M" does a nice job creating a patch that ca=
n actually be looked at via email.
>
> http://marc.info/?l=3Dlinux-kernel&m=3D143593782206479&w=3D2
>
> For the Ipath driver I was going to send directly to the staging main=
tainer/list. Doug, should that come to you through linux-rdma instead?
>
> -Denny
>

Thanks.  Yes,  I originally sent the full patch and it didn't hit=20
linux-rdma due to its size.  I just sent out a new patch via=20
format-patch -M.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
