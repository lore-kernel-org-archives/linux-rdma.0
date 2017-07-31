From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] infiniband: avoid overflow warning
Date: Mon, 31 Jul 2017 13:58:34 -0700
Message-ID: <CAGXu5jJ66RY05M=sYZeAMVPEtpneOKyBN2CSNsrewj4EREeu+g@mail.gmail.com>
References: <20170731065016.2947796-1-arnd@arndb.de> <CAG9sBKNaFTAuf2gL9QLOCwvH-xAq7SXfaMZxNMFo7d=6cH3TkQ@mail.gmail.com>
 <CAK8P3a2AP7WSF2HUe_4nxsNFqCit_djKdd3_5ab6P1YgP7bvJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2AP7WSF2HUe_4nxsNFqCit_djKdd3_5ab6P1YgP7bvJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Daniel Micay <danielmicay@gmail.com>, "Kalderon, Michal" <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, "David S. Miller" <davem@davemloft.net>, Bart Van Assche <bart.vanassche@sandisk.com>, Parav Pandit <parav@mellanox.com>, Noa Osherovich <noaos@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 31, 2017 at 12:30 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Jul 31, 2017 at 9:08 AM, Moni Shoua <monis@mellanox.com> wrote:
>> On Mon, Jul 31, 2017 at 9:50 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> --- a/include/rdma/ib_addr.h
>>> +++ b/include/rdma/ib_addr.h
>>> @@ -172,7 +172,8 @@ static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
>>>                                        (struct in6_addr *)gid);
>>>                 break;
>>>         case AF_INET6:
>>> -               memcpy(gid->raw, &((struct sockaddr_in6 *)addr)->sin6_addr, 16);
>>> +               *(struct in6_addr *)&gid->raw =
>>> +                       ((struct sockaddr_in6 *)addr)->sin6_addr;

This seems reasonable.

>>>                 break;
>>>         default:
>>>                 return -EINVAL;
>> what happens if you replace 16 with sizeof(struct in6_addr)?
>
> Same thing: the problem is that gcc already knows the size of the structure we
> pass in here, and it is in fact shorter.

So gcc is ignoring both the cast (to 16 byte struct in6_addr) and the
caller's actual 128 byte struct sockaddr_storage, and looking only at
struct sockaddr? That seems really weird.

-Kees

-- 
Kees Cook
Pixel Security
