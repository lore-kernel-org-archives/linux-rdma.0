From: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Is multicast only available with UD Transport mode?
Date: Sun, 14 Nov 2010 15:06:12 -0700
Message-ID: <4CE05D54.4070909@redhat.com>
References: <20101112101223.44mbsbnygwcw0008@peddycoart.com> <AANLkTi=Pdk5nZXq+Yed=fbxXLwkSJGere=26-3YNmd_Y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=Pdk5nZXq+Yed=fbxXLwkSJGere=26-3YNmd_Y-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/13/2010 01:35 AM, Bart Van Assche wrote:
> On Fri, Nov 12, 2010 at 6:12 PM, <ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org> wrote:
>> Is multicast only available with UD Transport mode?
> 
> In the past several reliable multicast protocols have been developed
> on top of unreliable multicast for IPv4. See e.g.
> 
> S. Pingali, D. Towsley and J. Kurose, A comparison of sender-initiated
> and receiver-initiated reliable multicast protocols, SIGMETRICS '94
> Proceedings, 1994.
> 
> Note: I'm not sure how much work it would take to convert one of the
> existing reliable multicast protocols to IB.
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Bart,

Corosync (http://www.corosync.org) implements The Totem Single Ring
Protocol which provides virtual synchrony via a closed process group C
programming API.  We have full support for native ibverbs/rdmacm
infrastructure for RDMA operation.

As an aside, it is challenging to bolt in RDMA support into any
multicast protocol - good luck to those out there wishing to take this
tsak on :)

If people would like to see some preliminary benchmarks, mail me off list.

Regards
-steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
