From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH -v2 09/26] infiniband: rename random32() to prandom_u32()
Date: Sat, 05 Jan 2013 17:33:51 -0600
Message-ID: <50E8B85F.9030605@opengridcomputing.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com> <1357215562-6288-10-git-send-email-akinobu.mita@gmail.com> <50E5B183.4030706@opengridcomputing.com> <CAC5umygnMMC2sH2c88P_gEWTgwM=CBCUcqBbo+NX=fOZ2rEGxw@mail.gmail.com> <50E70E48.3010900@opengridcomputing.com> <CAC5umyjpA4_J-1RRv0O72GiPW5O6-1b+dypg746vOphEkpKyYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAC5umyjpA4_J-1RRv0O72GiPW5O6-1b+dypg746vOphEkpKyYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 1/5/2013 7:37 AM, Akinobu Mita wrote:
> 2013/1/5 Steve Wise <swise@opengridcomputing.com>:
>> I'm asking: why are you bothering with renaming the functions?  This seems
>> like a needless change, _unless_ there are really non-pseudo-random services
>> being added.
> We already have get_random_byte() which is not pseudo-random number
> generator.
>
> Apart from that, the naming scheme was confusing without "prandom" prefix.
> Because I introduced new functions in the commit 6582c665 ("prandom:
> introduce prandom_bytes() and prandom_bytes_state()").

Ok, thanks for the explanation.
