From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: InfiniBand/RDMA merge plans for 2.6.36
Date: Thu, 5 Aug 2010 13:51:20 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040805BD8392A@irsmsx503.ger.corp.intel.com>
References: <adak4o654x9.fsf@roland-alpha.cisco.com>
 <BE2BFE91933D1B4089447C64486040805BD838C4@irsmsx503.ger.corp.intel.com>
 <4C5AAE5F.2080008@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C5AAE5F.2080008-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Or, 
My patch was implemented using the most effective method available for current version of code and it is ready and working as a functionality. 

For me another thing then functionality is an optimization of the existing SW paths in infiniband code and modification earlier written code to new interfaces. 

Tomorrow I will start a new discussion regarding an optimization of the post_send/post_recv path. Thank you for reminder.

Regards,

Mirek

-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org] 
Sent: Thursday, August 05, 2010 2:28 PM
To: Walukiewicz, Miroslaw
Cc: Roland Dreier; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.36

Walukiewicz, Miroslaw wrote:
> Hello Roland,  What about a series from Aleksey Senin [...] And my patch RDMA/nes: IB_QPT_RAW_PACKET QP type support for nes driver https://patchwork.kernel.org/patch/110252
Hi Mirek,

Reading your response @ http://marc.info/?l=linux-rdma&m=127954552519544 
to the comments made during the review, I was under the impression that 
you're going to try and modify the NES implementation, isn't this the 
case any more?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
