From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/3 fixed] infiniband-diags: Allow specification of an
 mkey on the command line
Date: Tue, 13 Mar 2012 08:30:23 -0400
Message-ID: <4F5F3DDF.9090307@dev.mellanox.co.il>
References: <1331065551.10889.14.camel@auk75.llnl.gov> <1331072283.17729.16.camel@auk75.llnl.gov> <4F59FEDB.7050605@dev.mellanox.co.il> <20120309120931.609233da.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120309120931.609233da.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/9/2012 3:09 PM, Ira Weiny wrote:
> On Fri, 09 Mar 2012 08:00:11 -0500
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
>> On 3/6/2012 5:18 PM, Jim Foraker wrote:
>>>
>>> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
>>> ---
>>>  include/ibdiag_common.h                     |    1 +
>>>  libibnetdisc/include/infiniband/ibnetdisc.h |    3 ++-
>>>  libibnetdisc/src/ibnetdisc.c                |    1 +
>>>  man/ibaddr.8                                |    2 ++
>>>  src/ibaddr.c                                |    2 ++
>>>  src/ibccconfig.c                            |    2 ++
>>>  src/ibccquery.c                             |    2 ++
>>>  src/ibdiag_common.c                         |    5 +++++
>>>  src/iblinkinfo.c                            |    3 +++
>>>  src/ibping.c                                |    2 ++
>>>  src/ibportstate.c                           |    2 ++
>>>  src/ibqueryerrors.c                         |    3 +++
>>>  src/ibroute.c                               |    2 ++
>>>  src/ibsendtrap.c                            |    2 ++
>>>  src/ibsysstat.c                             |    2 ++
>>>  src/ibtracert.c                             |    2 ++
>>>  src/mcm_rereg_test.c                        |    3 +++
>>>  src/perfquery.c                             |    2 ++
>>>  src/sminfo.c                                |    2 ++
>>>  src/smpquery.c                              |    2 ++
>>>  src/vendstat.c                              |    2 ++
>>>  21 files changed, 46 insertions(+), 1 deletions(-)
>>
>> Why do all these tools need mkey ? Isn't it only tools that require SMPs
>> needing this support ?
> 
> Unfortunately many of the diags issue SMP's when they should not.  To keep
> them working in the short term with mkey's this patch will have to be applied
> until an audit can be performed of every tool.  You may have noted I already
> fixed saquery with previous patches.

Yes, I saw that. It doesn't seem like it would be much work to fix the
ones that should be fixed for this (easy for me to say ;-) and IMO this
should be done prior to this rather than adding MKey in places where it
shouldn't be and then removing that later.

-- Hal

> 
> Ira
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
