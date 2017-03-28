From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Tue, 28 Mar 2017 19:49:08 +0300
Message-ID: <e3a49c96-b248-7491-301d-faa47109aa41@mellanox.com>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
 <4058624b-a947-9635-76ca-482fd6a6bd95@mellanox.com>
 <20170327201156.GA29831@srabinov-linux.uk.oracle.com>
 <a141c94a-63b7-491c-ce42-9b8cb08aeb93@mellanox.com>
 <20170328160251.GA26781@srabinov-linux.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170328160251.GA26781-t9juWtktDCT52KUv/Ok+f8QLKKaP9WJ9VpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 28/03/2017 19:02, Shamir Rabinovitch wrote:
> On Tue, Mar 28, 2017 at 06:45:44PM +0300, Mark Bloch wrote:
>>>
>>> Hi Mark,
>>>
>>> v3 of this patch works fine on system that has CX3 with 2 ports and the
>>> below udev rules:
>>>
>>> # InfiniBand: Mellanox Technologies MT27500 Family [ConnectX-3]
>>> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="mlx4_core", BUS=="pci",
>>> ID=="0002:01:00.0", ATTR{dev_id}=="0x0", KERNEL=="ib*", NAME="ib1"
>>> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="mlx4_core", BUS=="pci",
>>> ID=="0002:01:00.0", ATTR{dev_id}=="0x1", KERNEL=="ib*", NAME="ib0"
>>>
>>> On this system, the udev rules rename ib0-ib1 & ib1->ib0 causing small
>>> chaos in the ipoib device names.
>>>
>>> The attached logs include the information collected when the openibd
>>> service was started and when it was stopped. You can have a look in the
>>> files and see what are the network events and how they are processed by
>>> the ipoib devices.
>>>
>>> I think it will answer your concerns. 
>>>
>>> BR, Shamir
>>>
>>
>> I'm not saying it doesn't work, I'm saying works != works correctly.
>> We are calling ipoib_delete_debug_file too many times, it works by luck/chance.
>>
>> While testing the patch, I've encountered another issue, running:
>>
>> modprobe ib_ipoib
>> echo "0x0043" > /sys/class/net/ib0/create_child
>> modprobe -r ib_ipoib
>>
>> and then looking the at the debugfs dir:
>> [root@dev-r-vrt-175 ~]# ls /sys/kernel/debug/ipoib/
>> ib0.8043_mcg  ib0.8043_pat1
>>
>> As you can see the the debugfs entries for the ib0 child weren't removed.
>> Also notice that after that, I can't load ib_ipoib
>> [root@dev-r-vrt-175 ~]# modprobe ib_ipoib
>> modprobe: ERROR: could not insert 'ib_ipoib': Cannot allocate memory
>>
>> The more interesting issue is, dmesg output has this:
>> [  467.185609] ib0.8043: failed to create mcg debug file
>> [  467.192551] ib0.8043: failed to create path debug file
>>
>> so maybe this is a debugfs bug?
>>
>> Sorry I can't look into it, I have some internal stuff I need to work on :/
>>
>> Mark.
>>  
> 
> Hi Mark,
> 
> I am confused. Have you used v3 of the patch? If yes please add this
> print after you apply the patch and send me the output when you stop the
> openibd service:
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index c84b8ee..a2f43ff 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -118,12 +118,17 @@ static int ipoib_netdev_event(struct
> notifier_block *this,
>         if (dev->netdev_ops->ndo_open != ipoib_open)
>                 return NOTIFY_DONE;
>  
> +       pr_err("%s: dev %p name %s event 0x%lx\n",
> +               __func__, dev, dev->name, event);
> +
>         switch (event) {
>         case NETDEV_REGISTER:
>                 ipoib_create_debug_files(dev);
>                 break;
> 
> My output show this:
> 
> ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x9
> ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x2
> ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x9
> ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x2
> ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x9
> ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x2
> ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x9
> ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x2
> ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x6 <--
> NETDEV_UNREGISTER { here we delete the debugfs entries }
> ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x6
> ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x6
> ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x6
> 
> So the 4 ports I have are closed only once. Hence no double free.
> I am not sure why you see the double free. Please double check your
> findings. 
>
I agree that we call ipoib_delete_debug_files() from ipoib_netdev_event()
the right number of times, but we also call it in ipoib_dev_cleanup()
which means we call it too many times. Your V3 didn't remove that call.
 
> I am using the 4.9.9 upstream kernel because the commit "Merge tag 
> 'for-next-dma_ops' of git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma"
> cause MAD DMA mapping kernel panic on SPARC T7.
> 
> BR, Shamir
> 

Mark.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
