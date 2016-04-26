From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH V2] powerpc/infiniband: Use cache inhibitted and guarded
 mapping on powerpc
Date: Tue, 26 Apr 2016 21:03:52 +1000
Message-ID: <1461668632.31920.1.camel@ellerman.id.au>
References: <1461139097-10213-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <32E1700B9017364D9B60AED9960492BC25ACE29D@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC25ACE29D-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org" <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, "paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: "linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2016-04-20 at 16:29 +0000, Marciniszyn, Mike wrote:
> > From: Aneesh Kumar K.V [mailto:aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org]
> > Sent: Wednesday, April 20, 2016 3:58 AM
> > Subject: [PATCH V2] powerpc/infiniband: Use cache inhibitted and guarded
> > mapping on powerpc
> > 
> 
> Doug, can you fix up the summary to git the spelling error and powerpc/infiniband:  -> IB/qib:

We'll need to take this via the powerpc tree, we have a 68 patch series that
depends on it. I'm happy to update the subject.

cheers

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
