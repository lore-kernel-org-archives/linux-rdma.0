From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to re-use a QP for a new connection
Date: Fri, 20 Jun 2014 15:24:33 -0700
Message-ID: <53A4B4A1.50301@oracle.com>
References: <36E48CE3-3FB6-4985-9CA5-4D6B800EE3DC@oracle.com> <1828884A29C6694DAF28B7E6B8A82373993132A8@ORSMSX109.amr.corp.intel.com> <5F77D836-4EE1-458D-B256-3C0EF4B1F2C2@oracle.com> <1828884A29C6694DAF28B7E6B8A8237399313467@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399313467-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The QP can be reused. The rdma_id_private has a field reuseaddr. What additional change is needed besides rdma_set_reuseaddr?

Shirley

On 06/20/2014 02:17 PM, Hefty, Sean wrote:
>> During a remote transport disconnect, the QP leaves RTS.
>>
>> xprtrdma deals with this in a separate transport connect worker process,
>> where it creates a new id and qp, and replaces the existing id and qp.
>>
>> Unfortunately there are parts of xprtrdma (namely FRMR deregistration)
>> that are not easy to serialize with this reconnect logic.
>>
>> Re-using the QP would mean no serialization would be needed between
>> transport reconnect and FRMR deregistration.
>>
>> If QP re-use is not supported, though, it's not worth considering any
>> further.
> 
> It may be possible to reuse the QP, just not the rdma_cm_id without additional code changes.  Reuse of the rdma_cm_id may also require changes in the underlying IB/iWarp CMs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
