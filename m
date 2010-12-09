From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: Re: NFS-RDMA hangs: connection closed (-103)
Date: Thu, 09 Dec 2010 09:25:05 -0600
Message-ID: <4D00F4D1.9050501@ogc.us>
References: <4CF6D69B.4030501@shiftmail.org> <4CF6E144.1080200@opengridcomputing.com> <4CF78E0E.2040308@shiftmail.org> <ada39qgm36k.fsf@cisco.com> <4CF7EEE0.9030408@shiftmail.org> <4CFE5CF1.6020806@opengridcomputing.com> <4CFF9FE4.5010705@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFF9FE4.5010705-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Spelic <spelic-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/8/10 9:10 AM, Spelic wrote:
> Tom, have you reproduced the "RDMA hangs - connection closes" bug or 
> the "sparse file at server side upon NFS hitting ENOSPC" ?
>
> Because for the latter people have already given exhaustive 
> explanation: see this other thread at 
> http://fossplanet.com/f13/%5Blinux-lvm%5D-bugs-mkfs-xfs-device-mapper-xfs-dev-ram-81653/ 
>
>
> While the former bug is still open and very interesting for us.
>
I'm working on the 'former' bug. The bug that I think you've run in to 
with how RDMA transport errors are handled and how RPC are retried in 
the event of an error. With hard mounts (which I'm suspecting you have), 
the RPC will be retried forever. In this bug, the transport never 
'recovers' after the error and therefore the RPC never succeeds and the 
mount is effectively hung.

There were bugs fixed in this area between 34 and top which is why you 
saw the less catastrophic, but still broken behavior you see now.

Unfortunately I can only support this part-time, but I'll keep you 
updated on the progress.

Thanks for finding this and helping to debug,
Tom

> Thanks for your help
> S.
>
>
> On 12/07/2010 05:12 PM, Tom Tucker wrote:
>> Status update...
>>
>> I have reproduced the bug a number of different ways. It seems to be 
>> most easily reproduced by simply writing more data than the 
>> filesystem has space for. I can do this reliably with any FS. I think 
>> the XFS bug may have tickled this bug somehow.
>>
>> Tom
>>
>> On 12/2/10 1:09 PM, Spelic wrote:
>>> Hello all
>>> please be aware that the "file oversize" bug is reproducible also 
>>> without infiniband, with just nfs over ethernet over xfs over 
>>> ramdisk (but it doesn't hang, so it's a different bug than the one I 
>>> posted here at the RDMA mailing list)
>>> I have posted another thread regarding the "file oversize" bug, 
>>> which you can read in the LVM, XFS, and LKML mailing lists, please 
>>> have a look
>>> http://fossplanet.com/f13/%5Blinux-lvm%5D-bugs-mkfs-xfs-device-mapper-xfs-dev-ram-81653/ 
>>>
>>> Especially my second post, replying myself at +30 minutes, explains 
>>> that it's reproducible also with ethernet.
>>>
>>> Thank you
>>>
>>> On 12/02/2010 07:37 PM, Roland Dreier wrote:
>>>> Adding Dave Chinner to the cc list, since he's both an XFS guru as 
>>>> well
>>>> as being very familiar with NFS and RDMA...
>>>>
>>>> Dave, if you read below, it seems there is some strange behavior
>>>> exporting XFS with NFS/RDMA.
>>>>
>>>>   - R.
>>>>
>>>> >  On 12/02/2010 12:59 AM, Tom Tucker wrote:
>>>> > >  Spelic,
>>>> > >
>>>> > >  I have seen this problem before, but have not been able to 
>>>> reliably
>>>> > >  reproduce it. When I saw the problem, there were no transport 
>>>> errors
>>>> > >  and it appeared as if the I/O had actually completed, but that 
>>>> the
>>>> > >  waiter was not being awoken. I was not able to reliably reproduce
>>>> > >  the problem and was not able to determine if the problem was a
>>>> > >  latent bug in NFS in general or a bug in the RDMA transport in
>>>> > >  particular.
>>>> > >
>>>> > >  I will try your setup here, but I don't have a system like 
>>>> yours so
>>>> > >  I'll have to settle for a smaller ramdisk, however, I have a few
>>>> > >  questions:
>>>> > >
>>>> > >  - Does the FS matter? For example, can you use ext[2-4] on the
>>>> > >  ramdisk and not still reproduce
>>>> > >  - As I mentioned earlier NFS v3 vs. NFS v4
>>>> > >  - RAMDISK size, i.e. 2G vs. 14G
>>>> > >
>>>> > >  Thanks,
>>>> > >  Tom
>>>> >
>>>> >  Hello Tom, thanks for replying
>>>> >
>>>> >  - The FS matters to some extent: as I wrote, with ext4 it's not
>>>> >  possible to reproduce the bug in this way, so immediately and
>>>> >  reliably, however ext4 also will hang eventually if you work on 
>>>> it for
>>>> >  hours so I had to switch to IPoIB for our real work; reread my
>>>> >  previous post.
>>>> >
>>>> >  - NFS3 not tried yet. Never tried to do RDMA on NFS3... do you 
>>>> have a
>>>> >  pointer on instructions?
>>>> >
>>>> >
>>>> >  - RAMDISK size: I am testing it.
>>>> >
>>>> >  Ok I confirm with 1.5GB ramdisk it's reproducible.
>>>> >  boot option ramdisk_size=1572864
>>>> >  (1.5*1024**2=1572864.0)
>>>> >  confirm: blockdev --getsize64 /dev/ram0 == 1610612736
>>>> >
>>>> >  now at server side mkfs and mount with defaults:
>>>> >  mkfs.xfs /dev/ram0
>>>> >  mount /dev/ram0 /mnt/ram
>>>> >  (this is a simplification over my previous email, and it's 
>>>> needed with
>>>> >  a smaller ramdisk or mkfs.xfs will refuse to work. The bug is still
>>>> >  reproducible like this)
>>>> >
>>>> >
>>>> >  DOH! another bug:
>>>> >  It's strange how at the end of the test
>>>> >      ls -lh /mnt/ram
>>>> >  at server side will show a zerofile larger than 1.5GB at the end of
>>>> >  the procedure, sometimes it's 3GB, sometimes it's 2.3GB... but it's
>>>> >  larger than the ramdisk size.
>>>> >
>>>> >  # ll -h /mnt/ram
>>>> >  total 1.5G
>>>> >  drwxr-xr-x 2 root root   21 2010-12-02 12:54 ./
>>>> >  drwxr-xr-x 3 root root 4.0K 2010-11-29 23:51 ../
>>>> >  -rw-r--r-- 1 root root 2.3G 2010-12-02 12:59 zerofile
>>>> >  # df -h
>>>> >  Filesystem            Size  Used Avail Use% Mounted on
>>>> >  /dev/sda1             294G  4.1G  275G   2% /
>>>> >  devtmpfs              7.9G  184K  7.9G   1% /dev
>>>> >  none                  7.9G     0  7.9G   0% /dev/shm
>>>> >  none                  7.9G  100K  7.9G   1% /var/run
>>>> >  none                  7.9G     0  7.9G   0% /var/lock
>>>> >  none                  7.9G     0  7.9G   0% /lib/init/rw
>>>> >  /dev/ram0             1.5G  1.5G   20K 100% /mnt/ram
>>>> >
>>>> >  # dd if=/mnt/ram/zerofile | wc -c
>>>> >  4791480+0 records in
>>>> >  4791480+0 records out
>>>> >  2453237760
>>>> >  2453237760 bytes (2.5 GB) copied, 8.41821 s, 291 MB/s
>>>> >
>>>> >  It seems there is also an XFS bug here...
>>>> >
>>>> >  This might help triggering the bug however please note than ext4
>>>> >  (nfs-rdma over it) also hanged on us and it was real work on HDD 
>>>> disks
>>>> >  and they were not full... after switching to IPoIB it didn't hang
>>>> >  anymore.
>>>> >
>>>> >  On IPoIB the size problem also shows up: final file is 2.3GB 
>>>> instead
>>>> >  of<  1.5GB, however nothing hangs:
>>>> >
>>>> >  # echo begin; dd if=/dev/zero of=/mnt/nfsram/zerofile bs=1M ; echo
>>>> >  syncing now ; time sync ; echo finished
>>>> >  begin
>>>> >  dd: writing `/mnt/nfsram/zerofile': Input/output error
>>>> >  2497+0 records in
>>>> >  2496+0 records out
>>>> >  2617245696 bytes (2.6 GB) copied, 10.4 s, 252 MB/s
>>>> >  syncing now
>>>> >
>>>> >  real    0m0.057s
>>>> >  user    0m0.000s
>>>> >  sys     0m0.000s
>>>> >  finished
>>>> >
>>>> >  I think I noticed the same problem with a 14GB ramdisk, the file 
>>>> ended
>>>> >  up to be about 15GB, but at that time I thought I made some
>>>> >  computation mistakes. Now with a smaller ramdisk it's more obvious.
>>>> >
>>>> >  Earlier or later someone should notify the XFS developers of the 
>>>> "size" bug.
>>>> >  However currently it's a good thing: the size bug might help us 
>>>> to fix
>>>> >  the RDMA bug.
>>>> >
>>>> >  Thanks for your help
>>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
