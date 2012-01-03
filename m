From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [OMPI users] Problems when running open-MPI on OFED
Date: Tue, 03 Jan 2012 17:10:07 +0200
Message-ID: <4F031A4F.4020305@dev.mellanox.co.il>
References: <CACiOAODJBWTjsQrDV5it-9peQu+Bapg58=B=S+tLDh=NYWAw2w@mail.gmail.com>	<4EFC429E.5000700@dev.mellanox.co.il> <CACiOAOAq68s0XFzx=Q8QG7KYKDbWxgO+zxiM_bZ=ueFeAH4P8g@mail.gmail.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACiOAOAq68s0XFzx=Q8QG7KYKDbWxgO+zxiM_bZ=ueFeAH4P8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Venkateswara Rao Dokku <dvrao.584-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 29-Dec-11 7:10 PM, Venkateswara Rao Dokku wrote:
> Yes, Previously we could run those tests, but after adding some changes we see those errors,,...
> can you please suggest why those errors will occur?

I would strongly suggest to have the usual IB tests running
before even trying to run OMPI - these tests are going to be
way more easy to debug. OMPI have lots of components and layers,
and debugging driver with OMPI won't be pretty.

Please address your questions to Linux RDMA mailing list:linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
You can find all the relevant experts there.

-- YK

> On Thu, Dec 29, 2011 at 4:06 PM, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org <mailto:kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>> wrote:
> 
>     Hi,
> 
>     Does OMPI with IMP work OK on the official OFED release?
>     Do the usual ibv performance tests (ibv_rc_*) work on your customized OFED?
> 
>     -- YK
> 
>     On 29-Dec-11 9:34 AM, Venkateswara Rao Dokku wrote:
>      > Hi,
>      >      We tried running the Intel Benchmarks(IMB_3.2) on the customized OFED(that was build by us).. While executing the tests we are getting the following errors
>      > 1.
>      > --------------------------------------------------------------------------
>      > The OpenFabrics stack has reported a network error event.  Open MPI
>      > will try to continue, but your job may end up failing.
>      >
>      >    Local host:        localhost.localdomain
>      >    MPI process PID:   5259
>      >    Error number:      2 (IBV_EVENT_QP_REQ_ERR)
>      >
>      > This error may indicate connectivity problems within the fabric;
>      > please contact your system administrator.
>      > --------------------------------------------------------------------------
>      > 2.
>      > While executing the Reduce_scatter benchmark..
>      > [localhost.localdomain:04437] *** An error occurred in MPI_Reduce_scatter
>      > [localhost.localdomain:04437] *** on communicator MPI COMMUNICATOR 3 SPLIT FROM 0
>      > [localhost.localdomain:04437] *** MPI_ERR_TRUNCATE: message truncated
>      > [localhost.localdomain:04437] *** MPI_ERRORS_ARE_FATAL (your MPI job will now abort)
>      > --------------------------------------------------------------------------
>      >
>      >
>      >
>      > What is the root cause for those errors??, and any suggestions on how to remove those errors..!!!
>      >
>      > Thanks for your reply..
>      >
>      >
>      > --
>      > Thanks & Regards,
>      > D.Venkateswara Rao,
>      >
>      >
>      >
>      >
>      > _______________________________________________
>      > users mailing list
>      > users-ygRj4skf0tpg9hUCZPvPmw@public.gmane.org <mailto:users-ygRj4skf0tpg9hUCZPvPmw@public.gmane.org>
>      > http://www.open-mpi.org/mailman/listinfo.cgi/users
> 
> 
> 
> 
> -- 
> Thanks & Regards,
> D.Venkateswara Rao,
> Software Engineer,One Convergence Devices Pvt Ltd.,
> Jubille Hills,Hyderabad.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
