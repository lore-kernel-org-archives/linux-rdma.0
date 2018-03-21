From: Sinan Kaya <okaya@codeaurora.org>
Subject: RFC on writel and writel_relaxed
Date: Tue, 20 Mar 2018 22:07:06 -0500
Message-ID: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
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
To: "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi PPC Maintainers,

We are seeking feedback on the status of relaxed write API implementation.
What is the motivation for not implementing the relaxed API? 

I see that network drivers are working around the issue by calling
__raw_write() API directly but this also breaks other architectures
like SPARC since the semantics of __raw_writel() seems to be system dependent.

This is putting drivers into a tight position and they cannot achieve true
multi-arch enablement and are forced into calling __raw APIs flavors
directly with #ifdef BIG_ENDIAN ugliness.

Sinan

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
