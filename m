From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.36
Date: Thu, 05 Aug 2010 23:50:42 +0300
Message-ID: <4C5B2422.1040708@voltaire.com>
References: <adak4o654x9.fsf@roland-alpha.cisco.com>	<BE2BFE91933D1B4089447C64486040805BD838C4@irsmsx503.ger.corp.intel.com>	<4C5AAE5F.2080008@voltaire.com> <BE2BFE91933D1B4089447C64486040805BD8392A@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040805BD8392A-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Walukiewicz, Miroslaw wrote:
> My patch was implemented using the most effective method available for current version of code and it is ready and working as a functionality. 
> [...] I will start a new discussion regarding an optimization of the post_send/post_recv path. Thank you for reminder.
Hi Mirek,

As suggested over the review (and you basically agreed it make sense), 
it looks like the current code path in the IB stack (libibverbs and 
kernel uverbs) can be patched to be more efficient such that an 
alternative implementation as you did within libibnes/nes can be avoided.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
