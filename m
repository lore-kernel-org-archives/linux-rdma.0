From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] librdmacm 1.0.12
Date: Mon, 24 May 2010 15:24:38 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F242979@orsmsx501.amr.corp.intel.com>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com>
 <A04A50C5C9294B538ECAB7C44CEBE56D@amr.corp.intel.com>
 <4BF9486D.5000402@dev.mellanox.co.il>
 <0846C0BCE03D4EAD9B73A2522C1CC2AE@amr.corp.intel.com>
 <4BFA292E.3090001@dev.mellanox.co.il>
 <E3280858FA94444CA49D2BA02341C983C713ACAA@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E3280858FA94444CA49D2BA02341C983C713ACAA-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>librdmacmincludedir = $(includedir)/rdma $(includedir)/infiniband
>>
>>This cause *.h files to be installed under "/usr/include/rdma\
>>/usr/include/infiniband":
>>
>>/usr/include/rdma /usr/include/infiniband/ib.h
>>/usr/include/rdma /usr/include/infiniband/rdma_cma.h
>>/usr/include/rdma /usr/include/infiniband/rdma_cma_abi.h
>>/usr/include/rdma /usr/include/infiniband/rdma_verbs.h
>
>Please re-pull the package and retry.

The installation issue should be corrected in the latest package.

Also, a new config option was added to the librdmacm to allow for support for IB ACM.  I'm not sure of the best way to expose the option to users through the OFED install scripts.  Requiring users to build a custom RPM if they want to enable IB ACM is fine for me.

I also placed a release of ib_acm on the OFA server to include in OFED 1.5.2.  It should always be safe to install ib_acm, but the librdmacm will not make use of it unless the above mentioned config option has been set.  I will look at the install scripts to see what might be a good way to enable/disable IB ACM, but if you have any ideas, please let me know.  (It should be disabled by default.)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
