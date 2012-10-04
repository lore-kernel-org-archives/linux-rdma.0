From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problem running rping over Intel adapters
Date: Thu, 04 Oct 2012 09:27:30 -0500
Message-ID: <506D9CD2.20606@opengridcomputing.com>
References: <506CB0E9.90201@redhat.com> <1828884A29C6694DAF28B7E6B8A8237346A98E58@FMSMSX151.amr.corp.intel.com> <506CB4D8.4010604@redhat.com> <1828884A29C6694DAF28B7E6B8A8237346A98E8E@FMSMSX151.amr.corp.intel.com> <506CEAC1.9070808@opengridcomputing.com> <506D2174.10601@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506D2174.10601-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/4/2012 12:41 AM, Or Gerlitz wrote:
> On 04/10/2012 03:47, Steve Wise wrote:
>>
>> Not used by iwarp drivers...
>
> Which one, the retry counter or the RNR retry counter?
>

rnr_retry_count has no meaning in iWARP.  There is no RNR message in the 
iwarp protocol.  For some iwarp devices (cxgb3 for example), an ingress 
send with no recv buffer available results in immediate connection 
termination.   Some devices, (eg cxgb4), the ingress SEND is buffered in 
the adapter until a recv buf is posted.  Both behaviors are allowed in 
the iwarp specs.

retry_count, I assume, is for connection establishment?  For the Chelsio 
devices, this is all up to the TCP stack and thus this counter is not 
used.  If there is no TCP listener, then the connection establishment 
will fail immediately.  If the node is not reachable, then normal TCP 
retransmit rules apply, but once TCP gives up, then the rdma connection 
establishment will fail.

Also, the RDMA_CM and IW_CM don't even pass these two counters down to 
the drivers' connect function.  See struct iw_cm_conn_param and 
cma.c/cma_connect_iw() iwcm.c/iw_cm_connect().


Steve.

> Or.
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
