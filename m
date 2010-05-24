From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] librdmacm 1.0.12
Date: Mon, 24 May 2010 12:24:41 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C713ACAA@orsmsx506.amr.corp.intel.com>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com>
 <A04A50C5C9294B538ECAB7C44CEBE56D@amr.corp.intel.com>
 <4BF9486D.5000402@dev.mellanox.co.il>
 <0846C0BCE03D4EAD9B73A2522C1CC2AE@amr.corp.intel.com>
 <4BFA292E.3090001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BFA292E.3090001-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
>Sean,
>The problem is in the Makefile.am:
>
>librdmacmincludedir = $(includedir)/rdma $(includedir)/infiniband
>
>This cause *.h files to be installed under "/usr/include/rdma\ 
>/usr/include/infiniband":
>
>/usr/include/rdma /usr/include/infiniband/ib.h
>/usr/include/rdma /usr/include/infiniband/rdma_cma.h
>/usr/include/rdma /usr/include/infiniband/rdma_cma_abi.h
>/usr/include/rdma /usr/include/infiniband/rdma_verbs.h

Vlad,

Please re-pull the package and retry.

-arlin (for Sean, dead PC)
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
