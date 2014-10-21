From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] IB/mlx5: Implement Fast Indirect Memory Registration
 Feature
Date: Tue, 21 Oct 2014 13:59:18 +0300
Message-ID: <54463C86.9010904@dev.mellanox.co.il>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <1412693281-6161-3-git-send-email-sagig@mellanox.com> <543CB79B.6050400@acm.org> <5444122C.6070804@dev.mellanox.co.il> <5444BDDC.1060507@acm.org> <54462842.8080701@dev.mellanox.co.il> <54463B4A.1070308@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54463B4A.1070308-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/21/2014 1:54 PM, Bart Van Assche wrote:
> On 10/21/14 11:32, Sagi Grimberg wrote:
>> Since you didn't give any comments on the API itself should I conclude
>> that you find it clear and you agree with it?
>
> Mostly. The only aspect of which I think that it is missing in the API
> is the alignment requirement for the addresses in
> ib_indir_reg_list.sg_list. Is byte alignment sufficient ?

Yes.

> If so, will
> all HCA vendors be able to support this or do we perhaps need to add a
> member in the device attributes structure that declares what the
> alignment requirements are ?
>

This feature is designed to remove any alignment constraints on memory
registration. I don't see any point in allowing the API to relax the
constraints instead.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
