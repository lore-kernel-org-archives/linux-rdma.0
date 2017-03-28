From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Tue, 28 Mar 2017 18:45:44 +0300
Message-ID: <a141c94a-63b7-491c-ce42-9b8cb08aeb93@mellanox.com>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
 <4058624b-a947-9635-76ca-482fd6a6bd95@mellanox.com>
 <20170327201156.GA29831@srabinov-linux.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170327201156.GA29831-t9juWtktDCT52KUv/Ok+f8QLKKaP9WJ9VpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Shamir,

On 27/03/2017 23:11, Shamir Rabinovitch wrote:
> On Mon, Mar 27, 2017 at 06:06:42PM +0300, Mark Bloch wrote:
>> Hi Shamir,
>>
>> Like I've said in v1 of this patch, I believe we are calling ipoib_delete_debug_files too many times.
>> We are calling in unconditionally in: ipoib_dev_cleanup
>> and also in ipoib_netdev_event when we get an NETDEV_UNREGISTER event.
>>
>> For example, I have a setup with ConnectX-4 dual port configured to be in IB mode.
>> So I have two ipoib interfaces (ib0, ib1)
>>
>> When I load and unload mlx5_ib (while ib_ipoib is loaded:
>>
>> root@dev-r-vrt-175 tools]# ./funccount.py 'ipoib_*_debug_files'
>> Tracing 2 functions for "ipoib_*_debug_files"... Hit Ctrl-C to end.
>> ^C
>> FUNC                                    COUNT
>> ipoib_create_debug_files                    2
>> ipoib_delete_debug_files                    4
>> Detaching...
>>
>> Why not just remove the call in ipoib_dev_cleanup?
>>
> 
> Hi Mark,
> 
> v3 of this patch works fine on system that has CX3 with 2 ports and the
> below udev rules:
> 
> # InfiniBand: Mellanox Technologies MT27500 Family [ConnectX-3]
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="mlx4_core", BUS=="pci",
> ID=="0002:01:00.0", ATTR{dev_id}=="0x0", KERNEL=="ib*", NAME="ib1"
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="mlx4_core", BUS=="pci",
> ID=="0002:01:00.0", ATTR{dev_id}=="0x1", KERNEL=="ib*", NAME="ib0"
> 
> On this system, the udev rules rename ib0-ib1 & ib1->ib0 causing small
> chaos in the ipoib device names.
> 
> The attached logs include the information collected when the openibd
> service was started and when it was stopped. You can have a look in the
> files and see what are the network events and how they are processed by
> the ipoib devices.
> 
> I think it will answer your concerns. 
> 
> BR, Shamir
> 

I'm not saying it doesn't work, I'm saying works != works correctly.
We are calling ipoib_delete_debug_file too many times, it works by luck/chance.

While testing the patch, I've encountered another issue, running:

modprobe ib_ipoib
echo "0x0043" > /sys/class/net/ib0/create_child
modprobe -r ib_ipoib

and then looking the at the debugfs dir:
[root@dev-r-vrt-175 ~]# ls /sys/kernel/debug/ipoib/
ib0.8043_mcg  ib0.8043_pat1

As you can see the the debugfs entries for the ib0 child weren't removed.
Also notice that after that, I can't load ib_ipoib
[root@dev-r-vrt-175 ~]# modprobe ib_ipoib
modprobe: ERROR: could not insert 'ib_ipoib': Cannot allocate memory

The more interesting issue is, dmesg output has this:
[  467.185609] ib0.8043: failed to create mcg debug file
[  467.192551] ib0.8043: failed to create path debug file

so maybe this is a debugfs bug?

Sorry I can't look into it, I have some internal stuff I need to work on :/

Mark.
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
