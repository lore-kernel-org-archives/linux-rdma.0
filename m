From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 21 Mar 2018 10:04:19 -0500
Message-ID: <8993aae1-4004-694d-7898-cff1572f2f5f@codeaurora.org>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <8a13375fd8e5439890768b7dd8473099@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <8a13375fd8e5439890768b7dd8473099@AcuMS.aculab.com>
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
To: David Laight <David.Laight@ACULAB.COM>, Oliver <oohall@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On 3/21/2018 9:35 AM, David Laight wrote:
>> x86 has compiler barrier inside the relaxed() API so that code does not
>> get reordered. ARM64 architecturally guarantees device writes to be observed
>> in order.
> 
> There are places where you don't even need a compile barrier between
> every write.
> 
> I had horrid problems getting some ppc code (for a specific embedded SoC)
> optimised to have no extra barriers.
> I ended up just writing through 'pointer to volatile' and adding an
> explicit 'eieio' between the block of writes and status read.
> 
> No less painful was doing a byteswapping write to normal memory.

If the architecture is reordering writes to the peripheral, then removing
the compiler barrier can break the multi-arch drivers. barriers document
clearly states that device need to observe writes in order. 

Though for special cases like you mentioned, you can certainly do this:

wmb()
__raw_write/pointer access
__raw_write/pointer access
__raw_write/pointer access

/* flush everything */
mmiowb()
__raw_write/pointer access

There would be no ordering guarantee between the wmb() and mmiowb().
This can only be done for known code and known hardware. I don't believe
this applies to multi-arch drivers.


> 
> 	David
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
