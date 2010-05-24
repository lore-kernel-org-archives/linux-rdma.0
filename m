From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ANNOUNCE] librdmacm 1.0.12
Date: Mon, 24 May 2010 10:22:22 +0300
Message-ID: <4BFA292E.3090001@dev.mellanox.co.il>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com> <A04A50C5C9294B538ECAB7C44CEBE56D@amr.corp.intel.com> <4BF9486D.5000402@dev.mellanox.co.il> <0846C0BCE03D4EAD9B73A2522C1CC2AE@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0846C0BCE03D4EAD9B73A2522C1CC2AE-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> Hi Sean,
>> After updating librdmacm. compat-dapl compilation fails:
> 
> Thanks - I'll look into this tomorrow.  Was DAPL updated at all?  And what is
> 'compat-dapl'?
> 
>> In file included from ./dapl/include/dapl.h:246In file included from
>> ./dapl/include/dapl.h:246,
>>                  from dapl/udapl/dapl_init.c:39:
>> ./dapl/openib_cma/dapl_ib_util.h:54:27: error: rdma/rdma_cma.h: No such file or
>> directory
> 
> I don't get this.  rdma/rdma_cma.h was modified, but it's still there.  Is only
> the redhat EL5 build affected, or do all builds fail?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


Sean,
The problem is in the Makefile.am:

librdmacmincludedir = $(includedir)/rdma $(includedir)/infiniband

This cause *.h files to be installed under "/usr/include/rdma\ /usr/include/infiniband":

/usr/include/rdma /usr/include/infiniband/ib.h
/usr/include/rdma /usr/include/infiniband/rdma_cma.h
/usr/include/rdma /usr/include/infiniband/rdma_cma_abi.h
/usr/include/rdma /usr/include/infiniband/rdma_verbs.h


Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
