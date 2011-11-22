From: dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: RE: Independent server management of Multicasting connections
Date: Tue, 22 Nov 2011 11:27:23 -0700
Message-ID: <20111122112723.153527yw26bz6n4b@celticblues.com>
References: <20111121071551.14306gf6ogr9z8yf@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9B9E9@ORSMSX101.amr.corp.intel.com>
 <20111122110030.112519gpho0ikta6@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9BD23@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E9BD23-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Quoting "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:

>> In reviewing the mckey.c source code, it looks like, in post_sends,
>> that a remote key and remote qpn is being assigned in the wr.  I am
>> confused as to why this is done if rmeote keys etc. are not required.
>
> The qpn used for multicast traffic is 0xFFFFFF.  The qkey is part of  
> the multicast group attributes and is specified by the creator of  
> the multicast group.  The kernel rdma_cm returns these parameters to  
> the user after joining the multicast group.  The qkey is discovered  
> as part of the join process, and the qpn is hard-coded.

Are there examples of how to create the multicast group using rdma_cm?


>> Also, how do I multicast once the SA has created the group and I have
>> joined it?
>
> I'm not sure I understand this question, but posting a send with the  
> multicast group as the destination sends the multicast message.  The  
> send destination is indicated by the qpn, qkey, and address handle.   
> These are returned as part of the rdma_join_multicast response.

Ok... I think I understand this part... I was just a bit confused  
about the destination of the msg.


> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
