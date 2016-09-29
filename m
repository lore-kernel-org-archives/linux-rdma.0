From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/9] Remove HAVE_VALGRIND_MEMCHECK_H/INCLUDE_VALGRIND
Date: Thu, 29 Sep 2016 16:48:25 -0700
Message-ID: <610a3086-07bd-baa7-11e2-88642c0e2297@sandisk.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <aef5ce41-14bf-9869-88c8-ab5796634a8c@acm.org>
 <20160929223415.GD27229@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160929223415.GD27229-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/29/2016 03:34 PM, Jason Gunthorpe wrote:
> On Thu, Sep 29, 2016 at 02:01:26PM -0700, Bart Van Assche wrote:
>> Independent of this patch: Valgrind has a stable ABI so I propose to add a
>> copy of the memcheck.h header file to the rdma-core source tree. Many other
>> open source projects already do this.
>
> Interesting idea, what do you see as the benefit?

Hello Jason,

That would allow to annotate rdma-core code correctly for Valgrind 
without introducing a dependency on the valgrind-devel package. As you 
know most Linux distro's by default do not install the valgrind-devel 
package.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
