From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Default force_link_speed value in opensm configuration
Date: Tue, 13 Oct 2009 15:53:22 -0400
Message-ID: <f0e08f230910131253o7c667932xacf24a17cb9e0fd8@mail.gmail.com>
References: <4ACB6891.7010202@gmail.com>
	 <20091006142728.3d1e5bcc.weiny2@llnl.gov> <4AD2FB39.6040602@gmail.com>
	 <20091012143553.04554689.weiny2@llnl.gov>
	 <f0e08f230910130639v7f2da43bt630b7f42eb0da795@mail.gmail.com>
	 <20091013124448.208cf778.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091013124448.208cf778.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 13, 2009 at 3:44 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Tue, 13 Oct 2009 09:39:08 -0400
> Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Oct 12, 2009 at 5:35 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>> > On Mon, 12 Oct 2009 11:47:37 +0200
>> > "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> Ira Weiny wrote:
>> >> > On Tue, 06 Oct 2009 17:56:01 +0200
>> >> > "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >
>> >> >> Hi,
>> >> >>
>> >> >> Is there a reason for setting default force_link_speed to 15 (=
set enabled as supported)
>> >> >> and not to 0 (don't modify PortInfo:LinkSpeedEnabled )?
>>
>> This is going back some 2 years to 7/15/07 commit ID
>> c7cbf11992b111d2b9c7347e398e67f2b5806edb
>>
>> commit c7cbf11992b111d2b9c7347e398e67f2b5806edb
>> Author: Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>> Date: =C2=A0 Sun Jul 15 06:43:20 2007 -0400
>>
>> =C2=A0 =C2=A0 OpenSM: Change force_link_speed to allow for local pol=
icy and more flexibili
>>
>> =C2=A0 =C2=A0 OpenSM: Change force_link_speed to allow for local pol=
icy and more
>> =C2=A0 =C2=A0 flexibility
>>
>> =C2=A0 =C2=A0 Extend (and change) the use of force_link_speed as fol=
lows:
>> =C2=A0 =C2=A0 0 - no change
>> =C2=A0 =C2=A0 1 - set to SDR
>> =C2=A0 =C2=A0 15 - set as supported (default)
>> =C2=A0 =C2=A0 (Non zero values are used to set LinkSpeedEnabled comp=
onent in PortInfo)
>>
>> =C2=A0 =C2=A0 Note that force_link_speed 0 which used to force SDR i=
s now
>> =C2=A0 =C2=A0 force_link_speed 1
>>
>> =C2=A0 =C2=A0 "Ideally", there were be a per port configuration of t=
his.
>
> BTW I have a patch which allows a user to except some nodes from this
> restriction. =C2=A0I don't know that anyone but us is using this "fea=
ture" so I did
> not submit the patch. =C2=A0If someone else would like some finer gra=
nularity I can
> clean up the patch and make it available.

There are others. This would be a worthwhile improvement IMO.

-- Hal

>
>>
>> =C2=A0 =C2=A0 [Note this is largely untested.]
>
> BTW, now, this is highly tested, to force SDR, on some of our cluster=
s!
> Thanks!
>
>>
>> =C2=A0 =C2=A0 Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8@public.gmane.org=
m>
>>
>> I think that the default was chosen based on IBA 1.2.1 vol 2 p. 108 =
stating:
>> "The default value following power on shall be set to LinkSpeedSuppo=
rted."
>> which should not be an issue with compliant hardware.
>>
>
> [snip]
>
>> >
>> > However, I would like to know if anyone else knows of hardware whi=
ch needs it
>> > set to "15". =C2=A0If so, this is going to be an interesting probl=
em... =C2=A0;-)
>>
>> I'm not sure about need but I think there is a tradeoff here in
>> changing this. The pro is it will work with non compliant hardware.
>> The con is that it may result in less than the max LSS being used in
>> some scenarios.
>>
>> Should the default be changed for non compliant hardware or should
>> this need to be configured in subnets including such hardware as it
>> has since this was introduced ?
>>
>
> I think that is a good way of thinking about things.
>
> Ira
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
