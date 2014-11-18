From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH V1 for-next 2/2] IB/mlx4_ib: Disassociate support
Date: Tue, 18 Nov 2014 10:48:07 -0600
Message-ID: <546B7847.2040406@opengridcomputing.com>
References: <1416312682-7899-1-git-send-email-yishaih@mellanox.com> <1416312682-7899-3-git-send-email-yishaih@mellanox.com> <546B5AE3.9060606@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546B5AE3.9060606-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/18/2014 8:42 AM, Or Gerlitz wrote:
> On 11/18/2014 2:11 PM, Yishai Hadas wrote:
>> Implements the IB core disassociate_ucontext API. The driver detaches 
>> the HW
>> resources for a given user context to prevent a dependency between 
>> application
>> termination and device disconnecting. This is done by managing the 
>> VMAs that
>> were mapped to the HW bars such as door bell and blueflame. When need 
>> to detach
>> remap them to an arbitrary kernel page returned by the zap API.
>>
>>
>
> Guys,
>
> Can we somehow make this patch generic (e.g land in the IB core) such 
> that it can apply also for mlx5 (and other HW drivers...) basically, 
> the HW driver should tell the IB core which pages to zap and we should 
> be OK, isn't that?
>

I agree.  cxgb* will want to support this also.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
