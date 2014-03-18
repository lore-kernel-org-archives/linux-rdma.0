From: Egor Medvedev <methodx-w/L3Ro8pDhisTnJN9+BGXg@public.gmane.org>
Subject: Can't re-add disk to handler with scst on the run
Date: Tue, 18 Mar 2014 11:18:52 +0400
Message-ID: <CAK4NFoFP23R2BF10ovSypUPgz28sKfscKbgf5MUmQGvf-wAxqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Good day.

I have a question, maybe someone can help me with it.
The problem is I have a target node with 3 disks in on handler sda, sdb,sdc.
For some reason, drive /dev/sdc failed, and was manually removed from
initiator node. I checked target node, removed LUN and device from
handler manually.

Then, when I try to add device, I see an error:

root@sas00: echo "add_device sas00_sdc filename=/dev/sdc; nv_cache=1"
> /sys/kernel/scst_tgt/handlers/vdisk_fileio/mgmt
-bash: echo: write error: No such device or address

root@sas00: ls -la /dev/sdc
brw-rw---T 1 root disk 8, 32 Mar 18 05:31 /dev/sdc

Here is dmesg message:
[10161276.316398] dev_vdisk: Registering virtual vdisk_fileio device
sas00_sdc (NV_CACHE, ROTATIONAL)
[10161276.316563] dev_vdisk: ***ERROR***: filp_open(/dev/sdc) returned error -6
[10161276.316620] scst: ***ERROR***: New device handler's vdisk_fileio
attach() failed: -6

I assumed, that the disk could be used by another process, but lsof
shows nothing for sdc:

root@sas00:/sys/kernel/scst_tgt# lsof | grep sdc
root@sas00:/sys/kernel/scst_tgt# lsof | grep sdb | head
sas00_sdb  1816            root  cwd       DIR               0,18
260          2 /
sas00_sdb  1816            root  rtd       DIR               0,18
260          2 /
sas00_sdb  1816            root  txt   unknown
               /proc/1816/exe

Why can't it be attached now? Any ideas?
Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
