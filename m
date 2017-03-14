From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: v4.11-rc2: DMAR: Allocating domain for mlx4_0 failed
Date: Tue, 14 Mar 2017 10:33:31 -0400
Message-ID: <A9E08AE1-6983-41AA-B3C1-909694D789B4@oracle.com>
References: <1BCFE3F4-A455-4EFC-845E-1FAAF3902D55@oracle.com> <1489429487.2658.4.camel@sandisk.com> <D34904A2-BEB6-4833-B2CC-97FA7B5B1029@oracle.com> <20170314072957.GP2079@mtr-leonro.local>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170314072957.GP2079-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Mar 14, 2017, at 3:29 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> On Mon, Mar 13, 2017 at 02:27:51PM -0400, Chuck Lever wrote:
>> 
>>> On Mar 13, 2017, at 2:25 PM, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>>> 
>>> On Mon, 2017-03-13 at 14:21 -0400, Chuck Lever wrote:
>>>> When I boot v4.11-rc1 or -rc2 on my systems, the CX-3 Pro cards
>>>> are no longer plumbed. Booting with v4.10 works as expected.
>>> 
>>> Hello Chuck,
>>> 
>>> Please the patch that is available at the following URL:
>>> https://www.spinics.net/lists/linux-rdma/msg47043.html.
>> 
>> Thank you Bart, I will give that a try.
> 
> Yeah, without Bart's patch the IB stack is broken.

Bart's patch works for me.

Tested-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
