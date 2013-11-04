From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: AW: IPoIB GRO
Date: Mon, 04 Nov 2013 14:41:54 +0200
Message-ID: <52779612.9020103@dev.mellanox.co.il>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>,<527759C6.3070009@dev.mellanox.co.il> <12EF8D94C6F8734FB2FF37B9FBEDD173585A4301@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173585A4301-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Markus,

Can you please tell me what is the FW version you have on your ConnectX 
cards?

Thanks, Erez

> Hi Erez,
>
>> don't you see that behaviour in tcpdump? what kernel are you using?
> On server side we have a 3.5 on client side a 3.11 kernel each of them with
> kernel standard drivers/modules. I can see the same pattern of GRO
> aggregation on the client that you mention but only if I disable TSO for
> ib0 on the server side.
>
> The test I'm running on the client is like this. The second and third read
> run are definetly served by the NFS server side cache.
>
> sysctl -w net.ipv4.tcp_mem="4096 65536 4194304"
> sysctl -w net.ipv4.tcp_rmem="4096 65536 4194304"
> sysctl -w net.ipv4.tcp_wmem="4096 65536 4194304"
> sysctl -w net.core.rmem_max=8388608
> sysctl -w net.core.wmem_max=8388608
>
> mount -o nfsvers=3,rsize=262144,wsize=262144 10.10.30.251:/export /mnt
> echo 3 > /proc/sys/vm/drop_caches
> dd if=/mnt/xxx.iso of=/dev/null bs=1M count=5000
> echo 3 > /proc/sys/vm/drop_caches
> dd if=/mnt/xxx.iso of=/dev/null bs=1M count=5000
> echo 3 > /proc/sys/vm/drop_caches
> dd if=/mnt/xxx.iso of=/dev/null bs=1M count=5000
> umount /mnt
>
> Markus

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
