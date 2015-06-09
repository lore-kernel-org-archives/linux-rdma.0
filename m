From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Tue, 9 Jun 2015 10:27:29 +0300
Message-ID: <55769561.8000300@mellanox.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE5D17-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 6/9/2015 12:37 AM, Hefty, Sean wrote:
>> Previously, every vendor implemented its net device notifiers in its own
>> driver. This introduces a huge code duplication as figuring
>
>
>>   28 files changed, 2253 insertions(+), 860 deletions(-)
>
> How does adding 1400 lines of code help reduce code duplication?
>
> Can you please explain and justify why this change is actually needed?
>

Let's look at this change from several perspectives:

(1) Each vedor lost ~250 lines of GID management code just by this 
change. In the future it's very probable that more vendor drivers will 
implement RoCE. This removes the burden and code duplication required by 
them to implement a full RoCE support and is a lot more scalable than 
the current approach.

(2) All vendors are now aligned. For example, mlx4 driver had bonding 
support but ocrdma didn't have such support. The user expects the same 
behavior regardless the vendor's driver.

(3) When making something more general it usually requires more lines of 
code as it introduces API and doesn't cut corners assuming anything on 
the vendor's driver.

(4) This is a per-requisite to the RoCE V2 series. I'm sure you remember 
we first submitted this patch-set as a part of the RoCE V2 series. 
Adding more features to the RoCE GID management will make the code 
duplication a lot worse than just ~250 lines. I don't think it's fair 
playing "lets divide the RoCE V2 patch-set to several patch-sets" and 
then say "why do we need this <first part> at all". Let alone, the other 
there reasons are more than enough IMHO.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
