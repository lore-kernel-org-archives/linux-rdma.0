From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow	reads
	and eventually hangs
Date: Tue, 15 Sep 2009 21:10:15 +0400
Message-ID: <4AAFCA77.6050305@vlnb.net>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>	<e2e108260909090938x6b72c519teed7dfd280eac804@mail.gmail.com>	<f3177b9e0909111250w159def51h9b720366e27fa3a7@mail.gmail.com>	<4AAE909F.6030202@vlnb.net>	<f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4@mail.gmail.com>	<e2e108260909142310vb353718uea99d50ab638a865@mail.gmail.com>	<f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed@mail.gmail.com>	<4AAFC42D.4030708@vlnb.net>	<f3177b9e0909150953x11d19210mf07cbdcc57928d42@mail.gmail.com>	<4AAFC794.7090205@vlnb.net>
	<f3177b9e0909151001i61027dd9y282e2f98a8f05b03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <f3177b9e0909151001i61027dd9y282e2f98a8f05b03@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Chris Worley <worleys@gmail.com>
Cc: linux-rdma@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, OpenIB <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

Chris Worley, on 09/15/2009 09:01 PM wrote:
> On Tue, Sep 15, 2009 at 10:57 AM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> Chris Worley, on 09/15/2009 08:53 PM wrote:
>>> On Tue, Sep 15, 2009 at 10:43 AM, Vladislav Bolkhovitin <vst@vlnb.net>
>>> wrote:
>>>> Chris Worley, on 09/15/2009 07:50 PM wrote:
>>>>> On Tue, Sep 15, 2009 at 12:10 AM, Bart Van Assche
>>>>> <bart.vanassche@gmail.com> wrote:
>>>>>> On Tue, Sep 15, 2009 at 1:03 AM, Chris Worley <worleys@gmail.com>
>>>>>> wrote:
>>>>>>> On Mon, Sep 14, 2009 at 12:51 PM, Vladislav Bolkhovitin <vst@vlnb.net>
>>>>>>> wrote:
>>>>>>>> Chris Worley, on 09/11/2009 11:50 PM wrote:
>>>>>>>>> I've definitely removed the switch/firmware from being the cause.
>>>>>>>>>
>>>>>>>>> I'm thinking the reason you can't repeat the test may be latency
>>>>>>>>> related.  We get ~50usecs average latency (on small block sizes),
>>>>>>>>> which can't be achieved using regular SSD's (and rotating drives are
>>>>>>>>> nowhere close).  Maybe a ramdisk would help repeat the issue.
>>>>>>>> I think you should try to reproduce the problem with ramdisk or
>>>>>>>> nullio.
>>>>>>>> By
>>>>>>>> so you will eliminate possible influence of the SSD backend.
>>>>>>> W/ 12GB RAM in the target, I created a 7GB ramdisk:
>>>>>>>
>>>>>>> mount -t ramfs -o size=7g ramfs /mnt/
>>>>>>> dd if=/dev/zero of=/mnt/foo bs=1024k count=7000
>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
>>>>>>>
>>>>>>> Then, on the initiator, I tested it... and it hung during sequential
>>>>>>> 8KB block reads:
>>>>>>>
>>>>>>> fio --rw=read --bs=8k --numjobs=64 --iodepth=64 --sync=0 --direct=1
>>>>>>> --randrepeat=0 \
>>>>>>>  --group_reporting --ioengine=libaio --filename=/dev/sde --name=test
>>>>>>> --loops=10000 --runtime=600
>>>>>>>
>>>>>>> Note that I was running the SM on the target this time too.
>>>>>> Which Linux distro was installed on the inititiator and on the target
>>>>>> ? And if applicable, which OFED version ? Which kernel messages were
>>>>>> logged by SRPT around the time the issue occurred (after having
>>>>>> enabled SRPT logging first) ?
>>>>> As logging hadn't helped this issue previously, I've not been enabling
>>>>> it.  That plus the kernel hacks needed to invoke logging, it's not
>>>>> worth enabling.
>>>>>
>>>>> This was with Ubuntu 8.10, built-in IB on the 2.6.27-14-server kernel.
>>>>>
>>>>> I couldn't get ramdisks working w/ SCST in RHEL5.2.  When running:
>>>>>
>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>
>>>>> I get the error:
>>>>>
>>>>> dev_vdisk: ***ERROR***: Wrong f_op or FS doesn't have required
>>>>> capabilities
>>>>>
>>>>> ... which doesn't occur in the Ubuntu kernel, so I've been unable to
>>>>> test RHEL kernels w/ ramdisks.  In general, this problem occurs w/ 8KB
>>>>> and smaller blocks w/ the Ubuntu kernels, and 2KB and smaller blocks
>>>>> w/ RHEL kernels.
>>>> Use ramfs instead.
>>> Do you mean:
>>>
>>> mount -t ramfs -o size=7g ramfs /mnt/
>> You should then create a file on it and use it.
> 
> That's what I'm doing, I believe.  From above:
> 
>>>>>>> mount -t ramfs -o size=7g ramfs /mnt/
>>>>>>> dd if=/dev/zero of=/mnt/foo bs=1024k count=7000
>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
> 
> ... but the "open", on RHEL5.2 kernel 2.6.18-92.el5, generates the
> following kernel messages:
> 
> dev_vdisk: Registering virtual FILEIO device ramdisk
> scst: Processing thread started, PID 9629
> scst: Processing thread started, PID 9630
> scst: Processing thread started, PID 9631
> scst: Processing thread started, PID 9632
> scst: Processing thread started, PID 9633
> dev_vdisk: ***ERROR***: Wrong f_op or FS doesn't have required capabilities
> scst: ***ERROR***: New device handler's vdisk attach() failed: -22
> scst: Processing thread PID 9629 finished
> scst: Processing thread PID 9630 finished
> scst: Processing thread PID 9631 finished
> scst: Processing thread PID 9632 finished
> scst: Processing thread PID 9633 finished
> scst: Failed to attach to virtual device ramdisk
> 
> Chris
>>> ?
>>>
>>> That's what I'm doing.

That's strange. I'm doing it all the time, although with not so old 
kernels as 2.6.18.

>>> Chris
>>>>> Chris
>>>>>> Bart.
