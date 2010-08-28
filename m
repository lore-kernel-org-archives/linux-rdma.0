From: Chris Worley <worleys@gmail.com>
Subject: Re: What is an IOC device ID and what is DriverStore
Date: Fri, 27 Aug 2010 18:10:40 -0600
Message-ID: <AANLkTin_3d64+U2aiQg6E8DMNY0FsjMUVfgjrtR2O2PR@mail.gmail.com>
References: <AANLkTikKcUwO59Pkmeu3kG_FBwpg=SXj3P0Ud3rsq4Mw@mail.gmail.com>
	<946F457324732742B1457FAFC8CF1ECB012DD2B0842A@EXCHANGE2.sbcounty.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <946F457324732742B1457FAFC8CF1ECB012DD2B0842A@EXCHANGE2.sbcounty.gov>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Sufficool, Stanley" <ssufficool@rov.sbcounty.gov>
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 27, 2010 at 6:01 PM, Sufficool, Stanley
<ssufficool@rov.sbcounty.gov> wrote:
> What does your scst.conf look like? I assume you have LUNS in the default=
 group.

A Linux initiator has no trouble seeing these:

# cat /proc/scsi_tgt/vdisk/vdisk
Name              Size(MB)    Block size  Options         File name
                                 T10 device id
fio-71957         76774       512         NV BIO          /dev/sda
                                fio-71957 8d58d2cc
fio-71962         76774       512         NV BIO          /dev/sdb
                                fio-71962 4ab477ef
fio-71965         76774       512         NV BIO          /dev/sdc
                                fio-71965 28ba5c58
fio-71964         76774       512         NV BIO          /dev/sdd
                                fio-71964 f2c69cf6
fio-41000         76774       512         NV BIO          /dev/sde
                                fio-41000 2492daab
fio-41002         76774       512         NV BIO          /dev/sdf
                                fio-41002 dd797f32
fio-40948         76774       512         NV BIO          /dev/sdg
                                fio-40948 a3ef7aa3
fio-41001         76774       512         NV BIO          /dev/sdh
                                fio-41001 543b6d8e
[root@fusion-io-live .bak]# cat /proc/scsi_tgt/groups/Default/devices
Device (host:ch:id:lun or name)                             LUN          Op=
tions
fio-71957                                                   0
fio-71962                                                   1
fio-71965                                                   2
fio-71964                                                   3
fio-41000                                                   4
fio-41002                                                   5
fio-40948                                                   6
fio-41001                                                   7

(Adding scst-devel, as it looks like Windows logs in then immediately
logs out or is forced out.)

Thanks,

Chris

