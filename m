From: "Sufficool, Stanley" <ssufficool-AmqEsPSg0VfuwJLVJmOTOA@public.gmane.org>
Subject: RE: [ofw] What is an IOC device ID and what is DriverStore
Date: Fri, 27 Aug 2010 17:01:51 -0700
Message-ID: <946F457324732742B1457FAFC8CF1ECB012DD2B0842A@EXCHANGE2.sbcounty.gov>
References: <AANLkTikKcUwO59Pkmeu3kG_FBwpg=SXj3P0Ud3rsq4Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikKcUwO59Pkmeu3kG_FBwpg=SXj3P0Ud3rsq4Mw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chris Worley' <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'OFED mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "'ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org'" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

What does your scst.conf look like? I assume you have LUNS in the default group.

>-----Original Message-----
>From: ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>[mailto:ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Chris Worley
>Sent: Friday, August 27, 2010 4:46 PM
>To: OFED mailing list
>Cc: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>Subject: Re: [ofw] What is an IOC device ID and what is DriverStore
>
>
>I'm resending this as plain text, as the
>linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org mailing list did not like my
>attempt to make the messages readable...
>
>On Fri, Aug 27, 2010 at 5:43 PM, Chris Worley
><worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> On Fri, Aug 27, 2010 at 5:02 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> wrote:
>> > On Fri, Aug 27, 2010 at 4:45 PM, Sufficool, Stanley
>> > <ssufficool-AmqEsPSg0VfuwJLVJmOTOA@public.gmane.org> wrote:
>> >>
>> >>
>> >>>-----Original Message-----
>> >>>From: ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>> >>>[mailto:ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Chris
>> >>>Worley
>> >>>Sent: Friday, August 27, 2010 1:52 PM
>> >>>To: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org; OFED mailing list
>> >>>Subject: [ofw] What is an IOC device ID and what is DriverStore
>> >>>
>> >>>
>> >>>In scouring the many manuals with the Window's IB drivers
>I found a
>> >>>clue as to why I can't get SRP working in WinOF:
>> >>>
>> >>>  Windows PNP (Plug-n-Play) will match the IOC device ID with
>> >>>DriverStore installed drives and then will load the IBiou.sys
>> >>>driver
>> >>>
>> >>>How do I set the "IOC device ID" and what is DriverStore?
>> >>
>> >> Not sure what this is, but I have never had to set any values on
>> >> the OFED-W initiator.
>> >>
>> >>>
>> >>>I can make the Windows SRP miniport devices appear and
>disappear by
>> >>>removing/reloading ib_srpt on the target (at least with the 2.1.1
>> >>>driver from Mellanox; the latest at openfabrics.org panics the
>> >>>WS2008R2 system when ib_srpt is rmmod'ed).
>> >>>
>> >>>Beyond that, Windows never sees the drives... Linux initiators
>> >>>don't have an issue.
>> >>
>> >> What messages do you get on the target? It it even receiving the
>> >> request?
>> >
>> > Yes:
>> >
>> > ib_srpt: ***ERROR***: received unrecognized IB CM event 10
>> > ib_srpt: Received DREQ and sent DREP for session
>> > 0x00247100000002c100247100000003d8.
>> > ib_srpt: Received SRP_LOGIN_REQ with i_port_id
>> > 0x247100000002c1:0x247100000003d8, t_port_id
>> > 0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 1
>> > (guid=0xfe80000000000000:0x247100000002bf)
>> > ib_srpt: disconnected session 0x00247100000002c100247100000003d8
>> > because a new SRP_LOGIN_REQ has been received.
>> > ib_srpt: Session : kernel thread ib_srpt_compl (PID 31542) started
>> > scst: Using security group "Default" for initiator
>> > "0x00247100000002c100247100000003d8"
>>
>> There is more to it than that.  I'm going to do this as HTML
>so I can
>> fix the font:
>>
>> ib_srpt: Received SRP_LOGIN_REQ with i_port_id
>> 0x247100000002c1:0x247100000003d8, t_port_id
>0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 2
>(guid=0xfe80000000000000:0x247100000002c3)
>> ib_srpt: Session : kernel thread ib_srpt_compl (PID 1109) started
>> scst: Using security group "Default" for initiator
>"0x00247100000002c100247100000003d8"
>> scst: Processing thread fio-719570_0 (PID 1110) started
>> scst: Processing thread fio-719570_1 (PID 1111) started
>> scst: Processing thread fio-719620_0 (PID 1112) started
>> scst: Processing thread fio-719620_1 (PID 1113) started
>> scst: Processing thread fio-719650_0 (PID 1114) started
>> scst: Processing thread fio-719650_1 (PID 1115) started
>> scst: Processing thread fio-719640_0 (PID 1116) started
>> scst: Processing thread fio-719640_1 (PID 1117) started
>> scst: Processing thread fio-410000_0 (PID 1118) started
>> scst: Processing thread fio-410000_1 (PID 1119) started
>> scst: Processing thread fio-410020_0 (PID 1120) started
>> scst: Processing thread fio-410020_1 (PID 1121) started
>> scst: Processing thread fio-409480_0 (PID 1122) started
>> scst: Processing thread fio-409480_1 (PID 1123) started
>> scst: Processing thread fio-410010_0 (PID 1124) started
>> scst: Processing thread fio-410010_1 (PID 1125) started
>> ib_srpt: ***ERROR***: received unrecognized IB CM event 10
>> ib_srpt: Received DREQ and sent DREP for session
>0x00247100000002c100247100000003d8.
>> ib_srpt: Received InfiniBand TimeWait exit for cm_id
>ffff81030b7c6c00.
>> ib_srpt: Session 0x00247100000002c100247100000003d8: kernel
>thread ib_srpt_compl (PID 1109) stopped
>> scst: Processing thread fio-719570_0 (PID 1110) finished
>> scst: Processing thread fio-719570_1 (PID 1111) finished
>> scst: Processing thread fio-719620_0 (PID 1112) finished
>> scst: Processing thread fio-719620_1 (PID 1113) finished
>> scst: Processing thread fio-719650_0 (PID 1114) finished
>> scst: Processing thread fio-719650_1 (PID 1115) finished
>> scst: Processing thread fio-719640_0 (PID 1116) finished
>> scst: Processing thread fio-719640_1 (PID 1117) finished
>> scst: Processing thread fio-410000_0 (PID 1118) finished
>> scst: Processing thread fio-410000_1 (PID 1119) finished
>> scst: Processing thread fio-410020_0 (PID 1120) finished
>> scst: Processing thread fio-410020_1 (PID 1121) finished
>> scst: Processing thread fio-409480_0 (PID 1122) finished
>> scst: Processing thread fio-409480_1 (PID 1123) finished
>> scst: Processing thread fio-410010_0 (PID 1124) finished
>> scst: Processing thread fio-410010_1 (PID 1125) finished
>> ib_srpt: Received SRP_LOGIN_REQ with i_port_id
>0x247100000002c1:0x24710000000390, t_port_id
>0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 2
>(guid=0xfe80000000000000:0x247100000002c0)
>> ib_srpt: Session : kernel thread ib_srpt_compl (PID 1138) started
>> scst: Using security group "Default" for initiator
>"0x00247100000002c10024710000000390"
>> scst: Processing thread fio-719570_0 (PID 1139) started
>> scst: Processing thread fio-719570_1 (PID 1140) started
>> scst: Processing thread fio-719620_0 (PID 1141) started
>> scst: Processing thread fio-719620_1 (PID 1142) started
>> scst: Processing thread fio-719650_0 (PID 1143) started
>> scst: Processing thread fio-719650_1 (PID 1144) started
>> scst: Processing thread fio-719640_0 (PID 1145) started
>> scst: Processing thread fio-719640_1 (PID 1146) started
>> scst: Processing thread fio-410000_0 (PID 1147) started
>> scst: Processing thread fio-410000_1 (PID 1148) started
>> scst: Processing thread fio-410020_0 (PID 1149) started
>> scst: Processing thread fio-410020_1 (PID 1150) started
>> scst: Processing thread fio-409480_0 (PID 1151) started
>> scst: Processing thread fio-409480_1 (PID 1152) started
>> scst: Processing thread fio-410010_0 (PID 1153) started
>> scst: Processing thread fio-410010_1 (PID 1154) started
>> ib_srpt: ***ERROR***: received unrecognized IB CM event 10
>> ib_srpt: Received DREQ and sent DREP for session
>0x00247100000002c10024710000000390.
>> ib_srpt: Received InfiniBand TimeWait exit for cm_id
>ffff810191ae5400.
>> ib_srpt: Session 0x00247100000002c10024710000000390: kernel
>thread ib_srpt_compl (PID 1138) stopped
>> scst: Processing thread fio-719570_0 (PID 1139) finished
>> scst: Processing thread fio-719570_1 (PID 1140) finished
>> scst: Processing thread fio-719620_0 (PID 1141) finished
>> scst: Processing thread fio-719620_1 (PID 1142) finished
>> scst: Processing thread fio-719650_0 (PID 1143) finished
>> scst: Processing thread fio-719650_1 (PID 1144) finished
>> scst: Processing thread fio-719640_0 (PID 1145) finished
>> scst: Processing thread fio-719640_1 (PID 1146) finished
>> scst: Processing thread fio-410000_0 (PID 1147) finished
>> scst: Processing thread fio-410000_1 (PID 1148) finished
>> scst: Processing thread fio-410020_0 (PID 1149) finished
>> scst: Processing thread fio-410020_1 (PID 1150) finished
>> scst: Processing thread fio-409480_0 (PID 1151) finished
>> scst: Processing thread fio-409480_1 (PID 1152) finished
>> scst: Processing thread fio-410010_0 (PID 1153) finished
>> scst: Processing thread fio-410010_1 (PID 1154) finished
>>
>> While I do have two HCA's in both the target and initiator, I have
>> tried it with just one in the initiator.
>>
>> Hopefully that doesn't cause the email to bounce and makes it more
>> readable.
>>
>> Thanks,
>>
>> Chris
>> >
>> >>
>> >> Does windows disk management show a broken LUN?
>> >
>> > No.  Nothing (except local drives).
>> >>
>> >>>
>> >>>Someone throw me a bone!  The SRP initiator seems to have been
>> >>>broken for many months on WinDoh's.
>> >>
>> >> I have had no problems with the SRP initiator as long as I start
>> >> the target _after_ the windows systems boot.
>> >
>> > I've tried five different revs of the Windows driver, and
>no drives
>> > are seen.
>> >
>> > Thanks,
>> >
>> > Chris
>> >>
>> >>>
>> >>>Thanks,
>> >>>
>> >>>Chris
>> >>>_______________________________________________
>> >>>ofw mailing list
>> >>>ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>> >>>http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>> >>>
>> >>
>> >
>>
>_______________________________________________
>ofw mailing list
>ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
