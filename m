From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: error in ibdiagnet output
Date: Tue, 03 Nov 2009 11:27:04 +0200
Message-ID: <4AEFF768.9080502@dev.mellanox.co.il>
References: <6203933669E90E4AB42B5BC4EDE38D350C8295A2D2@orsmsx510.amr.corp.intel.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6203933669E90E4AB42B5BC4EDE38D350C8295A2D2-qERRe+bbXDTTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Meyer, Donald J" <donald.j.meyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Donald,

Meyer, Donald J wrote:
> In the output of ibdiagnet, there is a line that has improper terminology.  The line refers to "partial" where the proper term is "limited" (per the IB standard).  Example shown below:
> 
> -I---------------------------------------------------
> -I- Fabric Partitions Report (see ibdiagnet.pkey for a full hosts list)
> -I---------------------------------------------------
> -I-    PKey:0x7fff Hosts:95 full:95 partial:0

Thanks, fixed.
Will push to the trunk later.

-- Yevgeny
 
> Thanks,
> Don Meyer
> Senior Network/System Engineer/Programmer
> US+ (253) 371-9532 iNet 8-371-9532
> *Other names and brands may be claimed as the property of others
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