>
>>-----Original Message-----
>>From: ofw-bounces@lists.openfabrics.org
>>[mailto:ofw-bounces@lists.openfabrics.org] On Behalf Of Chris Worley
>>Sent: Friday, August 27, 2010 4:46 PM
>>To: OFED mailing list
>>Cc: ofw@lists.openfabrics.org
>>Subject: Re: [ofw] What is an IOC device ID and what is DriverStore
>>
>>
>>I'm resending this as plain text, as the
>>linux-rdma@vger.kernel.org mailing list did not like my
>>attempt to make the messages readable...
>>
>>On Fri, Aug 27, 2010 at 5:43 PM, Chris Worley
>><worleys@gmail.com> wrote:
>>>
>>> On Fri, Aug 27, 2010 at 5:02 PM, Chris Worley <worleys@gmail.com>
>>> wrote:
>>> > On Fri, Aug 27, 2010 at 4:45 PM, Sufficool, Stanley
>>> > <ssufficool@rov.sbcounty.gov> wrote:
>>> >>
>>> >>
>>> >>>-----Original Message-----
>>> >>>From: ofw-bounces@lists.openfabrics.org
>>> >>>[mailto:ofw-bounces@lists.openfabrics.org] On Behalf Of Chris
>>> >>>Worley
>>> >>>Sent: Friday, August 27, 2010 1:52 PM
>>> >>>To: ofw@lists.openfabrics.org; OFED mailing list
>>> >>>Subject: [ofw] What is an IOC device ID and what is DriverStore
>>> >>>
>>> >>>
>>> >>>In scouring the many manuals with the Window's IB drivers
>>I found a
>>> >>>clue as to why I can't get SRP working in WinOF:
>>> >>>
>>> >>> =A0Windows PNP (Plug-n-Play) will match the IOC device ID with
>>> >>>DriverStore installed drives and then will load the IBiou.sys
>>> >>>driver
>>> >>>
>>> >>>How do I set the "IOC device ID" and what is DriverStore?
>>> >>
>>> >> Not sure what this is, but I have never had to set any values on
>>> >> the OFED-W initiator.
>>> >>
>>> >>>
>>> >>>I can make the Windows SRP miniport devices appear and
>>disappear by
>>> >>>removing/reloading ib_srpt on the target (at least with the 2.1.1
>>> >>>driver from Mellanox; the latest at openfabrics.org panics the
>>> >>>WS2008R2 system when ib_srpt is rmmod'ed).
>>> >>>
>>> >>>Beyond that, Windows never sees the drives... Linux initiators
>>> >>>don't have an issue.
>>> >>
>>> >> What messages do you get on the target? It it even receiving the
>>> >> request?
>>> >
>>> > Yes:
>>> >
>>> > ib_srpt: ***ERROR***: received unrecognized IB CM event 10
>>> > ib_srpt: Received DREQ and sent DREP for session
>>> > 0x00247100000002c100247100000003d8.
>>> > ib_srpt: Received SRP_LOGIN_REQ with i_port_id
>>> > 0x247100000002c1:0x247100000003d8, t_port_id
>>> > 0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 1
>>> > (guid=3D0xfe80000000000000:0x247100000002bf)
>>> > ib_srpt: disconnected session 0x00247100000002c100247100000003d8
>>> > because a new SRP_LOGIN_REQ has been received.
>>> > ib_srpt: Session : kernel thread ib_srpt_compl (PID 31542) started
>>> > scst: Using security group "Default" for initiator
>>> > "0x00247100000002c100247100000003d8"
>>>
>>> There is more to it than that. =A0I'm going to do this as HTML
>>so I can
>>> fix the font:
>>>
>>> ib_srpt: Received SRP_LOGIN_REQ with i_port_id
>>> 0x247100000002c1:0x247100000003d8, t_port_id
>>0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 2
>>(guid=3D0xfe80000000000000:0x247100000002c3)
>>> ib_srpt: Session : kernel thread ib_srpt_compl (PID 1109) started
>>> scst: Using security group "Default" for initiator
>>"0x00247100000002c100247100000003d8"
>>> scst: Processing thread fio-719570_0 (PID 1110) started
>>> scst: Processing thread fio-719570_1 (PID 1111) started
>>> scst: Processing thread fio-719620_0 (PID 1112) started
>>> scst: Processing thread fio-719620_1 (PID 1113) started
>>> scst: Processing thread fio-719650_0 (PID 1114) started
>>> scst: Processing thread fio-719650_1 (PID 1115) started
>>> scst: Processing thread fio-719640_0 (PID 1116) started
>>> scst: Processing thread fio-719640_1 (PID 1117) started
>>> scst: Processing thread fio-410000_0 (PID 1118) started
>>> scst: Processing thread fio-410000_1 (PID 1119) started
>>> scst: Processing thread fio-410020_0 (PID 1120) started
>>> scst: Processing thread fio-410020_1 (PID 1121) started
>>> scst: Processing thread fio-409480_0 (PID 1122) started
>>> scst: Processing thread fio-409480_1 (PID 1123) started
>>> scst: Processing thread fio-410010_0 (PID 1124) started
>>> scst: Processing thread fio-410010_1 (PID 1125) started
>>> ib_srpt: ***ERROR***: received unrecognized IB CM event 10
>>> ib_srpt: Received DREQ and sent DREP for session
>>0x00247100000002c100247100000003d8.
>>> ib_srpt: Received InfiniBand TimeWait exit for cm_id
>>ffff81030b7c6c00.
>>> ib_srpt: Session 0x00247100000002c100247100000003d8: kernel
>>thread ib_srpt_compl (PID 1109) stopped
>>> scst: Processing thread fio-719570_0 (PID 1110) finished
>>> scst: Processing thread fio-719570_1 (PID 1111) finished
>>> scst: Processing thread fio-719620_0 (PID 1112) finished
>>> scst: Processing thread fio-719620_1 (PID 1113) finished
>>> scst: Processing thread fio-719650_0 (PID 1114) finished
>>> scst: Processing thread fio-719650_1 (PID 1115) finished
>>> scst: Processing thread fio-719640_0 (PID 1116) finished
>>> scst: Processing thread fio-719640_1 (PID 1117) finished
>>> scst: Processing thread fio-410000_0 (PID 1118) finished
>>> scst: Processing thread fio-410000_1 (PID 1119) finished
>>> scst: Processing thread fio-410020_0 (PID 1120) finished
>>> scst: Processing thread fio-410020_1 (PID 1121) finished
>>> scst: Processing thread fio-409480_0 (PID 1122) finished
>>> scst: Processing thread fio-409480_1 (PID 1123) finished
>>> scst: Processing thread fio-410010_0 (PID 1124) finished
>>> scst: Processing thread fio-410010_1 (PID 1125) finished
>>> ib_srpt: Received SRP_LOGIN_REQ with i_port_id
>>0x247100000002c1:0x24710000000390, t_port_id
>>0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 2
>>(guid=3D0xfe80000000000000:0x247100000002c0)
>>> ib_srpt: Session : kernel thread ib_srpt_compl (PID 1138) started
>>> scst: Using security group "Default" for initiator
>>"0x00247100000002c10024710000000390"
>>> scst: Processing thread fio-719570_0 (PID 1139) started
>>> scst: Processing thread fio-719570_1 (PID 1140) started
>>> scst: Processing thread fio-719620_0 (PID 1141) started
>>> scst: Processing thread fio-719620_1 (PID 1142) started
>>> scst: Processing thread fio-719650_0 (PID 1143) started
>>> scst: Processing thread fio-719650_1 (PID 1144) started
>>> scst: Processing thread fio-719640_0 (PID 1145) started
>>> scst: Processing thread fio-719640_1 (PID 1146) started
>>> scst: Processing thread fio-410000_0 (PID 1147) started
>>> scst: Processing thread fio-410000_1 (PID 1148) started
>>> scst: Processing thread fio-410020_0 (PID 1149) started
>>> scst: Processing thread fio-410020_1 (PID 1150) started
>>> scst: Processing thread fio-409480_0 (PID 1151) started
>>> scst: Processing thread fio-409480_1 (PID 1152) started
>>> scst: Processing thread fio-410010_0 (PID 1153) started
>>> scst: Processing thread fio-410010_1 (PID 1154) started
>>> ib_srpt: ***ERROR***: received unrecognized IB CM event 10
>>> ib_srpt: Received DREQ and sent DREP for session
>>0x00247100000002c10024710000000390.
>>> ib_srpt: Received InfiniBand TimeWait exit for cm_id
>>ffff810191ae5400.
>>> ib_srpt: Session 0x00247100000002c10024710000000390: kernel
>>thread ib_srpt_compl (PID 1138) stopped
>>> scst: Processing thread fio-719570_0 (PID 1139) finished
>>> scst: Processing thread fio-719570_1 (PID 1140) finished
>>> scst: Processing thread fio-719620_0 (PID 1141) finished
>>> scst: Processing thread fio-719620_1 (PID 1142) finished
>>> scst: Processing thread fio-719650_0 (PID 1143) finished
>>> scst: Processing thread fio-719650_1 (PID 1144) finished
>>> scst: Processing thread fio-719640_0 (PID 1145) finished
>>> scst: Processing thread fio-719640_1 (PID 1146) finished
>>> scst: Processing thread fio-410000_0 (PID 1147) finished
>>> scst: Processing thread fio-410000_1 (PID 1148) finished
>>> scst: Processing thread fio-410020_0 (PID 1149) finished
>>> scst: Processing thread fio-410020_1 (PID 1150) finished
>>> scst: Processing thread fio-409480_0 (PID 1151) finished
>>> scst: Processing thread fio-409480_1 (PID 1152) finished
>>> scst: Processing thread fio-410010_0 (PID 1153) finished
>>> scst: Processing thread fio-410010_1 (PID 1154) finished
>>>
>>> While I do have two HCA's in both the target and initiator, I have
>>> tried it with just one in the initiator.
>>>
>>> Hopefully that doesn't cause the email to bounce and makes it more
>>> readable.
>>>
>>> Thanks,
>>>
>>> Chris
>>> >
>>> >>
>>> >> Does windows disk management show a broken LUN?
>>> >
>>> > No. =A0Nothing (except local drives).
>>> >>
>>> >>>
>>> >>>Someone throw me a bone! =A0The SRP initiator seems to have been
>>> >>>broken for many months on WinDoh's.
>>> >>
>>> >> I have had no problems with the SRP initiator as long as I start
>>> >> the target _after_ the windows systems boot.
>>> >
>>> > I've tried five different revs of the Windows driver, and
>>no drives
>>> > are seen.
>>> >
>>> > Thanks,
>>> >
>>> > Chris
>>> >>
>>> >>>
>>> >>>Thanks,
>>> >>>
>>> >>>Chris
>>> >>>_______________________________________________
>>> >>>ofw mailing list
>>> >>>ofw@lists.openfabrics.org
>>> >>>http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>>> >>>
>>> >>
>>> >
>>>
>>_______________________________________________
>>ofw mailing list
>>ofw@lists.openfabrics.org
>>http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
