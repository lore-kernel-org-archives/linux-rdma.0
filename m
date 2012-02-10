From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: [PATCH 00/18, v2] Make ib_srp better suited for H.A. purposes
Date: Sat, 11 Feb 2012 09:07:00 +1100
Message-ID: <CAOzFzEgL24DA=Cqaf5vvAesfR-w0Ve2J_7v+bfVfcsbAbaA6LQ@mail.gmail.com>
References: <3109536.qySrY1Ts3e@asus>
	<CAO+b5-q7q+-spucP821tpmQW5Qp7GXg+kTyL9TxesA32hAVbFA@mail.gmail.com>
	<20120207013617.GB4645@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120207013617.GB4645-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi David,

These patches have been running in my testing environment for quite
some time now. (since prior to the series first being posted to the
list)
I have reviewed the changes and tested the following functionality to
be working correctly as added by the patch series:

1) Disconnection from target using sysfs delete

2) Fast failover using dm-mulitpath or mdadm multipath by either
physically removing connection or disabling port.
ib_srp did not like this prior to patchset - failover could take as
long as 120-180 seconds.
Adjusting fast_io_fail and dev_loss parameters in sysfs proved very
effective in tuning this behaviour.

3) Use of the /sys/class/{srp_hosts,srp_remote_ports} shortcuts have
been very useful for automation and monitoring of the initiator.

In my testing this patchset has greatly increased the durablity of the
combination of ib_srp and SCST's ib_srpt under failure conditions.
I have stress tested this environment and executed disconnect commands
under I/O and other extranous conditions and have not experienced any
kernel panics etc.

I highly recommend these patches for inclusion and would be willing to
assist in testing wherever I can.

Kind regards,

Joseph.


On 7 February 2012 12:36, Dave Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> On Mon, Feb 06, 2012 at 11:16:25AM -0500, Bart Van Assche wrote:
>> On Sat, Jan 14, 2012 at 1:36 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org=
> wrote:
>> > This patch series makes the ib_srp driver better suited for use in=
 a H.A.
>>
>> Do you have any review comments about this patch series ?
>
> I haven't had a chance to review it yet. I had hoped to over the
> weekend, but the $DAYJOB intrudes even there. :(
>
> --
> Dave Dillow
> National Center for Computational Science
> Oak Ridge National Laboratory
> (865) 241-6602=A0office
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
=46ounder | Director | VP Research
Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1300=
 56
99 52 | Mobile: 0428 754 846
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
