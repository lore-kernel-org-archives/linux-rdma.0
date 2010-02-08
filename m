From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [ewg] bug 1918 - openmpi broken due to rdma-cm changes
Date: Mon, 08 Feb 2010 08:29:07 -0600
Message-ID: <4B701FB3.50105@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>	<4B6C498F.3060708@opengridcomputing.com>	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>	<4B6D9948.6040007@opengridcomputing.com>	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>	<4B6E15C4.9020703@opengridcomputing.com>	<4B6EAA5F.1000208@mellanox.co.il> <4B6EECBE.6020509@opengridcomputing.com> <4B6FFB07.1070701@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B6FFB07.1070701-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tziporet Koren wrote:
> On 2/7/2010 6:39 PM, Steve Wise wrote:
>>
>> If ofed-1.5.1 is based on 2.6.33 then it will get this patch
>> automatically (assuming it goes upstream and makes 2.6.33).  Or we can
>> pull it in as a kernel_patches/fixes/ patch.
>>    
> OFED 1.5.1 is not based on 2.6.33, but on 2.6.30, so we need the patch 
> under fixes.
> Steve - can you prepare such a patch?
>
> Tziporet
>
>

The reason I thought it was based on 2.6.33, is because I see 2.6.33 git 
tags in the ofed kernel tree.  I misinterpreted what that meant.

I can develop a patch, but it will disable _all_ 127.0.0.1 binds.  
Otherwise openmpi is still broken on IB.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
