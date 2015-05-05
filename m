From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v8 00/23] IB/Verbs: IB Management Helpers
Date: Tue, 05 May 2015 16:40:05 +0200
Message-ID: <5548D645.5070707@profitbricks.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com> <5548D0CD.3080400@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5548D0CD.3080400@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org



On 05/05/2015 04:16 PM, Or Gerlitz wrote:
> On 5/5/2015 3:50 PM, Michael Wang wrote:
>> Since v7:
>>    * Thanks to Doug, Ira, Devesh for the testing:-)
>>    * Thanks for the comments from or, Doug, Ira, Jason:-)
>>      Please remind me if anything missed:-P
>>    * Use rdma_cap_XX() instead of cap_XX() for readability
>>    * Remove CC list in git log for maintainability
>>    * Use bool as return value
>>    * Updated github repository to v8
> 
> Didn't you see that patches 15~23 will be squashed into one?

I missed the conversation on that, you mentioned to remove the
CC list but don't want to merge the patches, correct?

> 
> 
> Also, when you post version N you need not only to list the changes since version N-1 but rather also to keep the full changes since Vx for x=1...N-2, reviewers needs not chase your previous cover letters and see if/whatwent wrong, specifically with a sensitive series like this one.

That maybe too long and with some outdated info, I can reserve
the log since this version if it was preferred by folks.

> 
> So if/when there's V9, use that practice, and for the time being, reply on the V8 cover letter with the full listing of changes

I'm using git send-mail which reply on the cover of each version,
not sure how to reply on a prev cover? and that won't start a new
thread for the new version, isn't it?

Regards,
Michael Wang

> 
> Or.
> 
> 
