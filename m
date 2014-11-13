From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] libibmad: Add new fields for SM:PortInfoExtended and
 for PM:PortExtendedSpeedsCounters
Date: Thu, 13 Nov 2014 09:59:13 +0200
Message-ID: <546464D1.1010402@mellanox.com>
References: <1415798513-29753-1-git-send-email-danby@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415798513-29753-1-git-send-email-danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

space please  e.g [PATCH v3] and not  [PATCHv3]

also as each library as their own git, I see a value in specifying the 
library name in the part of the patch subject line which is later 
stripped by git am (that is [PATCH libibmad] and not [PATCH] libibmand:) 
but not something that remains with this commit forever, since when 
observing the code/git, the person that does that knows on which tree 
she's looking, right?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
