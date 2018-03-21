From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 21 Mar 2018 08:53:44 -0500
Message-ID: <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
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
To: Oliver <oohall@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On 3/20/2018 10:40 PM, Oliver wrote:
>> I see that network drivers are working around the issue by calling
>> __raw_write() API directly but this also breaks other architectures
>> like SPARC since the semantics of __raw_writel() seems to be system dependent.
> Yeah that's pretty gross. Which drivers are doing this?
> 

Searching for __raw_writel() and BIG_ENDIAN in drivers/net directory
should give you the idea.

In a nutshell, drivers are doing this today.

wmb()
__raw_writel();
mmiowb()

I'm in the process of posting patches ([1], [2], [3]) to various subsystems to
eliminate double barriers by replacing sequences like 

wmb()
writel()
mmiowb()

with

wmb()
writel_relaxed()
mmiowb()

Reviewers pointed out that writel_relaxed() is not __raw_writel() on PPC
and cannot take advantage of the optimization. 

Replacing writel_relaxed() with raw_writel() or vice versa is not correct.

writel_relaxed() needs to have ordering guarantees with respect to the order
device observes writes. 

x86 has compiler barrier inside the relaxed() API so that code does not
get reordered. ARM64 architecturally guarantees device writes to be observed
in order.

I was hoping that PPC could follow x86 and inject compiler barrier into the
relaxed functions. 

BTW, I have no idea what compiler barrier does on PPC and if

wrltel() == compiler barrier() + wrltel_relaxed()

can be said.

Need guidance from the PPC maintainers. 

[1] https://www.spinics.net/lists/netdev/msg490480.html
[2] https://www.spinics.net/lists/arm-kernel/msg642341.html
[3] https://www.spinics.net/lists/arm-kernel/msg642336.html

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
