From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 23 Jun 2010 13:51:38 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E90492697023@azsmsx506.amr.corp.intel.com>
References: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D@ch.ibm.com>
	<ada8w65veq4.fsf@roland-alpha.cisco.com>
	<4C225078.6050001@opengridcomputing.com>
	<adar5jxtxho.fsf@roland-alpha.cisco.com>
	<2EFBCAEF10980645BBCFB605689E08E90492696EF7@azsmsx506.amr.corp.intel.com>
 <ada6319ttnj.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada6319ttnj.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  > > On the other hand trying to hook offloaded iWARP into the normal stack
>  > > does seem to lead to a mess.  I see DaveM's point: TCP port space is
>  > > just the beginning -- filtering, queueing, etc also have config that
>  > > ultimately an offload device would want to hook too.
> 
>  > TCP port space is just the beginning but then these features
>  > didn't show up all at once in the kernel either.  Instead of
>  > evolving iWARP implementation, we can't even take a baby step
>  > and fix a flaw that exists in the current kernel.  Why are we
>  > "replicating" everything offered by the host stack instead of
>  > hooking in?  It does not sound like good engineering to me.
> 
> Well as I said I don't particularly see a clean solution.  But the point
> I was making was that the net stack is already very complex with many
> places where interface configs are controlled -- having to add hooks to
> pass that config on to offload devices is going to add even more
> complexity and also add constraints to the format of that config
> information.  Which is not good.

I don't want separate config file for L2 and iWARP as it adds more
work and complexity for the user.  I want it dead simple.  I can see
extending config format to include information specific for offload
but I don't see how it can limit the format.  That has not been the
case up to this point.  Also, port space patch is totally transparent
to the user and config file.  There is no managing host TCP and iWARP
TCP port space for the user.

I'm not sure about passing config info to offload devices, if the info
is outside of what L2 driver currently picks up then sure some work
needs to be done.  Hopefully everything can be pass-through from L2 to iWARP.


Chien




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
