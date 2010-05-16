From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [ewg] [PATCHv8 03/11] IB/umad: Enable support only for IB ports
Date: Sun, 16 May 2010 08:21:29 +0300
Message-ID: <4BEF80D9.5060200@voltaire.com>
References: <20100218172354.GD12286@mtls03>	<adazl0eatj6.fsf@roland-alpha.cisco.com> <20100506104848.GA29792@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506104848.GA29792-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> Roland Dreier wrote:
>   
>> Why do we not allow umad for IBoE ports?  I understand there's no QP0 but why can't userspace use QP1 just like for IB link layer ports?
>>     
> Currently QP1 is only used by the CM protocol which is implemented in the kernel. Since we handle the iboe specific flow in the cma rather than the SA, there is no need to expose qp1 to userspace.
Eli, any reason not to let reading (e.g perfquery) the HCA/port traffic 
counters with  IBoE?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
