From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Default force_link_speed value in opensm configuration
Date: Tue, 13 Oct 2009 09:39:08 -0400
Message-ID: <f0e08f230910130639v7f2da43bt630b7f42eb0da795@mail.gmail.com>
References: <4ACB6891.7010202@gmail.com>
	 <20091006142728.3d1e5bcc.weiny2@llnl.gov> <4AD2FB39.6040602@gmail.com>
	 <20091012143553.04554689.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091012143553.04554689.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2009 at 5:35 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
> On Mon, 12 Oct 2009 11:47:37 +0200
> "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Ira Weiny wrote:
>> > On Tue, 06 Oct 2009 17:56:01 +0200
>> > "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> Hi,
>> >>
>> >> Is there a reason for setting default force_link_speed to 15 (set enabled as supported)
>> >> and not to 0 (don't modify PortInfo:LinkSpeedEnabled )?

This is going back some 2 years to 7/15/07 commit ID
c7cbf11992b111d2b9c7347e398e67f2b5806edb

commit c7cbf11992b111d2b9c7347e398e67f2b5806edb
Author: Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Sun Jul 15 06:43:20 2007 -0400

    OpenSM: Change force_link_speed to allow for local policy and more flexibili

    OpenSM: Change force_link_speed to allow for local policy and more
    flexibility

    Extend (and change) the use of force_link_speed as follows:
    0 - no change
    1 - set to SDR
    15 - set as supported (default)
    (Non zero values are used to set LinkSpeedEnabled component in PortInfo)

    Note that force_link_speed 0 which used to force SDR is now
    force_link_speed 1

    "Ideally", there were be a per port configuration of this.

    [Note this is largely untested.]

    Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I think that the default was chosen based on IBA 1.2.1 vol 2 p. 108 stating:
"The default value following power on shall be set to LinkSpeedSupported."
which should not be an issue with compliant hardware.

>> >
>> > The thought was to enable all ports to the maximum supported by default.  This
>> > was the behavior before this option was added so it was though to leave it
>> > alone by default.
>> >
>> > Is there a reason this should not happen?  I guess since the Volume 2 spec
>> > says that the power on default for this is LinkSpeedSupported there is no
>> > reason to have the SM send these Set's.  Perhaps there is broken hardware out
>> > there?
>>
>> well actually there is a hardware that supports only 5.0Gbps (but reports 2.5 or 5.0 Gbps since there is no option for 5.0 only)
>> and powers on with enabled speed of 5.0Gbps only.
>> Setting the enabled speed to the supported speed will fail further negotiation (after link reset) since the device does not support 2.5Gbps.
>
> That seems like broken hardware...

Yes, all ports are required to support SDR.

IBA 1.2.1 vol 2 p. 108 states:
"Note that the SDR speed (2.5 Gb/s) must always be enabled, since
link initialization occurs at this speed."

If you feel that this should not be a requirement, shouldn't that be
taken up with the IBTA and have the spec amended ?

>>
>> So if the default for all other devices is enabled=supported then we can change the opensm configuration force_link_speed to 0.
>>
>
> I have no problem changing it.  As I said if hardware is compliant I think it
> might speed things up.  I will test out a patch with the hardware I can test.
>
> However, I would like to know if anyone else knows of hardware which needs it
> set to "15".  If so, this is going to be an interesting problem...  ;-)

I'm not sure about need but I think there is a tradeoff here in
changing this. The pro is it will work with non compliant hardware.
The con is that it may result in less than the max LSS being used in
some scenarios.

Should the default be changed for non compliant hardware or should
this need to be configured in subnets including such hardware as it
has since this was introduced ?

-- Hal

> Ira
>
>
> --
> Ira Weiny
> Math Programmer/Computer Scientist
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
