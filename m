From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 2/9] IB/core: Introduce Signature Verbs API
Date: Mon, 21 Oct 2013 19:12:50 +0300
Message-ID: <52655282.1000505@mellanox.com>
References: <1381851510-17290-1-git-send-email-sagig@mellanox.com> <1381851510-17290-3-git-send-email-sagig@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388CE2BFF@ORSMSX109.amr.corp.intel.com> <5263D2DE.8010500@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388CEA91E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CEA91E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/21/2013 5:34 PM, Hefty, Sean wrote:
>> The signature handover operation is binding all the necessary
>> information for the HCA together: where is the data (data_mr), where is
>> the protection information (prot_mr), what are the signature properties
>> (sig_attrs).
>> Once this step is taken (WR is posted), a single MR (sig_mr) describes
>> the signature handover operation and can be used to perform RDMA under
>> signature presence.
>> Once the HCA will perform RDMA over this MR, it will take into account
>> the signature context of the transaction and will follow the signature
>> attributes configured.
> It seems like this changes loses the ability to use an SGL.

I don't think so,
Signature MR simply describes a "signature associated" memory region 
i.e. it is a memory region that
also defines some signature operation offload aside from normal RDMA 
(for example validate & strip).
SGL are used to publish several rkeys for the server/target/peer to 
perform RDMA on each.
In this case the user previously registered each MR which he wishes it's 
peer to RDMA over.
Same story here, if user has several signature associated MRs, where he 
wish his peer to RDMA over (in a protected manner),
he can use these rkeys to construct SGL.

>    Why are the signature properties separate from the protection information?

Well,
Protection information is the actual protection block guards of the data 
(i.e. CRCs, XORs, DIFs etc..), while the signature properties
structure is the descriptor telling the HCA how to 
treat/validate/generate the protection information.

Note that signature support requires the HCA to be able to support 
INSERT operations.
This means that there is no protection information and the HCA is asked 
to generate it and add it to the data stream
(which may be incoming or outgoing...),

Hope this helps.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
