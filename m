From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/8] Critical bug fixes for RDMA/cxgb4
Date: Thu, 08 Aug 2013 14:00:23 +0530
Message-ID: <5203571F.9020904@chelsio.com>
References: <1375803280-7916-1-git-send-email-vipul@chelsio.com> <CAL1RGDXuigeKkMawuRZ_5GVnkQ0Mm0FiMk4eqZ5jthHHDx1v=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXuigeKkMawuRZ_5GVnkQ0Mm0FiMk4eqZ5jthHHDx1v=g@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Nirranjan Kirubaharan <nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 06-08-2013 23:12, Roland Dreier wrote:
> On Tue, Aug 6, 2013 at 8:34 AM, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:
> 
>> This series is on top of previously submitted series "Add IPv6 support for
>> iWARP" which can be found at following location:
>> http://comments.gmane.org/gmane.linux.network/272124
>> We request Roland to merge above series first and then apply this series on top
>> of it.
> 
> I can do that, and in fact I should be able to start queueing 3.12
> material soon.  However, if these are really critical bug fixes, do
> you want them to wait for 3.12 as well?
> 
> Which are really critical bug fixes?  For example, just from the
> subject line, I can't see advertising the wrong MR size as a critical
> bug.
> 

Hi Roland,

We would like to wait for iwarp/ipv6 and this series to get merge in
3.12. 3.11 is at RC4 and we think it won't take long for 3.12-rc.

Thanks,
Vipul

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
