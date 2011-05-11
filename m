From: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: [RFC] RDMA CM + XRC, take two
Date: Wed, 11 May 2011 14:36:34 -0500
Message-ID: <9ECD201D-0CD8-4339-81E0-163FC130C705@systemfabricworks.com>
References: <4DC86BB2.1020002@systemfabricworks.com> <1828884A29C6694DAF28B7E6B8A82373BBE2@ORSMSX101.amr.corp.intel.com> <4DCAA047.2040904@systemfabricworks.com> <1828884A29C6694DAF28B7E6B8A82373BC59@ORSMSX101.amr.corp.intel.com> <4DCAD746.7050606@systemfabricworks.com> <1828884A29C6694DAF28B7E6B8A82373BE79@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373BE79-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a connection between the ini and TFT qps they have to exchange qpns so that they can check them later
The sewn is also sent and used to route messages to the srq at the target

Sent from my iPhone

On May 11, 2011, at 2:08 PM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>>> I guess I need to go back and study the specs more to understand why the
>> QPN is in the REQ.
>> 
>> I looked at the kernel headers; struct cm_req_msg and cm_rep_msg, and
>> they both contain the QP numbers.
> 
> I was referring only to *why* the XRC TGT QP needed to know the XRC INI QPN (at a conceptual level).  I think it's for control messages.
> 
>>> The REQ/REP also carry EECN fields which might be usable here, and maybe
>> that was the intent.
>> 
>> The XRC spec does not make room for the srq number. Which implies it's left
>> to the application to transmit it.
> 
> Agreed - I was wondering if using the EECN would work, but I don't think that it does.  There would typically be multiple SRQs targeted by a single XRC INI->TGT connection.  Maybe SIDR could be adopted for this purpose as the standard discovery technique.
> 
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
