From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: rdma_connect() timeout question
Date: Thu, 16 Aug 2012 14:57:18 -0500
Message-ID: <502D509E.6000403@opengridcomputing.com>
References: <502D43A4.1090708@oracle.com> <1828884A29C6694DAF28B7E6B8A8237346A899E6@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A899E6-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Nowak <michael.nowak-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/16/2012 2:40 PM, Hefty, Sean wrote:
>> Is there a way to tune rdma_connect() timeout to a lower value ?
> I don't believe so.
>
> You could abort the connection by destroying the id after a specified amount of time had expired.
>
>> Can cma_response_timeout and CMA_MAX_CM_RETRIES be made tunables ?
>> Even better would have been if the caller (RDS in this case) could have
>> passed them as connection setup parameters. ;-)
>> That way we don't have to disturb the setting for non-RDS traffic.
> A per rdma_cm_id option for this makes sense to me.
>
> iWarp developers, would timeout/retry values be usable for iwarp?
I think this would be useful for the iwarp side too.  Not sure yet 
exactly how it would apply for cxgb3/4 though...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
