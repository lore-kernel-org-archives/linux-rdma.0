From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRPT and SCST
Date: Thu, 5 Nov 2009 19:34:17 +0100
Message-ID: <e2e108260911051034o43db58cdi65b84ce46219bb94@mail.gmail.com>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com>
	 <f3177b9e0911040802o7fce0f4fte02c52dfe940f582@mail.gmail.com>
	 <3142CEFB1403044F9954E2DF6C85660FBB34BF@orca.penguincomputing.com>
	 <f3177b9e0911041004t2e75d545v5cc10d5375550bde@mail.gmail.com>
	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4DD@orca.penguincomputing.com>
	 <4AF29201.6000606@penguincomputing.com> <4AF2D2B8.5080304@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF2D2B8.5080304-d+Crzxg7Rs0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arend Dittmer <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 5, 2009 at 2:27 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wr=
ote:
>
> Philip Pokorny, on 11/05/2009 11:51 AM wrote:
>>
>> Chris Worley asked that we post this to scst and linux-rdma lists fo=
r discussion.
>>
>> We're trying to get IB SRPT working and can't seem to get a stable c=
onfiguration using any of the various SCST, IB_SRPT, and kernel/distro =
versions out there. =A0In most cases, we're able to crash the connectio=
n and typically the target within minutes of pounding by 4 initiators d=
oing "mkfs.ext3", "tar xf" and "fsck" to the SRP block device.
>>
>> Our target is a Penguin Computing Altus 2704 with disk expansion cha=
ssis. =A0That's a 4-socket AMD hex-core (24 total cores) with 128GB of =
memory and 24 1TB drives attached to two LSI 1068 SAS controllers. (aka=
 3801E) =A0The drives are configured as 12 RAID-1 mirrors and 3-wide LV=
M stripes over those mirrors. =A0There are an additional 6 SSD's in the=
 server in a "fast" VG also RAID-1 mirrored and LVM striped. =A0Read ah=
ead is disabled on the LVM volumes.
>>
>> LVM volumes are exported via SCST as FILEIO block devices to initiat=
ors. =A050 groups are defined with two LVM volumes/block devices per gr=
oup. One initiator per group. (NODE GUID added to "names" in the group)
>>
>> With only 4 initiators, almost 100% of I/O is to RAM and no disk I/O=
 is seen on the target.
