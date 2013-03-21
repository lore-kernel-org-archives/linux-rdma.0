From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all
 ports of HCA are connected]
Date: Thu, 21 Mar 2013 22:49:44 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510EBB4B60@CRSMSX102.amr.corp.intel.com>
References: <2807E5FD2F6FDA4886F6618EAC48510EBB4214@CRSMSX102.amr.corp.intel.com>
 <514A3169.7000501@oracle.com> <20130320222422.GA30100@obsidianresearch.com>
 <514A3BDF.2090105@oracle.com> <20130320231923.GA32300@obsidianresearch.com>
 <514A5C07.3080308@oracle.com> <20130321052122.GB20882@obsidianresearch.com>
 <514B6F74.9020707@oracle.com> <20130321212703.GA8431@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4AF5@CRSMSX102.amr.corp.intel.com>
 <20130321220751.GG8431@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510EBB4B49@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510EBB4B49-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Weiny, Ira

[snip]

> 
> Of those returning int
> 


 Ib_path_query_via returns the dlid on success

mad_register_server_via returns the agent id on success 

mad_register_client_via returns the agent id on success 

mad_register_port_client returns the agent id on success
 

mad_rpc_class_agent returns the agent on success 

mad_build_pkt returns the length of the packet built on success 

mad_print_field returns the length of the string printed on success
 

Sorry about outlooks frelling line wrap crap...


Ira
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
