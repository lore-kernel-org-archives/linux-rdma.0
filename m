From: Oliver <oohall@gmail.com>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 21 Mar 2018 14:40:47 +1100
Message-ID: <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
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
To: Sinan Kaya <okaya@codeaurora.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 21, 2018 at 2:07 PM, Sinan Kaya <okaya@codeaurora.org> wrote:
> Hi PPC Maintainers,
>
> We are seeking feedback on the status of relaxed write API implementation.
> What is the motivation for not implementing the relaxed API?

Hmm, good question.

Looks like we've implemented the relaxed_* variants by aliasing them
to the normal version since the dawn of time. There's a comment in
io.h saying something about us not having the expected semantics for
the relaxed variants, but I don't see what the issue is... Ben?

> I see that network drivers are working around the issue by calling
> __raw_write() API directly but this also breaks other architectures
> like SPARC since the semantics of __raw_writel() seems to be system dependent.

Yeah that's pretty gross. Which drivers are doing this?

> This is putting drivers into a tight position and they cannot achieve true
> multi-arch enablement and are forced into calling __raw APIs flavors
> directly with #ifdef BIG_ENDIAN ugliness.
>
> Sinan
>
> --
> Sinan Kaya
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