>>
>> Performance (when it's working) is generally good at 800MB/sec aggre=
gate, but we'd like to see better. =A0It appeared we were getting 1.3GB=
/s at one point.
>>
>> On Wed, Nov 4, 2009 at 5:34 PM, Philip Pokorny
>> <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
>>>
>>> We got a serial console attached and ran a test using the SCST and =
IB_SRPT
>>> versions that you recommended (Arend set it up so I'll defer to him=
 on the
>>> exact SVN checkout that he used).
>>>
>>>> What sort of crashes are you seeing? =A0I also have a customer
>>>> experiencing a crash, but I can't get details out of them.
>>>
>>> The client gets SCSI I/O errors and aborts the filesystem (putting =
it in
>>> read-only mode).
>>>
>>> After about 400 seconds of testing, the server side logs the follow=
ing:
>>>
>>> [ 8418.697830] <6>[12426]: scst_check_sense:2444:Clearing dbl_ua_po=
ssible
>>> flag (dev ffff811816136000, cmd ffff81081017c1c8)
>>> [ 8418.697836] <6>[12426]: scst_dec_on_dev_cmd:577:cmd ffff81081017=
c1c8 (tag
>>> 17): unblocking dev ffff811816136000
>>> [ 8418.697843] <6>[0]: scst_unblock_dev:4653:Device UNBLOCK(new 0),=
 dev
>>> ffff811816136000
>>> [ 8864.258468] ib_mthca 0000:81:00.0: SQ 000405 full (999320 head, =
997272
>>> tail, 2048 max, 0 nreq)
>>> [ 8864.294450] ***ERROR***: srpt_xfer_data[2374] ret=3D-12
>>> [ 8864.326702] <6>[0]: scst_queue_retry_cmd:1099:TGT QUEUE FULL:
>>> incrementing retry_cmds 1
>>> [ 8864.326709] <6>[0]: scst_queue_retry_cmd:1106:Some command(s) fi=
nished,
>>> direct retry (finished_cmds=3D2023031, tgt->finished_cmds=3D2023137=
,
>>> retry_cmds=3D0)
>>> [ 8878.447081] ib_mthca 0000:81:00.0: SQ 000406 full (1080498 head,=
 1078450
>>> tail, 2048 max, 0 nreq)
>>> [ 8878.484452] ***ERROR***: srpt_xfer_data[2374] ret=3D-12
>>> [ 8878.517595] <6>[0]: scst_queue_retry_cmd:1099:TGT QUEUE FULL:
>>> incrementing retry_cmds 1
>>> [ 8878.517608] <6>[0]: scst_queue_retry_cmd:1106:Some command(s) fi=
nished,
>>> direct retry (finished_cmds=3D2256307, tgt->finished_cmds=3D2256504=
,
>>> retry_cmds=3D0)
>>> [ 8882.694684] ib_mthca 0000:81:00.0: SQ 000404 full (1087484 head,=
 1085436
>>> tail, 2048 max, 0 nreq)
>>> [ 8882.732542] ***ERROR***: srpt_xfer_data[2374] ret=3D-12
>>> [ 8882.766396] <6>[0]: scst_queue_retry_cmd:1099:TGT QUEUE FULL:
>>> incrementing retry_cmds 1
>>> [ 8882.766403] <6>[0]: scst_queue_retry_cmd:1106:Some command(s) fi=
nished,
>>> direct retry (finished_cmds=3D2310445, tgt->finished_cmds=3D2310539=
,
>>> retry_cmds=3D0)
>>> [ 8891.650890] ib_mthca 0000:81:00.0: SQ 000407 full (1155377 head,=
 1153329
>>> tail, 2048 max, 0 nreq)
>>> [ 8891.689016] ***ERROR***: srpt_xfer_data[2374] ret=3D-12
>>> [ 8891.723548] <6>[0]: scst_queue_retry_cmd:1099:TGT QUEUE FULL:
>>> incrementing retry_cmds 1
>>> [ 8891.723556] <6>[0]: scst_queue_retry_cmd:1106:Some command(s) fi=
nished,
>>> direct retry (finished_cmds=3D2381910, tgt->finished_cmds=3D2382001=
,
>>> retry_cmds=3D0)
>>> [ 8891.723573] ib_mthca 0000:81:00.0: too many gathers
>>> [ 8891.758000] ***ERROR***: srpt_xfer_data[2374] ret=3D-22
>>> [ 8891.792888] <6>[0]: scst: scst_rdy_to_xfer:985:***ERROR***: Targ=
et driver
>>> ib_srpt rdy_to_xfer() returned fatal error
>>>
>>> I hope that helps.
>>>
>>> I've seen that same "rdy_to_xfer() returned fatal error several tim=
es in
>>> different configurations. =A0The screen shots we sent earlier had t=
he same
>>> "ib_mthca ... SQ ... full (xx head..." message at the start. =A0So =
that seems
>>> to be related as well.
>
> Looks like ib_post_send() in srpt_perform_rdmas() returned ENOMEM and=
 then srpt_xfer_data() "forgot" to unmapped corresponding SG with all r=
elated consequences.

I would like to add the following to the above analysis:
* The function srpt_xfer_data() calls srpt_perform_rdmas(). The last
function calls ib_post_send() repeatedly. ib_post_send() can fail
because the work queue on which the send request should be posted is
full. When processing an sg list with multiple entries, it is possible
that some entries get posted to the work queue and some not.
* If this happens, the last send posted on the work queue won't
trigger a completion event (this is a bug in srpt_perform_rdmas()).
* If the srpt_perform_rdmas() call inside srpt_xfer_data() fails, it
is possible that some of the sg list entries have been posted on the
IB work queue and some not. So error recovery will be more complex
than just a single call to ib_dma_unmap_sg().

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
