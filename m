From: Spelic <spelic-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Subject: Re: NFS-RDMA hangs: connection closed (-103)
Date: Thu, 02 Dec 2010 13:16:14 +0100
Message-ID: <4CF78E0E.2040308@shiftmail.org>
References: <4CF6D69B.4030501@shiftmail.org>
 <4CF6E144.1080200@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4CF6E144.1080200-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/02/2010 12:59 AM, Tom Tucker wrote:
> Spelic,
>
> I have seen this problem before, but have not been able to reliably 
> reproduce it. When I saw the problem, there were no transport errors 
> and it appeared as if the I/O had actually completed, but that the 
> waiter was not being awoken. I was not able to reliably reproduce the 
> problem and was not able to determine if the problem was a latent bug 
> in NFS in general or a bug in the RDMA transport in particular.
>
> I will try your setup here, but I don't have a system like yours so 
> I'll have to settle for a smaller ramdisk, however, I have a few 
> questions:
>
> - Does the FS matter? For example, can you use ext[2-4] on the ramdisk 
> and not still reproduce
> - As I mentioned earlier NFS v3 vs. NFS v4
> - RAMDISK size, i.e. 2G vs. 14G
>
> Thanks,
> Tom

Hello Tom, thanks for replying

- The FS matters to some extent: as I wrote, with ext4 it's not possible 
to reproduce the bug in this way, so immediately and reliably, however 
ext4 also will hang eventually if you work on it for hours so I had to 
switch to IPoIB for our real work; reread my previous post.

- NFS3 not tried yet. Never tried to do RDMA on NFS3... do you have a 
pointer on instructions?


- RAMDISK size: I am testing it.

Ok I confirm with 1.5GB ramdisk it's reproducible.
boot option ramdisk_size=1572864
(1.5*1024**2=1572864.0)
confirm: blockdev --getsize64 /dev/ram0 == 1610612736

now at server side mkfs and mount with defaults:
mkfs.xfs /dev/ram0
mount /dev/ram0 /mnt/ram
(this is a simplification over my previous email, and it's needed with a 
smaller ramdisk or mkfs.xfs will refuse to work. The bug is still 
reproducible like this)


DOH! another bug:
It's strange how at the end of the test
     ls -lh /mnt/ram
at server side will show a zerofile larger than 1.5GB at the end of the 
procedure, sometimes it's 3GB, sometimes it's 2.3GB... but it's larger 
than the ramdisk size.

# ll -h /mnt/ram
total 1.5G
drwxr-xr-x 2 root root   21 2010-12-02 12:54 ./
drwxr-xr-x 3 root root 4.0K 2010-11-29 23:51 ../
-rw-r--r-- 1 root root 2.3G 2010-12-02 12:59 zerofile
# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1             294G  4.1G  275G   2% /
devtmpfs              7.9G  184K  7.9G   1% /dev
none                  7.9G     0  7.9G   0% /dev/shm
none                  7.9G  100K  7.9G   1% /var/run
none                  7.9G     0  7.9G   0% /var/lock
none                  7.9G     0  7.9G   0% /lib/init/rw
/dev/ram0             1.5G  1.5G   20K 100% /mnt/ram

# dd if=/mnt/ram/zerofile | wc -c
4791480+0 records in
4791480+0 records out
2453237760
2453237760 bytes (2.5 GB) copied, 8.41821 s, 291 MB/s

It seems there is also an XFS bug here...

This might help triggering the bug however please note than ext4 
(nfs-rdma over it) also hanged on us and it was real work on HDD disks 
and they were not full... after switching to IPoIB it didn't hang anymore.

On IPoIB the size problem also shows up: final file is 2.3GB instead of 
< 1.5GB, however nothing hangs:

# echo begin; dd if=/dev/zero of=/mnt/nfsram/zerofile bs=1M ; echo 
syncing now ; time sync ; echo finished
begin
dd: writing `/mnt/nfsram/zerofile': Input/output error
2497+0 records in
2496+0 records out
2617245696 bytes (2.6 GB) copied, 10.4 s, 252 MB/s
syncing now

real    0m0.057s
user    0m0.000s
sys     0m0.000s
finished

I think I noticed the same problem with a 14GB ramdisk, the file ended 
up to be about 15GB, but at that time I thought I made some computation 
mistakes. Now with a smaller ramdisk it's more obvious.

Earlier or later someone should notify the XFS developers of the "size" bug.
However currently it's a good thing: the size bug might help us to fix 
the RDMA bug.

Thanks for your help

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
