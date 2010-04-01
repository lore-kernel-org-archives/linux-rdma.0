From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: nfsrdma broken on 2.6.34-rc1?
Date: Thu, 01 Apr 2010 13:53:36 -0500
Message-ID: <4BB4EBB0.8010900@opengridcomputing.com>
References: <4BB0E670.3010507@opengridcomputing.com>	<B18454F3200D4A43B57F175388845AAC@amr.corp.intel.com>	<adaiq8fvtos.fsf@roland-alpha.cisco.com>	<20100329193715.GA28070@obsidianresearch.com>	<4BB104D2.9080309@opengridcomputing.com>	<adaaatqx4bo.fsf@roland-alpha.cisco.com>	<4BB4DBF4.3040506@opengridcomputing.com>	<4A8AA06C165A47A69C73CDA744EBDD48@amr.corp.intel.com>	<4BB4E1C5.3030905@opengridcomputing.com> <adatyrvm40m.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyrvm40m.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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
Yes, I think all we have to do is have the nfsctl.c code ignore any 
transport error on the IPV6 call as opposed to _only_ NOTSUP

>  - R.
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
