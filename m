From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Sat, 24 Mar 2018 11:06:52 -0400
Message-ID: <511b73e6-797c-9986-075c-c5b5d4eb1ed2@codeaurora.org>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <1521692689.16434.293.camel@kernel.crashing.org>
 <CAOSf1CFv1HHCL3YOVhRn2U=grdNjaQ=A4m3xwxN2Rek1-_TySg@mail.gmail.com>
 <1521726722.16434.312.camel@kernel.crashing.org>
 <5ccdb208-4664-0a7f-df5d-2e12cbe4c239@codeaurora.org>
 <1521764168.16434.324.camel@kernel.crashing.org>
 <9c7d3d35-ddaf-60ee-1430-19b5c3f66813@codeaurora.org>
 <1521854570.16434.358.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1521854570.16434.358.camel@kernel.crashing.org>
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
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Oliver <oohall@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, linuxppc dev list <linuxppc-dev@lists.ozlabs.org>, Will Deacon <will.deacon@arm.com>
List-Id: linux-rdma@vger.kernel.org

On 3/23/2018 9:22 PM, Benjamin Herrenschmidt wrote:
>> Yes, I'm %100 sure. The answer is both writel() and barrier() generates
>> a write barrier instruction. I found this by searching the kernel disassembly
>> for back to back "dsb st" instruction.
> I'm not sure you are correct here. As I wrote below, the implementatoin
> of writel() contains an *explicit" memory barrier which is completely
> different to a barrier() instruction:

OK. I did some directed tests and I'm taking it back. 
barrier() is a compiler reordering statement only.

What got me confused was this sequence:

wmb()
barrier()
writel()

I thought that the second barrier instruction was coming from barrier() but
it was actually coming from writel().

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
