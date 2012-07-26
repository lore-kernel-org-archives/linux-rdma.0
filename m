From: =?iso-8859-1?Q?=22Xavier_R=2E_Gu=E9rin=22?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: EINVAL when INIT -> RTR on RoCE
Date: Thu, 26 Jul 2012 08:20:33 -0400
Message-ID: <F0AFA058-856F-48A0-99A1-2FB5398B31B6@gmail.com>
References: <B2CAB3C7-6049-4B8B-90C1-9DD2180857EE@gmail.com> <CAL1RGDUEMiuNKBjShYUmj2OTAS=YDGgpK7d5Li090r2ot8VanQ@mail.gmail.com> <CAL1RGDUsk2YV4GwYF7doina+bDGqw6VAHAEajJ7Qg7PJhF6aew@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUsk2YV4GwYF7doina+bDGqw6VAHAEajJ7Qg7PJhF6aew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Roland,

>>> he queue pairs successfully switch from RESET to INIT, but miserably fail to switch from INIT to RTR with an EINVAL error code.
>> 
>> On IBoE, are you passing in a path with a global routing info, ie a GID?
> 
> for example, what is the value of
> 
>    qp_attr.ah_attr.is_global
> 
> that you pass into modify_qp for the INIT->RTR transition?

I use 0 for is_global, as i am only using a local subnet. Here is my qp_attr configuration for the switch to INIT -> RTR :

  qp_attr . qp_state              = IBV_QPS_RTR;
  qp_attr . path_mtu              = IBV_MTU_2048;
  qp_attr . rq_psn                = 0;  
  qp_attr . max_dest_rd_atomic    = 0x10; 
  qp_attr . min_rnr_timer         = 12;  
  qp_attr . ah_attr.is_global     = 0; 
  qp_attr . ah_attr.dlid          = remoteId;
  qp_attr . ah_attr.sl            = 0; 
  qp_attr . ah_attr.src_path_bits = 0;   
  qp_attr . ah_attr.port_num      = _interface . port () . id ();
  qp_attr . dest_qp_num           = remoteNumber;

remoteId, remoteNumber and _interface . port () . id () are runtime values returned by the peer QP and the interface.

Xavier

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
