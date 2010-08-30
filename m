From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofw] What is an IOC device ID and what is DriverStore
Date: Mon, 30 Aug 2010 17:46:38 -0600
Message-ID: <AANLkTi=9SLO+mP5MxwPhV8pC2_Yvd4KMWafgh7Y+zPVN@mail.gmail.com>
References: <AANLkTikKcUwO59Pkmeu3kG_FBwpg=SXj3P0Ud3rsq4Mw@mail.gmail.com>
	<946F457324732742B1457FAFC8CF1ECB012DD2B0842A@EXCHANGE2.sbcounty.gov>
	<AANLkTin_3d64+U2aiQg6E8DMNY0FsjMUVfgjrtR2O2PR@mail.gmail.com>
	<AANLkTi=-4NqF-B61teg4shWciMcea11yD3i8wsiUUQ_5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=-4NqF-B61teg4shWciMcea11yD3i8wsiUUQ_5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Uri Habusha <urih-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hint:

SCST rev 1901 ends compatibility w/ Windows; r1900 works fine.  As
there were a lot of diffs between these two revs, I won't include it
here.

svn diff -r 1900:1901 https://scst.svn.sourceforge.net/svnroot/scst/tru=
nk

Thanks,

Chris
On Mon, Aug 30, 2010 at 12:37 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> I am also seeing the following Windows events for all eight drives:
>
> Log Name: =A0 =A0 =A0System
> Source: =A0 =A0 =A0 =A0Microsoft-Windows-UserPnp
> Date: =A0 =A0 =A0 =A0 =A08/30/2010 11:58:58 AM
> Event ID: =A0 =A0 =A020001
> Task Category: (7005)
> Level: =A0 =A0 =A0 =A0 Information
> Keywords:
> User: =A0 =A0 =A0 =A0 =A0SYSTEM
> Computer: =A0 =A0 =A0WIN-6EB0ETQ8M85
> Description:
> Driver Management concluded the process to install driver
> FileRepository\disk.inf_amd64_neutral_10ce25bbc5a9cc43\disk.inf for
> Device Instance ID SCSI\DISK&VEN_SCST_BIO&PROD_FIO-41001\000007 with
> the following status: 0x0.
> Event Xml:
> <Event xmlns=3D"http://schemas.microsoft.com/win/2004/08/events/event=
">
> =A0<System>
> =A0 =A0<Provider Name=3D"Microsoft-Windows-UserPnp"
> Guid=3D"{96F4A050-7E31-453C-88BE-9634F4E02139}" />
> =A0 =A0<EventID>20001</EventID>
> =A0 =A0<Version>0</Version>
> =A0 =A0<Level>4</Level>
> =A0 =A0<Task>7005</Task>
> =A0 =A0<Opcode>0</Opcode>
> =A0 =A0<Keywords>0x8000000000000000</Keywords>
> =A0 =A0<TimeCreated SystemTime=3D"2010-08-30T17:58:58.867600000Z" />
> =A0 =A0<EventRecordID>6846</EventRecordID>
> =A0 =A0<Correlation />
> =A0 =A0<Execution ProcessID=3D"3228" ThreadID=3D"3260" />
> =A0 =A0<Channel>System</Channel>
> =A0 =A0<Computer>WIN-6EB0ETQ8M85</Computer>
> =A0 =A0<Security UserID=3D"S-1-5-18" />
> =A0</System>
> =A0<UserData>
> =A0 =A0<InstallDeviceID
> xmlns:auto-ns2=3D"http://schemas.microsoft.com/win/2004/08/events"
> xmlns=3D"http://manifests.microsoft.com/win/2004/08/windows/userpnp">
> =A0 =A0 =A0<DriverName>FileRepository\disk.inf_amd64_neutral_10ce25bb=
c5a9cc43\disk.inf</DriverName>
> =A0 =A0 =A0<DriverVersion>6.1.7600.16385</DriverVersion>
> =A0 =A0 =A0<DriverProvider>Microsoft</DriverProvider>
> =A0 =A0 =A0<DeviceInstanceID>SCSI\DISK&amp;VEN_SCST_BIO&amp;PROD_FIO-=
41001\000007</DeviceInstanceID>
> =A0 =A0 =A0<SetupClass>{4D36E967-E325-11CE-BFC1-08002BE10318}</SetupC=
lass>
> =A0 =A0 =A0<RebootOption>false</RebootOption>
> =A0 =A0 =A0<UpgradeDevice>false</UpgradeDevice>
> =A0 =A0 =A0<IsDriverOEM>false</IsDriverOEM>
> =A0 =A0 =A0<InstallStatus>0x0</InstallStatus>
> =A0 =A0 =A0<DriverDescription>Disk drive</DriverDescription>
> =A0 =A0</InstallDeviceID>
> =A0</UserData>
> </Event>
>
> Log Name: =A0 =A0 =A0System
> Source: =A0 =A0 =A0 =A0Disk
> Date: =A0 =A0 =A0 =A0 =A08/30/2010 11:58:58 AM
> Event ID: =A0 =A0 =A011
> Task Category: None
> Level: =A0 =A0 =A0 =A0 Error
> Keywords: =A0 =A0 =A0Classic
> User: =A0 =A0 =A0 =A0 =A0N/A
> Computer: =A0 =A0 =A0WIN-6EB0ETQ8M85
> Description:
> The driver detected a controller error on \Device\Harddisk8\DR8.
> Event Xml:
> <Event xmlns=3D"http://schemas.microsoft.com/win/2004/08/events/event=
">
> =A0<System>
> =A0 =A0<Provider Name=3D"Disk" />
> =A0 =A0<EventID Qualifiers=3D"49156">11</EventID>
> =A0 =A0<Level>2</Level>
> =A0 =A0<Task>0</Task>
> =A0 =A0<Keywords>0x80000000000000</Keywords>
> =A0 =A0<TimeCreated SystemTime=3D"2010-08-30T17:58:58.789600000Z" />
> =A0 =A0<EventRecordID>6845</EventRecordID>
> =A0 =A0<Channel>System</Channel>
> =A0 =A0<Computer>WIN-6EB0ETQ8M85</Computer>
> =A0 =A0<Security />
> =A0</System>
> =A0<EventData>
> =A0 =A0<Data>\Device\Harddisk8\DR8</Data>
> =A0 =A0<Binary>0F00800001000000000000000B0004C00301000000000000000000=
00000000000000000000000000822B000000000000FFFFFFFF060000005800000302000=
007FE200A124A012000080000003C00000050B39D0280F8FFFFB84B962D80FAFFFF0000=
00000000000070C8992D80FAFFFF0000000000000000000000000000000025000000000=
000000000000000000000000000000000000000000000000000000000000000000000</=
Binary>
> =A0</EventData>
> </Event>
>
> Chris
> On Fri, Aug 27, 2010 at 6:10 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> On Fri, Aug 27, 2010 at 6:01 PM, Sufficool, Stanley
>> <ssufficool-AmqEsPSg0VfuwJLVJmOTOA@public.gmane.org> wrote:
>>> What does your scst.conf look like? I assume you have LUNS in the d=
efault group.
>>
>> A Linux initiator has no trouble seeing these:
>>
>> # cat /proc/scsi_tgt/vdisk/vdisk
>> Name =A0 =A0 =A0 =A0 =A0 =A0 =A0Size(MB) =A0 =A0Block size =A0Option=
s =A0 =A0 =A0 =A0 File name
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 T10 =
device id
>> fio-71957 =A0 =A0 =A0 =A0 76774 =A0 =A0 =A0 512 =A0 =A0 =A0 =A0 NV B=
IO =A0 =A0 =A0 =A0 =A0/dev/sda
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fio-7=
1957 8d58d2cc
>> fio-71962 =A0 =A0 =A0 =A0 76774 =A0 =A0 =A0 512 =A0 =A0 =A0 =A0 NV B=
IO =A0 =A0 =A0 =A0 =A0/dev/sdb
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fio-7=
1962 4ab477ef
>> fio-71965 =A0 =A0 =A0 =A0 76774 =A0 =A0 =A0 512 =A0 =A0 =A0 =A0 NV B=
IO =A0 =A0 =A0 =A0 =A0/dev/sdc
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fio-7=
1965 28ba5c58
>> fio-71964 =A0 =A0 =A0 =A0 76774 =A0 =A0 =A0 512 =A0 =A0 =A0 =A0 NV B=
IO =A0 =A0 =A0 =A0 =A0/dev/sdd
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fio-7=
1964 f2c69cf6
>> fio-41000 =A0 =A0 =A0 =A0 76774 =A0 =A0 =A0 512 =A0 =A0 =A0 =A0 NV B=
IO =A0 =A0 =A0 =A0 =A0/dev/sde
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fio-4=
1000 2492daab
>> fio-41002 =A0 =A0 =A0 =A0 76774 =A0 =A0 =A0 512 =A0 =A0 =A0 =A0 NV B=
IO =A0 =A0 =A0 =A0 =A0/dev/sdf
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fio-4=
1002 dd797f32
>> fio-40948 =A0 =A0 =A0 =A0 76774 =A0 =A0 =A0 512 =A0 =A0 =A0 =A0 NV B=
IO =A0 =A0 =A0 =A0 =A0/dev/sdg
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fio-4=
0948 a3ef7aa3
>> fio-41001 =A0 =A0 =A0 =A0 76774 =A0 =A0 =A0 512 =A0 =A0 =A0 =A0 NV B=
IO =A0 =A0 =A0 =A0 =A0/dev/sdh
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fio-4=
1001 543b6d8e
>> [root@fusion-io-live .bak]# cat /proc/scsi_tgt/groups/Default/device=
s
>> Device (host:ch:id:lun or name) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 LUN =A0 =A0 =A0 =A0 =A0Options
>> fio-71957 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0
>> fio-71962 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1
>> fio-71965 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2
>> fio-71964 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 3
>> fio-41000 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 4
>> fio-41002 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 5
>> fio-40948 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 6
>> fio-41001 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 7
>>
>> (Adding scst-devel, as it looks like Windows logs in then immediatel=
y
>> logs out or is forced out.)
>>
>> Thanks,
>>
>> Chris
>>
>>>
>>>>-----Original Message-----
>>>>From: ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>>>[mailto:ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Chris Worle=
y
>>>>Sent: Friday, August 27, 2010 4:46 PM
>>>>To: OFED mailing list
>>>>Cc: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>>>Subject: Re: [ofw] What is an IOC device ID and what is DriverStore
>>>>
>>>>
>>>>I'm resending this as plain text, as the
>>>>linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org mailing list did not like my
>>>>attempt to make the messages readable...
>>>>
>>>>On Fri, Aug 27, 2010 at 5:43 PM, Chris Worley
>>>><worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>
>>>>> On Fri, Aug 27, 2010 at 5:02 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>> wrote:
>>>>> > On Fri, Aug 27, 2010 at 4:45 PM, Sufficool, Stanley
>>>>> > <ssufficool-AmqEsPSg0VfuwJLVJmOTOA@public.gmane.org> wrote:
>>>>> >>
>>>>> >>
>>>>> >>>-----Original Message-----
>>>>> >>>From: ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>>>> >>>[mailto:ofw-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Chris
>>>>> >>>Worley
>>>>> >>>Sent: Friday, August 27, 2010 1:52 PM
>>>>> >>>To: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org; OFED mailing list
>>>>> >>>Subject: [ofw] What is an IOC device ID and what is DriverStor=
e
>>>>> >>>
>>>>> >>>
>>>>> >>>In scouring the many manuals with the Window's IB drivers
>>>>I found a
>>>>> >>>clue as to why I can't get SRP working in WinOF:
>>>>> >>>
>>>>> >>> =A0Windows PNP (Plug-n-Play) will match the IOC device ID wit=
h
>>>>> >>>DriverStore installed drives and then will load the IBiou.sys
>>>>> >>>driver
>>>>> >>>
>>>>> >>>How do I set the "IOC device ID" and what is DriverStore?
>>>>> >>
>>>>> >> Not sure what this is, but I have never had to set any values =
on
>>>>> >> the OFED-W initiator.
>>>>> >>
>>>>> >>>
>>>>> >>>I can make the Windows SRP miniport devices appear and
>>>>disappear by
>>>>> >>>removing/reloading ib_srpt on the target (at least with the 2.=
1.1
>>>>> >>>driver from Mellanox; the latest at openfabrics.org panics the
>>>>> >>>WS2008R2 system when ib_srpt is rmmod'ed).
>>>>> >>>
>>>>> >>>Beyond that, Windows never sees the drives... Linux initiators
>>>>> >>>don't have an issue.
>>>>> >>
>>>>> >> What messages do you get on the target? It it even receiving t=
he
>>>>> >> request?
>>>>> >
>>>>> > Yes:
>>>>> >
>>>>> > ib_srpt: ***ERROR***: received unrecognized IB CM event 10
>>>>> > ib_srpt: Received DREQ and sent DREP for session
>>>>> > 0x00247100000002c100247100000003d8.
>>>>> > ib_srpt: Received SRP_LOGIN_REQ with i_port_id
>>>>> > 0x247100000002c1:0x247100000003d8, t_port_id
>>>>> > 0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 1
>>>>> > (guid=3D0xfe80000000000000:0x247100000002bf)
>>>>> > ib_srpt: disconnected session 0x00247100000002c100247100000003d=
8
>>>>> > because a new SRP_LOGIN_REQ has been received.
>>>>> > ib_srpt: Session : kernel thread ib_srpt_compl (PID 31542) star=
ted
>>>>> > scst: Using security group "Default" for initiator
>>>>> > "0x00247100000002c100247100000003d8"
>>>>>
>>>>> There is more to it than that. =A0I'm going to do this as HTML
>>>>so I can
>>>>> fix the font:
>>>>>
>>>>> ib_srpt: Received SRP_LOGIN_REQ with i_port_id
>>>>> 0x247100000002c1:0x247100000003d8, t_port_id
>>>>0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 2
>>>>(guid=3D0xfe80000000000000:0x247100000002c3)
>>>>> ib_srpt: Session : kernel thread ib_srpt_compl (PID 1109) started
>>>>> scst: Using security group "Default" for initiator
>>>>"0x00247100000002c100247100000003d8"
>>>>> scst: Processing thread fio-719570_0 (PID 1110) started
>>>>> scst: Processing thread fio-719570_1 (PID 1111) started
>>>>> scst: Processing thread fio-719620_0 (PID 1112) started
>>>>> scst: Processing thread fio-719620_1 (PID 1113) started
>>>>> scst: Processing thread fio-719650_0 (PID 1114) started
>>>>> scst: Processing thread fio-719650_1 (PID 1115) started
>>>>> scst: Processing thread fio-719640_0 (PID 1116) started
>>>>> scst: Processing thread fio-719640_1 (PID 1117) started
>>>>> scst: Processing thread fio-410000_0 (PID 1118) started
>>>>> scst: Processing thread fio-410000_1 (PID 1119) started
>>>>> scst: Processing thread fio-410020_0 (PID 1120) started
>>>>> scst: Processing thread fio-410020_1 (PID 1121) started
>>>>> scst: Processing thread fio-409480_0 (PID 1122) started
>>>>> scst: Processing thread fio-409480_1 (PID 1123) started
>>>>> scst: Processing thread fio-410010_0 (PID 1124) started
>>>>> scst: Processing thread fio-410010_1 (PID 1125) started
>>>>> ib_srpt: ***ERROR***: received unrecognized IB CM event 10
>>>>> ib_srpt: Received DREQ and sent DREP for session
>>>>0x00247100000002c100247100000003d8.
>>>>> ib_srpt: Received InfiniBand TimeWait exit for cm_id
>>>>ffff81030b7c6c00.
>>>>> ib_srpt: Session 0x00247100000002c100247100000003d8: kernel
>>>>thread ib_srpt_compl (PID 1109) stopped
>>>>> scst: Processing thread fio-719570_0 (PID 1110) finished
>>>>> scst: Processing thread fio-719570_1 (PID 1111) finished
>>>>> scst: Processing thread fio-719620_0 (PID 1112) finished
>>>>> scst: Processing thread fio-719620_1 (PID 1113) finished
>>>>> scst: Processing thread fio-719650_0 (PID 1114) finished
>>>>> scst: Processing thread fio-719650_1 (PID 1115) finished
>>>>> scst: Processing thread fio-719640_0 (PID 1116) finished
>>>>> scst: Processing thread fio-719640_1 (PID 1117) finished
>>>>> scst: Processing thread fio-410000_0 (PID 1118) finished
>>>>> scst: Processing thread fio-410000_1 (PID 1119) finished
>>>>> scst: Processing thread fio-410020_0 (PID 1120) finished
>>>>> scst: Processing thread fio-410020_1 (PID 1121) finished
>>>>> scst: Processing thread fio-409480_0 (PID 1122) finished
>>>>> scst: Processing thread fio-409480_1 (PID 1123) finished
>>>>> scst: Processing thread fio-410010_0 (PID 1124) finished
>>>>> scst: Processing thread fio-410010_1 (PID 1125) finished
>>>>> ib_srpt: Received SRP_LOGIN_REQ with i_port_id
>>>>0x247100000002c1:0x24710000000390, t_port_id
>>>>0x247100000002c1:0x247100000002c1 and it_iu_len 4148 on port 2
>>>>(guid=3D0xfe80000000000000:0x247100000002c0)
>>>>> ib_srpt: Session : kernel thread ib_srpt_compl (PID 1138) started
>>>>> scst: Using security group "Default" for initiator
>>>>"0x00247100000002c10024710000000390"
>>>>> scst: Processing thread fio-719570_0 (PID 1139) started
>>>>> scst: Processing thread fio-719570_1 (PID 1140) started
>>>>> scst: Processing thread fio-719620_0 (PID 1141) started
>>>>> scst: Processing thread fio-719620_1 (PID 1142) started
>>>>> scst: Processing thread fio-719650_0 (PID 1143) started
>>>>> scst: Processing thread fio-719650_1 (PID 1144) started
>>>>> scst: Processing thread fio-719640_0 (PID 1145) started
>>>>> scst: Processing thread fio-719640_1 (PID 1146) started
>>>>> scst: Processing thread fio-410000_0 (PID 1147) started
>>>>> scst: Processing thread fio-410000_1 (PID 1148) started
>>>>> scst: Processing thread fio-410020_0 (PID 1149) started
>>>>> scst: Processing thread fio-410020_1 (PID 1150) started
>>>>> scst: Processing thread fio-409480_0 (PID 1151) started
>>>>> scst: Processing thread fio-409480_1 (PID 1152) started
>>>>> scst: Processing thread fio-410010_0 (PID 1153) started
>>>>> scst: Processing thread fio-410010_1 (PID 1154) started
>>>>> ib_srpt: ***ERROR***: received unrecognized IB CM event 10
>>>>> ib_srpt: Received DREQ and sent DREP for session
>>>>0x00247100000002c10024710000000390.
>>>>> ib_srpt: Received InfiniBand TimeWait exit for cm_id
>>>>ffff810191ae5400.
>>>>> ib_srpt: Session 0x00247100000002c10024710000000390: kernel
>>>>thread ib_srpt_compl (PID 1138) stopped
>>>>> scst: Processing thread fio-719570_0 (PID 1139) finished
>>>>> scst: Processing thread fio-719570_1 (PID 1140) finished
>>>>> scst: Processing thread fio-719620_0 (PID 1141) finished
>>>>> scst: Processing thread fio-719620_1 (PID 1142) finished
>>>>> scst: Processing thread fio-719650_0 (PID 1143) finished
>>>>> scst: Processing thread fio-719650_1 (PID 1144) finished
>>>>> scst: Processing thread fio-719640_0 (PID 1145) finished
>>>>> scst: Processing thread fio-719640_1 (PID 1146) finished
>>>>> scst: Processing thread fio-410000_0 (PID 1147) finished
>>>>> scst: Processing thread fio-410000_1 (PID 1148) finished
>>>>> scst: Processing thread fio-410020_0 (PID 1149) finished
>>>>> scst: Processing thread fio-410020_1 (PID 1150) finished
>>>>> scst: Processing thread fio-409480_0 (PID 1151) finished
>>>>> scst: Processing thread fio-409480_1 (PID 1152) finished
>>>>> scst: Processing thread fio-410010_0 (PID 1153) finished
>>>>> scst: Processing thread fio-410010_1 (PID 1154) finished
>>>>>
>>>>> While I do have two HCA's in both the target and initiator, I hav=
e
>>>>> tried it with just one in the initiator.
>>>>>
>>>>> Hopefully that doesn't cause the email to bounce and makes it mor=
e
>>>>> readable.
>>>>>
>>>>> Thanks,
>>>>>
>>>>> Chris
>>>>> >
>>>>> >>
>>>>> >> Does windows disk management show a broken LUN?
>>>>> >
>>>>> > No. =A0Nothing (except local drives).
>>>>> >>
>>>>> >>>
>>>>> >>>Someone throw me a bone! =A0The SRP initiator seems to have be=
en
>>>>> >>>broken for many months on WinDoh's.
>>>>> >>
>>>>> >> I have had no problems with the SRP initiator as long as I sta=
rt
>>>>> >> the target _after_ the windows systems boot.
>>>>> >
>>>>> > I've tried five different revs of the Windows driver, and
>>>>no drives
>>>>> > are seen.
>>>>> >
>>>>> > Thanks,
>>>>> >
>>>>> > Chris
>>>>> >>
>>>>> >>>
>>>>> >>>Thanks,
>>>>> >>>
>>>>> >>>Chris
>>>>> >>>_______________________________________________
>>>>> >>>ofw mailing list
>>>>> >>>ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>>>> >>>http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>>>>> >>>
>>>>> >>
>>>>> >
>>>>>
>>>>_______________________________________________
>>>>ofw mailing list
>>>>ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>>>http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
