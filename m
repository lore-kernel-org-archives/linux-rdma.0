From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH RFC v2] Documentation/infiniband: Add docs for rdma-helpers
Date: Tue, 19 May 2015 09:56:50 +0200
Message-ID: <555AECC2.70502@profitbricks.com>
References: <1431938505-31779-1-git-send-email-yun.wang@profitbricks.com>		 <CAJ3xEMgkrUgSvRV7m_M9CE4w66Wyk-Svnfejvavj38iTNyH9HQ@mail.gmail.com>		 <5559B997.1030502@profitbricks.com> <1431962485.3114.8.camel@redhat.com>	 <555A04C8.10802@profitbricks.com> <1431968291.3114.13.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1431968291.3114.13.camel@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Or Gerlitz <gerlitz.or@gmail.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: linux-rdma@vger.kernel.org



On 05/18/2015 06:58 PM, Doug Ledford wrote:
[snip]
>> I see :-) I've not work with the kdoc yet, not sure if there is any
>> guidelines on how to write the header of inline func for kdoc?
> 
> It's an automated tool thing.  Any comment section that starts with /**
> is automatically included as a kdoc.  Then there is an expected format
> after that.  See Documentation/kernel-doc-nano-HOWTO.txt.

Got it :-)

> 
>>>
>>> Just because I want to move this along versus waiting for another
>>> respin, I'm going to copy and paste these into those locations and clean
>>> up the changelog when I integrate this patch.
>>
>> Got it, if there is anything I could help, please let me know ;-)
> 
> I'm sending the patch for review, please let me know if you are OK with
> how I handled the attribution.

The definition is far more detailed and accurate, it's already good enough
according to my understanding, should benefit the developer a lot ;-)

Regards,
Michael Wang

> 
