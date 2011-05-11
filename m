From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [RFC] RDMA CM + XRC, take two
Date: Wed, 11 May 2011 13:36:54 -0500
Message-ID: <4DCAD746.7050606@systemfabricworks.com>
References: <4DC86BB2.1020002@systemfabricworks.com> <1828884A29C6694DAF28B7E6B8A82373BBE2@ORSMSX101.amr.corp.intel.com> <4DCAA047.2040904@systemfabricworks.com> <1828884A29C6694DAF28B7E6B8A82373BC59@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373BC59-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/11/2011 10:03 AM, Hefty, Sean wrote:
>>> What are the QPNs carried in the REQ and REP?
>>
>> Those for the XRC QPs. Same as a for regular RC connection.
> 
> I guess I need to go back and study the specs more to understand why the QPN is in the REQ.

I looked at the kernel headers; struct cm_req_msg and cm_rep_msg, and they both contain the QP numbers.

> 
> The REQ/REP also carry EECN fields which might be usable here, and maybe that was the intent.

The XRC spec does not make room for the srq number. Which implies it's left to the application to transmit it.

Frank.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
