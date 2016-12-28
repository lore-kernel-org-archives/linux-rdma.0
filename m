From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/srpt: fix compilation warning
Date: Wed, 28 Dec 2016 13:44:42 +0200
Message-ID: <7a85fe72-04b3-92d5-95ec-0e586edbd9fd@mellanox.com>
References: <1482922813-8392-1-git-send-email-maxg@mellanox.com>
 <1482922813-8392-4-git-send-email-maxg@mellanox.com>
 <1482925264.6713.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482925264.6713.5.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 12/28/2016 1:41 PM, Bart Van Assche wrote:
> On Wed, 2016-12-28 at 13:00 +0200, Max Gurtovoy wrote:
>> warning: 'prev_nents' may be used uninitialized in this function
>
> What compiler and which version of that compiler reported that 'prev_nents'
> may be used uninitialized? That warning indicates a compiler bug. Recent
> versions of gcc do not report that warning. Patches that suppress warnings
> that are reported by bugs in old compiler versions should not be sent upstream.
>
> Bart.
>

gcc version 4.4.7 20120313 (Red Hat 4.4.7-3) (GCC)
I'll remove this patch in V2.

Thanks,
Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
