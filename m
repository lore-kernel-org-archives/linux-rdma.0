From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ANNOUNCE] libibcm 1.0.5 and librdmacm 1.0.10 released
Date: Tue, 27 Oct 2009 12:03:27 +0200
Message-ID: <4AE6C56F.8050707@dev.mellanox.co.il>
References: <4256F55248EA4D8AB34F933CEF754FB3@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4256F55248EA4D8AB34F933CEF754FB3-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> Vlad, please pull in these releases into OFED 1.5
> 
> libibcm 1.0.5, changes from 1.0.4:
> 	return errors from the library consistently
> 
> librdmacm 1.0.10, changes from 1.0.9:
> 	examples: print errno on failures
> 	return errors from the library consistently
> 	initialize correct pthread condition
> 	fix race initializing library
> 
> Both are available through my git trees and for download from:
> 
> http://www.openfabrics.org/downloads/rdmacm/
> 
> - Sean
> 

Done,

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
