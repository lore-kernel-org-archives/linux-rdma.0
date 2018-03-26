From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Mon, 26 Mar 2018 12:00:52 -0400
Message-ID: <4b1004a8-2d8b-681f-3050-a1365cfb8321@codeaurora.org>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <2d2a744a-57b2-ca42-db40-4705df0375db@codeaurora.org>
 <CAK8P3a2tumcR7mcE3++cofhF-FHzgZg_1OF+GXCZuwGckMOF1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAK8P3a2tumcR7mcE3++cofhF-FHzgZg_1OF+GXCZuwGckMOF1Q@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, Oliver <oohall@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On 3/26/2018 9:43 AM, Arnd Bergmann wrote:
> On Wed, Mar 21, 2018 at 2:58 PM, Sinan Kaya <okaya@codeaurora.org> wrote:
>> On 3/21/2018 8:53 AM, Sinan Kaya wrote:
>>> BTW, I have no idea what compiler barrier does on PPC and if
>>>
>>> wrltel() == compiler barrier() + wrltel_relaxed()
>>>
>>> can be said.
>>
>> this should have been
>>
>> writel_relaxed() == compiler barrier() + __raw_writel()
> 
> I don't think anyone clarified this so far, but there are additional differences
> between the two, writel_relaxed() assumes we are talking to a 32-bit
> little-endian
> MMIO register, while __raw_writel() is primarily used for writing into
> memory-type
> regions with no particular byte order. This means:
> 
> - writel_relaxed() must perform a byte swap when running on big-endian kernels
> - when used with __packed MMIO pointers, __raw_writel() may turn into a series
>   of byte writes, while writel_relaxed() must result in a single 32-bit access.
> - A set if consecutive writel_relaxed() on the same device is issued in program
>   order, while __raw_writel() is not ordered. This typically requires
> only a compiler
>   barrier, but may also need a CPU barrier (in addition to the
> barriers we use to
>   serialize with spinlocks and DMA in writel() but not writel_relaxed()).

Thanks for the great summary. I didn't know that __raw_writel() could get converted
to byte writes.

> 
>         Arnd
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
