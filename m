From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: ibstat does not recognize iWARP RNIC adapters
Date: Thu, 26 Apr 2012 08:39:13 -0500
Message-ID: <4F995001.7050306@opengridcomputing.com>
References: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com> <1828884A29C6694DAF28B7E6B8A82373469D85A8@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373469D85A8-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/26/2012 01:31 AM, Hefty, Sean wrote:
>> I noticed that doing ibstat, none of the iWARP RNIC adapters were showing
>> up.  I have attached a patch to address the issue (libibumad.patch).
>>
>> SYS_NODE_TYPE for iWARP RNIC is 4 and is_ib_type only checked to 3.
> I don't think libibumad should support RNICs.  Users can use ibv_devinfo instead.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Users seem to expect ibstat to show all rdma devices...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
