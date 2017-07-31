From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] infiniband: avoid overflow warning
Date: Mon, 31 Jul 2017 09:30:12 +0200
Message-ID: <CAK8P3a2AP7WSF2HUe_4nxsNFqCit_djKdd3_5ab6P1YgP7bvJQ@mail.gmail.com>
References: <20170731065016.2947796-1-arnd@arndb.de> <CAG9sBKNaFTAuf2gL9QLOCwvH-xAq7SXfaMZxNMFo7d=6cH3TkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKNaFTAuf2gL9QLOCwvH-xAq7SXfaMZxNMFo7d=6cH3TkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 31, 2017 at 9:08 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Mon, Jul 31, 2017 at 9:50 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
>> --- a/include/rdma/ib_addr.h
>> +++ b/include/rdma/ib_addr.h
>> @@ -172,7 +172,8 @@ static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
>>                                        (struct in6_addr *)gid);
>>                 break;
>>         case AF_INET6:
>> -               memcpy(gid->raw, &((struct sockaddr_in6 *)addr)->sin6_addr, 16);
>> +               *(struct in6_addr *)&gid->raw =
>> +                       ((struct sockaddr_in6 *)addr)->sin6_addr;
>>                 break;
>>         default:
>>                 return -EINVAL;
> what happens if you replace 16 with sizeof(struct in6_addr)?

Same thing: the problem is that gcc already knows the size of the structure we
pass in here, and it is in fact shorter.

I also tried changing the struct sockaddr pointer to a sockaddr_storage pointer,
without success. Other approaches that do work are:

- mark addr_event() as "noinline" to prevent gcc from seeing the true
size of the
  inetaddr_event stack object in rdma_ip2gid(). I considered this a little ugly.

- change inetaddr_event to put a larger structure on the stack, using
  sockaddr_storage or sockaddr_in6. This would be less efficient.

- define a union of sockaddr_in and sockaddr_in6, and use that as the argument
  to rdma_ip2gid/rdma_gid2ip, and change all callers to use that union type.
  This is probably the cleanest approach as it gets rid of a lot of questionable
  type casts, but it's a relatively large patch and also slightly less
efficient as we have
  to zero more stack storage in some cases.

        Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
