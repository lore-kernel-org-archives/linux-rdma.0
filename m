From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofw] What is an IOC device ID and what is DriverStore
Date: Fri, 27 Aug 2010 17:02:42 -0600
Message-ID: <AANLkTi=PM+ecJ9g_RbUibM-+cx-pZvPiSj5OXZz7DFN-@mail.gmail.com>
References: <AANLkTikvA8oaksoszCoAvUs=sHp7uap-q+d9=f+AoQ96@mail.gmail.com>
	<946F457324732742B1457FAFC8CF1ECB012DD2B083B6@EXCHANGE2.sbcounty.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <946F457324732742B1457FAFC8CF1ECB012DD2B083B6-Xnr6BND5kcgCA5QMIYIz5UySuYQ/OXwe@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Sufficool, Stanley" <ssufficool-AmqEsPSg0VfuwJLVJmOTOA@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 27, 2010 at 4:45 PM, Sufficool, Stanley
<ssufficool-AmqEsPSg0VfuwJLVJmOTOA@public.gmane.org> wrote:
>
>
>>-----Original Message-----
>>From: ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>[mailto:ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Chris Worley
>>Sent: Friday, August 27, 2010 1:52 PM
>>To: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org; OFED mailing list
>>Subject: [ofw] What is an IOC device ID and what is DriverStore
>>
>>
>>In scouring the many manuals with the Window's IB drivers I
>>found a clue as to why I can't get SRP working in WinOF:
>>
>> =A0Windows PNP (Plug-n-Play) will match the IOC device ID with
>>DriverStore installed drives and then will load the IBiou.sys driver
>>
>>How do I set the "IOC device ID" and what is DriverStore?
>
> Not sure what this is, but I have never had to set any values on the =
OFED-W initiator.
>
>>
>>I can make the Windows SRP miniport devices appear and
>>disappear by removing/reloading ib_srpt on the target (at
>>least with the 2.1.1 driver from Mellanox; the latest at
>>openfabrics.org panics the WS2008R2 system when ib_srpt is rmmod'ed).
>>
>>Beyond that, Windows never sees the drives... Linux initiators
>>don't have an issue.
>
> What messages do you get on the target? It it even receiving the requ=
est?

Yes:

ib_srpt: ***ERROR***: received unrecognized IB CM event 10
ib_srpt: Received DREQ and sent DREP for session
0x00247100000002c100247100000003d8.
ib_srpt: Received SRP_LOGIN_REQ with i_port_id
0x247100000002c1:0x247100000003d8, t_port_id
0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 1
(guid=3D0xfe80000000000000:0x247100000002bf)
ib_srpt: disconnected session 0x00247100000002c100247100000003d8
because a new SRP_LOGIN_REQ has been received.
ib_srpt: Session : kernel thread ib_srpt_compl (PID 31542) started
scst: Using security group "Default" for initiator
"0x00247100000002c100247100000003d8"

>
> Does windows disk management show a broken LUN?

No.  Nothing (except local drives).
>
>>
>>Someone throw me a bone! =A0The SRP initiator seems to have been
>>broken for many months on WinDoh's.
>
> I have had no problems with the SRP initiator as long as I start the =
target _after_ the windows systems boot.

I've tried five different revs of the Windows driver, and no drives are=
 seen.

Thanks,

Chris
>
>>
>>Thanks,
>>
>>Chris
>>_______________________________________________
>>ofw mailing list
>>ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
