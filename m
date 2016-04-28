From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Thu, 28 Apr 2016 11:02:53 +0300
Message-ID: <5721C3AD.8050407@mellanox.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <1461765892-1285-2-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1604271043540.20042@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB046AB1@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB046AB1-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28/04/2016 00:54, Hefty, Sean wrote:
>>> +struct ib_lso_caps {
>>> +	u32 max_lso;
>>> +	u32 supported_qpts; /* Use enum ib_qp_type */
>>
>> So this is a bitmap of the qps supported? And thus we have a limit now of
>> 32 QP types. That needs to be documented and  you need a BUILD_BUG_ON
>> somewhere in case IB_QPT_MAX becomes larger than 32. Also needs to be
>> better commented so we know this is a bitmap.
>
> I think it would make more sense to indicate what protocol, or specific aspect of a protocol, are being offloaded.  Some qp types support LSO as a matter of practice.
>

For a lot of applications, we want to hide the lower level protocol. For 
example, we try hard to hide whether IB/RoCE is used by an application. 
Thus, is it wise to expose this thing in API?
A user creates a UD QP, he doesn't know or care whether the lower layer 
is Ethernet (RoCE v1/V2) or IB.

I agree that the max_lso could be different for various QP types and 
maybe probing a QP type would be favorable that getting this information 
in a generic query_device.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
