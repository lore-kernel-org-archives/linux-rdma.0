From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: ibstat does not recognize iWARP RNIC adapters
Date: Thu, 26 Apr 2012 08:47:21 -0400
Message-ID: <4F9943D9.2060705@dev.mellanox.co.il>
References: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8A71B368A89016469F72CD08050AD3340B8AAE7F-utt48SW1nMZEErodcbzraFjMPmZJtkid@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/25/2012 8:38 PM, Troy Leedberg wrote:
> I noticed that doing ibstat, none of the iWARP RNIC adapters were showing up.  

Once upon a time, this used to work:

commit c864f5d6f1886510f69d1756843c1754fd3a42b4
Author: Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Fri May 19 12:40:35 2006 +0000

    r7350: Change to libibmad and diags/ibstat.c to support iWARP RNIC node type
    
    Signed-off-by: Hal Rosenstock <halr-smomgflXvOZWk0Htik3J/w@public.gmane.org>

but appears to have been broken for some time now by:

commit 4474288a0eeccced81782c3aac2133aa538a2234
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Wed Jul 23 04:32:41 2008 +0300

    libibumad: check that node type has IB type
    
    When resolving CA device name (name is not provided) check that it has
    IB type.
    
    Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>

which is what your patch addresses.

I couldn't find any discussion on the linux-rdma list relative to that change but may have missed the motivation. The OpenSM vendor layer checks for IB node type. Not sure or not if there are any other IB diagnostic tools which would have similar problems for iWARP.

BTW, what does CapabilityMask 0x009f0000 mean ?

-- Hal

> I have attached a patch to address the issue (libibumad.patch).
> 
> SYS_NODE_TYPE for iWARP RNIC is 4 and is_ib_type only checked to 3.
> 
> 
> Before patch is applied:
> 
> [root@t4-2 SOURCES]# ibstat
> [root@t4-2 SOURCES]#
> 
> 
> After patch is applied:
> 
> [root@t4-2 libibumad-1.3.7]# ibstat
> iWARP RNIC 'cxgb4_0'
>         iWARP RNIC type: cxgb4
>         Number of ports: 2
>         Firmware version: 1.4.23.0
>         Hardware version: 2
>         Node GUID: 0x000743101d000000
>         System image GUID: 0x000743101d000000
>         Port 1:
>                 State: Active
>                 Physical state: No state change
>                 Rate: 20
>                 Base lid: 0
>                 LMC: 0
>                 SM lid: 0
>                 Capability mask: 0x009f0000
>                 Port GUID: 0x0000000000000000
>                 Link layer: Ethernet
>         Port 2:
>                 State: Down
>                 Physical state: No state change
>                 Rate: 20
>                 Base lid: 0
>                 LMC: 0
>                 SM lid: 0
>                 Capability mask: 0x009f0000
>                 Port GUID: 0x0000000000000000
>                 Link layer: Ethernet
> [root@t4-2 libibumad-1.3.7]#
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
