From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: nfsrdma broken on 2.6.34-rc1?
Date: Thu, 01 Apr 2010 13:32:52 -0500
Message-ID: <4BB4E6D4.90403@opengridcomputing.com>
References: <4BB0E670.3010507@opengridcomputing.com>	<B18454F3200D4A43B57F175388845AAC@amr.corp.intel.com>	<adaiq8fvtos.fsf@roland-alpha.cisco.com>	<20100329193715.GA28070@obsidianresearch.com>	<4BB104D2.9080309@opengridcomputing.com>	<adaaatqx4bo.fsf@roland-alpha.cisco.com>	<4BB4DBF4.3040506@opengridcomputing.com>	<4A8AA06C165A47A69C73CDA744EBDD48@amr.corp.intel.com>	<4BB4E1C5.3030905@opengridcomputing.com> <adatyrvm40m.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyrvm40m.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > LOL. Yes...yes it would. There is of course a Dragon to be slain. Roland?
>
> umm....
>
> seriously is there anyway to un-screw this for 2.6.34?
>
> hack around it in the NFS-RDMA server so it just skips the second bind
> to the same port?
>
>   

If the nfsd code would ignore the error on the INET6 xprt create, then 
it works:

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 0f0e77f..d6abab9 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1008,8 +1008,10 @@ static ssize_t __write_ports_addxprt(char *buf)
 
        err = svc_create_xprt(nfsd_serv, transport,
                                PF_INET6, port, SVC_SOCK_ANONYMOUS);
+#if 0
        if (err < 0 && err != -EAFNOSUPPORT)
                goto out_close;
+#endif
        return 0;
 out_close:
        xprt = svc_find_xprt(nfsd_serv, transport, PF_INET, port);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
