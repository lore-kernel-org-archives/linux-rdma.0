From: Joe Landman <landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org>
Subject: Re: rdma_bw fails
Date: Tue, 17 May 2011 13:17:45 -0400
Message-ID: <4DD2ADB9.2050300@scalableinformatics.com>
References: <BANLkTik_42DBsd5SdyDcMvpTaw9+dXTr_w@mail.gmail.com>	<1828884A29C6694DAF28B7E6B8A82373F8C7@ORSMSX101.amr.corp.intel.com> <20110517111606.3ohp6l6z34gckcoo@celticblues.com>
Reply-To: landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110517111606.3ohp6l6z34gckcoo-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/17/2011 01:16 PM, ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org wrote:
> So... what is the correct way to configure ib? I *think* I have it
> configured correctly, but want to verify... Where is this information
> online?
>
> I currently have my eth0 addr set, for example, to 100.100.100.1 and ib0
> set to 100.100.100.2. I assume that is ok, but I think my bcast and
> masks are same.

They shouldn't be on the same subnet in most cases.  Keep IB on its own 
subnet.  What are your subnet masks?

What we usually do when we have a set of mixed nets is something like this:

eth:  10.100.0.0/16
IB:   10.200.0.0/16

this allows us to keep the traffic easily and obviously separate, and 
not set up strange routing bits.


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
